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
아침 바람이 불고,
게시판 앞에 사람들이 서 있다.

## NPC

바리가 게시판을 가리킨다.

🎒 행상 바리

"검증을 시작하기 전에
한 가지만 해두자.

지금 서 있는 위치,
이번 주 검증 가설,
주간 목표를 짧게 기록하는 거야.

이게 baseline이야.
일주일 뒤에 돌아보면
진짜 움직였는지 알 수 있어."

## GUIDE

### baseline 세 줄

NPC가 유저에게 세 가지를 묻는다.
이전 Day에서 정리한 SPEC baseline과
인터뷰 결과를 참고해서 채운다.

1. **지금 stage** — 현재 상태를 한 줄로
2. **이번 주 hypothesis** — 이번 주 검증할 가설
3. **검증 목표** — 주간 목표 숫자 (예: 순방문자 50명)

state.json의 `builderContext`나
MCP `get_learning_context`로
이전 인터뷰/SPEC 데이터를 가져와서
초안을 제안할 수 있다.

### 자동 발송

세 줄이 정리되면
MCP `send_baseline` 도구를 호출하여
Discord에 자동 발송한다.

유저가 직접 Discord에 쓸 필요 없다.
봇이 대신 게시하고 메시지 URL을 돌려준다.

## STOP

AskUserQuestion:
질문: 바리가 묻는다. "baseline 세 줄을
정리해봐. 지금 stage,
이번 주 가설, 검증 목표."

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
