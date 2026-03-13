---
stop_mode: checkpoint
title: "Week 1 검증 리뷰"
npc: 달이
quests:
  - id: d7-data-collect
    type: main
    title: "Week 1 검증 리뷰"
    xp: 50
transition: "검증 리뷰가 완료되었습니다. 이제 회고와 최종 판단을 정리합니다."
---

# Week 1 검증 리뷰

## ROOM

호수 둑에 도착한다.
물결 위로 이번 주 메모가
겹쳐 보인다.

## NPC

달이가 손으로 네 줄을 그린다.

🎣 어부 달이

"오늘은 흩어진 걸
한 번에 모아서 보자.

고객 검증,
채널 검증,
수익 검증,
최종 판단.

이 네 줄기가 같이 보여야
최종 판단을 낼 수 있어."

## GUIDE

### Week 1 종합 데이터 수집 (자동)

MCP 도구 3개를 호출하여 전체 수치를 모읍니다:

1. `get_links` source: "manual" — 전체 추적 링크 클릭 현황
2. `get_landing_analytics` — 퍼널 분석 (플랫폼 랜딩 유저)
3. `get_bio` — 바이오 페이지 상태 + 블록 수

달이가 네 줄기를 모아 적는다:

```text
━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Week 1 종합 리포트
━━━━━━━━━━━━━━━━━━━━━━━━━━
채널 검증:
- 총 링크: {totalLinks}개 / 총 클릭: {totalClicks}회
- 채널별: {channel1} {clicks}, {channel2} {clicks}, ...
- 가장 효과적 채널: {best}

랜딩 검증 (플랫폼 유저):
- 방문자: {uniqueVisitors} / 전환율: {formConversion}%
- 폼 제출: {formSubmissions}건
- 퍼널: viewed → cta → form → signup

바이오:
- 페이지: {bioUrl}
- 블록 수: {blockCount}개

대시보드: https://agentic30.app/dashboard/links
바이오 설정: https://agentic30.app/settings/bio
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 📚 Day 7 추천 읽기

`create_utm_link` MCP 도구로
`{REFS_DIR}/shared/week1-reading-list.md`의 Day 7 섹션을 Read합니다.

- 공통값: `channel="blog"`, `utmSource="agnt"`, `utmMedium="reading"`
- 항목별 `url`, `title`, `utmCampaign`, `utmContent`는 Day 7 섹션을 그대로 사용합니다.
- 3개 링크를 생성하고 short URL을 아래 형식으로 정리합니다.

```
📚 Day 7 추천 읽기
1. Go/Pivot/No-Go 프레임 → {shortUrl}
2. Pieter Levels 빌드 철학 → {shortUrl}
3. Agentic Engineer 역량 → {shortUrl}
```

달이: "최종 판단 전에 읽어.
Go/Pivot/No-Go가 특히 중요해."

### 증거 정리

다음을 모읍니다.

1. 고객 검증
2. 채널 검증
3. 수익 검증
4. 최종 판단

각 항목마다
"무엇이 가장 강했는가"를
한 줄씩 남깁니다.

## STOP

AskUserQuestion:
질문: 달이가 묻는다. "Week 1 검증 리뷰가
됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "어부 달이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

다음 블록으로 이동합니다.

## MOVE

달이가 물가 안쪽을 가리킨다.

"좋아.
이제 회고를 짧게 하고
판단으로 넘어가자."
