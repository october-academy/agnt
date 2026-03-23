# Navigator Engine — Signal-Driven Navigator 규칙

이 문서는 agnt v2의 모든 커맨드가 따르는 Navigator 시스템의 SSoT입니다.

## 1. State Schema (v2)

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

### v1 → v2 마이그레이션

`state.json`에 `currentDay` 필드가 있으면 v1(RPG) 스키마다.

1. 기존 `state.json`을 `state.v1.bak`으로 복사
2. 신규 v2 스키마로 fresh state 생성
3. 이전하는 필드:
   - `authenticated` → `meta.authenticated`
   - `builderContext.problem` → `project.problem` (있으면)
   - `builderContext.icp` → `project.icp` (있으면)
   - `builderContext.hypothesis` → `project.hypothesis` (있으면)
4. 나머지 필드는 초기값 유지

## 2. 경로 결정 (모든 커맨드 공통)

### AGNT_DIR (state + data 루트)

아래 순서로 탐색. 첫 번째 성공한 경로 사용:

1. `.claude/agnt/state.json` → project scope (모노레포 개발자)
2. `~/.claude/agnt/state.json` → user scope (Claude Code 외부 유저)
3. `.codex/agnt/state.json` → project scope (Codex)
4. `~/.codex/agnt/state.json` → user scope (Codex)
5. 모두 없으면 → Claude Code: `~/.claude/agnt`, Codex: `~/.codex/agnt` (기본값)

### REFS_DIR (references 루트)

`navigator-engine.md` 존재 여부로 탐색:

1. `{AGNT_DIR}/references/`
2. `~/.claude/plugins/marketplaces/agentic30/references/`
3. `.agents/skills/agnt/references/`
4. `~/.codex/skills/agnt/references/`
5. 모두 없으면 에러

## 3. Navigator 추천 로직 (`/agnt:next`)

state를 읽고, 아래 우선순위로 다음 행동을 추천한다. 첫 번째 매칭되는 조건을 추천.

### 추천 우선순위 테이블

| # | 조건 | 추천 커맨드 | 메시지 |
|---|------|-------------|--------|
| 1 | `project.problem == null` | `/agnt:discover` | "아직 어떤 문제를 풀지 정하지 않았어요." |
| 2 | `artifacts.interviews < 3` | `/agnt:interview` | "인터뷰 {N}/3. 최소 3건의 고객 대화가 있어야 가설이 선명해져요." |
| 3 | `artifacts.spec_versions == 0` | `/agnt:spec` | "인터뷰 {N}건 완료. 이제 SPEC으로 정리할 시점이에요." |
| 4 | `!artifacts.landing_deployed` | `/agnt:landing` | "SPEC이 있으니 랜딩페이지를 만들어 반응을 확인해보세요." |
| 5 | `artifacts.channels_active < 2` | `/agnt:channel` | "랜딩이 있으니 사람들에게 보여줄 채널 {N}/2를 선정하세요." |
| 6 | `signals.link_clicks > 0 && !artifacts.offer_drafted` | `/agnt:offer` | "클릭이 들어오고 있어요. 이제 오퍼를 설계할 시점이에요." |
| 7 | `artifacts.offer_drafted && signals.revenue == 0` | `/agnt:launch` | "오퍼가 준비됐어요. 실제로 내보내세요." |
| 8 | 시그널 변화 감지 (이전 조회 대비 증가) | `/agnt:analyze` | "새 시그널이 들어왔어요. 분석하고 다음 행동을 정하세요." |
| 9 | `meta.total_actions > 5` && 마지막 retro 후 7+ actions | `/agnt:retro` | "활동이 쌓였어요. 회고하고 다음 스프린트를 계획하세요." |
| 10 | 위 모두 해당 없음 | `/agnt:status` | "모든 단계를 완료했어요! 현재 상태를 확인해보세요." |

### 추천 출력 포맷

```
══════════════════════════════════════════
  Day {D}/30 · 남은 {30-D}일
══════════════════════════════════════════

📍 다음 행동: /agnt:{command}

{메시지}

근거: {왜 이 행동인지 1-2문장}
진척: {현재까지 완료된 항목 요약}
예상 소요: {시간 추정}
══════════════════════════════════════════
```

