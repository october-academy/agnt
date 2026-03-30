분석 환경 세팅. PostHog 설치 안내와 제품 유형별 핵심 이벤트를 추천합니다.

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

내부 로직 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료

기본값 보증:
- `artifacts.analytics_setup`가 undefined면 `false`로 처리

### 2. PostHog 설치 안내

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  분석 환경 세팅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

제품에 PostHog를 연결하고 핵심 이벤트를 설정하자.

📦 설치 방법 2가지:

1️⃣ 자동 설치 (추천):
   npx @posthog/wizard
   → 프레임워크 감지 + 설정 파일 자동 생성

2️⃣ 수동 설치:
   npm install posthog-js (또는 bun add posthog-js)
   → posthog.init('phc_YOUR_KEY', { api_host: 'https://us.i.posthog.com' })
```

AskUserQuestion: "PostHog 설치 상태는?"
- A) 이미 설치됨
- B) 지금 설치할게 (진행 후 돌아올게)
- C) 나중에 할게 — 이벤트 추천만 먼저

### 3. 제품 유형 선택

`{REFS_DIR}/analytics/posthog-events.md` Read.

AskUserQuestion: "제품 유형은?"
- A) SaaS (웹 앱/대시보드)
- B) 앱 (모바일/데스크톱)
- C) 커머스 (쇼핑몰/마켓플레이스)
- D) 콘텐츠 (블로그/뉴스레터/강의)
- E) API / 개발자 도구

### 4. 이벤트 추천

선택한 유형에 맞는 핵심 이벤트를 posthog-events.md에서 로드하여 출력한다.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {유형} 핵심 이벤트
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{이벤트 테이블 — posthog-events.md 기반}

📝 코드 예시:
{해당 유형의 코드 스니펫}

+ 공통 이벤트:
• $pageview (자동)
• cta_clicked
• error_occurred
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. MCP 연동 안내

```
📡 MCP 연결하면 PostHog 데이터를 자동 동기화할 수 있어.
```

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
```
MCP 연결됨. connect_posthog_project로 API key를 연결해줘:
→ PostHog 프로젝트 설정 → Project API Key 복사
```

도구 없으면:
```
MCP 미연결 — /agnt:connect로 연결하면 PostHog 데이터 동기화 가능.
```

### 6. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  분석 환경 세팅 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

설정한 것:
• PostHog: {설치됨/보류}
• 추천 이벤트: {유형}별 {N}개

이벤트를 심으면 유저 행동 데이터가 쌓이기 시작해.
1주일 후 /agnt:analyze에서 실제 데이터를 분석할 수 있어.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 7. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.analytics_setup = true`
- `tools.analytics = "posthog"`
- `meta.last_action = "analytics-setup"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-analytics-setup"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-analytics-setup" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- PostHog를 강제하지 않는다 — GA4, Amplitude도 대안으로 안내 (`/agnt:tools` C 참조)
- 이벤트는 5-8개만 추천 — 처음부터 과다 추적 방지
- 코드 스니펫은 참고용 — 유저 프로젝트에 직접 삽입하지 않음
- state.json Write 먼저 (critical path)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
