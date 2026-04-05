# Navigator Engine — Signal-Driven Navigator 규칙

이 문서는 agnt v2의 모든 커맨드가 따르는 Navigator 시스템의 SSoT입니다.

## 1. State Schema (v3)

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

### identity.mode 3-value enum

| 값             | 의미                                                         |
| -------------- | ------------------------------------------------------------ |
| `"guest"`      | 미가입, 미연결 (초기 상태)                                   |
| `"registered"` | 웹 가입 완료, MCP 미연결 (가입 확인 후 MCP 인증 실패/미완료) |
| `"synced"`     | 웹 가입 + MCP 인증 완료                                      |

### pending_events 형식

`submit_practice`만 큐잉. 최대 50건. 초과 시 가장 오래된 이벤트 제거 (FIFO).

```json
{
  "type": "submit_practice",
  "args": { "quest_id": "wf-discover" },
  "created_at": "2026-03-25T00:00:00.000Z"
}
```

`args`는 `{ quest_id: string }` 고정 형식. 50건이어도 ~3KB 미만.

`save_interview`, `save_spec_iteration`은 큐잉하지 않음 — 로컬 파일(`journey-brief.md`, `specs/spec-v{N}.md`)에 이미 보존됨.

### 필드 기본값 규칙

state.json에 필드가 누락된 경우 (기존 유저), 아래 기본값을 사용한다. 커맨드는 누락 필드에 대해 실패하지 않아야 한다.

| 필드                                | 기본값                                                                                                      | 설명                                                                                   |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `artifacts.competitors_analyzed`    | `false`                                                                                                     | 경쟁 분석 완료 여부                                                                    |
| `artifacts.content_planned`         | `false`                                                                                                     | 콘텐츠 전략 수립 여부                                                                  |
| `artifacts.launch_planned`          | `false`                                                                                                     | 론칭 계획 수립 여부                                                                    |
| `artifacts.last_analyze_loop`       | `0`                                                                                                         | 마지막 analyze 실행 루프 (0 = 미실행)                                                  |
| `artifacts.loops_completed`         | `0`                                                                                                         | Decision Loop 완료 횟수                                                                |
| `identity`                          | `{ "mode": "guest", "mcp": { "connected": false, "last_checked_at": null } }`                               | 섹션 전체 누락 시                                                                      |
| `identity.mode`                     | `"guest"`                                                                                                   | 미가입/미연결 기본 상태                                                                |
| `identity.mcp.connected`            | `false`                                                                                                     | MCP 미연결 기본 상태                                                                   |
| `sync`                              | `{ "pending_events": [], "last_synced_at": null, "last_inline_nudge_at": null, "last_cta_nudge_at": null }` | 섹션 전체 누락 시                                                                      |
| `sync.pending_events`               | `[]`                                                                                                        | 미동기화 이벤트 없음                                                                   |
| `sync.last_inline_nudge_at`         | `null`                                                                                                      | 인라인 넛지 미표시                                                                     |
| `sync.last_cta_nudge_at`            | `null`                                                                                                      | Navigator CTA 미표시                                                                   |
| `artifacts.seo_audited`             | `false`                                                                                                     | SEO 점검 완료 여부                                                                     |
| `artifacts.analytics_setup`         | `false`                                                                                                     | 분석 환경 세팅 완료 여부                                                               |
| `artifacts.launch_copies_generated` | `false`                                                                                                     | 런칭 카피 생성 완료 여부                                                               |
| `artifacts.ad_creatives_generated`  | `false`                                                                                                     | 광고 소재 생성 완료 여부                                                               |
| `tools.business_registration`       | `null`                                                                                                      | 사업자 등록 판정 (null/delayed/registered/considering)                                 |
| `tools.revenue_model`               | `null`                                                                                                      | 추천 수익 모델 (null/saas/ebook/consulting/cohort/ads/sponsor/affiliate/template)      |
| `audit_result`                      | `null`                                                                                                      | Audit 판정 결과 (null 또는 { track, verdict, user_confidence, reasons, completed_at }) |
| `audit_progress`                    | `null`                                                                                                      | Audit 세션 진행 상태 (null 또는 { current_step: 1-4, data: {} }) — 중단 시 resume용    |

