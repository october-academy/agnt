---
stop_mode: conversation
title: "목표 선언 — 무엇을 만들지 최종 확정"
npc: 두리
quests:
  - id: d0-goal
    type: main
    title: "목표 선언문 작성"
    xp: 50
transition: "서약의 돌에 최종 방향과 목표가 새겨졌습니다. 이제 동료들이 기다리는 Discord로 향합시다."
---

# 목표 선언 — 무엇을 만들지 최종 확정

## ROOM

광장 안쪽, 서약의 돌 앞에 선다.
돌 표면에 이전 모험가들의 이름이
빼곡하다.

손끝을 대자 차가운 감촉이 스민다.
멀리서 깃발 스치는 소리가 들린다.

숨이 한번 길게 가라앉는다.

## NPC

두리가 서약의 돌 옆에 서서
이름들을 훑어본다.

🏘️ 촌장 두리

"여기 서약의 돌이야.
오늘은 여기서
후보를 하나로 정하고
목표를 새긴다.

탐색 노트 가져와.
말보다 행동이지."

## CONVERSATION

이 인터뷰의 목적은 학습자가
탐색한 후보를 비교해
**최종 프로젝트 1개**를
확정하고,
**30일 목표**를
측정 가능하게 선언하는 것입니다.

단, `builderContext.entryMode`가
`landing_live` / `product_live` /
`revenue_live`이면 목표는
"새 프로젝트 확정"이 아니라
"현재 병목 + 다음 실험/액션 확정"
으로 바뀝니다.

### 완성 체크리스트

`no_idea` / `idea_only`:
- [ ] 후보 아이템 2개 이상 비교
      (반복 빈도/고통/실행 난이도)
- [ ] 최종 프로젝트 1개 확정
      (프로젝트명 포함)
- [ ] 최종 프로젝트를 선택한 이유
      ("왜?" 3연쇄 결과)
- [ ] 30일 후 달성하고 싶은
      구체적 목표 1개
- [ ] 그 목표가 왜 중요한지
      (개인적 의미)
- [ ] 24시간 안에 실행할
      첫 검증 행동 1개

`landing_live` / `product_live` / `revenue_live`:
- [ ] 현재 병목 1개 확정
- [ ] 그 병목을 지금 풀어야 하는
      이유 3연쇄
- [ ] 30일 목표를 현재 자산 단계에
      맞게 재선언
- [ ] 다음 7일 액션 1개와
      24시간 안 첫 행동 1개
- [ ] 관찰할 핵심 지표 1개

### 대화 시작

이전 블록에서 수집한
character.exploration 데이터를
참조합니다.

두리:
"후보를 쭉 늘어놓고
하나씩 깎아보자.
왜 이걸 먼저 해야 하는지,
세 번은 물을 거야."

### 대화 규칙

- 최소 6턴 이상 진행
- 후보 비교 없이 바로 확정 금지
- "왜?"를 최소 3번 연쇄로
  파고듭니다
  — 표면적 답변이면
  실제 장면으로 되돌아가
  다시 묻습니다
- 목표는 측정 가능하게 구체화합니다
  "유저 100명 확보" >
  "성공적인 서비스"
- 24시간 안에 가능한
  첫 검증 행동을 반드시
  포함합니다
- 두리 말투: 짧고 단호, "말보다
  행동이지"

## SUMMARY

두리가 서약의 돌을 가리킨다.

"정리해서 새기자."

`no_idea` / `idea_only` 요약 형식:

```
🧭 최종 선택
- 최종 프로젝트: {확정 프로젝트명}
- 선택 이유: {왜 3연쇄 요약}
- 타겟 사용자: {구체적 타겟}
- 핵심 문제: {해결할 1개 문제}

🎯 목표 선언문
"나는 30일 안에 {구체적 목표}를 달성한다.
 왜냐하면 {개인적 동기}이기 때문이다."

⚡ 24시간 액션
- {첫 검증 행동 1개}
```

`landing_live` / `product_live` / `revenue_live` 요약 형식:

