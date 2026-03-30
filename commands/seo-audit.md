SEO 기본 점검. 사이트 URL의 SEO 요소 10개를 점검하고 점수와 개선 체크리스트를 제공합니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색.

## 출력 규칙

내부 로직(경로 탐색, state 파싱, MCP 검색)은 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료

기본값 보증 (navigator-engine.md 필드 기본값 규칙):
- `artifacts.seo_audited`가 undefined면 `false`로 처리
- `artifacts.landing_deployed`가 undefined면 `false`로 처리

### 2. URL 입력

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO 기본 점검
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

사이트 URL을 알려줘.
```

AskUserQuestion: "점검할 URL은?"
- 자유 입력 (예: "https://myproduct.com")

### 3. 점검 모드 결정 (3-tier 폴백)

`{REFS_DIR}/seo/seo-checklist.md` Read.

**Tier 1 — 자동 점검 (gstack /browse):**
gstack /browse가 사용 가능하면 URL에 접속하여 10개 항목을 자동 점검한다.
HTML 소스에서 title, meta description, OG 태그, viewport, h1, canonical을 파싱.
robots.txt, sitemap.xml 접근을 확인.
응답 시간을 측정.

**Tier 2 — WebFetch 폴백:**
gstack 불가 시 WebFetch로 HTML을 가져와 동일 항목을 점검한다.
robots.txt, sitemap.xml은 별도 WebFetch.

**Tier 3 — 수동 체크리스트:**
자동 도구가 모두 불가 시, seo-checklist.md 기반으로 AskUserQuestion을 통해 유저에게 직접 확인한다.

AskUserQuestion (각 항목별):
- "HTTPS 적용 되어 있어?" → 예/아니오
- "title 태그가 있어? 60자 이내야?" → 예/아니오
- ... (10개 항목)

### 4. 점수 계산 + 결과 출력

seo-checklist.md의 배점 기준으로 점수를 산출한다.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO 점검 결과
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

URL: {입력한 URL}
점수: {점수}/100 ({등급})

✅ 통과 항목:
  {통과한 항목 나열}

❌ 미비 항목:
  {미비 항목 + 개선 방법 요약}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. OG 이미지 미비 안내

og:image가 없거나 비어있으면:

```
⚠️ OG 이미지가 없어. 링크 공유 시 미리보기가 깨져.

무료 생성 도구:
• Canva — canva.com (1200×630 템플릿)
• og.dev — 코드 기반 동적 OG 이미지
• @vercel/og — Vercel 프로젝트용

OG 이미지 설정 후 다시 점검해봐.
```

### 6. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `## Market` 섹션에 `### SEO` 서브섹션을 추가 또는 Replace.

SEO 섹션:
```markdown
### SEO
- 점검 URL: {URL}
- 점수: {점수}/100 ({등급})
- 미비 항목: {미비 항목 요약}
- 점검일: {날짜}
```

### 7. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO 점검 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{등급에 따른 메시지}

{미비 항목이 있으면}
미비 항목을 수정하고 다시 /agnt:seo-audit 해봐.

{미비 항목이 없으면}
기본 SEO는 완비됐어. 콘텐츠로 검색 유입을 확대하자 → /agnt:content
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 8. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.seo_audited = true`
- `meta.last_action = "seo-audit"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-seo-audit"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-seo-audit" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- 점수를 부풀리지 않는다 — 미비 항목은 미비로 표시
- 자동 점검 결과가 애매하면 보수적으로 판정 (미비로)
- OG 이미지는 반드시 체크 — 링크 공유 시 가장 체감 큰 항목
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