**모든 커맨드는 이 기본값을 사용.**

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

| #   | 조건                                                                                                                       | 추천 커맨드       | 메시지                                                                                                      |
| --- | -------------------------------------------------------------------------------------------------------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------- |
| 0   | `audit_result == null && (meta.total_actions == 0 \|\| project.problem == null)`                                           | `/agnt:audit`     | "Revenue Readiness Audit부터 시작해. 45분이면 돼."                                                          |
| 1   | `project.problem == null && audit_result.track != "A"`                                                                     | `/agnt:discover`  | "아직 어떤 문제를 풀지 정하지 않았어요."                                                                    |
| 2   | `artifacts.interviews < 3 && audit_result.track != "A"`                                                                    | `/agnt:interview` | "인터뷰 {N}/3. 최소 3건의 고객 대화가 있어야 가설이 선명해져요."                                            |
| 3   | `!artifacts.competitors_analyzed && audit_result.track != "A"`                                                             | `/agnt:compete`   | "인터뷰에서 현재 대안을 들었어요. 경쟁 환경을 체계적으로 정리하세요."                                       |
| 4   | `artifacts.spec_versions == 0 && audit_result.track != "A"`                                                                | `/agnt:spec`      | "경쟁 분석 완료. 이제 SPEC으로 제품을 정리할 시점이에요."                                                   |
| 5   | `artifacts.channels_active < 2`                                                                                            | `/agnt:channel`   | "이제 사람들에게 보여줄 채널 {N}/2를 정하세요. 메시지 정리가 필요하면 `/agnt:landing`도 바로 쓸 수 있어요." |
| 6   | `!artifacts.content_planned`                                                                                               | `/agnt:content`   | "채널이 있어요. 거기에 뭘 올릴지 콘텐츠 전략을 세우세요."                                                   |
| 7   | `(signals.link_clicks > 0 \|\| (artifacts.channels_active >= 2 && artifacts.content_planned)) && !artifacts.offer_drafted` | `/agnt:offer`     | "오퍼를 설계할 시점이에요. 클릭 데이터 또는 채널+콘텐츠 준비가 됐어요."                                     |
| 8   | `artifacts.offer_drafted && !artifacts.launch_planned`                                                                     | `/agnt:launch`    | "오퍼가 준비됐어요. 론칭 계획을 세우세요."                                                                  |
| 9   | `artifacts.launch_planned && artifacts.last_analyze_loop < artifacts.loops_completed + 1`                                  | `/agnt:analyze`   | "론칭 후 결과를 분석할 시점이에요. 성과를 판정하세요."                                                      |
| 10  | `artifacts.last_analyze_loop > artifacts.loops_completed`                                                                  | `/agnt:retro`     | "분석이 끝났어요. 회고하고 다음 루프를 계획하세요."                                                         |
| 11  | 위 모두 해당 없음                                                                                                          | `/agnt:status`    | "모든 단계를 완료했어요! 현재 상태를 확인해보세요."                                                         |

### Track별 skip 규칙

`audit_result.track`이 존재할 때, 위 테이블의 조건에 추가로 적용되는 skip 규칙:

| Track            | skip하는 Row                                   | 이유                                                                |
| ---------------- | ---------------------------------------------- | ------------------------------------------------------------------- |
| A (바로 빌드)    | 1(discover), 2(interview), 3(compete), 4(spec) | Audit에서 project.\* 수집 완료, 검증 불필요 → 바로 채널/메시지 검증 |
| B (검증 필요)    | 1(discover)                                    | Audit에서 project.\* 수집 완료, 인터뷰부터 시작                     |
| C (문제 탐색)    | 없음                                           | 전체 플로우 진행                                                    |
| 없음 (기존 유저) | 없음                                           | 기존 테이블 그대로                                                  |

