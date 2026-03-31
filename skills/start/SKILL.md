---
name: start
user-invocable: true
description: >-
  Agentic30 온보딩 + 상태 초기화. 시작하기, 프로젝트 시작 시 사용.
---

Agentic30 Signal-Driven Navigator를 시작합니다. 온보딩 + 상태 초기화.

## 데이터 경로 결정

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 기본값:
   - Claude Code: **AGNT_DIR = `~/.claude/agnt`**
   - Codex: **AGNT_DIR = `~/.codex/agnt`**

## 출력 규칙

### 내부 로직 무음 처리

아래 절차는 **유저에게 텍스트를 출력하지 않고** 내부적으로만 수행합니다:

- AGNT_DIR 경로 탐색 및 결과
- state.json 파싱/생성 결과
- 파일 Read 성공/실패 여부
- MCP ToolSearch 결과
## 실행 절차

### 1. state.json 확인

`{AGNT_DIR}/state.json`을 Read 시도.

**파일이 없는 경우** (신규 유저):
- 디렉토리가 없으면 생성
- v3 기본 state를 Write (아래 스키마)
- 2단계로 이동

**파일이 있는 경우**:
- JSON 파싱 시도. 실패 시 v3 기본 state로 재생성
- `meta.schema_version`이 3이 아니면 v3 기본 state로 재생성
- 정상이면 2단계로 이동

### 2. MCP 연결 확인

`ToolSearch`로 `+agentic30` 검색.

**도구 발견됨**:
- `meta.authenticated = true`로 설정
- `identity.mode = "synced"` (또는 기존 "synced" 값 유지)
- `identity.mcp.connected = true`
- `identity.mcp.last_checked_at = now()`
- MCP `complete_onboarding` 호출 (에러 시 무시하고 계속)

**도구 없음**:
- `meta.authenticated = false` 유지
- `identity.mode` 기존 값 유지 ("guest" 또는 "registered")
- `identity.mcp.connected = false`
- (연결 안내는 `/agnt:connect` 참조 — 인라인 안내 없음)

### 3. 온보딩 메시지

`state.project.problem`이 null이면 온보딩 메시지를 표시한다.

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  30일 안에 첫 유료 시그널을 만들자
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

만들었는데 아무도 안 왔지?
또는 만들기도 전에 멈췄거나.

