---
stop_mode: full
title: "Monetization ask 설계"
npc: 은이
quests:
  - id: d6-model
    type: main
    title: "Monetization ask 설계"
    xp: 50
transition: "유효한 monetization rail을 골랐습니다. 이제 실제 검증을 캡처합시다."
---

# 수익화 제안 (Monetization ask) 설계

## ROOM

길드 건물 안으로 들어선다.
장부와 영수증이
탁자 위에 놓여 있다.

## NPC

은이가 장부를 펴고 말한다.

💰 길드장 은이

"오늘은 가격표를 예쁘게 쓰는 날이 아니야.
누가 지금 이 방향의 제품에
실제로 돈을 낼 의향이 있는지
수익화 제안을 던지는 날이지."

## SCENE 1: 인정되는 검증

은이가 세 줄만 적는다.

- `payment_commitment` (결제 의향)
- `bank_transfer_received` (송금 확인)
- `ad_revenue_received` (광고 수입 확인)

"이 셋 말고는
오늘 수익 검증으로
올려 읽지 마.

waitlist나 막연한 관심은
검증이 아니라
다음 질문 거리일 뿐이야."

## SCENE 2: ask 구조

좋은 ask는 세 가지가 필요하다.

1. offer
2. amount
3. 요청 행동

예:

- "이번 주 파일럿을 5만 원에 바로 시작할 의향 있나요?"
- "수동 이체로 먼저 참여할 수 있나요?"
- "현재 랜딩 방향이라면 광고 붙은 무료 버전보다 유료 버전을 택하실 건가요?"

## TASK

은이가 말한다.

"정리해."

1. rail 1개
2. amount 범위
3. 누구에게 물을지
4. 어떤 문장으로 ask할지

## STOP

AskUserQuestion:
질문: 은이가 묻는다. "수익화 제안이
정리됐어?"

1. "다음"
2. "아직"

⛔ STOP — "길드장 은이가 기다립니다."

## RETURN

AskUserQuestion:
질문: 은이가 묻는다.
"`좋아 보여요`와 `5만 원이면 해볼래요` 중
뭐가 더 강한 신호지?"

1. "`좋아 보여요`"
2. "`5만 원이면 해볼래요`"

정답: 2번.

## MOVE

은이가 안쪽 회의실을 가리킨다.

"좋아.
이제 실제로 남길 검증을
적자."