### 비강제 원칙

Navigator는 **추천만** 한다. 유저가 순서를 어겨도 차단하지 않는다. 단, MCP 레벨 게이팅된 도구는 XP 부족 시 자연 차단된다.

## 4. 카운트다운 + 시간 가중치

### 카운트다운 계산

```
D = floor((now - meta.started_at) / 86400000) + 1
remaining = max(0, 30 - D)
```

- `meta.started_at`이 null이면 카운트다운 미표시
- D > 30이어도 모든 기능 정상 동작 (잠금 없음)

### 시간 가중치 (톤 변화)

Navigator 추천 시, 진행 단계 대비 경과 시간으로 톤을 조절한다.

| 경과일 | 기대 단계 | 톤 |
|--------|-----------|-----|
| D 1-7 | discover + interview 시작 | 기본 — "차근차근 시작해봐요" |
| D 8-15 | interview 완료 + spec | 기본 — "좋은 페이스예요" |
| D 16-22 | landing + channel | 독려 — "중반이에요, 속도를 높여볼까요?" |
| D 23-30 | offer + launch | 긴급 — "마감이 가까워요. 핵심에 집중하세요" |
| D 31+ | 어떤 단계든 | 중립 — "30일이 지났지만, 계속 진행할 수 있어요" |

**시간 가중치 적용 규칙:**
- 추천 순서를 바꾸지 않는다 (순수 상태 기반 유지)
- 톤과 부가 메시지만 변경한다
- 뒤처진 경우: "속도를 높여야 합니다" 메시지 추가
- 앞서가는 경우: "좋은 페이스예요" 메시지 추가

## 5. State Mutation Contract

### 원칙

1. 각 워크플로우 커맨드가 자신의 state 필드를 직접 업데이트한다
2. 워크플로우 완료 시 반드시 `state.json` 업데이트 → MCP `submit_practice` 호출 순서
3. MCP 호출 실패 시 로컬 state는 저장하되 완료 마커는 미기록 (fail-closed)
4. `/agnt:next`는 state를 **읽기만** 한다 (쓰기 금지)
5. `meta.total_actions`는 모든 워크플로우 완료 시 +1
6. `meta.last_action`은 마지막 실행한 커맨드 이름

### 커맨드별 Mutation 매핑

| Command | 업데이트하는 state 필드 | MCP 호출 |
|---|---|---|
| `/agnt:start` | `meta.started_at`, `meta.authenticated` | `complete_onboarding` |
| `/agnt:discover` | `project.problem`, `project.icp`, `project.hypothesis` | `save_interview`, `submit_practice("wf-discover")` |
| `/agnt:interview` | `artifacts.interviews++`, `signals.interview_insights++` | `submit_practice("wf-interview-{N}")` |
| `/agnt:spec` | `artifacts.spec_versions++` | `save_spec_iteration`, `submit_practice("wf-spec-{N}")` |
| `/agnt:build` | (체크리스트 로컬 기록) | `submit_practice("wf-build")` |
| `/agnt:landing` | `artifacts.landing_deployed = true` | `deploy_landing`, `submit_practice("wf-landing")` |
| `/agnt:channel` | `artifacts.channels_active++`, `artifacts.tracking_links++` | `create_utm_link`, `submit_practice("wf-channel-{N}")` |
| `/agnt:offer` | `artifacts.offer_drafted = true`, `tools.payment` | `submit_practice("wf-offer")` |
| `/agnt:launch` | `signals.*` (MCP에서 조회) | `submit_practice("wf-launch")` |
| `/agnt:analyze` | `signals.*` (MCP에서 조회 후 로컬 캐시) | `get_landing_analytics`, `get_links` |
| `/agnt:retro` | `meta.last_action = "retro"` | `submit_practice("wf-retro")` |
| `/agnt:status` | 없음 (읽기 전용) | `get_leaderboard` (선택) |
| `/agnt:tools` | `tools.*` (유저 선택 기록) | 없음 |

## 6. MCP 연동 규칙

### 연결 확인

모든 커맨드 시작 시:

