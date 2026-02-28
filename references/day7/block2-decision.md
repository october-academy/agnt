---
stop_mode: conversation
title: "Go/No-Go 결정 — 다음 23일을 어떻게 보낼 것인가"
npc: 달이
quests:
  - id: d7-go-nogo
    type: main
    title: "Go/No-Go 결정"
    xp: 50
transition: "결정이 내려졌습니다. 이제 Foundation Phase를 마무리합시다."
---

# Go/No-Go 결정 — 다음 23일을 어떻게 보낼 것인가

## ROOM

호수 중앙,
물 위로 솟은 큰 바위에 선다.

사방이 물로 둘러싸여 있고,
하늘과 물의 경계가
흐릿해 보인다.

## NPC

달이가 바위 옆에 배를 대고
올라오며 말한다.

🎣 어부 달이

"여기가 결정의 돌이야.

지난 7일의 데이터를 바탕으로
{{character.project|프로젝트}}의
방향을 결정하자."

달이가 수면을 내려다본다.

"물에 비친 걸 봐.
답이 보일 거야."

## CONVERSATION

### 완성 체크리스트

- [ ] Go/Pivot/No-Go
      판단 + 근거
- [ ] Go라면: 다음 7일 핵심
      마일스톤 1개
- [ ] Pivot이라면: 어떤
      방향으로, 무엇이 달라지는지
- [ ] No-Go라면: 배운 것을
      다음 아이디어에 어떻게 적용할지

### 버전 이력 로딩

인증 상태면 MCP `get_spec_iterations` 호출로
v0~v2 이력을 조회한다.
state.json `specVersions`도 확인한다.

달이: "v0에서 v2까지
어떻게 바뀌었는지 보자."

### 대화 시작

달이가 7일간 수집한 핵심 데이터를
요약한 후 말한다.

버전 이력이 있으면 달이가
v0→v1→v2 변화 추이를 먼저
짧게 정리한다:

"v0에서 시작해서
v1에서 {변경점},
v2에서 {변경점}을 거쳤어.

이 흐름을 보면서,
{{character.project|이 프로젝트}}를
계속 진행해야 한다고 생각해?"

### Go/No-Go 기준 (델타 기반)

달이: "기준을 알려줄게.
이번엔 **버전 간 변화**가 핵심이야."

**Go 시그널 (v2↔v3 또는 전체 추이 기반):**

- 최신 버전이 직전 버전 대비
  전환 또는 폼 응답에서 개선
- 3명 이상 같은 문제 언급 +
  현재 비용/시간 지출 중
- 랜딩 전환율 5% 이상 또는 폼
  응답 3건 이상
- 경쟁자 분석에서 명확한 차별화
  가능
- 2주 이내 MVP 구현 가능

**Pivot 시그널:**

- 최신 버전이 직전 버전 대비
  핵심 지표에서 악화
- 문제는 맞지만 솔루션 형태가 다름
- 타겟이 예상과 다른 세그먼트
- 비즈니스 모델 재고 필요

**No-Go 시그널:**

- v0→v2 전체 추이에서 개선 없음
- 문제 공감 없음
- 전환율 1% 미만 + 긍정 피드백
  없음
- 기술적/시간적 제약으로 구현 불가

**표본 부족 경고** (방문 < 5):
달이: "데이터가 부족해.
판단을 유보하고
질적 피드백에 무게를 둬."

### 대화 규칙

- 감정이 아닌 데이터 기반 판단
  유도
- No-Go도 훌륭한 결정임을 강조
  (7일 만에 검증 완료)
- Pivot의 경우 구체적 방향
  함께 도출
- 달이 말투: "흘러간 물은 다시
  오지 않아. 근데 방향은 바꿀 수
  있어."

## SUMMARY

달이가 결정을 정리한다:

```
🎯 Go/No-Go 결정
━━━━━━━━━━━━━━━
판정: {Go / Pivot / No-Go}
근거: {핵심 데이터 포인트 3개}
다음 액션: {구체적 행동}
```

달이: "이게 네 결정이야. 맞아?"

## STOP

달이가 물을 바라보며 말한다.

"확인해봐.
이건 중요한 결정이니까."

AskUserQuestion:
질문: 달이가 묻는다.
"Go/Pivot/No-Go 결정을 확정할까?"

1. "확인"
2. "수정 요청"

⛔ STOP — "어부 달이가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.
"수정 요청"이면
CONVERSATION으로 돌아가
근거를 보완 후 SUMMARY →
STOP을 반복합니다.

### SPEC v3 기록 + 최종 판단

state.json에 decision 데이터 저장.

state.json `specVersions`에 v3를 추가한다:

```json
{
  "version": "v3",
  "day": 7,
  "hypothesis": "{최종 개선 또는 피벗 가설}",
  "changes": "{v2 대비 구체적 변경점}",
  "decision": "{keep/pivot/rollback}",
  "deltaSummary": {
    "overall_trend": "{v0→v3 전체 추이 요약}",
    "latest_delta": "{v2↔v3 증감}",
    "verdict": "{Go/Pivot/No-Go}"
  }
}
```

인증 상태면 MCP `save_spec_iteration` 호출:

- `version`: "v3"
- `dayNumber`: 7
- `hypothesis`: 최종 개선 또는 피벗 가설
- `changes`: v2 대비 구체적 변경점
- `decision`: keep (Go) / pivot (Pivot) / rollback (No-Go)
- `deltaSummary`: 전체 추이 + v2↔v3 증감 요약

달이: "v3 최종 판단이 기록됐어.
v0부터 여기까지 온 거야."

## MOVE

달이가 뚝 쪽을 가리킨다.

"좋아.
이제 마지막으로
7일을 마무리하자."
