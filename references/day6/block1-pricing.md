---
stop_mode: conversation
title: "Monetization proof 캡처"
npc: 은이
quests:
  - id: d6-pricing
    type: main
    title: "Monetization proof 캡처"
    xp: 100
transition: "monetization checkpoint가 잡혔습니다. 이제 SPEC와 제안 기록에 반영합시다."
---

# Monetization proof 캡처

## ROOM

작은 회의실에 들어선다.
탁자 위에 메모지와
송금 알림 화면이 놓여 있다.

## NPC

은이가 펜을 들어 올린다.

💰 길드장 은이

"좋아.
이제 말이 아니라
남길 수 있는 proof를 적자."

## CONVERSATION

### 완성 체크리스트

- [ ] 증거 유형 (proofType) 1개 확정
- [ ] status 1개 확정
- [ ] amount / currency / reference 정리
- [ ] 왜 현재 product direction과 연결되는지 설명

### 대화 규칙

- 막연한 관심은 proof로 올려 읽지 않음
- `amount`나 `reference` 없이 claim만 적지 않음
- 은이 말투: "그래서 얼마야? 어디서 확인할 수 있어?"

## SUMMARY

은이가 장부에 적는 형식:

```text
proofType: ...
status: ...
amount: ...
currency: ...
reference: ...
summary: ...
context: ...
```

## STOP

AskUserQuestion:
질문: 은이가 묻는다.
"이 monetization proof를 기록할까?"

1. "확인"
2. "수정 요청"

⛔ STOP — "길드장 은이가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.

1. state.json에
   `monetizationCheckpoint`를 저장합니다.
2. 인증 상태면
   `proofArtifacts`를 명시적으로 담아
   `submit_practice`를 호출합니다.
3. 인증 상태고 state.json에
   최신 `specVersions`의 `v2`가 있으면
   같은 checkpoint를 반영한 뒤
   `save_spec_iteration(version: "v2")`로
   현재 canonical field를 다시 동기화합니다.
4. `proofType`는
   `payment_commitment`,
   `bank_transfer_received`,
   `ad_revenue_received`
   중 하나만 사용합니다.

## MOVE

은이가 기록실 쪽을 가리킨다.

"좋아.
이제 이걸 verdict에 쓸 수 있게
문서에 반영하자."
