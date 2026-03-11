---
stop_mode: checkpoint
title: "SPEC v1 기록 + 검증"
npc: 석이
quests:
  - id: d3-spec-write
    type: main
    title: "SPEC.md v1 작성"
    xp: 100
  - id: d3-ai-review
    type: side
    title: "AI 반론 + 놓친 점 검토"
    xp: 30
transition: "Day 3 완료! 이제 response를 해석하고 수정 사항을 다듬으러 갑니다."
---

# SPEC v1 기록 + 검증

## ROOM

탑 꼭대기 전망대에 선다.
바람이 세차게 불고
들판이 한눈에 내려다보인다.

## NPC

석이가 문서 양식을 펼친다.

📐 탑지기 석이

"좋아.
이제 남겨.

오늘 끝나면
누구에게 무엇을 던졌고,
왜 그걸 던졌는지,
내일 뭘 읽을지
문서만 봐도 보여야 해."

## GUIDE

### `SPEC v1` 최소 구조

```markdown
### v1 (Day 3)

- 핵심 가설 (Hypothesis): Day 2 이후 유지/수정한 가설
- 수정 사항 (Change Set): v0에서 바뀐 점
- 증거 요약 (Evidence Summary): 고객 검증/채널 검증 요약
- 목표 수치 (Metric Gate): 다음에 볼 기준
- 수익화 점검 (Monetization Checkpoint): null
- 판정 (Decision): null
- 다음 단계 (Next Step): Day 4에서 읽을 신호
```

### 같이 남길 것

- 검증 CTA 문장
- 놓친 점 1개 이상

`d3-ai-review`는
"이 판단을 뒤집을 만한 반론이 뭐냐"
를 적어두는 side quest다.

## PREVIEW

석이가 묻는다.

"이 문서를 읽는 사람이
세 가지를 바로 알 수 있어야 해.

1. 무엇을 믿고 있는가
2. 무엇을 바꿨는가
3. 내일 무엇을 읽을 것인가"

## STOP

AskUserQuestion:
질문: 석이가 묻는다. "SPEC v1과
놓친 점 검토가 준비됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "탑지기 석이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

### `SPEC v1` 기록

state.json `specVersions`에
v1을 추가합니다.

인증 상태면 MCP `save_spec_iteration` 호출 시
다음을 빠뜨리지 않습니다.

- `changes`
- `evidenceSummary`
- `metricGate`
- `nextStep`

### 제출

1. `d3-spec-write` 제출
2. 놓친 점이 정리됐으면
   `d3-ai-review`도 함께 제출

## MOVE

석이가 계단 아래를 가리킨다.

"좋아.
이제 내일부터는
반응의 질을 읽는 쪽으로 간다.

신호를 잘못 읽으면
v2가 무너져."
