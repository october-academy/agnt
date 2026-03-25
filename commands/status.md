현재 상태 대시보드. 프로젝트 진행 현황, 시그널, 도구를 한 눈에 보여줍니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

## 출력 규칙

내부 로직 무음 처리. 대시보드를 즉시 출력.

## 실행 절차

### 1. state 읽기

`{AGNT_DIR}/state.json` Read.
- `meta.schema_version < 2` → `/agnt:start`로 안내 후 종료

### 2. 카운트다운 계산

`meta.started_at`이 있으면:
```
D = floor((now - meta.started_at) / 86400000) + 1
remaining = max(0, 30 - D)
```
없으면 카운트다운 미표시.

### 3. MCP 시그널 동기화 (선택)

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `get_landing_analytics` → signals.landing_visits, signals.form_responses 갱신
- `get_links` → signals.link_clicks 갱신
- `get_leaderboard` → 리더보드 데이터 획득
- 갱신된 값을 state.json에 Write

### 4. Sync 패널 자동 플러시

`identity.mode == "synced"` AND `sync.pending_events.length > 0`인 경우:

1. ToolSearch로 `+agentic30` 확인 (이미 3단계에서 검색했으면 재사용)
2. 도구 발견 시: `pending_events` 순서대로 `submit_practice(quest_id)` 호출
   - 성공 시: 해당 이벤트 제거
   - 실패 시: 해당 이벤트 유지, 다음으로 계속
3. 플러시 후 `sync.last_synced_at = now()`, `state.json` 저장

### 5. 대시보드 출력

Sync 패널의 `미동기화` 수는 플러시 후 남은 `sync.pending_events.length`로 표시.

```
══════════════════════════════════════════
  {project.name || "프로젝트 미설정"}
  Day {D}/30 · 남은 {remaining}일
══════════════════════════════════════════

📌 프로젝트
  문제: {project.problem || "미정의"}
  ICP: {project.icp || "미정의"}
  가설: {project.hypothesis || "미정의"}

──────────────────────────────────────────
📦 산출물
  인터뷰      {artifacts.interviews}/3  {progressBar}
  SPEC        v{artifacts.spec_versions}  {✅ or ⬜}
  랜딩페이지  {artifacts.landing_deployed ? "배포됨" : "미배포"}
  채널        {artifacts.channels_active}/2  {progressBar}
  오퍼        {artifacts.offer_drafted ? "설계됨" : "미설계"}

──────────────────────────────────────────
📡 시그널
  랜딩 방문     {signals.landing_visits}
  폼 응답       {signals.form_responses}
  링크 클릭     {signals.link_clicks}
  결제 시도     {signals.payment_intents}
  매출          {signals.revenue > 0 ? "₩" + signals.revenue : "아직 없음"}

──────────────────────────────────────────
🔧 도구
  결제: {tools.payment || "미선택"}
  분석: {tools.analytics || "미선택"}
  채널: {tools.marketing_channels.join(", ") || "미선택"}

──────────────────────────────────────────
📈 활동
  총 액션: {meta.total_actions}
  마지막: {meta.last_action || "없음"}
  시작일: {meta.started_at ? 날짜만 : "미시작"}

──────────────────────────────────────────
🔄 Sync
  상태: {identity.mode == "synced" ? "✅ 연결됨" | identity.mode == "registered" ? "⚠️ 가입만 완료" | "❌ 미연결"}
  미동기화: {sync.pending_events.length}건
  마지막 동기화: {sync.last_synced_at ?? "없음"}
  연결: {identity.mode != "synced" ? "/agnt:connect" : "https://agentic30.app/dashboard"}

{MCP 연결되어 있고 리더보드 데이터가 있으면}
──────────────────────────────────────────
🏆 리더보드 (Top 5)
  {리더보드 데이터}

══════════════════════════════════════════

다음 행동 추천: /agnt:next
도구 비교: /agnt:tools
══════════════════════════════════════════
```

### 7. 진행률 바 생성 규칙

`{N}/{max}` 형태의 필드에 진행률 바를 추가:

```
인터뷰 2/3  [████████░░░░] 67%
```

10칸 바, filled = round(N/max * 10), `█` = filled, `░` = empty

## 규칙

- `/agnt:status`는 state를 **읽기만** 한다 (MCP 시그널 동기화 및 Sync 패널 플러시 제외)
- MCP 미연결 시 로컬 state 기반 표시
- `identity`, `sync` 필드가 state에 없으면 navigator-engine.md 기본값 사용
- 값이 없는 필드는 "미정의", "미선택", "아직 없음"으로 표시 (빈 칸 아님)
- 한국어, 반말 톤 없음 (대시보드이므로 중립 톤)