**규칙**: `audit_result.track`이 null이면 skip 조건을 평가하지 않는다 (기존 유저 호환).
Track A 유저가 명시적으로 `/agnt:discover`를 실행하면 차단하지 않는다 (비강제 원칙 유지).

### 부가 메시지 (추천 시 사이드 안내)

추천 커맨드 출력 시, 아래 조건에 해당하면 부가 메시지를 추가한다. 메인 추천 순서는 변경하지 않는다.

| 추천 커맨드                         | 조건                          | 부가 메시지                                                         |
| ----------------------------------- | ----------------------------- | ------------------------------------------------------------------- |
| `/agnt:channel`                     | —                             | "메시지가 아직 흐리면 `/agnt:landing`으로 헤드라인/CTA부터 정리해." |
| `/agnt:channel`                     | —                             | "사업자 등록 고민이면 /agnt:biz-setup"                              |
| `/agnt:offer`                       | `!artifacts.analytics_setup`  | "분석 세팅이 안 되어 있으면 /agnt:analytics-setup"                  |
| `/agnt:launch`                      | —                             | "/agnt:launch-copy로 10채널 카피를 한 번에 만들 수 있어."           |
| `/agnt:analyze`                     | CONTINUE 또는 PIVOT 판정 시   | "트래픽이 더 필요하면 /agnt:ad-creative"                            |
| `/agnt:retro` 이후 (`/agnt:status`) | `tools.revenue_model == null` | "수익 모델 고민이면 /agnt:revenue"                                  |

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

#### Track별 기대 기간

`audit_result.track`이 존재하면 해당 Track의 기대 기간을 사용한다. 없으면 기본 30일 테이블.

| Track | 기대 기간 | 기본 구간 | 독려 구간 | 긴급 구간 | 초과  |
| ----- | --------- | --------- | --------- | --------- | ----- |
| A     | 5일       | D 1-2     | D 3       | D 4-5     | D 6+  |
| B     | 8일       | D 1-4     | D 5-6     | D 7-8     | D 9+  |
| C     | 10일      | D 1-5     | D 6-8     | D 9-10    | D 11+ |
| 없음  | 30일      | D 1-15    | D 16-22   | D 23-30   | D 31+ |

#### 톤 매핑

| 구간 | 톤                                        |
| ---- | ----------------------------------------- |
| 기본 | "차근차근 시작해봐요" / "좋은 페이스예요" |
| 독려 | "중반이에요, 속도를 높여볼까요?"          |
| 긴급 | "마감이 가까워요. 핵심에 집중하세요"      |
| 초과 | "기간이 지났지만, 계속 진행할 수 있어요"  |

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
4. `/agnt:next`는 state를 **읽기만** 한다 (쓰기 금지) — 단, 자동 실행(Step 9)으로 dispatch된 자식 스킬은 자신의 Mutation Contract에 따라 state를 쓴다
5. `meta.total_actions`는 모든 워크플로우 완료 시 +1
6. `meta.last_action`은 마지막 실행한 커맨드 이름

### 커맨드별 Mutation 매핑

