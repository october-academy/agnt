---
stop_mode: checkpoint
title: "Week 1 baseline 공유"
npc: 바리
quests:
  - id: d2-baseline
    type: main
    title: "Week 1 baseline 공유"
    xp: 30
transition: "baseline이 기록됐습니다. 이제 검증의 도구를 챙기러 가봅시다."
---

# Week 1 baseline 공유

## ROOM

검증의 광장 입구.
게시판 앞에 사람들이 서 있다.

## NPC

🎒 행상 바리

"검증 시작 전에
지금 위치 세 줄만 남겨두자.
일주일 뒤에 진짜 움직였는지 알 수 있어."

## GUIDE

state.json의 `builderContext`나
MCP `get_learning_context`로
이전 인터뷰/SPEC 데이터를 가져와서
아래 세 줄 초안을 제안한다.

세 줄이 정리되면
MCP `send_baseline`으로 Discord에 자동 발송한다.

## STOP

AskUserQuestion:
질문: 바리가 묻는다. "지금 stage,
이번 주 가설, 검증 목표.
세 줄로 정리해봐."

1. 직접 입력

⛔ STOP — "행상 바리가 기다립니다."

## ON_CONFIRM

유저가 baseline 세 줄을 답하면:

1. 답변에서 stage, hypothesis, target을 추출
2. MCP `send_baseline` 호출:
   - stage: 지금 stage
   - hypothesis: 이번 주 가설
   - target: 검증 목표
3. 성공 시 `d2-baseline` 제출 처리
4. 실패 시 에러 메시지 표시 후 재시도 안내

## MOVE

바리가 고개를 끄덕인다.

"좋아.
baseline이 기록됐어.

이제 진짜 검증 도구를 챙기자.
The Mom Test부터."
