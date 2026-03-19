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

- **Go 판정 시**: "저축이 줄어드는 동안 이 SPEC을 검증했어. Week 2에서 첫 매출까지 가는 길이 여기 있어. AI가 코드를 함께 짜줄 거야. Day 8부터 이 SPEC으로 실제 MVP를 만든다."
- **Iterate 판정 시**: "저축은 계속 줄어. Week 2에서 더 날카로운 검증 도구와 AI 피드백 루프로 속도를 높여. Day 8에서 새로운 검증 표면을 AI가 30분 안에 만들어줘. 지금까지의 데이터가 Week 2의 출발점이야."
- **Pivot 판정 시**: "방향을 바꿔도 Week 1에서 배운 검증 기술은 그대로야. Week 2에서 새 방향의 빠른 검증을 AI와 함께 반복해. 속도가 2배야."

### Week 2 상세 미리보기 (Go 선택 시)

Week 2에서 당신이 할 것:

| Day | 테마 | 핵심 산출물 |
|-----|------|------------|
| Day 8 | MVP 스코프 확정 | 핵심 기능 3개 + 기술 스택 결정 |
| Day 9 | 핵심 기능 구현 시작 | 첫 동작하는 코드 |
| Day 10 | 핵심 기능 완성 | 데모 가능한 MVP |
| Day 11 | 베타 준비 | 온보딩 플로우 + 피드백 채널 |
| Day 12 | 베타 런칭 | 첫 베타 유저 초대 |
| Day 13 | 피드백 수집 | 베타 유저 반응 분석 |
| Day 14 | Week 2 회고 | 성장 지표 + Week 3 계획 |

Week 1에서 검증한 가설을
Week 2에서 실제 프로덕트로 만듭니다.

지금 결제하면 Day 8 콘텐츠에
바로 접근할 수 있습니다.

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
