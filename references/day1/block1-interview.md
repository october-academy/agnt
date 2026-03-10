---
stop_mode: conversation
title: "AI 코파운더 진단 인터뷰"
npc: 소리
quests:
  - id: d1-interview
    type: main
    title: "Builder 상태 진단 + SPEC v0 기준선"
    xp: 100
on_complete: save_interview
transition: "기준선이 잡혔습니다. 이제 이번 주에 검증할 proof surface와 next proof target을 정리해봅시다."
---

# Builder 진단 + SPEC v0 기준선

## ROOM

숲 깊은 곳,
고대 나무 뿌리 앞에 앉는다.
고요한 공기 위로
잎사귀 소리만 스친다.

## NPC

소리가 노트를 펼친다.

🦉 현자 소리

"좋아.
오늘 인터뷰 목표는 네 가지다.

1. 지금 stage를 고정한다
2. 가장 큰 병목을 고른다
3. `SPEC v0` 기준선을 만든다
4. 이번 주 첫 proof target을 좁힌다

예쁜 답보다
실제 장면이 필요해."

## CONVERSATION

### 완성 체크리스트

- [ ] 현재 stage 1개
- [ ] 핵심 병목 1개
- [ ] 현재 surface 또는 만들 surface 1개
- [ ] 기준 가설 1개
- [ ] 이번 주 first proof target 1개

### 대화 규칙

- "누구를 위해 무엇을 확인하려는가"가 빠지면 다시 묻기
- 기존 자산 유저는 새 아이디어로 도망가지 않기
- no_idea 유저는 문제 장면 없이 solution으로 점프하지 않기
- 소리 말투: "정말 그런가? 어떤 장면에서?"

### 인터뷰 핵심 질문

1. 지금 자산 단계는 무엇인가
2. 현재 가장 큰 병목은 무엇인가
3. 이 병목을 보여주는 최근 증거는 무엇인가
4. 이번 주 무엇이 증명되면 앞으로 밀 수 있는가
5. 어떤 surface에서 그 proof를 받을 것인가

## SUMMARY

소리가 오늘 기준선을 읽는다.

```text
Day 1 기준선
- 진입 경로 (entry mode): ...
- 자산 단계 (asset stage): ...
- 핵심 병목 (primary bottleneck): ...
- 기준 가설 (baseline hypothesis): ...
- 이번 주 proof target: ...
- 첫 proof surface: ...
```

소리:
"좋아.
이게 오늘의 `SPEC v0`
재료다."

## STOP

AskUserQuestion:
질문: 소리가 묻는다. "기준선이 맞아?"

1. "확인"
2. "수정 요청"

⛔ STOP — "현자 소리가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.

1. state.json에 interview 결과를 저장합니다.
2. `builderContext`, `builderBrief`,
   `primaryBottleneck`, `nextProofTarget`
   초안을 갱신합니다.
3. 인증 상태면
   interview 저장과 `d1-interview`
   제출을 수행합니다.

## MOVE

소리가 전망대 쪽을 가리킨다.

"좋아.
이제 그 기준선을
문서와 실행 패키지로 묶자.

무엇을 보여줄지
한 번에 정리해야 해."