그 루프를 끊으려고 여기 온 거잖아.
이번에는 "만들기 전에 팔릴지 확인"부터 시작할 거야.
```

AskUserQuestion으로 상황 확인만 수행 (프로젝트 정보 수집은 `/agnt:audit`에서):

**Q0**: "지금 상황을 알려줘."
- A) 퇴사하고 전업 중 — 아직 첫 매출 없어
- B) 직장 다니면서 사이드프로젝트 중
- C) 이미 매출이 나고 있어
- D) 그 외

**Q0 분기 응답**:
- A: "같은 상황이야. 저축 태우면서 뭘 만들어야 할지 모르는 그 느낌. 30일 안에 답을 찾자."
- B: "이 프로그램은 하루 풀타임(6시간+)을 30일 연속 투입하는 강도로 설계됐어. 계속할 수는 있지만, 파트타임으로는 일정이 빠듯할 수 있어."
- C: "이 커리큘럼은 수익 0에서 시작하는 사람을 위해 설계됐어. 계속할 수는 있지만, 앞 단계가 불필요하게 느껴질 수 있어."
- D: 추가 응답 없이 진행.

project.* 수집은 하지 않는다 (URL 제외). `/agnt:next`가 `/agnt:audit`를 추천하면 거기서 진행.

### 3.5 기존 사이트 확인

Q0 분기 응답 후, **모든 Q0 답변에 공통으로** 기존 사이트 존재 여부를 묻는다.

AskUserQuestion: "이미 만든 랜딩페이지나 사이트가 있어? 있으면 URL 알려줘."
- URL 입력 → Site Reconnaissance 수행
- "없어" / "아직" / 무관한 답변 → 건너뛰고 4단계로

#### Site Reconnaissance

URL이 제공되면, 아래 도구를 **우선순위 순서대로** 시도한다. 첫 번째 성공하는 도구를 사용:

**1순위 — Chrome DevTools MCP** (ToolSearch `+chrome-devtools`):
- `mcp__chrome-devtools__navigate_page` — URL 로드
- `mcp__chrome-devtools__take_screenshot` — 전체 페이지 캡처 (시각 분석용)
- `mcp__chrome-devtools__evaluate_script` — DOM 분석:
  ```javascript
  // H1 텍스트, CTA 버튼, 폼, meta 태그 추출
  JSON.stringify({
    h1: document.querySelector('h1')?.textContent?.trim(),
    ctas: [...document.querySelectorAll('a[href], button')].slice(0, 5).map(el => el.textContent?.trim()),
    forms: document.querySelectorAll('form').length,
    inputs: [...document.querySelectorAll('input[type="email"], input[type="text"]')].length,
    title: document.title,
    metaDesc: document.querySelector('meta[name="description"]')?.content,
    images: document.querySelectorAll('img').length,
    pricing: !!document.body.innerText.match(/\d+[,.]?\d*\s*원|₩|\$\d+|pricing/i)
  })
  ```
- `mcp__chrome-devtools__lighthouse_audit` — 성능/접근성/SEO 점수 (선택, 시간 여유 시)

**2순위 — `/browse` skill (gstack)** (Chrome DevTools 미사용 시):
- URL 네비게이트 + 스크린샷 + 페이지 콘텐츠 추출

**3순위 — Playwright** (`mcp__playwright__*` 또는 Bash `npx playwright`):
- URL 네비게이트 + 스크린샷 + DOM 분석

**4순위 — WebFetch** (최후 수단, 텍스트만):
- HTML 원본 가져오기 → 태그 구조로 분석

#### Recon 분석 항목

| 항목 | 확인 내용 |
|------|----------|
| 페이지 로드 | HTTP 정상, 렌더링 완료 |
| 스크린샷 | 시각적 완성도 — 전문적인가, 깨지는 곳 |
| 헤드라인 (H1) | 명확한 가치 제안 존재 여부 |
| CTA 버튼 | 존재 여부, 텍스트, 위치 |
| 리드 캡처 | 폼, 이메일 입력, 대기리스트 등 |
| 가격/오퍼 | 뭘 얼마에 파는지 노출 여부 |
| 모바일 반응형 | 뷰포트 대응 (가능 시 모바일 스크린샷 추가) |
| SEO 기본 | title, meta description 존재 여부 |

#### Recon 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Site Recon: {URL}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅/❌ 페이지 로드
✅/❌ 헤드라인: "{H1 텍스트}"
✅/❌ CTA: "{버튼 텍스트}"
✅/❌ 리드 캡처 (폼/이메일)
✅/❌ 가격/오퍼
✅/❌ 모바일 반응형
✅/❌ SEO 기본 (title: "{title}")

한줄 진단: {가장 크리티컬한 문제 1가지}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Recon 출력 후, 결과에 기반한 **한 마디** 코멘트:
- 헤드라인 없음: "방문자가 3초 안에 뭔지 모르면 떠나. 헤드라인부터 잡아야 해."
- CTA 없음: "보고 나서 뭘 하라는 건지 안 보여. 버튼이 필요해."
- 폼 없음: "관심 있는 사람을 잡을 장치가 없어. 이메일이라도 받아야 해."
- 전부 있음: "기본 구조는 있어. Audit에서 메시지가 통하는지 검증하자."

#### Recon 결과 저장

- `project.url`에 URL 저장 → state.json Write
- `{AGNT_DIR}/recon-report.md`에 상세 분석 결과 Write:
  ```markdown
  # Site Reconnaissance Report
  - URL: {url}
  - Date: {ISO 8601}
  - Tool: {사용한 도구명}

  ## 분석 결과
  | 항목 | 결과 | 상세 |
  |------|------|------|
  | ... | ✅/❌ | ... |

  ## 스크린샷
  {스크린샷 경로 또는 인라인 설명}

  ## 한줄 진단
  {핵심 문제}
  ```
- `/agnt:audit`가 `recon-report.md`를 참조하여 evidence_clarity 점수에 반영

#### Recon 실패 시

모든 브라우저 도구 사용 불가 시:
- "사이트를 직접 확인하지 못했어. URL은 저장했으니 Audit에서 직접 확인할게."
- `project.url`만 저장하고 4단계로 진행

### 4. 시작 시간 기록 + 완료

`meta.started_at`을 현재 시각(ISO 8601)으로 설정.
`meta.total_actions`를 0으로 설정 (start는 setup이므로 action 카운트 안 함).
`meta.last_action`을 `"start"`로 설정.
state.json Write.

`identity.mode != "synced"`인 경우, 완료 출력 앞에 추가:

```
──────────────────────────────────────────
💡 진행 상황을 저장하고 XP를 받으려면:
`/agnt:connect` — 30초면 Agentic30에 연결돼.
→ 지금 안 해도 언제든 연결 가능.
──────────────────────────────────────────
```

완료 출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Day 1/30 · 남은 29일
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

준비 완료. 먼저 프로젝트 진단부터 시작하자.

/agnt:next — 다음 행동 추천 (Revenue Readiness Audit로 안내)
/agnt:status — 현재 상태 확인
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. 이미 상태가 있는 경우

`project.problem`이 이미 있으면 온보딩을 건너뛴다.

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Day {D}/30 · 남은 {remaining}일
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

이미 시작한 프로젝트가 있어: {project.name}
{project.url이 있으면 → "사이트: " + project.url}

다음 명령:
/agnt:next — 다음 행동 추천받기
/agnt:status — 현재 상태 확인
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## v3 기본 state 스키마

```json
{
  "identity": {
    "mode": "guest",
    "mcp": { "connected": false, "last_checked_at": null }
  },
  "sync": {
    "pending_events": [],
    "last_synced_at": null,
    "last_inline_nudge_at": null,
    "last_cta_nudge_at": null
  },
  "project": {
    "name": null,
    "url": null,
    "problem": null,
    "icp": null,
    "hypothesis": null
  },
  "artifacts": {
    "interviews": 0,
    "spec_versions": 0,
    "landing_deployed": false,
    "offer_drafted": false,
    "channels_active": 0,
    "tracking_links": 0,
    "competitors_analyzed": false,
    "content_planned": false,
    "launch_planned": false,
    "last_analyze_loop": 0,
    "loops_completed": 0
  },
  "signals": {
    "interview_insights": 0,
    "landing_visits": 0,
    "form_responses": 0,
    "link_clicks": 0,
    "payment_intents": 0,
    "revenue": 0
  },
  "tools": {
    "payment": null,
    "analytics": null,
    "marketing_channels": []
  },
  "meta": {
    "authenticated": false,
    "started_at": null,
    "last_action": null,
    "total_actions": 0,
    "schema_version": 3
  }
}
```

## 규칙

- MCP 호출 실패 시 로컬 state는 저장하되 완료 마커는 미기록
- 한국어 출력, 기술 용어 원문 유지
- 온보딩 메시지는 1회만 (project.problem이 있으면 건너뜀)
- project.* 수집은 start에서 하지 않음 — `/agnt:audit`가 담당 (단, `project.url`은 start에서 수집)
- Site Reconnaissance는 URL 제공 시에만 수행 — 없으면 건너뜀
- 브라우저 도구 전부 실패해도 start 플로우를 중단하지 않음 — URL만 저장하고 진행
- Recon 출력은 간결하게 — 상세 분석은 `recon-report.md`에 기록
