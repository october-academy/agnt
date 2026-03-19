---
stop_mode: checkpoint
title: "검증 계획 수립"
npc: 소리
quests:
  - id: d1-landing
    type: main
    title: "검증 계획 + 가설 카드 작성"
    xp: 150
  - id: d1-first-link
    type: side
    title: "첫 추적 링크 생성"
    xp: 30
  - id: d1-bio-landing
    type: side
    title: "바이오에 프로젝트 연결"
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
transition: "Day 1 완료! 가설 카드와 검증 계획이 정리되었습니다. 다음은 검증의 광장에서 진짜 반응을 모읍니다."
---

# 검증 계획 수립

## ROOM

숲을 나서자
들판 바람이 한 번에 밀려온다.
먼 곳 마을 불빛이 점점이 보인다.

## NPC

소리가 숲 출구에서 멈춘다.

🦉 현자 소리

"오늘 마지막은
가설을 검증할 계획을 세우는 거야.

{state.character.isFullTime 존재 시}
누구한테 물어볼 건지,
어디에 공유할 건지,
어떤 반응이 오면 '된다'고 볼 건지.

계획이 없으면 데이터도 없어.

{미존재 시}
이번 주 목표를 세울 때
'오늘 안에'로 잡으면
네 상황에서 가능할까?

하루에 1개씩 3일이면
같은 결과를 낼 수 있지 않아?"

## GUIDE

### `d1-landing` — 검증 계획 수립

이 퀘스트는 가설 카드를 바탕으로
이번 주 검증 계획을 세우는 것이다.

아래 세 가지를 정리한다:

1. **검증 채널 3곳 선정**
   - 가설의 타겟이 있는 곳
   - 예: OKKY, 카카오톡 오픈챗, Threads, X, Discord, 지인 DM
   - "타겟이 안 보이면 채널이 틀린 거야."

2. **검증 질문 설계**
   - 각 채널에서 물어볼 핵심 질문 1개
   - Mom Test 원칙: 아이디어가 아닌 과거 행동을 묻는다
   - 예: "이 문제를 마지막으로 겪은 게 언제예요?"
   - 예: "그때 어떻게 해결했어요?"
   - ICP 특화 질문 (전업 개발자라면):
     - "이전 프로젝트에서 첫 유저를 어떻게 데려왔어요?
       안 데려왔다면, 왜요?"

3. **성공 기준 정의**
   - 이번 주에 어떤 반응이 오면 "검증됐다"고 볼 것인가
   - 예: "3명이 '그 문제 나도 있다'고 답하면 Go"
   - 예: "DM 5개 보내서 2개 이상 답장 오면 Go"

### `d1-first-link` — 첫 추적 링크

검증 채널을 정했으면
공유할 때 쓸 **추적 링크**를 만든다.

이미 배포된 랜딩이나 제품이 있다면 그 URL을,
없다면 바이오 페이지 URL을 targetUrl로 쓴다:
`https://agentic30.app/bio/{username}`

MCP `create_utm_link` 도구로 생성한다:

- `targetUrl`: 공유할 URL (랜딩, 제품, 또는 바이오 페이지)
- `utm_source`: 프로젝트명
- `utm_medium`: 공유 방식 (link, social, messenger)
- `utm_campaign`: `week1-validation`
- `channel`: 주요 채널명

> 생성된 링크는 https://agentic30.app/dashboard/links 에서 확인 가능.

### `d1-bio-landing` — 바이오에 프로젝트 연결

바이오 페이지에 프로젝트 링크를 추가한다.

`manage_bio_blocks` MCP 도구:
- `action`: "add"
- `block_type`: "link"
- `data`: { "url": "{프로젝트 또는 바이오 URL}", "title": "{프로젝트명}" }

### `d1-reading` — Day 1 추천 읽기

`create_utm_link` MCP 도구로
`{REFS_DIR}/shared/week1-reading-list.md`의 Day 1 섹션을 Read합니다.

- 공통값: `channel="blog"`, `utmSource="agnt"`, `utmMedium="reading"`
- 항목별 `url`, `title`, `utmCampaign`, `utmContent`는 Day 1 섹션을 그대로 사용합니다.
- 3개 링크를 생성하고 short URL을 정리합니다.

```
📚 Day 1 추천 읽기
1. 인터뷰 주도 개발 → {shortUrl}
2. The Mom Test 기초 → {shortUrl}
3. Cold DM 가이드 → {shortUrl}
```

### `d1-discord-project`

Discord #프로젝트-소개 채널에
프로젝트를 소개한다.

"프로젝트 소개하기" 버튼을 눌러
모달을 열고 제출해.

## STOP

AskUserQuestion:
질문: 소리가 묻는다. "검증 계획과
가설 카드가 정리됐어?"

1. "확인"
2. "수정 요청"

⛔ STOP — "현자 소리가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.

1. `d1-landing`:
   가설 카드 + 검증 계획이 정리되면
   텍스트 검증(minLength: 50)으로 제출합니다.
2. `d1-first-link`:
   MCP `create_utm_link`를 호출하여
   첫 추적 링크를 생성합니다.
3. `d1-bio-landing`:
   `get_bio`로 바이오에 link 블록이 있는지 확인합니다.
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

계획은 세웠으니
이제 실제로 사람한테 물어볼 차례야.

참고로,
이번 주가 끝나면
이 가설로 AI가 MVP를 만들어줘.
검증된 가설이 있어야 속도가 나오거든.
오늘 만든 게 다음 주의 출발점이야."
