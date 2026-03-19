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

### Week 2 미리보기

Week 2에서는 검증에서 실행으로 넘어간다:

- **Day 8-14**: AI와 함께 MVP 빌드 + 첫 배포
- **Day 15-21**: 유저 확보 + 피드백 루프 + 개선
- **Day 22-30**: 수익화 + 스케일링 + 첫 매출 달성

Week 1에서 만든 SPEC, 채널 데이터, 고객 피드백이 모두 Week 2의 연료가 된다.

### 전환 메커니즘 1: 성과 시각화

"7일간 __명과 대화했고,
__번 클릭이 왔고,
SPEC을 __번 진화시켰다.

혼자였으면 이게 나왔을까?
이건 혼자서는 만들 수 없는 속도야."

### 전환 메커니즘 2: 손실 회피 (개인화)

{state.character.runway 존재 시}
"런웨이가 {{character.runway}}개월이야.
여기서 멈추면
남은 시간을 혼자 시행착오로 쓰게 돼.
7일간 만든 검증 데이터가
서랍에 들어가.

Day 8부터 이어가면
이 데이터가 첫 매출로 이어져.
혼자 했으면 3개월,
이 구조로 하면 3주야."

{미존재 시}
"여기서 멈추면
7일간의 모멘텀이 사라져.

내일 바로 이어가면
이 속도가 유지돼.
1주일 쉬면
다시 0에서 시작이야."

### 전환 메커니즘 3: Week 2 미리보기

"Day 8에서 이 SPEC으로
AI가 MVP를 만들어.
검증된 SPEC으로.

Week 1의 데이터가
Week 2의 첫 매출을 만든다."

### 전환 메커니즘 4: 가격 프레이밍

"월 99,000원.
카페 커피 한 잔.
근데 카페에서 30일 검증은 안 돼.

7일 이내 전액 환불 보장.
마음에 안 들면
질문 없이 돌려받는다."

`get_spec_iterations` MCP 도구로
Week 1의 SPEC 변화 이력을 조회하여
성장의 증거를 보여줍니다.

### handoff 작성

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
