---
stop_mode: checkpoint
title: "회원가입 — 모험가 등록"
npc: 두리
requires_auth: true
transition: "접수처 등록이 끝났습니다. 이제 당신이 어떤 사람인지 이야기해볼까요?"
---

# 회원가입 — 모험가 등록

## ROOM

마을 안쪽 접수처에 들어선다.

나무 카운터 뒤에
두꺼운 장부가 펼쳐져 있고,
깃펜이 잉크병 옆에 놓여 있다.

## NPC

두리가 카운터 뒤로 돌아가
장부를 편다.

🏘️ 촌장 두리

"모험을 시작하려면
먼저 등록부터 해야 해.

이름을 알려줘."

## GUIDE

### 1단계: 인증

MCP `agentic30` 서버 연결을 확인합니다.

1. `ToolSearch`로 `+agentic30` 검색
2. **도구 발견됨**: MCP 도구 중 아무거나 호출 시도 → Claude Code가 자동으로 OAuth 플로우 시작 (브라우저에서 Google 로그인)
3. **도구 없음**: 두리 대사로 안내 후 종료:

   ```
   두리가 장부를 만지작거리며 멈춘다.

   "접수처 장부가 연결이 안 돼.
   먼저 이걸 해봐."

   1. `/mcp` 명령으로 agentic30 서버 확인
   2. 서버가 목록에 없으면 Claude Code 재시작
   3. 연결 후 `/agnt:continue` 다시 실행
   ```

4. 인증 완료 → 다음 단계로 진행
5. 인증 실패 → 두리: "뭔가 막힌 것 같아. 다시 해봐." 안내 후 재시도

### 2단계: 프로필 수집 (기본 4단계 + 빠른 경로)

**사전 준비**: MCP `get_user_info` 호출하여
사용자 정보를 가져옵니다.

값셋 상수는 Supabase `profiles` CHECK 제약과
`@agentic30/shared/profile-constants`를
SSoT로 사용합니다.
추가로 `profile-constants.json`을 Read해서
질문 선택지를 동적으로 구성합니다.
(`{REFS_DIR}/shared/profile-constants.json`
우선, 경로 변수 미지원 환경은
`references/shared/profile-constants.json`)

- 이름 후보:
  - `name` (기존 프로필명)
  - `googleName` (Google 계정 실명)
- 온보딩 데이터:
  - `onboarding.background`
  - `onboarding.sideproject_experience`
  - `onboarding.referral_source`
  - `onboarding.enrolled_at`
  - `hasOnboardingProfile`
- 상수 데이터 (`profile-constants.json`):
  - `backgroundHierarchy`
  - `backgroundValues`
  - `sideprojectExperienceOptions`
  - `sideprojectExperienceValues`
  - `referralSourceOptions`
  - `referralSourceValues`

⚠️ 이름/기존 값은 **절대 추측하거나 생성하지
마세요**. 반드시 `get_user_info` 응답값만
사용합니다.

**빠른 경로: 기존 회원가입 정보 재사용**

`hasOnboardingProfile=true`면
AskUserQuestion:
질문: "웹에서 입력한 가입 정보를 그대로
사용할까?"

1. "기존 정보 그대로 사용"
2. "일부 수정"

- 1번 선택:
  - Q1~Q4를 생략하고 바로 PREVIEW로 이동
  - 값은 아래처럼 채웁니다:
    - `name`: `name` 우선, 없으면 `googleName`
    - `background`: `onboarding.background`
    - `sideproject_experience`: `onboarding.sideproject_experience`
    - `referral_source`: `onboarding.referral_source`
- 2번 선택:
  - 아래 Q1~Q4 일반 흐름 진행
  - 기존 값이 있으면 기본값으로 제시

**Q1. 이름 확인**
AskUserQuestion:

- "등록할 이름을 확인해주세요."
- `name`이 있을 때:
  1. "{name}으로 등록"
