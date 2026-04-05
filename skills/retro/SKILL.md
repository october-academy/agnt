---
user-invocable: false
name: retro
description: >-
  회고 + 다음 루프 설계. 회고, 배운 것 정리, 다음 반복 계획 시 사용.
---

회고 + 다음 루프 설계. 뭘 배웠고, 다음에 뭘 바꿀지 결정합니다.

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
- `artifacts.last_analyze_loop == 0` 또는 `artifacts.last_analyze_loop <= artifacts.loops_completed` → "먼저 `/agnt:analyze`로 성과를 판정해." (비강제 — 진행 가능)

기본값 보증 (navigator-engine.md 필드 기본값 규칙):

- `artifacts.launch_planned`가 undefined면 `false`로 처리
- `artifacts.last_analyze_loop`가 undefined면 `0`으로 처리
- `artifacts.loops_completed`가 undefined면 `0`으로 처리

### 2. 컨텍스트 수집

`{AGNT_DIR}/journey-brief.md` Read 시도.

있으면:

- 최신 Results 섹션에서 판정(CONTINUE/PIVOT/KILL/TOO EARLY) 추출
- Offer 섹션에서 약속/가격 참조
- Launch Plan 섹션에서 채널/임계값 참조

없으면: state 기반으로 진행 (판정 없이 일반 회고).

### 3. 회고 시작

현재 루프: `artifacts.loops_completed + 1`

출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  회고 — Loop {N}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{journey-brief에서 판정이 있으면}
이전 판정: {VERDICT}
{없으면}
분석 데이터 없이 진행합니다.
```

### 4. 회고 질문

AskUserQuestion: "이번 루프에서 가장 놀라운 발견이 뭐야?"

- 자유 입력

AskUserQuestion: "ICP 가정 중 확인된 것과 틀린 것은?"

- 자유 입력

### 5. 판정별 분기 질문

**판정이 CONTINUE인 경우**:

```
✅ CONTINUE — 다음 루프에서 뭘 강화할 거야?

선택지:
• 트래픽 늘리기 — 채널 추가 또는 포스팅 빈도 증가
• 오퍼 개선 — 가격 조정 또는 가치 제안 강화
• 전환 최적화 — 랜딩 CTA 또는 온보딩 개선
```

AskUserQuestion: "다음 루프에서 집중할 영역은?"

- A) 트래픽 늘리기
- B) 오퍼 개선
- C) 전환 최적화

**판정이 PIVOT인 경우**:

```
🔄 전환이 안 됐어. 뭘 바꿀 건지 결정해야 해.

바꿀 수 있는 것:
• 오퍼 — 약속이나 가격을 바꾸기 (/agnt:offer)
• 채널 — 다른 곳에서 시도하기 (/agnt:channel)
• 메시지/랜딩 카피 — 헤드라인/CTA 변경 (/agnt:landing)
```

AskUserQuestion: "뭘 바꿀 거야?"

- A) 오퍼 변경
- B) 채널 변경
- C) 랜딩 변경
- D) 여러 가지 동시에

**판정이 KILL인 경우**:

```
❌ 이 조합은 안 됐어. 근본적인 재검토가 필요해.

이 조합을 버리고 다른 ICP로 재시작하는 게 가장 빠른 경로야.
```

AskUserQuestion: "어떻게 할 거야?"

- A) ICP/문제 재정의 — 다른 ICP로 재시작 (추천)
- B) 세션 종료

**판정이 TOO EARLY이거나 없는 경우**:

```
⏳ 아직 데이터가 부족하지만, 지금까지 배운 것을 정리하자.
```

AskUserQuestion: "다음에 뭘 할 거야?"

- A) 트래픽 더 모으기 — 포스팅 계속
- B) 오퍼/랜딩 수정 후 재시도

### 5-bis. KILL→A 경로 실행

유저가 KILL 분기에서 A를 선택한 경우, 아래 순서를 **정확히** 실행한다. Step 7, Step 8의 정상 mutation은 이 경로에 통합되므로 별도 실행하지 않는다.

**1. artifacts 리셋**:

- `artifacts.interviews = 0`
- `artifacts.spec_versions = 0`
- `artifacts.competitors_analyzed = false`
- `artifacts.channels_active = 0`
- `artifacts.content_planned = false`
- `artifacts.offer_drafted = false`
- `artifacts.tracking_links = 0`
- `artifacts.last_analyze_loop = 0`
- `artifacts.launch_planned = false`
- `tools.marketing_channels = []`

`loops_completed`와 `signals.*`는 이력이므로 리셋하지 않는다.

**2. loops_completed++** (정상 retro 완료 처리)

**3. meta 갱신**: `meta.last_action = "retro"`, `meta.total_actions++`

**4. state.json Write**

**5. journey-brief.md 리셋**:
`{AGNT_DIR}/journey-brief.md` Read → `## Discovery` 섹션만 유지. 나머지 섹션(`## Interview Insights`, `## Competition`, `## Product`, `## Market`, `## Decision Loop`)을 `(미작성)` 플레이스홀더로 초기화. 이유: state artifacts만 리셋하면 다른 커맨드가 journey-brief에서 이전 ICP의 데이터를 읽어 stale context 혼입.

