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
- v2 기본 state를 Write (아래 스키마)
- 3단계로 이동

**파일이 있는 경우**:
- JSON 파싱 시도. 실패 시 `state.json.bak`으로 백업 후 v2 기본 state 재생성
- `currentDay` 필드가 있으면 v1(RPG) 스키마 → **2단계 마이그레이션** 실행
- `meta.schema_version == 2`이면 이미 v2 → 3단계로 이동

### 2. v1 → v2 마이그레이션

1. 기존 state를 `{AGNT_DIR}/state.v1.bak`으로 복사
2. v2 기본 state 생성
3. 이전하는 필드:
   - `authenticated` → `meta.authenticated`
   - `builderContext.problem` → `project.problem` (있으면)
   - `builderContext.icp` → `project.icp` (있으면)
   - `builderContext.hypothesis` → `project.hypothesis` (있으면)
4. state.json을 v2 스키마로 Write

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  agnt v2.0 — Signal-Driven Navigator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

커리큘럼이 새로워졌어.
Day-by-Day 진행 대신, 네 상태에 맞는 다음 행동을 안내할게.

기존 진행 데이터는 state.v1.bak에 백업했어.
```

### 3. MCP 연결 확인

`ToolSearch`로 `+agentic30` 검색.

**도구 발견됨**:
- `meta.authenticated = true`로 설정
- MCP `complete_onboarding` 호출 (에러 시 무시하고 계속)
- "MCP 연결 완료" 표시

**도구 없음**:
- `meta.authenticated = false` 유지
- MCP 연결 안내 표시:

```
⚠️ MCP 미연결 — 진행 기록이 서버에 저장되지 않아.

[Claude Code] /mcp에서 agentic30 서버를 연결하세요.
[Codex] codex mcp add agentic30 --url https://mcp.agentic30.app/mcp
```

### 4. 온보딩 (project 정보가 없을 때)

`state.project.problem`이 null이면 온보딩을 진행한다.

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  30일 안에 첫 유료 시그널을 만들자
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

나는 네 코파운더 에이전트야.
"팔리는 제품 만들기"를 같이 할 거야.

시작하기 전에 몇 가지 물어볼게.
```

AskUserQuestion으로 순차 질문:

**Q1**: "지금 풀고 싶은 문제가 있어?"
- A) 있어 — 구체적으로 입력받음
- B) 아직 없어 — "괜찮아. `/agnt:discover`에서 같이 찾아보자."로 안내

Q1에서 A를 선택한 경우:

**Q2**: "그 문제를 겪는 사람은 누구야? (구체적으로: 나이, 직업, 상황)"
- 자유 입력

**Q3**: "그 사람이 돈을 내고 살 만한 해결책은 뭐라고 생각해?"
- 자유 입력

수집한 답변을 state에 저장:
- Q1 → `project.problem`
- Q2 → `project.icp`
- Q3 → `project.hypothesis`

`project.name`은 problem에서 자동 생성 (짧은 프로젝트명 추출).

### 5. 시작 시간 기록 + 완료

`meta.started_at`을 현재 시각(ISO 8601)으로 설정.
`meta.total_actions`를 1로 설정.
`meta.last_action`을 `"start"`로 설정.
state.json Write.

MCP 인증 상태이면 `submit_practice`로 `wf-discover` 제출 (Q1에서 A 선택한 경우만).

완료 출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Day 1/30 · 남은 29일
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

준비 완료. 다음 명령:
/agnt:next — 다음 행동 추천받기
/agnt:status — 현재 상태 확인
/agnt:tools — 도구 비교 가이드
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

## v2 기본 state 스키마

```json
{
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
    "tracking_links": 0
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
    "schema_version": 2
  }
}
```

## 규칙

- v1 state 감지 시 자동 마이그레이션 (유저 확인 불필요 — 디자인 문서 결정)
- MCP 호출 실패 시 로컬 state는 저장하되 완료 마커는 미기록
- 한국어 출력, 기술 용어 원문 유지
- 온보딩은 1회만 (project.problem이 있으면 건너뜀)
