---
stop_mode: conversation
title: "신호 읽기 + 패턴 정리"
npc: 나래
quests:
  - id: d4-competitors
    type: main
    title: "반응 해석"
    xp: 50
transition: "패턴 정리가 끝났습니다. 이제 change set을 좁힙니다."
---

# 신호 읽기 + 패턴 정리

## ROOM

중턱 관측소 안으로 들어선다.
유리판 위로 메모와 화살표가 겹쳐 보인다.

## NPC

나래가 메모를 흩뿌린다.

🦅 척후 나래

"좋아.
이제 반응을
한 줄 감상으로 끝내지 말고
패턴으로 남겨."

## CONVERSATION

### 실시간 데이터 확인

먼저 MCP `get_links` source: "manual"을 호출하여
채널별 클릭 데이터를 가져옵니다.

플랫폼 랜딩 유저인 경우
MCP `get_landing_analytics`도 호출하여
채널별(utm_source) 전환율 비교 데이터를 가져옵니다.

나래가 데이터를 테이블에 놓는다:

```text
📊 채널별 반응 현황:
- {channel1}: {clicks}회 클릭 → 피드백 {n}건
- {channel2}: {clicks}회 클릭 → 피드백 {n}건
- {channel3}: {clicks}회 클릭 → 피드백 {n}건
```

나래: "이 숫자와 아래 정성 신호를
같이 봐야 패턴이 보여."

### 📚 Day 4 추천 읽기

`create_utm_link` MCP 도구로
`{REFS_DIR}/shared/week1-reading-list.md`의 Day 4 섹션을 Read합니다.

- 공통값: `channel="blog"`, `utmSource="agnt"`, `utmMedium="reading"`
- 항목별 `url`, `title`, `utmCampaign`, `utmContent`는 Day 4 섹션을 그대로 사용합니다.
- 3개 링크를 생성하고 short URL을 아래 형식으로 정리합니다.

```
📚 Day 4 추천 읽기
1. Threads 글쓰기 전략 → {shortUrl}
2. 세션 리플레이 실전 → {shortUrl}
3. A/B 테스팅 가이드 → {shortUrl}
```

### 완성 체크리스트

- [ ] 강한 신호 2개 이상
- [ ] 약한 신호 2개 이상
- [ ] 가격/ask 관련 신호 1개 이상
- [ ] 다음 change-set 힌트 1개 이상

### 정리 형식

```text
강한 신호:
- ...

약한 신호:
- ...

가격/ask 신호:
- ...

다음에 바꿀 것:
- ...
```

### 대화 규칙

- 누가/어디서/무슨 반응인지 빠지면 다시 묻기
- customer/channel/monetization 중 어떤 축인지 구분하기
- 칭찬과 검증을 섞지 않기

## SUMMARY

나래:
"좋아.
이제 바꾸지 않을 것과
바꿀 것을 분리할 수 있겠네."

## STOP

AskUserQuestion:
질문: 나래가 묻는다. "패턴 정리가 맞아?"

1. "확인"
2. "수정 요청"

⛔ STOP — "척후 나래가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.

state.json에
`interpretationSignals`, `weakSignals`,
`changeSetHints`를 저장합니다.

## MOVE

나래가 정상 바위를 가리킨다.

"좋아.
이제 유지(keep) / 제거(drop) / 수정(change) / 시험(test)을
한 줄씩 정하자."