- `name`이 없고 `googleName`이 있을 때:
  1. "{googleName}으로 등록"
     (시스템이 "Other" 선택지를
     자동 추가하므로 별도 "다른 이름"
     선택지 불필요)

**Q2. 배경 (상수 파일 기반 동적 질문)**
AskUserQuestion:
질문: "현재 어떤 일을 하고 계세요?"

옵션은 `backgroundHierarchy[*].label`을
그대로 사용합니다.

선택된 category에 따라:

- `subcategories`가 있으면:
  - 질문: "어떤 분야를 하고 계세요?"
  - 옵션: `subcategories[*].label`
  - 다시 질문: "구체적으로 어떤 역할이세요?"
  - 옵션: 선택한 subcategory의
    `options[*].label`
  - 최종 선택된 option의 `value`를
    `background`로 저장
- `options`만 있으면:
  - 질문: "구체적으로 어떤 역할이세요?"
  - 옵션: 선택한 category의
    `options[*].label`
  - 최종 선택된 option의 `value`를
    `background`로 저장

**Q3. 사이드 프로젝트 경험**
AskUserQuestion:
질문: "사이드 프로젝트 경험이 어떻게
되세요?"

옵션은 `sideprojectExperienceOptions`에서
`label`을 사용하고, 선택 결과는 해당
`value`를 `sideproject_experience`로 저장합니다.

**Q4. 유입 경로**
AskUserQuestion:
질문: "Agentic30을 어떻게 알게
되셨나요?"

옵션은 `referralSourceOptions`에서
`label`을 사용하고, 선택 결과는 해당
`value`를 `referral_source`로 저장합니다.

Q4에서 "지인 추천" 선택 시 추가
질문:

- "추천해주신 분의 이메일을
  알려주시면 감사 포인트를
  드립니다. (선택사항)"
  - 조건: `referral_source === "friend"`

**값 검증 (필수)**

PREVIEW 전에 아래를 검증합니다.

- `background ∈ backgroundValues`
- `sideproject_experience ∈ sideprojectExperienceValues`
- `referral_source ∈ referralSourceValues`

하나라도 불일치하면 해당 항목 질문으로
되돌아가 다시 선택받습니다.

## PREVIEW

두리가 장부에 적은 내용을 읽어준다.

"정리해보면 이래."

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 프로필 확인
━━━━━━━━━━━━━━━━━━━━━━━━━━
  이름: {name}
  배경: {background}
  경험: {sideproject_experience}
  유입: {referral_source}
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## STOP

두리가 깃펜을 내려놓으며 말한다.

"맞으면 `확인`,
고칠 게 있으면
`수정 요청`을 골라."

AskUserQuestion:
질문: 두리가 묻는다. "정리한 내용이
맞아?"

1. "확인"
2. "수정 요청"

⛔ STOP — "촌장 두리가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.
"수정 요청"이면 GUIDE로 돌아가
수정 후 PREVIEW → STOP을
반복합니다.

1. MCP `complete_onboarding` 호출:
   - name,
     background,
     sideproject_experience,
     referral_source,
     referrer_email(선택)
     전달
   - 빠른 경로(기존 정보 그대로 사용)에서도
     동일하게 호출합니다.
     (`already_enrolled=true` 응답으로
     syncState를 받아 로컬 상태를 동기화)
   - 성공 시: 두리: "등록
     완료. 이제 모험가야."
   - 실패 시: 에러 메시지 표시
     후 재시도 안내

2. state.json 갱신:
   - `authenticated = true`
   - syncState 반영
     (level, xp,
     title)

## MOVE

두리가 장부를 닫고
깃펜을 잉크병에 꽂는다.

"좋아.
밖으로 나가자."

접수처 문을 밀고 나온다.
햇빛이 한꺼번에 쏟아진다.
광장 쪽에서 물 흐르는 소리가
가늘게 들린다.
풀 냄새가 따뜻하게 올라온다.

두리가 광장 우물 쪽으로 걸으며
말한다.
"네가 어떤 사람인지
이야기해보자."
