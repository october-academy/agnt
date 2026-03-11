---
stop_mode: checkpoint
title: "Week 2 handoff"
npc: 달이
quests:
  - id: d7-letter
    type: side
    title: "Week 2 handoff note"
    xp: 30
transition: "Week 1 검증 루프가 마무리되었습니다."
---

# Week 2 넘기기 (handoff)

## ROOM

둑 위에 다시 선다.
석양이 물가에 길게 번진다.

## NPC

달이가 마지막으로 말한다.

🎣 어부 달이

"좋아.
Week 1을 끝내는 문장은
반드시 Week 2 첫 행동으로
이어져야 해.
이걸 '넘기기(handoff)'라고 하지."

## GUIDE

좋은 넘기기(handoff)는
최종 판단과 모순되지 않는다.

- 진행 (Go): 확장할 한 가지
- 반복 (Iterate): 다시 검증할 한 가지
- 방향 전환 (Pivot): 바꿀 축 한 가지
- 중단 (No-Go): 다음 아이디어에 가져갈 기준 한 가지

예:

- "paid pilot ask 5명에게 보내고 commitment 1건 확보"
- "reply는 나오지만 click이 약하니 hero + CTA만 수정"
- "problem은 유지, target segment만 freelancer PM으로 좁힘"

## STOP

AskUserQuestion:
질문: 달이가 묻는다. "Week 2 넘기기를
확정할까?"

1. "완료"
2. "수정 요청"

⛔ STOP — "어부 달이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"완료"를 선택했을 때만
ON_CONFIRM을 수행합니다.

1. state.json에
   `week2Handoff`를 저장합니다.
2. `d7-letter` 제출을 처리합니다.

## MOVE

달이가 웃는다.

"좋아.
Week 1은 끝났고,
이제 근거 있는 Week 2로 넘어간다."