| Command                                | 업데이트하는 state 필드                                                                                                                 | MCP 호출                                                                    |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `/agnt:start`                          | `meta.started_at`, `meta.authenticated`                                                                                                 | `complete_onboarding`                                                       |
| `/agnt:audit`                          | `project.*`, `audit_result`, `audit_progress` (resume), `meta.last_action = "audit"`, `meta.total_actions++`                            | `submit_practice("wf-audit")`                                               |
| `/agnt:connect`                        | `identity.mode`, `identity.mcp.*`, `sync.pending_events` (플러시), `sync.last_synced_at`                                                | `submit_practice` (pending_events 일괄)                                     |
| `/agnt:discover`                       | `project.problem`, `project.icp`, `project.hypothesis`                                                                                  | `save_interview`, `submit_practice("wf-discover")`                          |
| `/agnt:interview`                      | `artifacts.interviews++`, `signals.interview_insights++`                                                                                | `submit_practice("wf-interview-{N}")`                                       |
| `/agnt:compete`                        | `artifacts.competitors_analyzed = true`, `meta.last_action = "compete"`, `meta.total_actions++`                                         | `submit_practice("wf-compete")`                                             |
| `/agnt:spec`                           | `artifacts.spec_versions++`                                                                                                             | `save_spec_iteration`, `submit_practice("wf-spec-{N}")`                     |
| `/agnt:build`                          | `meta.last_action = "build"`                                                                                                            | `submit_practice("wf-build")`                                               |
| `/agnt:landing`                        | `meta.last_action = "landing"`, `meta.total_actions++`                                                                                  | 없음 (전략 메모만 저장)                                                     |
| `/agnt:channel`                        | `artifacts.channels_active++`, `tools.marketing_channels` 추가                                                                          | `submit_practice("wf-channel-{N}")`                                         |
| `/agnt:content`                        | `artifacts.content_planned = true`, `meta.last_action = "content"`, `meta.total_actions++`                                              | `submit_practice("wf-content")`                                             |
| `/agnt:offer`                          | `artifacts.offer_drafted = true`, `meta.last_action = "offer"`, `meta.total_actions++`                                                  | `submit_practice("wf-offer")`, `save_spec_iteration(type:"paywall")` (선택) |
| `/agnt:launch`                         | `artifacts.launch_planned = true`, `meta.last_action = "launch"`, `meta.total_actions++`                                                | `submit_practice("wf-launch")`                                              |
| `/agnt:analyze`                        | `artifacts.last_analyze_loop = loops_completed + 1`, `meta.last_action = "analyze"`, `meta.total_actions++`                             | `get_links`, `submit_practice("wf-analyze-1")`                              |
| `/agnt:retro`                          | `artifacts.loops_completed++`, `artifacts.launch_planned = false`, `meta.last_action = "retro"`, `meta.total_actions++`                 | `submit_practice("wf-retro")`                                               |
| `/agnt:status`                         | 없음 (읽기 전용, auto-flush 시 `sync.pending_events`, `sync.last_synced_at` 쓰기는 예외)                                                | `get_leaderboard` (선택)                                                    |
| `/agnt:tools`                          | `tools.*` (유저 선택 기록)                                                                                                              | 없음                                                                        |
| `/agnt:seo-audit`                      | `artifacts.seo_audited = true`, `meta.last_action = "seo-audit"`, `meta.total_actions++`                                                | `submit_practice("wf-seo-audit")`                                           |
| `/agnt:biz-setup`                      | `tools.business_registration = "{판정}"`, `meta.last_action = "biz-setup"`, `meta.total_actions++`                                      | `submit_practice("wf-biz-setup")`                                           |
| `/agnt:analytics-setup`                | `artifacts.analytics_setup = true`, `tools.analytics = "posthog"`, `meta.last_action = "analytics-setup"`, `meta.total_actions++`       | `submit_practice("wf-analytics-setup")`                                     |
| `/agnt:launch-copy`                    | `artifacts.launch_copies_generated = true`, `artifacts.tracking_links += N`, `meta.last_action = "launch-copy"`, `meta.total_actions++` | `create_utm_link` × N (synced), `submit_practice("wf-launch-copy")`         |
| `/agnt:ad-creative`                    | `artifacts.ad_creatives_generated = true`, `meta.last_action = "ad-creative"`, `meta.total_actions++`                                   | `submit_practice("wf-ad-creative")`                                         |
| `/agnt:revenue`                        | `tools.revenue_model = "{모델명}"`, `meta.last_action = "revenue"`, `meta.total_actions++`                                              | `get_growth_report` (선택), `submit_practice("wf-revenue")`                 |
| 모든 워크플로우 커맨드 (MCP 미연결 시) | `sync.pending_events` append `{type: "submit_practice", args: {quest_id}, created_at}`                                                  | 없음 (큐잉)                                                                 |

