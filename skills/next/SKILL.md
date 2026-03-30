---
user-invocable: false
name: next
description: >-
  Signal-driven navigator — 현재 상태를 읽고 다음 최선 행동 추천. 다음에 뭐 해야 하는지 물어볼 때 사용.
---

Signal-Driven Navigator — 현재 상태를 읽고 다음 최선 행동을 추천합니다.

## 데이터 경로 결정

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR (references 루트)

1. `{AGNT_DIR}/references/shared/navigator-engine.md`를 Read 시도 → 성공하면 **REFS_DIR = `{AGNT_DIR}/references`**
2. 실패 시 `~/.claude/plugins/marketplaces/agentic30/references/shared/navigator-engine.md` Read 시도 → 성공하면 해당 경로
3. 실패 시 `.agents/skills/agnt/references/shared/navigator-engine.md` Read 시도
4. 실패 시 `~/.codex/skills/agnt/references/shared/navigator-engine.md` Read 시도
5. 모두 없으면 에러 안내 출력 후 종료

## 출력 규칙

### 내부 로직 무음 처리

아래 절차는 유저에게 출력하지 않고 내부적으로만 수행합니다:
- 경로 탐색, state 파싱, navigator-engine.md Read, MCP 검색

## 실행 절차

### 1. state 읽기

`{AGNT_DIR}/state.json`을 Read.

- `meta.schema_version != 3`이면 → "먼저 `/agnt:start`를 실행하세요." 출력 후 종료
- `meta.started_at == null`이면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### 2. 카운트다운 계산

```
D = floor((now - meta.started_at) / 86400000) + 1
remaining = max(0, 30 - D)
```

### 3. MCP 시그널 동기화 (선택)

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `get_landing_analytics` 호출 → `signals.landing_visits`, `signals.form_responses` 갱신
- `get_links` 호출 → `signals.link_clicks` 갱신
- 갱신된 값을 state.json에 Write

도구 없으면 로컬 state 기반으로 진행.

### 4. Navigator 추천 로직

`{REFS_DIR}/shared/navigator-engine.md`의 Section 3 "추천 우선순위 테이블"을 참조하여, 아래 조건을 **순서대로** 평가한다. 첫 번째 매칭되는 조건을 추천.

| # | 조건 | 추천 |
|---|------|------|
| 0 | `audit_result == null && (meta.total_actions == 0 \|\| project.problem == null)` | `/agnt:audit` |
| 1 | `project.problem == null && audit_result.track != "A"` | `/agnt:discover` |
| 2 | `artifacts.interviews < 3 && audit_result.track != "A"` | `/agnt:interview` |
| 3 | `!artifacts.competitors_analyzed && audit_result.track != "A"` | `/agnt:compete` |
| 4 | `artifacts.spec_versions == 0 && audit_result.track != "A"` | `/agnt:spec` |
| 5 | `!artifacts.landing_deployed` | `/agnt:landing` |
| 6 | `artifacts.channels_active < 2` | `/agnt:channel` |
| 7 | `!artifacts.content_planned` | `/agnt:content` |
| 8 | `(signals.link_clicks > 0 \|\| (artifacts.channels_active >= 2 && artifacts.content_planned)) && !artifacts.offer_drafted` | `/agnt:offer` |
| 9 | `artifacts.offer_drafted && !artifacts.launch_planned` | `/agnt:launch` |
| 10 | `artifacts.launch_planned && artifacts.last_analyze_loop < artifacts.loops_completed + 1` | `/agnt:analyze` |
| 11 | `artifacts.last_analyze_loop > artifacts.loops_completed` | `/agnt:retro` |
| 12 | 모두 해당 없음 | `/agnt:status` |

### 5. 시간 가중치 톤 결정

`{REFS_DIR}/shared/navigator-engine.md`의 Section 4를 참조.

경과일(D) 대비 현재 단계를 평가하여 톤을 결정. `audit_result.track`이 있으면 Track별 기대 기간을 사용:

- **Track A**: 5일 (기본 D1-2, 독려 D3, 긴급 D4-5, 초과 D6+)
- **Track B**: 8일 (기본 D1-4, 독려 D5-6, 긴급 D7-8, 초과 D9+)
- **Track C**: 10일 (기본 D1-5, 독려 D6-8, 긴급 D9-10, 초과 D11+)
- **Track 없음**: 30일 (기본 D1-15, 독려 D16-22, 긴급 D23-30, 초과 D31+)

톤 매핑:
- **기본**: 부가 메시지 없음 또는 "좋은 페이스야."
- **독려**: "속도를 높여야 해. 핵심에 집중하자."
- **긴급**: "마감이 가까워. 지금 가장 중요한 한 가지에 집중하자."
- **초과**: "기간이 지났지만, 멈출 필요 없어. 계속 가자."

### 6. 컨텍스트 기반 부가 메시지

추천 커맨드에 따라, state와 journey-brief 데이터를 참조하여 부가 메시지를 추가한다.

`{AGNT_DIR}/journey-brief.md` Read 시도. 있으면 해당 섹션 참조.

