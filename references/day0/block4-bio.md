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

"만든 거 공유할 때
'이 사람 누구야?' 물으면 끝이야.
프로필이 신뢰야."

두리가 빈 칸을 손가락으로 짚는다.

"30일 후에
네 이름으로 된 포트폴리오가 필요해.
지금 시작해.
1분이면 돼."

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

### 2단계: 첫 블록 추가

`manage_bio_blocks` MCP 도구로 text 블록을 추가합니다:
- `action`: "add"
- `block_type`: "text"
- `data`: { "text": 목표 선언문 요약 (block2에서 확정한 내용) }

두리:
"바이오에 네 목표가 박혔어.
앞으로 랜딩, 프로젝트 링크,
채널 성과까지 여기에 쌓인다."

### 4단계: 추천 읽기

두리가 짧게 덧붙인다.

"시간 나면 읽어봐."

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
수정: `https://agentic30.app/settings/bio`"

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
두리: "좋아. 네 이름표가 걸렸어.

바이오 페이지가 생겼어.
이건 네 검증의 홈이야.

잠재 고객한테 보여줄 수 있는
첫 자산이야."
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

"내일은 AI 코파운더를 만난다.
오늘 적은 것이 출발점이 된다."
