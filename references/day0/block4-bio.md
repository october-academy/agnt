---
stop_mode: checkpoint
title: "바이오 페이지 — 공개 프로필 만들기"
npc: 두리
quests:
  - id: d0-bio-setup
    type: main
    title: "바이오 페이지 셋업"
    xp: 50
  - id: d0-reading
    type: side
    title: "추천 읽기 완료"
    xp: 20
transition: "Day 0 완료! 다음은 발견의 숲에서 AI 코파운더를 만납니다."
---

# 바이오 페이지 — 공개 프로필 만들기

## ROOM

술집을 지나 게시판 앞에 선다.
알림장 옆에 빈 칸이 하나 있다.

## NPC

두리가 빈 칸을 가리킨다.

🏘️ 촌장 두리

"Discord에서 얼굴을 보여줬으니
이제 밖에서도 보이는
공개 프로필을 만들 차례야.

나중에 랜딩이나 채널을 공유할 때
사람들이 '이 사람 누구지?' 하면
바로 볼 수 있는 한 장짜리 페이지.

여기선 그걸 `바이오 페이지`라고 불러."

## GUIDE

### 1단계: 바이오 페이지 생성

`update_bio` MCP 도구를 호출합니다:
- `display_name`: state.json의 `character.name` 또는 프로필 이름
- `description`: 목표 선언에서 추출한 한 줄 소개 (30자 이내)

예시:
```
display_name: "유호균"
description: "30일 안에 첫 매출을 만드는 개발자"
```

### 2단계: 소셜 링크 추가

GitHub 또는 다른 소셜이 있으면 추가합니다.

AskUserQuestion:
질문: 두리가 묻는다. "GitHub나
다른 소셜 계정 있어?"
선택지:
1. "GitHub 있어요"
2. "다른 소셜 있어요"
3. "나중에 할게요"

1번/2번 선택 시:
AskUserQuestion으로 URL을 받아
`update_bio`에 `socials` 배열로 전달합니다.

3번 선택 시:
두리: "괜찮아. 나중에 여기서 추가할 수 있어."
`https://agentic30.app/settings/bio`

### 3단계: 첫 블록 추가

`manage_bio_blocks` MCP 도구로 text 블록을 추가합니다:
- `action`: "add"
- `block_type`: "text"
- `data`: { "text": 목표 선언문 요약 (block2에서 확정한 내용) }

두리:
"바이오에 네 목표가 박혔어.
앞으로 랜딩, 프로젝트 링크,
채널 성과까지 여기에 쌓인다."

### 4단계: 추천 읽기

두리가 게시판에서 종이 세 장을 꺼낸다.

"시작하기 전에 읽어두면 좋은 게 있어.
오늘 밤이나 내일 아침에 훑어봐."

`create_utm_link` MCP 도구로
`{REFS_DIR}/shared/week1-reading-list.md`의 Day 0 섹션을 Read합니다.

- 공통값: `channel="blog"`, `utmSource="agnt"`, `utmMedium="reading"`
- 항목별 `url`, `title`, `utmCampaign`, `utmContent`는 Day 0 섹션을 그대로 사용합니다.
- 유저 맥락에 맞게 3개 링크를 생성하고 short URL을 아래 형식으로 정리합니다.

생성된 단축 링크를 목록으로 표시합니다:

```
📚 Day 0 추천 읽기
1. Agentic30이란 무엇인가 → {shortUrl}
2. Agentic Engineer 선언 → {shortUrl}
3. GPP: 전문화의 종말 → {shortUrl}
```

두리:
"링크를 눌러서 읽으면
내가 읽었는지 알 수 있어.
나중에 확인할게."

## PREVIEW

두리가 게시판에 프로필 카드를 건다.

`get_bio` MCP 도구를 호출하여
현재 바이오 상태를 확인합니다.

바이오 페이지 URL을 표시합니다:
`https://agentic30.app/bio/{slug}`

두리:
"이게 네 공개 프로필이야.
수정은 여기서 할 수 있어:
`https://agentic30.app/settings/bio`

링크 관리는 여기:
`https://agentic30.app/dashboard/links`"

## STOP

AskUserQuestion:
질문: 두리가 묻는다. "바이오 페이지
만들었어?"

1. "완료"
2. "아직"

⛔ STOP — "촌장 두리가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"완료"를 선택하면
서버 검증을 수행합니다.

`verify_server_state` check: `bio_setup`

**verified: true**:
두리: "좋아. 네 이름표가 걸렸어."
→ `d0-bio-setup` submit_practice 처리

**verified: false**:
두리: "아직 바이오가 비어 있어.
블록을 하나라도 추가해야 해."
→ GUIDE 3단계로 돌아감

### 추천 읽기 검증 (side quest)

`get_links` source: "manual"로 조회하여
utmMedium: "reading", utmCampaign: "day0"인 링크 중
click_count > 0인 것이 1개 이상이면
→ `d0-reading` submit_practice 처리

0개면 건너뜀 (side quest이므로 필수 아님)

## MOVE

게시판을 지나
멀리 숲 입구에 등불이 흔들린다.

두리가 말한다.

"내일은 소리를 만난다.
거기서 네 상태를 진단하고
첫 검증 루프를 연다.

오늘 적은 소개와
바이오 페이지가
내일 출발점이 된다."
