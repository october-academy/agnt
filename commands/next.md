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

- `meta.schema_version != 2`이면 → "먼저 `/agnt:start`로 업그레이드하세요." 출력 후 종료
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
| 1 | `project.problem == null` | `/agnt:discover` |
| 2 | `artifacts.interviews < 3` | `/agnt:interview` |
| 3 | `artifacts.spec_versions == 0` | `/agnt:spec` |
| 4 | `!artifacts.landing_deployed` | `/agnt:landing` |
| 5 | `artifacts.channels_active < 2` | `/agnt:channel` |
| 6 | `signals.link_clicks > 0 && !artifacts.offer_drafted` | `/agnt:offer` |
| 7 | `artifacts.offer_drafted && signals.revenue == 0` | `/agnt:launch` |
| 8 | 시그널 변화 감지 | `/agnt:analyze` |
| 9 | `total_actions > 5` && 마지막 retro 후 7+ actions | `/agnt:retro` |
| 10 | 모두 해당 없음 | `/agnt:status` |

### 5. 시간 가중치 톤 결정

`{REFS_DIR}/shared/navigator-engine.md`의 Section 4를 참조.

경과일(D) 대비 현재 단계를 평가하여 톤을 결정:

- **정상 페이스**: 부가 메시지 없음
- **뒤처짐** (예: D 20인데 아직 interview 단계): "속도를 높여야 해. 핵심에 집중하자."
- **앞서감** (예: D 5인데 이미 spec 완료): "좋은 페이스야."
- **D 23-30**: "마감이 가까워. 지금 가장 중요한 한 가지에 집중하자."
- **D 31+**: "30일이 지났지만, 멈출 필요 없어. 계속 가자."

### 6. 출력

```
══════════════════════════════════════════
  Day {D}/30 · 남은 {remaining}일
══════════════════════════════════════════

📍 다음 행동: /agnt:{command}

{추천 메시지}

{시간 가중치 부가 메시지 — 해당 시에만}

근거: {왜 이 행동인지 1-2문장}
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
  매출: {revenue > 0 ? ✅ : ⬜}
──────────────────────────────────────────

💡 /agnt:status로 상세 현황, /agnt:tools로 도구 비교
══════════════════════════════════════════
```

### 7. Phase 2/3 커맨드 추천 시

추천된 커맨드가 아직 스텁인 경우 (build, landing, channel, offer, launch, analyze, retro):

```
⚠️ /agnt:{command}는 아직 준비 중이야.
지금 할 수 있는 건:
- /agnt:discover, /agnt:interview, /agnt:spec, /agnt:tools, /agnt:status
```

## 규칙

- `/agnt:next`는 state를 **읽기만** 한다 (쓰기 금지 — MCP 시그널 동기화 제외)
- MCP 시그널 동기화는 state.json의 `signals.*` 필드만 갱신
- 추천은 **비강제** — "이걸 해야 해"가 아니라 "이걸 추천해"
- 한국어 출력, 기술 용어 원문 유지
- 반말 톤 (존댓말 아님)
