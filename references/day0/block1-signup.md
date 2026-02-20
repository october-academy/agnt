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

### 2단계: 프로필 수집 (AskUserQuestion 4단계)

**사전 준비**: MCP `get_user_info` 호출하여
사용자 정보를 가져옵니다.
응답의 `googleName` 필드가 Google 계정
실명입니다.
⚠️ 이름을 **절대 추측하거나 생성하지
마세요**. 반드시 `get_user_info` 응답값만
사용합니다.

**Q1. 이름 확인**
AskUserQuestion:
- "등록할 이름을 확인해주세요."
- `googleName`이 있을 때:
  1. "{googleName}으로 등록"
  (시스템이 "Other" 선택지를
  자동 추가하므로 별도 "다른 이름"
  선택지 불필요)
- `googleName`이 없을 때:
  선택지 없이 직접 입력 유도

**Q2. 배경 — 1차 대분류**
AskUserQuestion:
질문: "현재 어떤 일을 하고 계세요?"
1. "개발" → Q2-dev-sub로
2. "디자인" → Q2-design로
3. "기획/PM" → Q2-pm로
4. "마케팅/그로스" → Q2-marketing로
5. "비즈니스" → Q2-biz로
6. "기타" → Q2-etc로

**Q2-dev-sub. 개발 — 2차 중분류**
질문: "어떤 분야의 개발을 하세요?"
1. "웹/앱 개발" → Q2-dev-web으로
2. "데이터/AI" → Q2-dev-data로
3. "인프라/보안" → Q2-dev-infra로
4. "기타 개발" → Q2-dev-etc로

**Q2-dev-web. 웹/앱 개발 — 3차 세분류**
질문: "구체적으로 어떤 역할이세요?"
1. "프론트엔드" → background=`frontend`
2. "백엔드" → background=`backend`
3. "풀스택" → background=`fullstack`
4. "모바일 (iOS/Android)" → background=`mobile`

**Q2-dev-data. 데이터/AI — 3차 세분류**
질문: "구체적으로 어떤 역할이세요?"
1. "데이터 엔지니어" → background=`data-engineer`
2. "ML/AI 엔지니어" → background=`ml-engineer`
3. "데이터 분석가" → background=`data-analyst`

**Q2-dev-infra. 인프라/보안 — 3차 세분류**
질문: "구체적으로 어떤 역할이세요?"
1. "DevOps/인프라" → background=`devops`
2. "보안" → background=`security`

**Q2-dev-etc. 기타 개발 — 3차 세분류**
질문: "구체적으로 어떤 역할이세요?"
1. "QA/테스트" → background=`qa`
2. "게임" → background=`game`

**Q2-design. 디자인 — 2차 세부**
질문: "어떤 디자인을 하세요?"
1. "UI/UX 디자이너" → background=`ui-ux`
2. "프로덕트 디자이너" → background=`product-designer`
3. "그래픽/브랜드 디자이너" → background=`graphic`

**Q2-pm. 기획/PM — 2차 세부**
질문: "어떤 역할이세요?"
1. "프로덕트 매니저" → background=`pm`
2. "서비스 기획자" → background=`planner`
3. "프로젝트 매니저" → background=`project-manager`

**Q2-marketing. 마케팅/그로스 — 2차 세부**
질문: "어떤 역할이세요?"
1. "마케터" → background=`marketer`
2. "그로스 해커" → background=`growth`
3. "콘텐츠 크리에이터" → background=`content-creator`

**Q2-biz. 비즈니스 — 2차 세부**
질문: "어떤 역할이세요?"
1. "창업자/대표" → background=`founder`
2. "사업개발/BD" → background=`biz-dev`
3. "영업/세일즈" → background=`sales`

**Q2-etc. 기타 — 2차 세부**
질문: "어떤 역할이세요?"
1. "학생" → background=`student`
2. "기타" → background=`other`

**Q3. 사이드 프로젝트 경험**
AskUserQuestion:
질문: "사이드 프로젝트 경험이 어떻게
되세요?"
1. "처음 도전"
2. "시도했지만 완성 못함"
3. "완성은 했지만 유저 없음"
4. "유저는 있지만 매출 없음"

**Q4. 유입 경로**
AskUserQuestion:
질문: "Agentic30을 어떻게 알게
되셨나요?"
1. "지인 추천"
2. "SNS
   (Threads/LinkedIn)"
3. "콘텐츠
   (YouTube/블로그)"
4. "검색"

Q4에서 "지인 추천" 선택 시 추가
질문:
- "추천해주신 분의 이메일을
  알려주시면 감사 포인트를
  드립니다. (선택사항)"

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
광장 쪽을 가리킨다.

"좋아.
이제 네가 어떤 사람인지
이야기하러 가자."
