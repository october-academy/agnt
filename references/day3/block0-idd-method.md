---
stop_mode: full
title: "Proof CTA 설계"
npc: 석이
quests:
  - id: d3-idd-method
    type: main
    title: "Proof CTA 설계"
    xp: 50
transition: "proof CTA가 정리되었습니다. 이제 이걸 SPEC v1 구조에 묶어봅시다."
---

# Proof CTA 설계

## ROOM

설계의 탑 1층에 들어선다.
벽에는 도면보다
짧은 메모와 화살표가 더 많다.

## NPC

석이가 칠판에 한 줄을 적는다.

📐 탑지기 석이

"오늘의 주인공은
기능 목록이 아니야.

Day 2에서 모은 증거를 바탕으로
이번 주에 받고 싶은 반응을
한 문장으로 고정하는 거지.

그게 `proof CTA`야."

## SCENE 1: proof CTA란

석이가 세 칸을 그린다.

1. 누구에게
2. 어떤 문제/offer로
3. 어떤 반응을 요청하는가

예:

"freelancer PM에게
반복 리포트 자동화 가설을 보여주고,
파일럿 참여 의향이나
구체적 objection을 받는다."

석이가 덧붙인다.

"파일럿 이야기를 꺼냈는데
상대가 '그건 좀…' 하고 멈칫하는 지점,
그게 'objection'이야.

거절이 아니라
아직 넘어가지 못한 장벽이지.
이게 보여야 다음 change set이 나와."

"좋아 보이세요?"는
proof CTA가 아니다.
반응을 어떻게 읽을지까지
포함돼야 한다.

### CHOICE

AskUserQuestion:
질문: 석이가 묻는다. "어떤 문장이
proof CTA에 더 가깝지?"
선택지:

1. "관심 있으시면 봐주세요"
2. "이 페이지를 보고
   가장 안 와닿는 지점을 말해주세요"
3. "서비스가 멋진지 평가해주세요"

정답: 2번.
석이가 고개를 끄덕인다.
"맞아.
행동이나 objection이 남아야
내일 change set으로 이어져."

## SCENE 2: Day 3에서 고정할 것

석이가 오늘 산출물을 적는다.

- proof CTA
- v1 hypothesis
- v0 대비 change set
- 다음 metric gate

"Day 3는 스펙의 뼈대를 늘리는 날이 아니라
Day 2 증거를 기준으로
무엇을 바꿨는지 남기는 날이야."

## TASK

석이가 말한다.

"지금 바로 정리해."

1. 누구에게 보낼지
2. 어떤 반응을 받고 싶은지
3. 그 반응이 나오면
   무엇을 keep / change 할지

## STOP

AskUserQuestion:
질문: 석이가 묻는다. "proof CTA가
한 문장으로 정리됐어?"

1. "다음"
2. "아직"

⛔ STOP — "탑지기 석이가 기다립니다."

## RETURN

AskUserQuestion:
질문: 석이가 묻는다.
"Day 3에서 제일 먼저 고정해야 할 건?"
선택지:

1. "feature list"
2. "proof CTA와 change set"
3. "경쟁사 전체 분석"

정답: 2번.
석이가 웃는다.
"좋아.
이제 v1 구조 안에 넣자."

## MOVE

석이가 2층 설계실을 가리킨다.

"위로 올라가.
이제 문장들을
`SPEC v1` 구조로 묶을 거야."