1. `ToolSearch`로 `+agentic30` 검색
2. 도구가 로드되면 MCP 사용 가능
3. 도구 미발견 시:
   - Claude Code: `/mcp`에서 `agentic30` 인증 안내
   - Codex: `codex mcp add agentic30 --url https://mcp.agentic30.app/mcp` 안내

### MCP 미인증 시 동작

MCP 없이도 로컬 워크플로우는 동작한다:
- `state.json` 읽기/쓰기: 정상
- 추천 로직: 정상 (로컬 state 기반)
- 참조 파일 읽기: 정상
- XP/레벨 동기화: 불가 (로컬에서 추적 안 함)
- 퀘스트 제출: 불가 (MCP 필수 — 완료 마커 미기록)

안내 메시지: "MCP 미연결 상태입니다. 로컬에서 진행할 수 있지만, 진행 기록은 MCP 연결 후 동기화됩니다."

## 7. 템플릿 변수

커맨드 출력에서 `{variable}` 패턴을 state 데이터로 치환한다.

| 변수 | 소스 | 예시 |
|------|------|------|
| `{project.name}` | state.project.name | "밥친구" |
| `{project.problem}` | state.project.problem | "혼밥이 외롭다" |
| `{project.icp}` | state.project.icp | "1인 가구 직장인" |
| `{artifacts.interviews}` | state.artifacts.interviews | "3" |
| `{D}` | 경과일 계산 | "12" |
| `{remaining}` | 남은일 계산 | "18" |

## 8. 퀘스트 ID 네이밍

기존: `d{day}-{slug}` (예: `d1-interview`)
신규: `wf-{workflow}-{n}` (예: `wf-interview-1`)

| Quest ID | Phase | XP | 설명 |
|----------|-------|-----|------|
| `wf-discover` | 1 | 100 | 문제 선택 + ICP 정의 |
| `wf-interview-1` | 1 | 80 | 고객 인터뷰 1회차 |
| `wf-interview-2` | 1 | 80 | 고객 인터뷰 2회차 |
| `wf-interview-3` | 1 | 80 | 고객 인터뷰 3회차 |
| `wf-spec-1` | 1 | 100 | SPEC v1 작성 |
| `wf-spec-2` | 1 | 80 | SPEC v2 이터레이션 |
| `wf-build` | 2 | 100 | MVP 빌드 완료 |
| `wf-landing` | 2 | 100 | 랜딩페이지 배포 |
| `wf-channel-1` | 2 | 60 | 채널 1 활성화 |
| `wf-channel-2` | 2 | 60 | 채널 2 활성화 |
| `wf-offer` | 3 | 100 | 오퍼 설계 완료 |
| `wf-launch` | 3 | 100 | GTM 실행 |
| `wf-analyze-1` | 3 | 60 | 시그널 분석 1회차 |
| `wf-retro` | 3 | 50 | 회고 완료 |

**XP 적산 예상:**
- Phase 1 (discover + interview×3 + spec×2): 520 XP → Lv.4
- Phase 2 (build + landing + channel×2): 320 XP → 누적 840 → Lv.6
- Phase 3 (offer + launch + analyze + retro): 310 XP → 누적 1150 → Lv.9 근접

## 9. 출력 톤 규칙

- 2인칭 현재형 반말 (존댓말 아님, 격식 아님)
- 짧고 직접적인 문장 — 프레임워크 용어보다 행동 지시
- 이모지 최소 사용 (카운트다운 헤더에만)
- 기술 용어(MCP, OAuth, CLI, SPEC)는 원문 유지
- 한국어 진행

## 10. Codex 호환

| Claude Code | Codex 대응 |
|---|---|
| `/agnt:start` | `$agnt-start` |
| `/agnt:next` | `$agnt-next` |
| `/agnt:discover` | `$agnt-discover` |
| `/agnt:interview` | `$agnt-interview` |
| `/agnt:spec` | `$agnt-spec` |
| `/agnt:tools` | `$agnt-tools` |
| `/agnt:status` | `$agnt-status` |
| `ToolSearch` | `codex mcp list` |
| `AskUserQuestion` | `ask(...)` |
