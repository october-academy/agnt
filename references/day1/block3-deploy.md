---
stop_mode: checkpoint
title: "첫 검증 채널 공개"
npc: 소리
quests:
  - id: d1-landing
    type: main
    title: "첫 검증 채널 배포/정리"
    xp: 150
  - id: d1-first-link
    type: side
    title: "첫 추적 링크 생성"
    xp: 30
  - id: d1-bio-landing
    type: side
    title: "바이오에 랜딩 카드 연결"
    xp: 30
  - id: d1-discord-project
    type: side
    title: "프로젝트 소개"
    xp: 30
  - id: d1-reading
    type: side
    title: "Day 1 추천 읽기"
    xp: 20
  - id: d1-branding
    type: hidden
    title: "프로젝트 브랜딩"
    xp: 20
    trigger: "package.json exists in project root"
transition: "Day 1 완료! 첫 검증 채널이 정리되었습니다. 다음은 검증의 광장에서 진짜 반응을 모읍니다."
---

# 첫 검증 채널 공개

## ROOM

숲을 나서자
들판 바람이 한 번에 밀려온다.
먼 곳 마을 불빛이 점점이 보인다.

## NPC

소리가 숲 출구에서 멈춘다.

🦉 현자 소리

"오늘 마지막은
`검증 채널`를 live 상태로
만드는 거야.

처음 시작하는 사람은
첫 surface를 띄우고,
이미 surface가 있는 사람은
지금 가설에 맞게
정리하고 다시 공개한다.

그리고 공유할 때는
**추적 링크**를 만들어야
누가 반응했는지 알 수 있어.

Discord에
프로젝트 소개도 남겨."

## GUIDE

### `d1-landing`이 뜻하는 것

이 퀘스트는
새 랜딩을 꼭 만든다는 뜻이 아니다.

아래 중 하나면 된다.

- 랜딩/공유 페이지를 live로 배포
- 기존 랜딩의 message/CTA를 Day 1 기준선에 맞게 정리
- 제품/pricing/onboarding surface를 현재 검증 목표에 맞게 공개

### 공개 전에 확인할 것

1. 현재 가설이 드러나는가
2. 검증 CTA가 한 문장으로 보이는가
3. 링크를 바로 공유할 수 있는가

### `d1-first-link` — 첫 추적 링크

검증 채널을 공개한 뒤,
raw URL이 아니라 **추적 링크**로 공유한다.

추적 링크를 만들면:

- 누가 얼마나 클릭했는지 알 수 있다
- 내일 채널별 성과를 비교할 기반이 된다
- 대시보드에서 실시간으로 확인할 수 있다

MCP `create_utm_link` 도구로 링크를 생성한다.
UTM 파라미터는 대화 맥락에서 결정한다:

- `targetUrl`: 방금 배포한 검증 채널 URL
- `utm_source`: 프로젝트명 또는 주요 공유처 (예: `my-project`, `direct`)
- `utm_medium`: 공유 방식 (예: `link`, `social`, `messenger`)
- `utm_campaign`: `week1-validation`
- `utm_content`: 가설 키워드 (예: `report-automation`) — 선택
- `channel`: 공유할 주요 채널명

랜딩을 배포했다면 `landingId`도 연결한다.

> 생성된 링크는 https://agentic30.app/dashboard/links 에서도
> 확인, 수정, 삭제할 수 있다.
> 내일 Day 2에서 채널별 링크를 더 만들 거다.

### `d1-bio-landing` — 바이오에 랜딩 카드 연결

검증 채널이 live 상태가 되면
바이오 페이지에 `landing_card` 블록을 추가한다.

`manage_bio_blocks` MCP 도구:
- `action`: "add"
- `block_type`: "landing_card"
- `data`: { "landing_id": "{랜딩 ID}" } (랜딩 배포한 경우)
  또는 `block_type`: "link", `data`: { "url": "{검증 채널 URL}", "title": "{프로젝트명}" }

소리:
"바이오에 네 검증 채널이 걸렸어.
사람들이 프로필 보고
바로 눌러볼 수 있다."

> 바이오 수정: https://agentic30.app/settings/bio

### `d1-reading` — Day 1 추천 읽기

소리가 가죽 주머니에서 종이를 꺼낸다.

"오늘 만든 SPEC과 검증 채널은
이 방법론들의 출발점이야."

`create_utm_link` MCP 도구로
`{REFS_DIR}/shared/week1-reading-list.md`의 Day 1 섹션을 Read합니다.

- 공통값: `channel="blog"`, `utmSource="agnt"`, `utmMedium="reading"`
- 항목별 `url`, `title`, `utmCampaign`, `utmContent`는 Day 1 섹션을 그대로 사용합니다.
- 3개 링크를 생성하고 short URL을 아래 형식으로 정리합니다.

```
📚 Day 1 추천 읽기
1. 인터뷰 주도 개발 → {shortUrl}
2. 랜딩페이지 전환율 → {shortUrl}
3. The Mom Test 기초 → {shortUrl}
```

소리: "내일 고객 반응을 모으기 전에
읽어두면 질문이 달라진다."

### `d1-discord-project`

Discord #프로젝트-소개 채널에
프로젝트를 소개한다.

인터뷰에서 정리한 내용이
모달에 미리 채워져 있으니
확인하고 제출하면 된다.

- 프로젝트 한 줄 소개
- 해결하려는 문제
- 해결 방법

"프로젝트 소개하기" 버튼을 눌러
모달을 열고 제출해.

## STOP

AskUserQuestion:
질문: 소리가 묻는다. "검증 채널 공개와
프로젝트 소개가 끝났어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "현자 소리가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

1. `d1-landing`:
   live surface가 확인되면 제출합니다.
2. `d1-first-link`:
   MCP `create_utm_link`를 호출하여
   검증 채널의 첫 추적 링크를 생성합니다.
   - `targetUrl`: 배포된 검증 채널 URL
   - `utm_source`, `utm_medium`, `channel`:
     대화에서 파악한 프로젝트/채널 정보로 채운다
   - `utm_campaign`: `week1-validation`
   - `utm_content`: 가설 키워드 — 선택
   - 랜딩 배포한 경우 `landingId` 연결
   - 생성된 short URL을 유저에게 보여준다
   - state.json에 `firstTrackingLink`로 저장한다
3. `d1-bio-landing`:
   `get_bio`로 바이오에 landing_card 또는 link 블록이 있는지 확인합니다.
   없으면 `manage_bio_blocks`로 추가 후 제출합니다.
4. `d1-discord-project`:
   프로젝트 소개가 확인되면 제출합니다.
5. `d1-reading`:
   `get_links` source: "manual"로 조회하여
   utmMedium: "reading", utmCampaign: "day1"인 링크 중
   click_count > 0인 것이 1개 이상이면 제출합니다.
6. `d1-branding`:
   `package.json`이 있으면 hidden quest로 처리합니다.

## MOVE

소리가 들판 너머 광장을 가리킨다.

"좋아.
내일은 바리를 만난다.

이제부터는
'뭘 만들었나'보다
'누가 어떻게 반응했나'가 더 중요해."
