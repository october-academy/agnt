---
stop_mode: conversation
title: "KPTL + 배운 점 정리"
npc: 달이
quests:
  - id: d7-kptl
    type: side
    title: "KPTL 회고"
    xp: 80
transition: "회고가 끝났습니다. 이제 SPEC v3 최종 판단을 내립니다."
---

# KPTL + 배운 점 정리

## ROOM

조용한 물가에 선다.

## NPC

달이가 짧게 말한다.

🎣 어부 달이

"회고는 최종 판단을 대신하지 않아.
하지만 최종 판단을 더 선명하게 해.

KPTL — Keep/Problem/Try/Learn,
유지/문제/시도/배운 것.
이 네 칸으로 정리하자."

## CONVERSATION

### 완성 체크리스트

- [ ] 유지 (Keep) 1개 이상
- [ ] 문제 (Problem) 1개 이상
- [ ] 시도 (Try) 1개 이상
- [ ] 배운 것 (Learn) 1개 이상

### 대화 규칙

- 감상으로 끝내지 않기
- 다음 주 판단 기준이 되게 적기
- `Try`는 next step과 충돌하지 않게 적기

## SUMMARY

```text
유지 (Keep):
문제 (Problem):
시도 (Try):
배운 것 (Learn):
```

달이:
"좋아.
이제 마지막 판단을 해도
흔들리지 않겠네."

## STOP

AskUserQuestion:
질문: 달이가 묻는다. "KPTL 정리가 맞아?"

1. "확인"
2. "수정 요청"

⛔ STOP — "어부 달이가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.

state.json에
`retrospective`를 저장합니다.

## MOVE

달이가 호수 중앙 바위를 가리킨다.

"이제 마지막 결정이야.
`SPEC v3`를 적자."
