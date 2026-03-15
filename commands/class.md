직업을 선택하거나 현재 직업을 확인합니다.

## 데이터 경로 결정

이 커맨드의 모든 파일 경로는 아래 절차로 결정합니다.

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 둘 다 없으면 → "먼저 `/agnt:continue`로 학습을 시작하세요." 출력 후 종료

### REFS_DIR (references 루트)

1. `{AGNT_DIR}/references/shared/classes.json`을 Read 시도 → 성공하면 **REFS_DIR = `{AGNT_DIR}/references`**
2. 실패 시 `~/.claude/plugins/marketplaces/agentic30/references/shared/classes.json` Read 시도 → 성공하면 **REFS_DIR = `~/.claude/plugins/marketplaces/agentic30/references`**
3. 실패 시 `.agents/skills/agnt/references/shared/classes.json` Read 시도 → 성공하면 **REFS_DIR = `.agents/skills/agnt/references`**
4. 실패 시 `~/.codex/skills/agnt/references/shared/classes.json` Read 시도 → 성공하면 **REFS_DIR = `~/.codex/skills/agnt/references`**
5. 둘 다 없으면 에러:
   - "references를 찾을 수 없습니다. Claude Plugin 사용자는 `bun run sync:assistant-assets` 또는 plugin 재설치를, Codex 사용자는 `npx skills add october-academy/agnt --agent codex --skill agnt`를 실행하세요."

## 출력 규칙 (필수)

### 내부 로직 무음 처리

아래 절차는 **유저에게 텍스트를 출력하지 않고** 내부적으로만 수행합니다:

- AGNT_DIR / REFS_DIR 경로 탐색 및 결과
- state.json 파싱 결과
- 파일 Read 성공/실패 여부
- JSON 파싱 결과

## 실행 절차

1. `{AGNT_DIR}/state.json`을 Read.

2. `{REFS_DIR}/shared/classes.json`을 Read.

3. **이미 직업이 있는 경우** (`state.class`가 null이 아닌 경우):

   `classes.json`에서 현재 직업 데이터를 찾아 아래 형식으로 출력:

   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━
   {emoji} {name}
   "{tagline}"
   ━━━━━━━━━━━━━━━━━━━━━━━━━━
     📑 스킬 탭:
     {tab1.emoji} {tab1.name}
     {tab2.emoji} {tab2.name}
     {tab3.emoji} {tab3.name}

     보유 스킬:
     {skills 객체에서 레벨 1+ 스킬 목록}

     💡 직업을 변경하면 시작 스킬이 초기화됩니다.
   ```

   `AskUserQuestion`으로 선택지 제공:
   - "현재 직업 유지"
   - "직업 변경하기"

   "현재 직업 유지" 선택 시 종료.
   "직업 변경하기" 선택 시 step 4로 진행.

4. **직업 선택 화면**:

   두리(NPC)가 직업을 소개하는 형식으로 출력:

   ```
   두리가 네 개의 문장(紋章)을 펼쳐 보인다.

   "넌 어떤 무기로 싸울 거야?
   하나를 골라. 나중에 바꿀 수도 있어."
   ```

   4개 직업을 카드 형식으로 출력:

   ```
   ┌─────────────────────────────┐
   │ {emoji} {name}              │
   │ "{tagline}"                 │
   │                             │
   │ {description}               │
   │                             │
   │ 📑 스킬 탭:                │
   │  {tab1.emoji} {tab1.name}  │
   │  {tab2.emoji} {tab2.name}  │
   │  {tab3.emoji} {tab3.name}  │
   │                             │
   │ 추천: {recommendedFor}      │
   │                             │
   │ 시작 스킬:                  │
   │  ✅ {startingSkill1 이름}   │
   │  ✅ {startingSkill2 이름}   │
   │  ✅ {startingSkill3 이름}   │
   └─────────────────────────────┘
   ```

   `AskUserQuestion`으로 4개 직업 중 선택:
   - options: 각 직업의 "{emoji} {name}" (4개)

5. **직업 저장**:

   선택된 직업 ID를 `state.json`의 `class` 필드에 저장.

   `skills` 필드가 없으면 빈 객체 `{}`로 초기화.

   선택된 직업의 `startingSkills` 배열의 각 스킬 ID를 `state.skills`에 레벨 1로 저장:
   ```json
   {
     "class": "code-knight",
     "skillPoints": 0,
     "skills": {
       "ck-fe-component-blade": 1,
       "ck-be-env-forge": 1,
       "ck-do-project-foundation": 1
     }
   }
   ```

   **직업 변경 시**: 기존 `skills`의 투자된 SP를 `skillPoints`에 환불한 뒤, `skills` 객체를 완전 초기화하고 새 직업의 `startingSkills`만 레벨 1로 설정.

6. **확인 출력**:

   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━
   {emoji} {name}
   "{tagline}"
   ━━━━━━━━━━━━━━━━━━━━━━━━━━

   두리가 고개를 끄덕인다.

   "좋아. {name}(이)라...
   어울리는 선택이야."

   시작 스킬 3개가 해금되었습니다 (각 탭에서 1개씩):
   ✅ {skill1 이름} ({tab1 이름})
   ✅ {skill2 이름} ({tab2 이름})
   ✅ {skill3 이름} ({tab3 이름})

   💡 `/agnt:skills`로 스킬트리를 확인하세요
   💡 Day 완료 시 스킬포인트를 획득합니다
   ```

## 규칙

- 한국어 출력. 기술 용어는 원문 유지.
- `classes.json`과 `skill-trees.json`의 데이터를 그대로 사용 (하드코딩 금지).
- NPC 대사는 두리 스타일 (직설적, 반말, 짧은 문장).
- state.json에 `class`, `skillPoints`, `skills` 필드가 없으면 null/0/{} 기본값으로 처리.