> **`/agnt:next` read-only 규칙 예외**: 기본적으로 next는 state를 읽기만 한다. 예외: (1) MCP 시그널 동기화 (`signals.*`), (2) Identity Overlay CTA 표시 후 `sync.last_cta_nudge_at` 쓰기, (3) 자동 실행(Step 9)으로 dispatch된 자식 스킬의 state 변경 — 자식 스킬은 자신의 Mutation Contract를 따른다. next 자체는 state를 직접 쓰지 않는다.

### pending_events 플러시 규칙 (`/agnt:connect`)

1. `sync.pending_events` 배열을 순서대로 순회
2. 각 이벤트에 대해 MCP `submit_practice(quest_id)` 호출
3. 성공 시: 해당 이벤트를 `pending_events`에서 제거
4. 실패 시: 해당 이벤트 유지 (다음 연결 시 재시도)
5. 플러시 완료 후 `sync.last_synced_at = now`, `state.json` 저장

## 5-ter. Identity Overlay CTA

`/agnt:next` 추천 출력 이후, `identity.mode != "synced"` 일 때 아래 조건 중 **첫 번째 매칭**을 secondary_cta로 표시한다.

### 쿨다운 체크 (먼저 확인)

`sync.last_cta_nudge_at`이 24시간 이내이면 secondary_cta **생략**. 표시 후 `sync.last_cta_nudge_at = now` 기록.

### CTA 조건 (우선순위 순)

| #   | 조건                             | CTA 메시지                                             |
| --- | -------------------------------- | ------------------------------------------------------ |
| 1   | `sync.pending_events.length > 3` | "미동기화 {N}건 — /agnt:connect로 XP 받기"             |
| 2   | `artifacts.interviews >= 1`      | "완료한 퀘스트 XP를 받으려면 /agnt:connect"            |
| 3   | 다음 추천이 `/agnt:channel`      | "채널에 올릴 때 UTM 추적 링크가 필요해. /agnt:connect" |
| 4   | 다음 추천이 `/agnt:analyze`      | "자동 분석을 쓰려면 /agnt:connect"                     |

조건 중 하나도 해당 없으면 secondary_cta 생략.

## 5-bis. Journey Brief Contract

`{AGNT_DIR}/journey-brief.md`는 Phase 1부터 여정 전체를 누적하는 공유 문서다. 각 커맨드가 자기 섹션만 Write하고, 다른 커맨드의 섹션은 건드리지 않는다.

### 초기 생성

최초로 Write하는 커맨드가 `{AGNT_DIR}/journey-brief.md`를 생성한다. 자기 섹션만 채우고 나머지는 `(미작성)` 플레이스홀더로 유지.

### 마이그레이션

`journey-brief.md`가 없고 `decision-brief.md`가 있으면 → 파일명을 `journey-brief.md`로 변경 후 사용. 기존 Phase 3 데이터를 보존.

### 섹션별 소유권 + Write 모드

