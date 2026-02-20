---
stop_mode: checkpoint
title: "데이터 수집 — 7일의 기록"
npc: 달이
quests:
  - id: d7-data-collect
    type: main
    title: "회고 데이터 수집"
    xp: 30
sounds:
  entry: day7-intro.mp3
transition: "데이터 수집이 완료되었습니다. 이제 KPTL 회고를 시작합시다."
---

# 데이터 수집 — 7일의 기록

## ROOM

숲과 들판을 지나 호수 둑에
도착한다.
맑은 수면에 하늘빛이 길게 비친다.
잔잔한 물결 소리만 낮게 번진다.
작은 배 한 척이 말뚝에 매여
흔들린다.
찬 물내음이 천천히 코끝에 스민다.

## NPC

뚝 위에 앉아
낚싯대를 드리우고 있는
인물이 돌아본다.

🎣 어부 달이

"왔구나.
물에 비친 걸 봐.

7일이 지났어.
흘러간 물은 다시 오지 않지만,
뭘 건져올렸는지는 볼 수 있어."

## GUIDE

### 데이터 수집

달이: "하나씩 확인하자."

state.json과 프로젝트
파일에서 다음 데이터를 수집합니다:

1. **학습 진행**: 완료한
   Day 수, 퀘스트 수, 총
   XP
2. **인터뷰 데이터**: Day
   0 캐릭터, Day 1 인터뷰
   요약
3. **검증 결과**: Day 2
   피드백, Day 5 수요 검증
   결과
4. **산출물**: SPEC.md,
   landing.html, 경쟁
   분석, 비즈니스 모델
5. **랜딩 성과** (인증 시): MCP `get_landing_analytics`

### 표시 형식

```
📊 7일 여정 요약
━━━━━━━━━━━━━━━
Day 0: 캐릭터 생성 ✅ | 목표: {{character.goal|미설정}}
Day 1: 인터뷰 + 랜딩 배포 ✅ | 핵심 문제: {problem}
Day 2: 수요 검증 ✅ | 전환율: {rate}%
Day 3: 스펙 작성 ✅ | Features: {count}개
Day 4: 경쟁 분석 ✅ | 차별화: {strategy}
Day 5: 수요 검증 ✅ | 판정: {verdict}
Day 6: 비즈니스 모델 ✅ | 모델: {model}

총 XP: {total} | Lv.{{state.level}} {{state.title}}
```

## PREVIEW

달이가 수집된 데이터를 보여준다.

달이: "이게 네가 7일 동안
건져올린 것들이야."

## STOP

달이가 낚싯대를 드리우며 말한다.

"천천히 봐.
물에 비친 걸 봐."

AskUserQuestion:
질문: 달이가 묻는다.
"수집된 7일 데이터를 확인했어?"
1. "확인"
2. "수정 요청"

⛔ STOP — "어부 달이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.
"수정 요청"이면 GUIDE로 돌아가
누락 데이터를 보완 후 PREVIEW
→ STOP을 반복합니다.

다음 블록(KPTL 회고)으로
이동합니다.

## MOVE

달이가 호수 안쪽을 가리킨다.

"좋아.
이제 좀 더 깊이
돌아봐야 해."
