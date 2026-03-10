---
stop_mode: checkpoint
title: "SPEC v0 + 다음 액션 패키지"
npc: 소리
transition: "현재 단계에 맞는 액션 패키지가 정리되었습니다. 다음 단계에서 실제 실행으로 옮깁니다."
---

# SPEC v0 + 다음 액션 패키지

## ROOM

숲 외곽 전망대에 선다.
나무 사이로 들판과 마을이
한눈에 내려다보인다.

## NPC

소리가 난간에 기대선다.

🦉 현자 소리

"이제 기준선을
실행 가능한 묶음으로 바꿔야 해.

오늘 필요한 건
'거대한 계획'이 아니라
`SPEC v0`와
바로 움직일 action package다."

## GUIDE

### `SPEC v0`에 꼭 들어갈 것

```markdown
### v0 (Day 1)

- 핵심 가설 (Hypothesis): 지금 밀 핵심 가설
- 수정 사항 (Change Set): 오늘 고정한 현재 방향
- 증거 요약 (Evidence Summary): 현재 가진 출발점
- 판단 기준 (Metric Gate): 첫 proof를 볼 기준
- 수익화 체크포인트 (Monetization Checkpoint): 아직 없음
- 판단 (Decision): 아직 없음
- 다음 단계 (Next Step): 이번 주 첫 proof target
```

### first proof surface 예시

- 아이디어 없음 / 아이디어만 있음: 간단한 랜딩, 공유 페이지, 파일럿 제안 페이지
- 랜딩 운영 중: 기존 랜딩의 첫 화면(hero)과 행동 유도(CTA), 제안(offer) 정리 후 재공개
- 제품 운영 중: 현재 제품의 첫 사용 경험(onboarding)과 대기 목록, 가격 설정 정리
- 매출 발생 중: 현재 결제와 제안, 첫 사용 경험 병목을 드러내는 surface 정리

"핵심은 형식이 아니라
사람이 반응할 수 있는 표면이냐는 거야."

## PREVIEW

소리가 묻는다.

"지금 네 패키지를 읽었을 때
세 가지가 보여야 해.

1. 무엇을 믿고 있는가
2. 어디서 그걸 확인할 것인가
3. 무엇이 나오면 다음으로 갈 것인가"

## STOP

AskUserQuestion:
질문: 소리가 묻는다. "SPEC v0와
액션 패키지가 정리됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "현자 소리가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

### `SPEC v0` 기록

state.json `specVersions`에
v0를 추가합니다.

필수 항목:

- `hypothesis`
- `changes`
- `evidenceSummary`
- `metricGate`
- `nextStep`

인증 상태면 MCP `save_spec_iteration`
호출 시 Day 1 canonical 필드를
비우지 않습니다.

### action package 저장

state.json에 아래를 함께 남깁니다.

- `proofSurface`
- `nextProofTarget`
- `metricGate`

## MOVE

소리가 숲 출구를 가리킨다.

"좋아.
이제 진짜로 surface를 공개하자.

처음부터 시작이면 새로 만들고,
기존 자산이면 더 선명하게 정리해서
밖으로 내보내."
