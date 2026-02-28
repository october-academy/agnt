---
stop_mode: checkpoint
title: "Discord 합류 — 동료 모험가를 만나다"
npc: 두리
quests:
  - id: d0-discord-join
    type: main
    title: "Discord 연동"
    xp: 50
  - id: d0-discord-intro
    type: main
    title: "Discord 자기소개"
    xp: 50
transition: "Day 0 완료! 다음은 발견의 숲에서 AI 코파운더를 만납니다."
---

# Discord 합류 — 동료 모험가를 만나다

## ROOM

좁은 골목을 지나 술집 문을 밀고
들어선다.

안쪽에서 웅성거리는 목소리가 겹쳐
들린다.
나무 탁자에서 잔 부딪히는 소리가
튄다.

맥주와 나무 냄새가 한꺼번에
밀려온다.
문턱의 열기가 뺨을 스친다.

## NPC

두리가 술집 안으로 들어서며
한쪽 탁자를 가리킨다.

🏘️ 촌장 두리

"여기 동료 모험가들이 모여.
혼자 하는 게 아니야.

Discord 서버에
가입하고 인사해."

## GUIDE

### 진행 방식 (필수)

한 번에 전체 안내를
길게 출력하지 않습니다.

아래 1→2단계를
순서대로 진행합니다.

각 단계 끝마다
AskUserQuestion으로
완료 여부를 확인하고
다음 단계로 이동합니다.

각 단계에서는
반드시 `중간 STOP`으로
사용자 행동을 기다립니다.

### 1단계: Discord 연동 + 서버 가입

먼저 `connect_discord()` MCP 도구를 호출합니다.

**`already_connected: true` 반환 시**:
두리: "이미 연동돼 있네."
→ 즉시 `verify_discord({ check: "membership" })` 호출:

- 성공 시: `submit_practice({ questId: "d0-discord-join", day: 0, evidence: { type: "text", content: "verified" } })` 호출 → 2단계로 이동
- 실패 시: 두리: "서버에는 아직 안 들어왔어. 여기서 가입해." + 초대 링크: https://discord.gg/H4A459FG5r → 가입 확인 질문으로

**`url` 반환 시**:
두리: "Discord 계정을 연동해야 해.
브라우저에서 열어줄게."

Bash 도구로 URL을 브라우저에서 엽니다: macOS는 `open <URL>`, Linux는 `xdg-open <URL>`.
URL도 코드 블록으로 함께 표시합니다 (자동 오픈 실패 시 수동 접근용).

AskUserQuestion:
질문: |
두리가 묻는다. "브라우저에서 Discord 연동을 마쳤어?"

1. "연동 완료" — Discord 연동을 마쳤다
2. "아직" — 잠시 다녀오겠다

"연동 완료"면 **즉시 MCP 검증**:

- `verify_discord({ check: "membership" })` 호출
- 성공 시: `submit_practice({ questId: "d0-discord-join", day: 0, evidence: { type: "text", content: "verified" } })` 호출 → 2단계로 이동
- 실패 시: 두리: "서버에 아직 안 들어온 것 같아. 초대 링크에서 가입하고 다시 와." + 초대 링크: https://discord.gg/H4A459FG5r → 같은 질문 반복
- MCP 미인증/에러 시: ON_CONFIRM의 MCP 인증 안내 절차를 따른다
  "아직"이면 두리가 잠깐 다녀오라고
  안내한 뒤 같은 질문을 반복합니다.

**`error` 반환 시** (Discord OAuth 미설정):
두리: "먼저 Discord 서버에 가입하고,
그다음 계정을 연동해야 해."
초대 링크: https://discord.gg/H4A459FG5r

AskUserQuestion:
질문: |
두리가 묻는다. "서버에 가입했어?"

1. "가입 완료" — Discord 서버에 가입했다
2. "아직" — 잠시 다녀오겠다

"가입 완료"면 `connect_discord()` 재호출:

- `url` 반환 시: 위의 `url` 반환 플로우와 동일하게 진행
- `already_connected: true` 반환 시: `verify_discord({ check: "membership" })` 호출 → 성공 시 `submit_practice` → 2단계로 이동
- 다시 `error` 반환 시: 두리: "아직 연동이 안 됐어. 웹에서 직접 연동할 수도 있어." + 웹 연동 URL: `https://agentic30.app/learn/day/0` 안내 + "웹에서 연동한 뒤 `/agnt:submit`으로 퀘스트를 직접 제출할 수도 있어." → 같은 질문 반복
  "아직"이면 같은 질문 반복.