| 추천 | 부가 메시지 조건 | 메시지 예시 |
|------|----------------|------------|
| `/agnt:interview` (2/3 이상) | journey-brief에 이전 인터뷰 인사이트 있으면 | "첫 번째에서 {고통점}을 발견했어. 이번에는 다른 ICP 세그먼트와 대화해. 같은 고통점이 나오면 가설이 강화돼." |
| `/agnt:compete` | journey-brief에 Interview Insights 있으면 | "인터뷰에서 '{현재 대안}'이 나왔어. 이걸 체계적으로 정리하면 차별점이 선명해져." |
| `/agnt:spec` | journey-brief에 Competition 있으면 | "경쟁 분석에서 '{차별점}'을 찾았어. 이걸 중심으로 SPEC을 잡아." |
| `/agnt:landing` | — | "MVP를 먼저 만들려면 `/agnt:build`." |
| `/agnt:content` | state.tools.marketing_channels 있으면 | "{채널}에 뭘 올릴지 정할 시점이야. BIP(빌드 과정 공유)가 개발자 ICP에게 가장 자연스러워." |
| `/agnt:offer` | journey-brief에 Competition 있으면 | "경쟁 대안 대비 '{차별점}'이 네 오퍼의 핵심이야." |
| `/agnt:landing` | — | "배포 전에 /agnt:seo-audit로 SEO도 점검해봐." |
| `/agnt:channel` | — | "사업자 등록 고민이면 /agnt:biz-setup" |
| `/agnt:offer` | `!artifacts.analytics_setup` | "분석 세팅이 안 되어 있으면 /agnt:analytics-setup" |
| `/agnt:launch` | — | "/agnt:launch-copy로 10채널 카피를 한 번에 만들 수 있어." |
| `/agnt:analyze` | D > 22 (카운트다운 후반) | "마감이 가까워. 100명 미만이어도 방향 감각은 잡을 수 있어." |
| `/agnt:analyze` | CONTINUE/PIVOT 판정 시 | "트래픽이 더 필요하면 /agnt:ad-creative" |
| 모두 해당 후 (`/agnt:status`) | `tools.revenue_model == null` | "수익 모델 고민이면 /agnt:revenue" |
| 기타 | — | 기본 메시지만 출력 (부가 메시지 없음) |

부가 메시지는 추천 출력 포맷의 `근거:` 라인 아래에 추가한다.

journey-brief가 없거나 해당 섹션이 `(미작성)`이면 부가 메시지를 생략한다.

### 7. 출력

```
══════════════════════════════════════════
  Day {D}/30 · 남은 {remaining}일
══════════════════════════════════════════

📍 다음 행동: /agnt:{command}

{추천 메시지}

{시간 가중치 부가 메시지 — 해당 시에만}

근거: {왜 이 행동인지 1-2문장}
💡 {부가 메시지 — journey-brief/state 기반}
진척: {현재까지 완료된 항목 요약}
예상 소요: {시간 추정}

──────────────────────────────────────────
전체 진행:
  문제 정의: {✅/⬜}
  인터뷰: {N}/3
  SPEC: {✅/⬜} (v{N})
  랜딩: {✅/⬜}
  채널: {N}/2
  오퍼: {✅/⬜}
  런칭: {✅/⬜}
  분석: {last_analyze_loop > 0 ? ✅ : ⬜}
  회고: {loops_completed > 0 ? "✅ (Loop " + loops_completed + ")" : ⬜}
  매출: {revenue > 0 ? ✅ : ⬜}
──────────────────────────────────────────

💡 /agnt:status로 상세 현황, /agnt:tools로 도구 비교
══════════════════════════════════════════
```

### 8. Identity Overlay CTA (선택)

추천 출력 완료 후, 아래 조건이 모두 충족되면 secondary_cta를 표시한다:

1. `identity.mode != "synced"` (미연결 유저)
2. `sync.last_cta_nudge_at`이 null 또는 24시간 이전
3. 아래 CTA 조건 중 첫 번째 매칭이 있음:

| # | 조건 | CTA 메시지 |
|---|------|-----------|
| 1 | `sync.pending_events.length > 3` | "미동기화 {N}건 — /agnt:connect로 XP 받기" |
| 2 | `artifacts.interviews >= 1` | "완료한 퀘스트 XP를 받으려면 /agnt:connect" |
| 3 | 다음 추천이 `/agnt:channel` | "채널에 올릴 때 UTM 추적 링크가 필요해. /agnt:connect" |
| 4 | 다음 추천이 `/agnt:analyze` | "자동 분석을 쓰려면 /agnt:connect" |

조건 중 하나도 해당 없으면 CTA 생략.

**CTA 표시 후**: `sync.last_cta_nudge_at = now()`로 state.json 저장.

출력 포맷:
```
──────────────────────────────────────────
💡 {CTA 메시지}
──────────────────────────────────────────
```

## 규칙

- `/agnt:next`는 state를 **읽기만** 한다 (쓰기 금지 — MCP 시그널 동기화 및 `sync.last_cta_nudge_at` 제외)
- MCP 시그널 동기화는 state.json의 `signals.*` 필드만 갱신
- `sync.last_cta_nudge_at` 쓰기는 Identity Overlay CTA 표시 시에만 허용 (예외)
- 추천은 **비강제** — "이걸 해야 해"가 아니라 "이걸 추천해"
- 한국어 출력, 기술 용어 원문 유지
- 반말 톤 (존댓말 아님)
- `identity`, `sync` 필드가 state에 없으면 navigator-engine.md 기본값 사용
