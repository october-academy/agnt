---
stop_mode: checkpoint
title: "성과 분석 + 대시보드 가이드"
npc: 바리
quests:
  - id: d2-analytics
    type: main
    title: "성과 분석 + 대시보드 확인"
    xp: 40
transition: "Day 2 완료! 고객 검증과 채널 검증이 모였습니다. 다음은 설계의 탑에서 SPEC v1을 적습니다."
---

# 성과 분석 + 대시보드 가이드

## ROOM

천막 뒤편 작은 탁자에
수첩과 계산기가 놓여 있다.

## NPC

🎒 행상 바리

"피드백은 사람이 남기고,
클릭 수는 시스템이 남긴다.
둘 다 봐야 어느 채널이 먹혔는지 안다."

## GUIDE

### 채널별 클릭 성과 확인

MCP `get_links` source: "manual"을 호출하여
채널별 클릭 수를 가져온다.

```text
📊 채널별 클릭 성과:
- {channel1}: {clickCount}회
- {channel2}: {clickCount}회
합계: {totalClicks}회 / 가장 반응 좋은 채널: {best}
```

상세 분석은 https://agentic30.app/dashboard/links 에서 확인.
링크 생성, 수정, 채널별 비교, 시간대별 추이 모두 가능.

### 클릭 + 피드백 교차 분석

- 클릭 많고 피드백 없다 → 메시지는 끌지만 CTA가 약하다
- 클릭 적고 피드백 질 높다 → 채널이 정확하다, 도달만 넓히면 된다
- 둘 다 낮다 → 메시지와 채널 모두 재검토

이 교차 분석이 내일 SPEC v1의 수정 근거가 된다.

### 플랫폼 랜딩 유저 보너스

agentic30에서 랜딩을 직접 배포한 경우,
MCP `get_landing_analytics`로
방문자 수, CTA 클릭률, 폼 제출, 채널별 전환율을 확인할 수 있다.

## PREVIEW

```text
채널 클릭 성과:
- 채널 1: XX 클릭
- 채널 2: XX 클릭

정성 피드백 요약 (block2에서 수집):
- 가장 강한 신호: ...
- 가장 약한 신호: ...

클릭 + 피드백 교차 분석:
- ...

내일 SPEC v1에 반영할 근거:
- ...
```

## STOP

AskUserQuestion:
질문: 바리가 묻는다. "추적 링크 클릭 수를 확인하고
대시보드 접속까지 해봤어?"

1. "완료"
2. "아직 데이터가 없어"
3. "수정 요청"

⛔ STOP — "행상 바리가 기다립니다."

"아직 데이터가 없어"를 선택하면
기준선(0)을 기록하고 넘어간다.

## ON_CONFIRM

AskUserQuestion에서
"완료" 또는 "아직 데이터가 없어"를
선택했을 때 ON_CONFIRM을 수행합니다.

1. MCP `get_links` source: "manual"을 호출하여
   채널별 클릭 데이터를 수집합니다.
   데이터가 없으면 기준선(0)으로 기록합니다.
2. 플랫폼 랜딩 유저인 경우,
   MCP `get_landing_analytics`를 호출하여
   퍼널 분석 데이터를 조회합니다:
   - 방문자 수, CTA 클릭률, 폼 제출 수
   - 채널별(utm_source) 전환율 비교
   - 결과를 유저에게 요약해서 보여줍니다.
3. `d2-analytics` 퀘스트를 제출합니다.
4. state.json에
   `analyticsBaseline`, `channelPerformance`,
   `dashboardChecked`를 저장합니다.
5. Day 2 추천 읽기 클릭 검증:
   `get_links` source: "manual"에서
   utmMedium: "reading", utmCampaign: "day2"인 링크 중
   click_count > 0인 것이 1개 이상이면
   `d2-reading` side quest를 제출합니다.

## MOVE

바리가 탑 쪽을 가리킨다.

"좋아.
이제 설계의 탑으로 가.

오늘 모은 피드백과 클릭 데이터를 가지고
SPEC v1을 적는 거야.

대시보드는 매일 한 번씩 들여다봐.
숫자가 쌓이면 방향이 보이기 시작한다."

바리가 잠깐 멈춘다.

"참고로, 벌써 Day 2야.

{state.character.runway 존재 시}
네 런웨이 {{character.runway}}개월 중
이미 2일이 지났어.

{미존재 시}
네가 투자하는 건 저축이 아니라 시간이야.
이번 주 투자한 시간으로
뭘 확인했는지가 핵심이야."
