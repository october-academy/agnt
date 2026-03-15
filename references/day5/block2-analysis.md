---
stop_mode: checkpoint
title: "델타 분석 + SPEC v2"
npc: 한이
quests:
  - id: d5-analysis
    type: main
    title: "SPEC v2 업데이트"
    xp: 100
  - id: d5-analytics
    type: side
    title: "v0→v1 데이터 차이 확인"
    xp: 30
transition: "Day 5 완료! 이제 monetization ask와 검증 checkpoint를 만듭니다."
---

# 델타 분석 + SPEC v2

## ROOM

분석소 책상 위에
차트와 메모가 펼쳐져 있다.

## NPC

한이가 선을 긋는다.

🔨 장인 한이

"좋아.
이제 기분 말고
변화량을 읽자."

## GUIDE

### 실시간 데이터 비교

MCP `get_links` source: "manual"을 호출하여
현재 채널별 클릭 데이터를 가져옵니다.

플랫폼 랜딩 유저인 경우
MCP `get_landing_analytics`도 호출하여
전체 퍼널 데이터를 가져옵니다.

한이가 두 줄을 나란히 적는다:

```text
📊 v0→v1 변화량:
- 총 클릭: {Day 2 기준선} → {현재} ({차이})
- 채널별:
  - {channel1}: {before} → {now}
  - {channel2}: {before} → {now}
  - {channel3}: {before} → {now}
- 폼 제출: {before} → {now}
- 전환율: {before}% → {now}%
```

state.json의 `analyticsBaseline`과
현재 값을 비교하여 델타를 계산합니다.

### 📚 Day 5 추천 읽기

`create_utm_link` MCP 도구로
`{REFS_DIR}/shared/week1-reading-list.md`의 Day 5 섹션을 Read합니다.

- 공통값: `channel="blog"`, `utmSource="agnt"`, `utmMedium="reading"`
- 항목별 `url`, `title`, `utmCampaign`, `utmContent`는 Day 5 섹션을 그대로 사용합니다.
- 3개 링크를 생성하고 short URL을 아래 형식으로 정리합니다.

```
📚 Day 5 추천 읽기
1. Jon Yongfook 50/50 공식 → {shortUrl}
2. Tony Dinh TypingMind → {shortUrl}
3. Marc Lou 24시간 출시 → {shortUrl}
```

한이: "이 사람들은 전부 빠르게 만들고
데이터로 판단했어. 정독보다 감을 잡아."

### 데이터가 적을 때 (클릭 10회 미만 또는 폼 응답 3건 미만)

한이가 말한다.

"숫자가 작으면 통계보다
패턴을 봐.

- 총 클릭 3회 → 어느 채널에서 왔는지가 핵심
- 폼 응답 1건 → 그 1건의 질이 전부
- 전환율 계산 불가 → '반응이 있었는가 없었는가'로 판단

SPEC v2의 evidenceSummary에
'소규모 데이터, 질적 판단 기반'이라고 명시해."

### 비교할 것

1. response 증가/감소
2. CTA 이후 행동 변화
3. 고객 검증의 질 변화
4. Day 6 ask로 이어질 근거

### `SPEC v2` 최소 구조

```json
{
  "version": "v2",
  "day": 5,
  "hypothesis": "{변화량을 반영한 현재 가설 (핵심 가설)}",
  "changes": "{v1 대비 수정 사항}",
  "evidenceSummary": "{response와 검증 핵심 요약 (증거 요약)}",
  "metricGate": "{다음에 통과해야 할 목표 수치 (판단 기준)}",
  "monetizationCheckpoint": {
    "proofType": null,
    "status": null,
    "amount": null,
    "currency": null,
    "reference": null,
    "summary": "{현재 수익화 점검 상태}"
  },
  "decision": null,
  "deltaSummary": {
    "response_delta": "{반응 변화량}",
    "cta_delta": "{CTA 변화량}",
    "strongest_proof": "{핵심 변화}"
  },
  "nextStep": "{Day 6에서 확인할 수익 검증 (다음 단계)}"
}
```

## PREVIEW

한이가 묻는다.

"이 문서를 읽었을 때
왜 Day 6에 그 ask를 해야 하는지
바로 보여야 해."

## STOP

AskUserQuestion:
질문: 한이가 묻는다. "SPEC v2가
정리됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "장인 한이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

1. state.json `specVersions`에
   v2를 추가합니다.
2. 인증 상태면
   `save_spec_iteration(version: "v2")`
   호출 시 canonical field를 빠뜨리지 않습니다.
3. `d5-analysis`, `d5-analytics`
   제출을 처리합니다.

## MOVE

한이가 길드 방향을 가리킨다.

"좋아.
이제 누가 실제로 돈을 낼지
직접 물을 차례다."
