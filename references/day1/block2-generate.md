---
stop_mode: checkpoint
title: "가설 카드 + SPEC baseline"
npc: 소리
transition: "현재 단계에 맞는 액션 패키지가 정리되었습니다. 다음 단계에서 실제 실행으로 옮깁니다."
---

# 가설 카드 + SPEC baseline

## ROOM

숲 외곽 전망대에 선다.
나무 사이로 들판과 마을이
한눈에 내려다보인다.

## NPC

소리가 난간에 기대선다.

🦉 현자 소리

"저축이 줄어드는 동안
만들기만 했잖아.

오늘부터 달라.
만들기 전에 검증한다.

{state.character.exploration.failureType 존재 시}
가설 카드를 만든다고 했지?
코드 리뷰 체크리스트 만들 때랑
뭐가 다를까?

가설, 변수, 측정 기준.
대상만 코드에서 시장으로 바뀌는 거
아닐까?

{미존재 시}
인터뷰에서 나온 걸
`가설 카드`와 `SPEC baseline`로 정리하자.

가설 카드는 한 장이면 돼.
누구의 / 어떤 문제를 / 왜 내가 푸는지."

## GUIDE

### `SPEC baseline`에 꼭 들어갈 것

```markdown
### v0 (Day 1)

- 핵심 가설 (Hypothesis): 지금 진행할 핵심 가설
- 수정 사항 (Change Set): 오늘 고정한 현재 방향
- 증거 요약 (Evidence Summary): 현재 가진 출발점
- 판단 기준 (Metric Gate): 첫 검증을 볼 기준
- 수익화 체크포인트 (Monetization Checkpoint): 아직 없음
- 판단 (Decision): 아직 없음
- 다음 단계 (Next Step): 이번 주 첫 검증 목표
```

### 가설 카드 구조

```markdown
## 가설 카드

- 타겟: 누구의 문제인가?
- 문제: 어떤 문제를 풀 것인가?
- 가치제안: 왜 이 문제를 내가 풀 수 있는가?
- 검증 질문: 이번 주에 확인할 핵심 질문 1개
```

"형식이 아니라
확인할 수 있는 질문이 있느냐가 핵심이야."

## PREVIEW

소리가 묻는다.

"지금 네 패키지를 읽었을 때
세 가지가 보여야 해.

1. 무엇을 믿고 있는가
2. 어디서 그걸 확인할 것인가
3. 무엇이 나오면 다음으로 갈 것인가"

## STOP

AskUserQuestion:
질문: 소리가 묻는다. "SPEC baseline와
액션 패키지가 정리됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "현자 소리가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

### `SPEC baseline` 기록

state.json `specVersions`에
v0를 추가합니다.

필수 항목:

- `hypothesis`
- `changes`
- `evidenceSummary`
- `metricGate`
- `nextStep`

인증 상태면 MCP `save_spec_iteration`
호출 시 Day 1 canonical 필드를
비우지 않습니다.

### action package 저장

state.json에 아래를 함께 남깁니다.

- `proofSurface`
- `nextProofTarget`
- `metricGate`

## MOVE

소리가 숲 출구를 가리킨다.

"좋아.
이제 이 가설을 어떻게 검증할지
계획을 세우자."
