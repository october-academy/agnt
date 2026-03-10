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
transition: "Day 5 완료! 이제 monetization ask와 proof checkpoint를 만듭니다."
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
delta를 읽자."

## GUIDE

### 비교할 것

1. response 증가/감소
2. CTA 이후 행동 변화
3. customer proof의 질 변화
4. Day 6 ask로 이어질 근거

### `SPEC v2` 최소 구조

```json
{
  "version": "v2",
  "day": 5,
  "hypothesis": "{delta를 반영한 현재 가설 (핵심 가설)}",
  "changes": "{v1 대비 변경 사항 (change set)}",
  "evidenceSummary": "{response와 proof 핵심 요약 (증거 요약)}",
  "metricGate": "{다음에 통과해야 할 기준 (판단 기준)}",
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
    "response_delta": "{반응 증감}",
    "cta_delta": "{CTA 증감}",
    "strongest_proof": "{핵심 변화}"
  },
  "nextStep": "{Day 6에서 확인할 수익화 proof (다음 단계)}"
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
