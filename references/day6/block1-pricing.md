---
stop_mode: conversation
title: "수익 검증 캡처"
npc: 은이
quests:
  - id: d6-pricing
    type: main
    title: "수익 검증 캡처"
    xp: 100
transition: "수익 검증 checkpoint가 잡혔습니다. 이제 SPEC와 제안 기록에 반영합시다."
---

# 수익 검증 캡처

## ROOM

작은 회의실에 들어선다.
탁자 위에 메모지와
송금 알림 화면이 놓여 있다.

## NPC

은이가 펜을 들어 올린다.

💰 길드장 은이

"좋아.
이제 말이 아니라
남길 수 있는 검증을 적자."

## CONVERSATION

### 완성 체크리스트

- [ ] 증거 유형 (proofType) 1개 확정
- [ ] status 1개 확정
- [ ] amount / currency / reference 정리
- [ ] 왜 현재 제품 방향과 연결되는지 설명

### 대화 규칙

- 막연한 관심은 검증으로 올려 읽지 않음
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
"이 수익 검증을 기록할까?"

1. "확인"
2. "아직 검증 결과가 없어"
3. "수정 요청"

⛔ STOP — "길드장 은이가 기다립니다."

"아직 검증 결과가 없어"이면:

은이가 펜을 내려놓는다.

"검증 결과가 아직 없다면
두 가지를 남겨.

1. ask를 보낸 기록 (누구에게, 어떤 문장으로)
2. 아직 결과가 없는 이유 해석

'보냈는데 무응답'은 약한 no-go 신호,
'아직 보내지 못했다'는 채널 접근 병목이야.
둘 다 내일 최종 판단의 재료가 돼."

state.json의 `monetizationCheckpoint`를
`status: "pending"` 또는 `status: "no_response"`로 저장하고
ON_COMPLETE로 진행한다.

## ON_COMPLETE

AskUserQuestion에서
"확인" 또는 "아직 검증 결과가 없어"를
선택했을 때 ON_COMPLETE를 수행합니다.

1. state.json에
   `monetizationCheckpoint`를 저장합니다.
   검증 결과가 없는 경우
   `status: "pending"` 또는 `status: "no_response"`로 저장하고
   `proofType`은 `null`로 허용합니다.
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
이제 이걸 최종 판단에 쓸 수 있게
문서에 반영하자."