**6. MCP submit_practice("wf-retro")** (가능 시):

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:

- `submit_practice` 호출: quest_id = `"wf-retro"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):

- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  {
    "type": "submit_practice",
    "args": { "quest_id": "wf-retro" },
    "created_at": "<now()>"
  }
  ```
- state.json 저장

**7. 안내 출력**:

```
이전 ICP의 데이터를 정리했어.
다음: /agnt:discover — 새로운 문제/ICP를 정의하자.
```

KILL→B(세션 종료) 선택 시에는 5-bis를 건너뛰고 기존 Step 6~8이 정상 실행된다.

### 6. 다음 행동 결정

유저 선택에 따라 다음 행동을 안내:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  다음 행동
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{유저 선택에 따라}

트래픽 → /agnt:channel 또는 포스팅 계속
오퍼 변경 → /agnt:offer
채널 변경 → /agnt:channel
메시지/랜딩 카피 변경 → /agnt:landing
ICP 재정의 → /agnt:discover
KILL → A: 5-bis 경로로 실행 (Step 7, 8 건너뜀)
KILL → B: Step 7, 8 정상 실행
세션 종료 → "수고했어. /agnt:status로 전체 여정을 확인할 수 있어."
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 7. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: 템플릿으로 신규 생성.
**파일이 있는 경우**: Next Actions 섹션 업데이트.

Next Actions 섹션:

```markdown
### Next Actions (Loop {N} 회고)

- 판정: {VERDICT}
- 핵심 발견: {유저 입력 요약}
- 다음 행동: {선택한 행동}
- 바꿀 것: {PIVOT/KILL인 경우 구체적 변경 사항}
```

### 8. state 업데이트 + MCP 제출

state.json 업데이트:

- `artifacts.loops_completed++` (현재 값 + 1)
- `artifacts.launch_planned = false` (다음 루프를 위해 리셋 — 의도적. 다음 루프에서 론칭 계획을 재확인) (KILL→A 경로에서는 5-bis에서 이미 처리됨)
- `meta.last_action = "retro"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:

- `submit_practice` 호출: quest_id = `"wf-retro"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):

- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  {
    "type": "submit_practice",
    "args": { "quest_id": "wf-retro" },
    "created_at": "<now()>"
  }
  ```
- state.json 저장

### 9. 루프 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Loop {N} 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{세션 종료가 아니면}
다음 루프가 준비돼.
/agnt:next로 다음 행동을 확인해.

{세션 종료면}
수고했어. 이 경험은 다음에 반드시 도움이 돼.
/agnt:status로 전체 여정을 돌아볼 수 있어.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 규칙

- retro는 판정을 내리지 않는다 — analyze의 판정을 받아서 "다음에 뭘 할지"를 정하는 것
- KILL 판정이라도 "포기해"가 아니라 "이 조합은 안 됐다"로 프레이밍 — 학습으로 전환
- launch_planned = false 리셋은 의도적 — 다음 루프에서 론칭 계획을 재확인하게 하기 위함
- loops_completed 증가는 retro 완료 시에만 — analyze에서는 증가하지 않음
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위 (learner artifact)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- verdict 이상의 격려 금지 — "방향이 맞았어", "잘 했어", "좋은 회고야" 사용 금지
- 대신: verdict만 전달. "CONTINUE — 전환율이 벤치마크 범위 안이야" (포지션 → 근거 → 행동)
- 한국어, 반말 톤
