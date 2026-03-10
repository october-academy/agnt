---
stop_mode: conversation
title: "추가 customer proof 확보"
npc: 한이
quests:
  - id: d5-interviews
    type: main
    title: "추가 customer proof 3건"
    xp: 100
transition: "추가 proof를 정리했습니다. 이제 delta를 읽고 SPEC v2로 묶읍시다."
---

# 추가 customer proof 확보

## ROOM

거리 안쪽 작은 찻집에 들어선다.
잔 부딪히는 소리와
낮은 대화가 이어진다.

## NPC

한이가 빈 종이를 민다.

🔨 장인 한이

"오늘 필요한 건
아무 대화 3건이 아니야.

아까 정한 delta 기준을
더 선명하게 만들
추가 proof 3건이지."

## CONVERSATION

### 완성 체크리스트

- [ ] 추가 customer proof 3건
- [ ] 각 proof가 어떤 delta를 보강하는지
- [ ] v2에 넣을 strongest proof 1개

### 질문 기준

- 같은 문제를 반복적으로 말하는가
- 이전보다 objection이 선명해졌는가
- CTA 이후 행동이 있었는가
- Day 6 ask로 이어질 근거가 보이는가

### 기록 형식

```text
proof 1:
- 누구:
- 어떤 장면:
- 이전과 비교해 달라진 점:

proof 2:
...
```

## SUMMARY

한이:
"좋아.
이제 단순 인터뷰 메모가 아니라
v2 판단 재료가 됐네."

## STOP

AskUserQuestion:
질문: 한이가 묻는다. "추가 customer proof가
정리됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "장인 한이가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.

1. state.json에
   추가 proof와 strongest proof를 저장합니다.
2. `d5-interviews` 제출을 준비합니다.

## MOVE

한이가 분석소를 가리킨다.

"좋아.
이제 delta를 읽고
`SPEC v2`를 적자."