```
🧭 현재 자산 선언
- 현재 자산 단계: {landing_live | product_live | revenue_live}
- 핵심 병목: {1개}
- 지금 이걸 먼저 푸는 이유: {왜 3연쇄 요약}

🎯 30일 목표 선언문
"나는 30일 안에 {현재 단계에 맞는 목표}를 달성한다.
 왜냐하면 {개인적 동기}이기 때문이다."

📈 핵심 지표
- {관찰할 metric 1개}

⚡ 다음 액션
- 이번 주 액션: {실험/수정/launch 액션 1개}
- 24시간 액션: {첫 행동 1개}
```

두리: "이거 맞아?"

## STOP

두리가 서약의 돌에 손을 올리며
말한다.

"한 번 새기면
바꾸기 힘들어.
맞으면 `확인`,
고칠 게 있으면
`수정 요청`을 골라."

AskUserQuestion:
질문: 두리가 묻는다. "목표 선언문이
맞아?"

1. "확인"
2. "수정 요청"

⛔ STOP — "촌장 두리가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.
"수정 요청"이면
CONVERSATION으로 돌아가
보완 후 SUMMARY → STOP을
반복합니다.

1. 학습자 확인 결과를 반영합니다.

2. state.json에 goal
   데이터를 추가합니다:

```json
{
  "character": {
    ...기존 데이터,
    "project": "확정 프로젝트명",
    "motivation": "선택 이유 요약",
    "target": "구체적 타겟",
    "goal": "목표 선언문 전문"
  },
  "nextAction": "24시간 액션"
}
```

기존 자산 유저면 `project`는
기존 자산 이름/URL 맥락을 유지하고,
`nextAction`은 새 프로젝트 탐색이 아니라
현재 병목 기준 실행 액션으로 저장합니다.

3. 인증 상태면 MCP `save_profile`을 순서대로 호출합니다:
   - **goalCategory 결정**: 확정 대화 내용을 기반으로 다음 5개 중 가장 적합한 카테고리를 추론합니다:
     `startup` | `side_income` | `ai_learning` | `employment` | `job_change`
   - **projectName 추출**: 확정 프로젝트의 짧은 이름을 2-5 단어로 추출합니다
   - 1차 호출(프로젝트 확정 정보):
     ```
     save_profile({
       character: { project, motivation, target, strengths },
       goalCategory: "startup" | "side_income" | "ai_learning" | "employment" | "job_change",
       projectName: "짧은 프로젝트 이름",
       builderContext: {
         entryMode: "no_idea" | "idea_only" | "landing_live" | "product_live" | "revenue_live",
         assetStage: "none" | "draft_landing" | "live_landing" | "mvp_live" | "revenue_live",
         primaryBottleneck: "focus" | "validation" | "traffic" | "conversion" | "activation" | "retention" | "pricing" | "positioning" | "documentation" | "shipping_speed",
         mainChannel: null | "..."
       }
     })
     ```
   - 2차 호출(목표 선언문):
     ```
     save_profile({ goalStatement: "나는 30일 안에 ... 달성한다. 왜냐하면 ..." })
     ```
   - block2의 exploration 데이터는 내부 근거로만 사용하고 전송하지 않습니다.
   - 기존 자산 유저는 `builderContext.primaryBottleneck`와
     `nextAction`을 기준으로 save_profile payload를 구성합니다.

4. 인증 상태면 MCP `submit_practice`를 호출합니다:
   - `submit_practice({ questId: "d0-goal", day: 0, evidence: { type: "text", content: goalStatement } })`

## MOVE

두리가 서약의 돌을 한 번 두드리고
마을 골목 쪽을 가리킨다.

"새겼어.
동료들을 만나러 가자."

좁은 골목으로 들어선다.
돌벽 틈으로 따뜻한 불빛이 새어 나온다.
안쪽에서 웅성거리는 목소리와
잔 부딪히는 소리가 겹쳐 들린다.
문틈으로 맥주 냄새가 풍긴다.

두리가 술집 문에 손을 얹으며
말한다.
"여기야. 들어가."
