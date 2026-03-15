---
stop_mode: conversation
title: "SPEC v3 최종 판단"
npc: 달이
quests:
  - id: d7-go-nogo
    type: main
    title: "SPEC v3 최종 판단"
    xp: 100
transition: "최종 판단이 기록됐습니다. 이제 Week 2로 넘기기(handoff)를 남깁니다."
---

# SPEC v3 최종 판단

## ROOM

호수 중앙 바위 위에 선다.

## NPC

달이가 낚싯대를 내려놓는다.

🎣 어부 달이

"여기서 이번 주를 결정하자.
속도가 아니라
검증으로."

## CONVERSATION

### 완성 체크리스트

- [ ] 증거 요약 (Evidence Summary)
- [ ] 수익화 점검 (Monetization Checkpoint)
- [ ] 판정 (Decision)
- [ ] 다음 단계 (Next Step)

### 버전 이력 로딩

인증 상태면
`get_spec_iterations`로 v0~v2를 불러온다.
state.json `specVersions`도 같이 본다.

### 판단 기준

- 고객 검증이 반복되는가
- 채널 검증에서 실제 반응이 있었는가
- 수익 검증 checkpoint가 명시적으로 남았는가
- 다음 주에 밀 근거가 있는가

## SUMMARY

```text
증거 요약 (Evidence Summary): ...
수익화 점검 (Monetization Checkpoint): ...
판정 (Decision): 진행(go) | 반복(iterate) | 방향 전환(pivot) | 중단(no_go)
다음 단계 (Next Step): ...
```

### Week 2 가치 예고

Go/No-Go 결정 후, 다음 단계를 안내한다:

- **Go 판정 시**: "Week 2에서는 AI가 코드를 함께 작성하고, 실제 프로덕트를 만들어 배포합니다. 검증된 SPEC을 가지고 빌드에 들어가면 속도가 완전히 달라집니다."
- **Iterate 판정 시**: "Week 2에서는 더 날카로운 검증 도구와 AI 피드백 루프를 사용합니다. 지금까지의 데이터가 Week 2의 출발점이 됩니다."
- **Pivot 판정 시**: "Week 2에서는 새로운 방향의 빠른 검증을 AI와 함께 반복합니다. 방향 전환이 곧 실패가 아니라, 더 좋은 기회를 찾는 과정입니다."

## STOP

AskUserQuestion:
질문: 달이가 묻는다. "SPEC v3 최종 판단을
확정할까?"

1. "확인"
2. "수정 요청"

⛔ STOP — "어부 달이가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.

1. state.json `specVersions`에
   v3를 추가합니다.
2. 인증 상태면
   `save_spec_iteration(version: "v3")`
   호출 시 `decision`을 포함한 canonical field를 모두 전달합니다.

## MOVE

달이가 둑 쪽을 가리킨다.

"좋아.
이제 다음 주 첫 걸음을
한 줄로 남기자."
