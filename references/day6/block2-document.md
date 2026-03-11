---
stop_mode: checkpoint
title: "검증 기록 + SPEC 반영"
npc: 은이
quests:
  - id: d6-unit-economics
    type: side
    title: "Offer log + 근거 정리"
    xp: 30
transition: "Day 6 완료! 이제 Week 1 최종 판단을 내릴 준비가 됐습니다."
---

# 검증 기록 + SPEC 반영

## ROOM

기록실 책상 위에
빈 종이와 오늘 메모가 놓여 있다.

## NPC

은이가 손가락으로 두 줄을 짚는다.

💰 길드장 은이

"오늘 남긴 걸
내일 바로 읽을 수 있게
정리하자.

모든 증거를 모아서 내리는 판단,
이걸 '최종 판단'이라 하자.
내일 달이가 이 최종 판단을 기록할 거니까
오늘 재료를 빠짐없이 남겨."

## GUIDE

오늘은 두 가지만 남긴다.

1. `Monetization Checkpoint` (수익화 점검)
2. `제안 기록 (Offer log) / follow-up plan`

예:

```text
Monetization Checkpoint:
- proofType: payment_commitment
- status: payment_commitment
- amount: 50000
- reference: dm://pilot-1
- summary: 1:1 파일럿 의향 확인

제안 기록 (Offer Log):
- 어떤 ask가 먹혔는가
- 어떤 objection이 남았는가
- 내일 최종 판단에서 어떻게 읽을 것인가
```

## STOP

AskUserQuestion:
질문: 은이가 묻는다. "제안 기록과
checkpoint를 확정할까?"

1. "확인"
2. "수정 요청"

⛔ STOP — "길드장 은이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

1. state.json에
   제안 기록(offer log)과 follow-up plan을 저장합니다.
2. state.json `specVersions.v2`의
   `monetizationCheckpoint`가 비어 있지 않다면
   authenticated 상태에서
   `save_spec_iteration(version: "v2")`를 다시 호출해
   최신 checkpoint를 서버 `spec_iterations`에도 반영합니다.
3. `d6-unit-economics` 제출을 처리합니다.

## MOVE

은이가 호수 방향을 가리킨다.

"좋아.
이제 이번 주 검증을
한 번에 펼쳐보자."
