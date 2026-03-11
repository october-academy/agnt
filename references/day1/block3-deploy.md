---
stop_mode: checkpoint
title: "첫 검증 채널 공개"
npc: 소리
quests:
  - id: d1-landing
    type: main
    title: "첫 검증 채널 배포/정리"
    xp: 150
  - id: d1-discord-project
    type: side
    title: "프로젝트 소개"
    xp: 30
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

그리고 Discord에
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
2. `d1-discord-project`:
   프로젝트 소개가 확인되면 제출합니다.
3. `d1-branding`:
   `package.json`이 있으면 hidden quest로 처리합니다.

## MOVE

소리가 들판 너머 광장을 가리킨다.

"좋아.
내일은 바리를 만난다.

이제부터는
'뭘 만들었나'보다
'누가 어떻게 반응했나'가 더 중요해."
