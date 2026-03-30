---
name: launch
description: >-
  7일 론칭 계획 — 채널, 일정, 수치 임계값. 론칭 계획 수립 시 사용.
---

7일 론칭 계획. 언제, 어디서, 어떻게 론칭할지 설계합니다.

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
- `!artifacts.offer_drafted` (또는 undefined) → "먼저 `/agnt:offer`로 오퍼를 정리하면 론칭이 선명해져." (비강제 — 진행 가능)

기본값 보증 (navigator-engine.md 필드 기본값 규칙):
- `artifacts.launch_planned`가 undefined면 `false`로 처리
- `artifacts.last_analyze_loop`가 undefined면 `0`으로 처리
- `artifacts.loops_completed`가 undefined면 `0`으로 처리

### 2. 컨텍스트 수집

state에서 읽기:
- `project.name`, `project.icp`
- `tools.marketing_channels` — 이미 활성화한 채널
- `artifacts.loops_completed` — 현재 루프 번호

`{AGNT_DIR}/journey-brief.md` Read 시도. 있으면 Offer 섹션에서 약속/가격 참조. 없으면 state 기반으로 진행.

### 3. 론칭 계획 가이드

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  론칭 계획
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

론칭 = 오퍼를 사람들 앞에 내놓는 것.
한 번에 대박을 노리는 게 아니라, 7일간 체계적으로 노출하는 거야.

{journey-brief.md에서 오퍼 요약이 있으면}
오퍼: {약속} / {가격}
{없으면 생략}

{tools.marketing_channels가 있으면}
활성 채널: {채널 목록}
```

### 4. 채널 선택

```
📍 론칭 채널 선택

{tools.marketing_channels가 있으면}
이미 활성화한 채널: {목록}
→ 가장 반응이 좋았던 채널에서 론칭하는 게 효과적이야.

{없으면}
아직 채널을 활성화하지 않았어.
/agnt:channel로 먼저 채널을 정하는 걸 추천해.
그래도 여기서 론칭 계획은 세울 수 있어.
```

AskUserQuestion: "어떤 채널에서 론칭할 거야?"
- 자유 입력

### 5. 7일 계획

```
📅 7일 론칭 계획

Day 1: 티저 — 문제를 공유해. "나는 이런 문제를 풀고 있어."
Day 2: 미리보기 — 솔루션 스크린샷 또는 데모 영상.
Day 3: 론칭 — 제품 공개 + CTA. "지금 써봐."
Day 4: 후기 — 첫 반응 공유. "어제 론칭했는데 이런 반응이 왔어."
Day 5: FAQ — 예상 질문 대응. "많이 물어보는 것들."
Day 6: 사용자 스토리 — 있으면 공유. 없으면 네 사용 경험.
Day 7: 결산 — 7일 성과 공개. 숫자를 공유해.

⚠️ 핵심: Day 3에 반드시 CTA가 있어야 해.
CTA 없는 론칭은 "예쁜 소개"일 뿐이야.
```

### 6. 수치 임계값 설정

```
📊 성공/실패 기준

론칭 전에 "성공"과 "실패"를 숫자로 정해둬.
느낌으로 판단하면 안 돼.

기본 기준 (조정 가능):
• 성공: 7일간 방문 100명 + 전환 3% 이상
• 실패: 7일간 방문 50명 미만

이 숫자는 /agnt:analyze에서 판정할 때 쓰여.
```

AskUserQuestion: "성공 기준을 정해줘. (기본값: 100방문 + 3% 전환)"
- A) 기본값 사용
- B) 직접 설정

**B 선택 시**: 자유 입력으로 수치 수집.

**성공 기준 검증**:
- 숫자만 있고 메트릭 없을 때 (예: "100명"): "뭐를 기준으로? 방문? 전환? 매출?" 재질문
- 메트릭만 있고 숫자 없을 때: "숫자를 정해줘. '방문 100명 + 전환 3%'처럼." 재질문
- 유효한 형식 (숫자+메트릭): 확정 후 고지

성공 기준 확정 후:
```
이 기준은 네 판단용이야. `/agnt:analyze`는 방문 100명 기준으로 TOO EARLY을 판정해. 기준이 다르면 analyze 판정과 다를 수 있어.
```

### 7. 론칭일 확인

AskUserQuestion: "론칭일을 정했어?"
- A) 정했어 — 날짜 입력
- B) 아직 날짜를 못 정했어

### 8. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: 템플릿으로 신규 생성 (Offer는 `(미작성)` 플레이스홀더).
**파일이 있는 경우**: Launch Plan 섹션만 업데이트.

Launch Plan 섹션:
```markdown
### Launch Plan
- 채널: {선택한 채널}
- 기간: 7일 ({론칭일} ~ )
- 성공 임계값: {방문 N명 + 전환 N%}
- 실패 임계값: {방문 N명 미만}
- 계획: Day1 티저 → Day3 론칭+CTA → Day7 결산
```

### 9. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  론칭 계획 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

채널: {선택한 채널}
성공 기준: {방문 N + 전환 N%}

{A선택 시}
7일 후에 /agnt:analyze로 성과를 판정해.
그때까지는 계획대로 포스트를 올려.
{B선택 시}
날짜를 정하면 `/agnt:launch`를 다시 실행해.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 10. state 업데이트 + MCP 제출

**A선택 시에만** state.json 업데이트:
- `artifacts.launch_planned = true`
- `meta.last_action = "launch"`
- `meta.total_actions++`

**B선택 시**:
- `launch_planned` 미변경
- journey-brief Launch Plan의 `기간:`을 `(미정)`으로 기록
- 완료 출력: "날짜를 정하면 `/agnt:launch`를 다시 실행해." ("7일 후에 /agnt:analyze" 출력 금지)
- `meta.last_action = "launch"`, `meta.total_actions++` (메타는 갱신)

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-launch"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-launch" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- agnt가 포스트를 대신 올리지 않는다 — ICP가 직접 한다
- 7일 계획은 템플릿 — ICP 상황에 맞게 조정 가능
- 수치 임계값은 analyze에서 판정할 때 사용됨을 안내
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위 (learner artifact)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
- 론칭 계획을 칭찬하지 않는다 — "좋은 계획이야", "채널을 잘 골랐네", "일정이 잘 잡혔어", "성공 기준이 적절해" 사용 금지
- 대신: 포지션("이 채널이 ICP에 맞는지는") → 근거("첫 주 100클릭이 나와야 검증돼") → 행동("벤치마크 섹션에서 확인해")
