---
stop_mode: checkpoint
title: "Change Set refinement"
npc: 나래
quests:
  - id: d4-differentiation
    type: main
    title: "Change Set refinement"
    xp: 100
  - id: d4-positioning
    type: side
    title: "다음 검증 목표 정리"
    xp: 30
transition: "Day 4 완료! 이제 변화량을 읽고 SPEC v2를 적을 차례입니다."
---

# Change Set refinement

## ROOM

정상 바위 위에 다시 선다.

## NPC

나래가 짧게 말한다.

🦅 척후 나래

"좋아.
오늘 마지막은
네 줄이면 끝나.

참, 내일부터 한이가
변화의 크기를 재는 기준을 알려줄 거야.
그걸 '변화량'이라고 불러.
오늘은 그 전 단계 — 뭘 바꿀지 정하는 날이지."

## GUIDE

```text
유지 (Keep):
제거 (Drop):
수정 (Change):
시험 (Test):
```

그리고 마지막에
`next 검증 목표` 1개를 적는다.

예:

- 유지 (Keep): 문제 장면 중심 메시지
- 제거 (Drop): 추상적인 생산성 문구
- 수정 (Change): CTA를 "출시 알림"에서 "파일럿 문의"로
- 시험 (Test): Discord 대신 직접 연락
- next 검증 목표: 명시적 결제 의향이 나오는지

"좋은 수정 사항은
보기 좋은 아이디어가 아니라
반응을 더 빨리 확인할 수 있는 수정안이야."

## STOP

AskUserQuestion:
질문: 나래가 묻는다. "수정 사항과
다음 검증 목표가 정리됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "척후 나래가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

1. `d4-differentiation` 제출
2. `d4-positioning` 제출
3. state.json에
   `changeSet`, `nextProofTarget` 저장

## MOVE

나래가 시장 쪽을 가리킨다.

"좋아.
이제 숫자와 반응의
변화량을 읽으러 가."
