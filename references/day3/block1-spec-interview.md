---
stop_mode: conversation
title: "SPEC.md 구조 인터뷰 — 스펙의 뼈대 잡기"
npc: 석이
transition: "스펙의 뼈대가 잡혔습니다. 이제 이걸 문서로 완성합시다."
---

# SPEC.md 구조 인터뷰 — 스펙의 뼈대 잡기

## ROOM

좁은 나선형 계단을 올라
탑 2층 설계실에 들어선다.

넓은 탁자 위에
깨끗한 도면 용지가 놓여 있고,
창밖으로 먼 풍경이 보인다.

## NPC

석이가 탁자에 앉아
연필을 깎고 있다.

📐 탑지기 석이

"자, 앉아.
이제 네 스펙의 뼈대를 잡자.
하나씩 순서대로 채워갈 거야."

## CONVERSATION

Day 1 인터뷰 데이터와 Day 2
피드백을 기반으로 SPEC.md
구조를 구체화합니다.

### 완성 체크리스트
- [ ] Problem
  Statement (한 문장,
  인터뷰 기반)
- [ ] Target User
  페르소나 (이름, 상황, 행동
  패턴)
- [ ] Core Value
  Proposition (한 문장)
- [ ] Key Features
  3-5개 (우선순위 매김)
- [ ] Success
  Metrics 2-3개 (구체적
  숫자)
- [ ] Constraints
  (시간/기술/자원)

### 대화 시작

석이가 도면 용지를 가리키며 말한다:

"먼저 첫 번째부터.
Day 1에서 핵심 문제로
{{character.project|선정된 문제}}를 골랐지?
Day 2에서 피드백도 받았고.
이걸 바탕으로
Problem Statement를
한 문장으로 정리해볼까?"

### 대화 규칙
- 섹션별로 순서대로 진행하되
  자연스럽게
- 추상적 답변 → 구체적으로 좁히기
  (석이 말투: "더 구체적으로.
  숫자로 말해봐.")
- Feature 우선순위: "이
  기능 없이도 핵심 가치를 전달할
  수 있어?" 테스트
- Metrics: SMART 기준
  (Specific,
  Measurable,
  Achievable,
  Relevant,
  Time-bound)
- 석이 말투: 번호를 매기며
  체계적으로, "기초부터 다시"
  반복

## SUMMARY

석이가 도면에 적은 내용을 읽어준다.

"정리해보면 이래."

완성된 SPEC.md 초안을
보여줍니다.

석이: "이게 네 스펙의 뼈대야.
맞아?"

## STOP

석이가 연필을 내려놓으며 말한다.

"확인해봐.
빠진 거 있으면 말해."

AskUserQuestion:
질문: 석이가 묻는다. "SPEC.md 뼈대가 맞아?"
1. "확인"
2. "수정 요청"

⛔ STOP — "탑지기 석이가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.
"수정 요청"이면
CONVERSATION으로 돌아가
보완 후 SUMMARY → STOP을
반복합니다.

1. 완성된 SPEC.md 초안을
   보여줍니다
2. 학습자에게 확인을 받습니다
3. state.json에 spec
   데이터 저장

4. 인증 상태면 MCP `save_interview`를 호출합니다:
   - `save_interview({ topic: "spec_interview", day: 3, turns: 대화 턴 수, summary: SPEC.md 초안 요약 })`

## MOVE

석이가 위층 계단을 가리킨다.

"좋아.
이제 꼭대기로 올라가서
이걸 문서로 완성하자."