⚠️ **`verify_discord` 통과(service_connections 존재) 없이는 `d0-discord-join` 퀘스트를 완료할 수 없습니다.**

⛔ 중간 STOP —
"Discord 연동을 마치고 선택해."

### 2단계: 자기소개 작성 + 제출

두리: "#자기소개 채널로 가서
`자기소개 작성하기` 버튼을 눌러.
내용 확인하고 제출까지 해.
열어줄게."

Bash 도구로 Discord 채널을 브라우저에서 엽니다: macOS는 `open "https://discord.com/channels/1463373562000838774/1463432947745947759/1467136426796908647"`, Linux는 `xdg-open` 사용.
URL도 코드 블록으로 함께 표시합니다 (자동 오픈 실패 시 수동 접근용).

폼이 열리면
이전 작성 내용과
웹에서 저장된 프로필이
가능한 범위에서 자동으로 채워집니다.
채널 상단 고정 안내에서
`자기소개 작성하기` 버튼을 누릅니다.

AskUserQuestion:
질문: |
두리가 묻는다. "자기소개 폼 제출까지 마쳤어?"

#자기소개 채널: https://discord.com/channels/1463373562000838774/1463432947745947759/1467136426796908647

1. "제출 완료" — 자기소개를 제출했다
2. "아직" — 잠시 다녀오겠다

"제출 완료"면 ON_CONFIRM으로
이동합니다.
"아직"이면 잠깐 다녀오라고
안내한 뒤 같은 질문을 반복합니다.

⛔ 중간 STOP — "제출까지 끝낸 뒤 선택해."

## PREVIEW

두리가 안내한다:

1. 서버 가입부터 끝내
2. #자기소개에서 버튼으로 폼을 열고 제출해

## STOP

2단계의 AskUserQuestion이
STOP 역할을 겸합니다.
별도 STOP 질문 없이
2단계 완료 시 바로
ON_CONFIRM으로 진행합니다.

## ON_CONFIRM

AskUserQuestion에서
"제출 완료"를 선택하면 **반드시
MCP로 검증**합니다.
"아직"을 선택하면 두리가 다시
안내하고 같은 질문을 반복합니다.

1. `verify_discord({ check: "message_exists", channelId: "1463432947745947759" })` → 자기소개 메시지 확인
   - 실패 시: 두리:
     "자기소개가 안 보여. #자기소개 채널에서
     `자기소개 작성하기` 버튼으로
     다시 제출해." →
     다시 STOP
   - 성공 시: `submit_practice({ questId: "d0-discord-intro", day: 0, evidence: { type: "text", content: "verified" } })` 호출

2. **MCP 호출이 실패하거나
   미인증 상태인 경우**:
   - "Discord 검증을 위해
     MCP 인증이 필요합니다.
     인증을 진행할까요?" →
     AskUserQuestion
   - "네" 선택: MCP 인증
     플로우 → 인증 후 재검증
   - "나중에" 선택: 두리: "나중에 `/agnt:submit`으로 제출해도 돼." → 블록은 완료 처리하되 퀘스트는 미완료

3. 검증 성공:

```
자기소개 확인! +50 XP
```

참고: 서버 가입 검증(`d0-discord-join`)은
1단계에서 이미 완료됨 (서버 dedup으로 중복 호출 안전)

## MOVE

두리가 술집 문 앞에 서며 말한다.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Day 0 완료!
📍 견습생의 마을
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚔️ 퀘스트: 4/4
  💰 획득 XP: 170

  📍 다음: 발견의 숲
  🎯 AI 코파운더와 심층 인터뷰
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

두리가 술집 문 밖으로 나서며
마을 끝 숲 입구를 가리킨다.

"잘 했어.
내일 저 숲으로 가."

술집을 나서자 밤바람이 차갑다.
마을 불빛이 하나씩 꺼져간다.
저 멀리 숲 입구에
희미한 등불이 흔들린다.
풀벌레 소리가 사방에서 올라온다.

두리가 걸음을 멈추며 말한다.

"발견의 숲에 가면
소리라는 현자를 만날 거야."

두리가 잠시 멈춘다.

"'정말 그런가?'가 입버릇이야.
질문으로 이끄는 사려깊은 사람이지."

━━━━━━━━━━━━━━━━━━━━━━━━━━
🦉 현자 소리
"정말 그런가?"
질문으로 이끄는 사려깊은 안내자
━━━━━━━━━━━━━━━━━━━━━━━━━━

"말보다 행동이지.
가서 해."
