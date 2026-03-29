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
- v1 → v2 마이그레이션 내부 판정

## 실행 절차

### 1. state.json 확인

`{AGNT_DIR}/state.json`을 Read 시도.

**파일이 없는 경우** (신규 유저):
- 디렉토리가 없으면 생성
- v3 기본 state를 Write (아래 스키마)
- 3단계로 이동

**파일이 있는 경우**:
- JSON 파싱 시도. 실패 시 `state.json.bak`으로 백업 후 v3 기본 state 재생성
- `currentDay` 필드가 있으면 v1(RPG) 스키마 → **2단계 마이그레이션** 실행
- `meta.schema_version >= 2`이면 v2→v3 체크 후 3단계로 이동:
  - `schema_version == 2`인 경우만 v2→v3 마이그레이션 실행 (아래 참조)
  - `schema_version >= 3`이면 마이그레이션 불필요, 바로 3단계로 이동

### 2. v1 → v2 마이그레이션

1. 기존 state를 `{AGNT_DIR}/state.v1.bak`으로 복사
2. v3 기본 state 생성
3. 이전하는 필드:
   - `authenticated` → `meta.authenticated`
   - `builderContext.problem` → `project.problem` (있으면)
   - `builderContext.icp` → `project.icp` (있으면)
   - `builderContext.hypothesis` → `project.hypothesis` (있으면)
4. state.json을 v3 스키마로 Write (identity + sync 섹션 포함)

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  agnt v2.0 — Signal-Driven Navigator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

커리큘럼이 새로워졌어.
Day-by-Day 진행 대신, 네 상태에 맞는 다음 행동을 안내할게.

기존 진행 데이터는 state.v1.bak에 백업했어.
```

### 2-b. v2 → v3 마이그레이션

`meta.schema_version == 2`인 경우 (무음 처리):

1. `identity` 섹션이 없으면 삽입:
   - `meta.authenticated == true` → `identity.mode = "synced"`, `identity.mcp.connected = true`
   - `meta.authenticated == false` (또는 미존재) → `identity.mode = "guest"`, `identity.mcp.connected = false`
   - `identity.mcp.last_checked_at = null`
2. `sync` 섹션이 없으면 삽입:
   - `{ "pending_events": [], "last_synced_at": null, "last_inline_nudge_at": null, "last_cta_nudge_at": null }`
3. `meta.authenticated` 필드 유지 (하위 호환)
4. `meta.schema_version = 3`으로 갱신
5. `state.json` 저장

### 3. MCP 연결 확인

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

### 4. 온보딩 메시지

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

project.* 수집은 하지 않는다. `/agnt:next`가 `/agnt:audit`를 추천하면 거기서 진행.

### 5. 시작 시간 기록 + 완료

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

### 6. 이미 v2 상태가 있는 경우

`project.problem`이 이미 있으면 온보딩을 건너뛴다.

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Day {D}/30 · 남은 {remaining}일
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

이미 시작한 프로젝트가 있어: {project.name}

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

## journey-brief 마이그레이션

start 실행 시 (1단계 이후):

1. `{AGNT_DIR}/journey-brief.md` Read 시도
2. 없으면 `{AGNT_DIR}/decision-brief.md` Read 시도
3. `decision-brief.md`가 있으면 → `journey-brief.md`로 파일명 변경 (기존 Phase 3 데이터 보존)
4. 둘 다 없으면 → 무시 (첫 Write하는 커맨드가 생성)

## 규칙

- v1 state 감지 시 자동 마이그레이션 (유저 확인 불필요 — 디자인 문서 결정)
- decision-brief.md → journey-brief.md 마이그레이션은 무음 처리
- MCP 호출 실패 시 로컬 state는 저장하되 완료 마커는 미기록
- 한국어 출력, 기술 용어 원문 유지
- 온보딩 메시지는 1회만 (project.problem이 있으면 건너뜀)
- project.* 수집은 start에서 하지 않음 — `/agnt:audit`가 담당
