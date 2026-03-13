---
stop_mode: conversation
title: "공유 채널 선정 + 추적 링크 생성"
npc: 바리
quests:
  - id: d2-channels
    type: main
    title: "공유 채널 3곳 선정"
    xp: 50
  - id: d2-message
    type: main
    title: "공유 메시지 작성"
    xp: 50
  - id: d2-tracking-links
    type: main
    title: "채널별 추적 링크 생성"
    xp: 40
transition: "추적 링크가 준비되었습니다. 메시지를 보낸 후 피드백을 수집해봅시다."
---

# 공유 채널 선정 + 추적 링크 생성

## ROOM

광장 안쪽 커다란 게시판 앞에 선다.
전단지와 메모가 빼곡히 붙어 있다.

## NPC

바리가 게시판을 훑는다.

🎒 행상 바리

"메시지를 아무렇게나 퍼뜨리면
신호가 흐려진다.

오늘은
'내가 검증을 받을 수 있는 곳'만
고른다.

그리고 채널마다
**다른 추적 링크**를 만들어야
어디서 반응이 왔는지 알 수 있어."

## CONVERSATION

### 완성 체크리스트

- [ ] 고객이 실제로 모이는 채널 3곳
- [ ] 채널별 메시지 1개씩
- [ ] 검증 CTA가 들어간 문장
- [ ] 적어도 1곳은 낯선 사람 채널
- [ ] 채널별 추적 링크 생성

### 증거로 쓸 수 있는 메시지 기준

좋은 메시지는 아래를 담는다.

1. 문제 장면
2. 현재 hypothesis
3. 받고 싶은 반응

예:

"반복 리포트 정리에 1시간 이상 쓰는 분 있나요?
이 문제를 줄이는 방향을 검증 중인데,
이 페이지를 보고 뭐가 가장 안 와닿는지 말해주실 수 있을까요?"

나쁜 예:

"새 서비스 만들었어요.
관심 있으시면 한번 봐주세요."

### 대화 규칙

- 채널은 도달 범위보다 관련성 우선
- 메시지는 칭찬 요청 금지
- Day 3에서 바로 `SPEC v1`에 넣을 수 있는 질문으로 끝나야 함

## SUMMARY

바리가 정리한 형식:

```text
채널
1. ...
2. ...
3. ...

메시지
- channel 1: ...
- channel 2: ...
- channel 3: ...

검증 CTA
- 이번에 꼭 받고 싶은 반응: ...
```

### 채널별 추적 링크

바리가 게시판 옆 도구함을 가리킨다.

"메시지에 링크를 넣을 거잖아.
그냥 URL을 쓰면
어느 채널에서 반응이 왔는지 모른다.

채널마다 다른 추적 링크를 만들어야
나중에 '이 채널이 먹혔다'고
데이터로 말할 수 있어."

MCP `create_utm_link`로
**채널별 3개 추적 링크**를 만든다.

UTM 파라미터는 대화 맥락에서 결정한다:

- `targetUrl`: 검증 채널 URL (Day 1에서 배포한 랜딩 또는 기존 surface)
- `utm_source`: 각 채널명 (예: `twitter`, `kakaotalk-open-chat`, `reddit`)
- `utm_medium`: 채널 유형 (예: `social`, `community`, `messenger`, `forum`)
- `utm_campaign`: `d2-channel-test`
- `utm_content`: 메시지 핵심 키워드 또는 변형 식별자 (예: `problem-scene`, `direct-ask`) — 선택
- `utm_term`: 타겟 키워드가 있으면 추가 (예: `report-automation`) — 선택
- `channel`: 각 채널명

랜딩 ID가 있으면 `landingId`도 연결한다.

예시 (3개 채널):

```text
채널 1 (트위터): https://a30.link/abc123
  → utm_source=twitter, utm_medium=social

채널 2 (카카오 오픈챗): https://a30.link/def456
  → utm_source=kakaotalk, utm_medium=messenger

채널 3 (디스코드 서버): https://a30.link/ghi789
  → utm_source=discord-community, utm_medium=community
```

> 생성된 링크는 https://agentic30.app/dashboard/links 에서
> 수정, 삭제, 성과 모니터링이 가능하다.
> 메시지의 raw URL을 이 추적 링크로 교체해서 보내라.

### 📚 채널 선정에 도움 되는 읽기

바리가 주머니에서 메모를 꺼낸다.

"채널 고르기 전에
이 중에 하나라도 훑으면
시행착오를 줄일 수 있어."

`create_utm_link` MCP 도구로
`{REFS_DIR}/shared/week1-reading-list.md`의 Day 2 섹션을 Read합니다.

- 공통값: `channel="blog"`, `utmSource="agnt"`, `utmMedium="reading"`
- 항목별 `url`, `title`, `utmCampaign`, `utmContent`는 Day 2 섹션을 그대로 사용합니다.
- 4개 링크를 생성하고 short URL을 아래 형식으로 정리합니다.

```
📚 Day 2 추천 읽기
1. The Mom Test 실전 예시 → {shortUrl}
2. 한국 런칭 채널 가이드 → {shortUrl}
3. UTM 링크 설계 → {shortUrl}
4. Cold Call DM 가이드 → {shortUrl}
```

## STOP

AskUserQuestion:
질문: 바리가 묻는다. "채널, 메시지,
추적 링크가 다 준비됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "행상 바리가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.

1. `d2-channels`, `d2-message`
   제출을 준비합니다.
2. state.json에
   `channels`, `shareMessages`,
   `proofCTA`를 저장합니다.
3. `d2-tracking-links`:
   MCP `create_utm_link`를 채널 수만큼 호출합니다.
   - 각 채널에 맞는 `utm_source`, `utm_medium` 설정
   - `utm_campaign`: `d2-channel-test`
   - `utm_content`: 채널별 메시지 특성 키워드 — 선택
   - `utm_term`: 타겟 키워드 — 선택
   - `landingId`: Day 1 랜딩 ID (있으면)
   - 생성된 3개 short URL을 유저에게 보여준다
   - state.json에 `trackingLinks` 배열로 저장한다

## MOVE

바리가 광장 중앙 천막을 가리킨다.

"좋아.
이제 실제 반응을 모아.

숫자든 댓글이든 DM이든
내일 쓸 수 있게
구조적으로 남겨야 해.

추적 링크 성과는
반응을 다 모은 뒤에
데이터로 확인할 거야."
