---
stop_mode: checkpoint
title: "차별화 전략 수립"
npc: 나래
quests:
  - id: d4-differentiation
    type: main
    title: "차별화 전략 수립"
    xp: 100
  - id: d4-positioning
    type: side
    title: "포지셔닝 맵"
    xp: 30
transition: "Day 4 완료! 차별화 전략을 세웠습니다. 다음은 시장의 거리에서 실제 고객을 만납니다."
---

# 차별화 전략 수립

## ROOM

언덕 정상에 다시 올라선다.

사방이 탁 트이고,
저 멀리 여러 마을이 보인다.

## NPC

나래가 정상에서
전체 풍경을 내려다보며 말한다.

🦅 척후 나래

"여기서 보면
전체 전장이 보이지.

경쟁자 분석을 바탕으로
{{character.project|네 프로젝트}}의
차별화 전략을 세우자."

## GUIDE

### 차별화 전략 프레임워크

나래: "세 가지를 도출해."

1. **Competitive
   Advantage**: 경쟁자가
   못하는 것 중 네가 할 수 있는
   것
2. **Market Gap**:
   경쟁자가 서비스하지 않는
   세그먼트
3. **Positioning**:
   "X를 위한 Y" 한 문장
   포지셔닝

### SPEC.md 업데이트

SPEC.md에 Competition
섹션을 추가합니다:

```markdown
## Competition

| 서비스 | 타입 | 강점 | 약점 |
| ------ | ---- | ---- | ---- |
| {이름} | 직접 | ...  | ...  |

### Differentiation

{포지셔닝 한 문장}
{핵심 차별화 근거}
```

## PREVIEW

업데이트된 SPEC.md를
프리뷰합니다.

## STOP

나래가 망원경을 내려놓으며 말한다.

"확인해봐.
고칠 거 있으면 말해."

AskUserQuestion:
질문: 나래가 묻는다. "차별화 전략이
정리됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "척후 나래가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.
"수정 요청"이면 GUIDE로 돌아가
수정 후 PREVIEW → STOP을
반복합니다.

1. 인증 상태면 MCP `submit_practice`로 제출

## MOVE

나래가 언덕 아래 시장 방향을
가리킨다.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Day 4 완료!
📍 정찰의 언덕
━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔍 경쟁자를 분석하고
  ⚔️ 차별화 전략을 세웠다

  📍 다음: 시장의 거리
  🎯 실제 고객을 만난다
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

나래가 마지막으로 말한다.

"시장의 거리에
한이라는 장인이 있어.
아이디어만으로는 안 산다는 거.
저기 좀 봐."