| 커맨드                     | 섹션                                                     | Write 모드 | 재실행 동작            |
| -------------------------- | -------------------------------------------------------- | ---------- | ---------------------- |
| `/agnt:audit`              | `## Audit`                                               | Replace    | 덮어쓰기 (재진단)      |
| `/agnt:discover`           | `## Discovery`                                           | Replace    | 덮어쓰기 (문제 재정의) |
| `/agnt:interview`          | `### 인터뷰 {N}`                                         | Append     | N번째 추가 (누적)      |
| `/agnt:interview` (3건 후) | `### 교차 패턴`                                          | Replace    | 3건 데이터로 재분석    |
| `/agnt:compete`            | `## Competition`                                         | Replace    | 덮어쓰기 (재분석)      |
| `/agnt:spec`               | `## Product`                                             | Replace    | 최신 SPEC으로 덮어쓰기 |
| `/agnt:build`              | `## Product` 내 `- MVP 범위:`                            | Replace    | 덮어쓰기               |
| `/agnt:landing`            | `## Market` 내 `- 헤드라인:`, `- CTA:`, `- 트래픽 소스:` | Replace    | 덮어쓰기               |
| `/agnt:channel`            | `## Market` 내 `- 채널:`                                 | Replace    | 덮어쓰기               |
| `/agnt:content`            | `## Market` 내 `- 콘텐츠 전략:`                          | Replace    | 덮어쓰기               |
| `/agnt:offer`              | `### Offer`                                              | Replace    | 덮어쓰기               |
| `/agnt:launch`             | `### Launch Plan`                                        | Replace    | 덮어쓰기               |
| `/agnt:analyze`            | `### Results (Loop {N})`                                 | Append     | 루프별 누적            |
| `/agnt:retro`              | `### Next Actions (Loop {N})`                            | Replace    | 최신 루프로 덮어쓰기   |

### Write 없는 커맨드

`/agnt:start`, `/agnt:next`, `/agnt:status`, `/agnt:tools` — journey-brief를 읽기만 하거나 사용하지 않음.

### journey-brief.md 템플릿

```markdown
# Journey Brief — {project.name}

## Audit

- Track: (미작성)
- Verdict: (미작성)
- Revenue Readiness Score: (미작성)
- 근거: (미작성)

## Discovery

- 문제: (미작성)
- ICP: (미작성)
- 가설: (미작성)

## Interview Insights

(미작성)

## Competition

(미작성)

## Product

- SPEC: (미작성)
- MVP 범위: (미작성)

## Market

- 랜딩 URL: (미작성)
- 헤드라인: (미작성)
- CTA: (미작성)
- 트래픽 소스: (미작성)
- 채널: (미작성)
- 콘텐츠 전략: (미작성)

## Decision Loop

### Offer

(미작성)

### Launch Plan

(미작성)

### Results

(미작성)

### Next Actions

(미작성)
```

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
- 퀘스트 제출: 불가 (MCP 필수) → `sync.pending_events`에 큐잉

안내 메시지: "MCP 미연결 상태입니다. 로컬에서 진행할 수 있지만, 진행 기록은 MCP 연결 후 동기화됩니다."

### schema_version 체크 규칙

모든 커맨드는 `state.json` 로드 후 `meta.schema_version == 3`인지 확인한다. 3이 아니면 "먼저 `/agnt:start`를 실행하세요." 출력 후 종료.

## 7. 템플릿 변수

커맨드 출력에서 `{variable}` 패턴을 state 데이터로 치환한다.

| 변수                     | 소스                       | 예시              |
| ------------------------ | -------------------------- | ----------------- |
| `{project.name}`         | state.project.name         | "밥친구"          |
| `{project.problem}`      | state.project.problem      | "혼밥이 외롭다"   |
| `{project.icp}`          | state.project.icp          | "1인 가구 직장인" |
| `{artifacts.interviews}` | state.artifacts.interviews | "3"               |
| `{D}`                    | 경과일 계산                | "12"              |
| `{remaining}`            | 남은일 계산                | "18"              |

## 8. 퀘스트 ID 네이밍

기존: `d{day}-{slug}` (예: `d1-interview`)
신규: `wf-{workflow}-{n}` (예: `wf-interview-1`)

