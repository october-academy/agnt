---
stop_mode: checkpoint
title: "Week 1 proof review"
npc: 달이
quests:
  - id: d7-data-collect
    type: main
    title: "Week 1 proof review"
    xp: 50
transition: "proof review가 완료되었습니다. 이제 회고와 verdict를 정리합니다."
---

# Week 1 proof review

## ROOM

호수 둑에 도착한다.
물결 위로 이번 주 메모가
겹쳐 보인다.

## NPC

달이가 손으로 네 줄을 그린다.

🎣 어부 달이

"오늘은 흩어진 걸
한 번에 모아서 보자.

customer,
channel,
monetization,
decision.

이 네 줄기가 같이 보여야
verdict(최종 판단)를 낼 수 있어."

## GUIDE

다음을 모읍니다.

1. customer proof
2. channel proof
3. monetization proof
4. decision proof

각 항목마다
"무엇이 가장 강했는가"를
한 줄씩 남깁니다.

## STOP

AskUserQuestion:
질문: 달이가 묻는다. "Week 1 proof review가
됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "어부 달이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

다음 블록으로 이동합니다.

## MOVE

달이가 물가 안쪽을 가리킨다.

"좋아.
이제 회고를 짧게 하고
판단으로 넘어가자."
