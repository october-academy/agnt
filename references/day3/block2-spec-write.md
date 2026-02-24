---
stop_mode: checkpoint
title: "SPEC.md 작성 + 검증 — 설계 완성"
npc: 석이
quests:
  - id: d3-spec-write
    type: main
    title: "SPEC.md 작성 완료"
    xp: 100
  - id: d3-ai-review
    type: side
    title: "AI 스펙 검증"
    xp: 30
transition: "Day 3 완료! 스펙을 완성했습니다. 다음은 정찰의 언덕에서 경쟁자를 분석합니다."
---

# SPEC.md 작성 + 검증 — 설계 완성

## ROOM

마지막 계단을 올라
탑 꼭대기 전망대에 선다.

사방이 트여
먼 산과 들판이 한눈에 보인다.

바람이 세차게 분다.

## NPC

석이가 전망대 난간에서
돌아서며 말한다.

📐 탑지기 석이

"여기서 보면 전체가 보이지.
이제 스펙을 문서로 완성하자.

프로젝트 루트에 `SPEC.md` 파일을
만들 거야."

## GUIDE

### 버전 누적 원칙 (v1)

석이: "Day 1에서 v0를 기록했지?
이번엔 v1이야.
v0를 덮어쓰지 마.
새 버전으로 추가해."

**규칙**:
- `SPEC.md`에 기존 v0 내용을 유지하고 v1 섹션을 추가한다
- v1에는 Day 2 피드백 기반 변경점을 명시한다
- state.json `specVersions`의 v0는 수정하지 않고 v1을 append한다

state.json `feedback` 데이터가 있으면
석이가 피드백 핵심을 참조한다:
"Day 2에서 이런 피드백이 있었지.
이걸 반영해서 v1을 만들자."

### SPEC.md 템플릿

석이: "이 구조대로 채워."

```markdown
# {{character.project|프로젝트명}} — Product Spec

## Problem Statement

{인터뷰 기반 문제 한 문장}

## Target User

- **페르소나**: {이름}, {상황}
- **행동 패턴**: {구체적 행동}
- **핵심 니즈**: {해결하고 싶은 것}

## Core Value Proposition

{핵심 가치 한 문장}

## Key Features (MVP)

1. **{기능명}** — {설명} [P0]
2. **{기능명}** — {설명} [P0]
3. **{기능명}** — {설명} [P1]

## Success Metrics

- {지표 1}: {목표 숫자} (by {기한})
- {지표 2}: {목표 숫자} (by {기한})

## Constraints

- 시간: {제약}
- 기술: {제약}
- 자원: {제약}

## Version Log

### v0 (Day 1)
- **Hypothesis**: {v0 가설 — state.specVersions에서 참조}
- **Change Set**: 초기 설정
- **Metric Gate**: {v0 관찰 지표}
- **Decision**: {v0 판단 결과 또는 대기}

### v1 (Day 3)
- **Hypothesis**: {Day 2 피드백 기반 수정 가설}
- **Change Set**: {v0 대비 구체적 변경점}
- **Metric Gate**: {v1에서 관찰할 지표}
- **Decision**: 대기
```

## PREVIEW

석이가 생성된 SPEC.md를
검증한다:

"하나씩 확인하자."

- Problem Statement가
  인터뷰 데이터에 기반하는가?
- Feature 수가 3-5개
  범위인가?
- Metrics가 측정 가능한가?
- MVP 범위가 2주 이내 구현
  가능한가?

검증 결과를 보여줍니다.

## STOP

석이가 도면을 말아 올리며 말한다.

"확인해봐.
고칠 거 있으면 말해."

AskUserQuestion:
질문: 석이가 묻는다.
"SPEC.md 최종본이 준비됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "탑지기 석이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.
"수정 요청"이면 GUIDE로 돌아가
수정 후 PREVIEW → STOP을
반복합니다.

### SPEC v1 기록

state.json `specVersions`에 v1을 추가한다:

```json
{
  "version": "v1",
  "day": 3,
  "hypothesis": "{Day 2 피드백 기반 수정 가설}",
  "changes": "{v0 대비 구체적 변경점}",
  "decision": null
}
```

인증 상태면 MCP `save_spec_iteration` 호출:
- `version`: "v1"
- `dayNumber`: 3
- `hypothesis`: Day 2 피드백 기반 수정 가설
- `changes`: v0 대비 구체적 변경점
- `metricGate`: v1에서 관찰할 지표

석이: "v1이 기록됐어.
v0이랑 뭐가 달라졌는지
나중에 비교할 수 있어."

### 제출

1. 인증 상태면 MCP `submit_practice`로 제출

## MOVE

석이가 계단 아래를 가리킨다.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Day 3 완료!
📍 설계의 탑
━━━━━━━━━━━━━━━━━━━━━━━━━━
  📄 SPEC.md 작성 완료!
  🏗️ 구체적인 설계도가 있다

  📍 다음: 정찰의 언덕
  🎯 경쟁자를 분석한다
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

석이가 마지막으로 말한다.

"내일 해야 할 것.

1. 정찰의 언덕으로 가
2. 나래를 찾아 — 척후야
3. SPEC.md를 가져가."