| Quest ID             | Phase | XP  | 설명                         |
| -------------------- | ----- | --- | ---------------------------- |
| `wf-audit`           | 0     | 100 | Revenue Readiness Audit 완료 |
| `wf-discover`        | 1     | 100 | 문제 선택 + ICP 정의         |
| `wf-interview-1`     | 1     | 80  | 고객 인터뷰 1회차            |
| `wf-interview-2`     | 1     | 80  | 고객 인터뷰 2회차            |
| `wf-interview-3`     | 1     | 80  | 고객 인터뷰 3회차            |
| `wf-compete`         | 1     | 80  | 경쟁 분석 완료               |
| `wf-spec-1`          | 1     | 100 | SPEC v1 작성                 |
| `wf-spec-2`          | 1     | 80  | SPEC v2 이터레이션           |
| `wf-build`           | 2     | 100 | MVP 빌드 완료                |
| `wf-channel-1`       | 2     | 60  | 채널 1 활성화                |
| `wf-channel-2`       | 2     | 60  | 채널 2 활성화                |
| `wf-content`         | 2     | 80  | 콘텐츠 전략 완료             |
| `wf-offer`           | 3     | 100 | 오퍼 설계 완료               |
| `wf-launch`          | 3     | 100 | GTM 실행                     |
| `wf-analyze-1`       | 3     | 60  | 시그널 분석 1회차            |
| `wf-retro`           | 3     | 50  | 회고 완료                    |
| `wf-seo-audit`       | 2     | 60  | SEO 기본 점검                |
| `wf-biz-setup`       | 2     | 80  | 사업자 등록 판단             |
| `wf-analytics-setup` | 2     | 80  | 분석 환경 세팅               |
| `wf-launch-copy`     | 3     | 80  | 런칭 카피 생성               |
| `wf-ad-creative`     | 3     | 60  | 광고 소재 생성               |
| `wf-revenue`         | 3     | 80  | 수익 모델 선택               |

**XP 적산 예상:**

- Phase 1 (discover + interview×3 + compete + spec×2): 600 XP → Lv.4
- Phase 2 (build + channel×2 + content): 300 XP → 누적 900 → Lv.6
- Phase 3 (offer + launch + analyze + retro): 310 XP → 누적 1210 → Lv.8

## 9. 출력 톤 규칙

- 2인칭 현재형 반말 (존댓말 아님, 격식 아님)
- 짧고 직접적인 문장 — 프레임워크 용어보다 행동 지시
- 이모지 최소 사용 (카운트다운 헤더에만)
- 기술 용어(MCP, OAuth, CLI, SPEC)는 원문 유지
- 한국어 진행

## 10. Codex 호환

| Claude Code             | Codex 대응              |
| ----------------------- | ----------------------- |
| `/agnt:start`           | `$agnt-start`           |
| `/agnt:audit`           | `$agnt-audit`           |
| `/agnt:next`            | `$agnt-next`            |
| `/agnt:discover`        | `$agnt-discover`        |
| `/agnt:interview`       | `$agnt-interview`       |
| `/agnt:spec`            | `$agnt-spec`            |
| `/agnt:build`           | `$agnt-build`           |
| `/agnt:landing`         | `$agnt-landing`         |
| `/agnt:compete`         | `$agnt-compete`         |
| `/agnt:channel`         | `$agnt-channel`         |
| `/agnt:content`         | `$agnt-content`         |
| `/agnt:offer`           | `$agnt-offer`           |
| `/agnt:launch`          | `$agnt-launch`          |
| `/agnt:analyze`         | `$agnt-analyze`         |
| `/agnt:retro`           | `$agnt-retro`           |
| `/agnt:tools`           | `$agnt-tools`           |
| `/agnt:status`          | `$agnt-status`          |
| `/agnt:connect`         | `$agnt-connect`         |
| `/agnt:seo-audit`       | `$agnt-seo-audit`       |
| `/agnt:biz-setup`       | `$agnt-biz-setup`       |
| `/agnt:analytics-setup` | `$agnt-analytics-setup` |
| `/agnt:launch-copy`     | `$agnt-launch-copy`     |
| `/agnt:ad-creative`     | `$agnt-ad-creative`     |
| `/agnt:revenue`         | `$agnt-revenue`         |
| `ToolSearch`            | `codex mcp list`        |
| `AskUserQuestion`       | `ask(...)`              |
