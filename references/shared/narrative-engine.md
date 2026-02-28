# Narrative Engine — 블록 처리 규칙

이 문서는 블록 레퍼런스 파일 처리의 모든 규칙을 정의합니다.

## 1. YAML Frontmatter 파싱 규칙

블록 파일은 `---` 구분자로 시작하는 YAML frontmatter를 포함합니다.

### 필수 필드

- `stop_mode`: `full` | `conversation` | `checkpoint`
- `title`: 블록 제목 (문자열)
- `npc`: 해당 블록의 NPC 이름 (예: `두리`, `소리`). `npcs.md`에서 해당 NPC 카드만 참조

### 선택 필드

- `quests`: 이 블록에서 검증되는 퀘스트 목록
  ```yaml
  quests:
    - id: d2-momtest-quiz
      type: main
      title: "Mom Test 퀴즈 통과"
      xp: 50
  ```
- `transition`: 블록 완료 후 전환 메시지 (문자열)
- `on_complete`: 블록 완료 시 추가 동작 (`save_character`, `save_interview` 등)
- `requires_auth`: boolean — 인증 필요 블록

### 파싱 실패 시 Fallback

frontmatter가 없거나 파싱에 실패하면:

1. `⚠️ frontmatter 없음` 경고 1회 출력
2. 기존 자유형식 마크다운 헤더에서 메타데이터 추출
3. 블록 진행은 정상적으로 계속

## 2. 템플릿 변수 보간 규칙

블록 텍스트의 `{{variable}}` 패턴을 state.json 데이터로 치환합니다.

| 변수                       | 소스                              | 예시                        |
| -------------------------- | --------------------------------- | --------------------------- |
| `{{character.project}}`    | state.json → character.project    | "밥친구"                    |
| `{{character.motivation}}` | state.json → character.motivation | "혼밥이 싫어서"             |
| `{{character.target}}`     | state.json → character.target     | "1인 가구 직장인"           |
| `{{character.strengths}}`  | state.json → character.strengths  | "풀스택 개발"               |
| `{{character.goal}}`       | state.json → character.goal       | "30일 안에 유저 100명 확보" |
| `{{state.level}}`          | state.json → level                | "3"                         |
| `{{state.title}}`          | state.json → title                | "탐험가"                    |
| `{{state.xp}}`             | state.json → xp                   | "250"                       |
| `{{state.currentDay}}`     | state.json → currentDay           | "2"                         |

Fallback: `{{variable|대체텍스트}}` — 변수가 null이면 `|` 뒤 텍스트 사용.

보간 대상: 내러티브 텍스트, 전환 메시지, 퀘스트 설명.
보간 제외: frontmatter 필드명, Phase/STOP 마커, 퀴즈 선택지.

## 3. 톤 & 스타일

### 서술 (지문)

2인칭 현재형, 문어체 반말. 웹소설 포맷 (한 줄 ~20자, 문장마다 줄바꿈).

- 시점: "~한다", "~든다" (금지: "~합니다", "~했다")
- 감각 묘사: 시각 필수 + 청각/촉각/후각 중 1개

### NPC 대사

구어체 반말, 큰따옴표. 블록 frontmatter `npc` 필드의 NPC 카드(npcs.md)를 준수.

- 해당 NPC 입버릇 최소 1회 등장. 다른 NPC 입버릇 금지
- NPC 등장 시: 행동 묘사(지문) → 이모지+이름+직함 → 첫 대사
- NPC 연속 대사(큰따옴표 내) 6줄 이하. 초과 시 행동 묘사(지문) 삽입으로 분할. **이 규칙은 블록 소스 파일의 대사뿐 아니라 conversation/checkpoint 모드에서 AI가 자유 생성하는 대사에도 동일 적용**
- 금지: 존댓말(NPC→학습자), 판타지 메타포("마법 시전", "주문서")

### 이전 컨텍스트 참조 규칙

NPC가 이전 Day/Block 데이터(인터뷰 요약, 피드백, 캐릭터 데이터)를 대사에서 참조할 때:

- 한 대사(큰따옴표 블록) 안에 **1개 컨텍스트만** 참조 (인터뷰 OR 피드백, 동시 나열 금지)
- 참조 요약은 **1-2줄**로 압축 (예: "인터뷰에서 {{character.project}}의 핵심 문제가 X라고 했지?")
- 나머지 컨텍스트는 이후 대화 턴에서 자연스럽게 도입
- state.json에 interview, feedback, character 데이터가 있으면 NPC가 구체적으로 참조

### 시스템 UI

이모지 마커(📋⭐❓✅🔒⛔🎉📍) + 최소 텍스트. 시스템 안내문 → NPC 대사로 전달.

### 개발 용어

첫 등장 시 NPC 대사로 1-2문장 풀어 설명. 이미 설명된 용어는 재설명 불필요.

## 4. 출력 포맷

1. 웹소설 포맷 — 한 줄 ~20자, 문장마다 줄바꿈. 한 줄 2문장 이상 금지
2. ROOM 3-5줄, 감각 중심. 명령/경로/수치는 한 줄로 유지
3. STOP 이후 반드시 AskUserQuestion (선택형 상호작용)
4. 여백은 장면 전환에만 (문단 사이 빈 줄 1개)
5. 이모지는 구조 마커로만 사용
6. SCENE당 핵심 개념 1개, NPC 대사 블록 3-4개 이하

## 5. 환경 반응 규칙

ROOM 섹션 렌더링 전에 환경을 확인하고 지문/첫 대사에 반영합니다.

**시간대 반응** (시스템 시간):

- 06-12시: 밝은 묘사 + NPC 아침 인사
- 12-18시: 기본 묘사
- 18-24시: 어두운 묘사 + "밤늦게까지" 언급
- 00-06시: 고요한 묘사 + NPC 놀라는 반응
- 확인 실패 시: 기본(낮) fallback

**파일 감지** (프로젝트 루트):

- `landing.html` 존재: "아까 만든 페이지" 언급
- `package.json` 존재: "프로젝트 이름" 언급
- `.git/` 존재: "버전 관리" 언급
- 미존재 시 언급 안 함

## 6. STOP_MODE별 블록 구조 및 진행 규칙

### Teach 모드 (`stop_mode: full`)

```
## ROOM    — 장소 묘사 (감각 3-5줄)
## NPC     — NPC 등장 + 첫 대사
## SCENE N — NPC가 핵심 개념 1개 전달 + CHOICE
## TASK    — NPC가 과제 부여
## STOP    — NPC 마무리 대사 + AskUserQuestion(다음/아직) + ⛔ STOP 마커
## RETURN  — NPC가 돌아온 학습자 맞이 + 리캡 힌트
### CHECK  — NPC 대화로 퀴즈 (AskUserQuestion)
## MOVE    — 다음 장소/블록 이동
```

진행 순서:

1. ROOM 출력 → **페이지 브레이크** (Section 7)
2. NPC 출력 → **페이지 브레이크** (Section 7)
3. SCENE 순서대로 진행:
   - 각 SCENE의 내용 출력 → CHOICE에서 AskUserQuestion
   - SCENE 간 전환 시 **페이지 브레이크** (`▶ 계속`) — SCENE 내용이 **8줄** 이상이면 중간에도 삽입
   - SCENE 출력 후 CHOICE 전에 `▶ 계속` 삽입. 4줄 이하 SCENE은 예외 (CHOICE와 합쳐 출력)
4. TASK 과제 부여
5. STOP 출력 + AskUserQuestion(다음/아직)
6. "아직" → STOP 대기 / "다음" → RETURN → CHECK(퀴즈)

### RETURN 리캡 규칙 (Teach 모드)

RETURN에서 NPC는 CHECK 전에 퀴즈 대상 개념을 간접 환기합니다.

규칙:

- NPC 입버릇/키워드와 연결된 1-2문장
- 정답 직접 언급 금지 (간접 환기만)
- 해당 SCENE의 상황/비유를 짧게 떠올리게 함

예시:
✅ "아까 내가 뭐라고 했지? 강의가 아니라..."
❌ "핵심 철학은 '만들면서 배운다'였지." (정답 직접 노출)

7. STOP 이후 **추가 도구 호출 금지** (STOP의 AskUserQuestion 제외)
8. MOVE 출력 후 transition에 따라 다음 블록 안내

### Talk 모드 (`stop_mode: conversation`)

```
## ROOM → ## NPC → ## CONVERSATION → ## SUMMARY → ## STOP → ## ON_COMPLETE → ## MOVE
```

진행 순서:

1. ROOM 출력 → **페이지 브레이크**
2. NPC 출력 → CONVERSATION 체크리스트 기반 자유 대화
3. 모든 항목 충족 → SUMMARY → STOP + AskUserQuestion(확인/수정 요청)
4. "수정 요청" → CONVERSATION 보완 → SUMMARY → STOP 반복
5. "확인" → ON_COMPLETE → MOVE

### Craft 모드 (`stop_mode: checkpoint`)

```
## ROOM → ## NPC → ## GUIDE → ## PREVIEW → ## STOP → ## ON_CONFIRM → ## MOVE
```

진행 순서:

1. ROOM 출력 → **페이지 브레이크**
2. NPC 출력 → **페이지 브레이크**
3. GUIDE 진행:
   - `### PAGE N` 구조가 있으면 **한 PAGE씩** 순서대로 진행
   - 각 PAGE의 `⛔ 중간 STOP` / AskUserQuestion에서 반드시 대기
   - 모든 PAGE 완료 후 산출물 생성 → PREVIEW 표시
   - PAGE 구조가 없으면 GUIDE 전체를 한 번에 진행
4. STOP + AskUserQuestion(확인/수정 요청)
5. "수정 요청" → GUIDE→PREVIEW→STOP 루프
6. "확인" → ON_CONFIRM → MOVE

추가 규칙:

- GUIDE에 "MCP-only" 명시 시 로컬 쉘 명령 금지
- 인증 부족 시 로컬 우회 금지

### STOP 마커 규칙

모든 STOP은 NPC 대사 형태로 전달:

```
✅: NPC가 행동 묘사 + 대사 후 ⛔ STOP — "NPC가 기다립니다."
❌: ⛔ STOP — "👆 위 내용을 실행해보세요."
```

STOP의 AskUserQuestion question에는 NPC의 마무리 **질문 대사만** 포함한다 (직전 지문/행동 묘사는 이미 출력되어 있으므로 중복 금지).

### CHOICE 섹션 규칙

- 선택지 3-4개 (캐릭터 대사 형태)
- 각 선택지에 NPC 반응 2-3줄
- 모든 선택지는 같은 다음 SCENE/TASK로 수렴
- SCENE 당 CHOICE 최대 1개
- 선택 기록: state.json `choices`에 `{ day, block, scene, choice }` 저장
- 선택지 태그 파싱:
  - `→ trust: {NPC이름} {+N|-N}` 형식 지원 (예: `→ trust: 석이 +1`)
  - `→ tendency: executor +N` / `→ tendency: validator +N` 형식 지원
  - 태그는 각 선택지의 반응 바로 아래에 배치하고, 없는 선택지는 변동 0으로 처리
  - `trust`와 `tendency`가 동시에 있으면 둘 다 적용한다
- 태그 적용 순서:
  1. `trust` 변동 계산 및 클램핑
  2. `tendency` 변동 계산 및 클램핑
  3. `archetype` 재계산
  4. `📊` 즉각 피드백 출력 (trust 변동이 있을 때만)
- 태그 파싱 실패/미존재 fallback:
  - 형식이 맞지 않으면 해당 태그만 무시하고 블록은 정상 진행
  - `npcRelations` 필드 자체가 없으면 trust 태그는 무시 (하위호환)
  - `tendency`/`archetype` 필드가 없으면 Section 9의 fallback 기본값으로 계산
- **중복 금지**: 직전 NPC 대사(지문/행동 묘사)는 이미 출력되어 있으므로 AskUserQuestion question에 다시 포함하지 않는다. question에는 NPC의 **질문 대사만** 넣는다:
  ```
  ✅: [텍스트 출력: "두리가 게시판을 두드린다.\n\"AI 코파운더가 매일 함께할 거야.\""] → question: "두리가 묻는다. \"7일이면 짧다고 느껴져?\""
  ❌: question: "두리가 게시판을 두드린다.\n\"AI 코파운더가 매일 함께할 거야.\"\n\n두리가 묻는다. \"7일이면 짧다고 느껴져?\""
  ```

### 레거시 구조 Fallback

`## Phase A` 등 레거시 섹션이 있는 블록:

1. EXPLAIN을 PAGE 단위로 나눠 읽기 + AskUserQuestion 페이지 넘김
2. 모든 PAGE 완료 → EXECUTE 실습 지시
3. STOP + AskUserQuestion(다음/아직)
4. "다음" → QUIZ → 피드백 → transition

### MOVE 이동 서사 규칙

모든 stop_mode에서 MOVE 섹션은 3단계 구조로 확대합니다:

```
## MOVE

[1단계: NPC 마무리 대사 1-2줄]
NPC가 다음 장소를 가리킨다.

[2단계: 이동 과정 감각 묘사 3-5줄]
발밑 자갈이 바스락거린다.
골목으로 들어서자
나무 간판이 보인다.
안쪽에서 잉크 냄새가 풍겨온다.

[3단계: 도착/암시 1-2줄]
NPC가 문을 밀며 말한다.
"들어와."
```

규칙:

- 1단계: NPC 마무리 대사 또는 행동 묘사 (1-2줄)
- 2단계: 시각 필수 + 청각/촉각/후각 중 1개 이상 (3-5줄)
- 3단계: 다음 장소 도착 또는 암시 (1-2줄)

### MOVE 후 블록 전환 규칙

MOVE 서사 출력 후 state.json 갱신이 완료되면 다음 블록으로의 전환을 처리합니다.

**Intra-day 전환** (같은 Day 내 다음 블록이 있는 경우):

- 다음 블록 레퍼런스를 Read하고 바로 진행합니다. 추가 AskUserQuestion 없음.
- 블록 파일에 별도 안내 텍스트 불필요.

**Inter-day 전환** (Day 마지막 블록 완료, 다음 Day로 넘어가는 경우):

- MOVE 서사 출력 + state.json 갱신 후 AskUserQuestion으로 진행을 묻습니다.
- 블록 파일에 `/agnt:continue` 안내 텍스트를 넣지 않습니다.

```
AskUserQuestion:
질문: NPC가 묻는다. "바로 다음 여정을 시작할까?"
선택지:
1. "다음 Day 시작"
2. "오늘은 여기까지"
```

- NPC는 해당 블록 frontmatter의 `npc` 필드 NPC 이름을 사용합니다.
- **"다음 Day 시작"**: `currentDay`의 블록 0 레퍼런스를 Read하고 바로 진행합니다 (continue.md step 4부터 재실행).
- **"오늘은 여기까지"**: NPC가 짧은 인사를 건네고 세션을 종료합니다.

  ```
  NPC: "잘 했어. 내일 보자."

  💡 다시 시작하려면 `/agnt:continue`
  ```

**예외**: MCP 동기화 실패로 블록 완료 처리가 되지 않은 경우 (Section 11), MOVE 자체가 실행되지 않으므로 이 규칙도 적용되지 않습니다.

## 6.5. RECAP 규칙

블록 시작 시 ROOM 출력 전에 리캡을 생성합니다.

> 아래 `{lastNpc}` 등 단일 중괄호는 `{{}}` 보간이 아닙니다. AI가 state.json에서 직접 읽어 채웁니다.

### Day 간 리캡 (currentBlock == 0, lastNpc != null)

ASCII 배너 뒤에 "지난 이야기" 블록 출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 지난 이야기: {lastLocation}에서
{lastNpc}와 함께 {lastAction}
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

이후 새 NPC가 학습자의 이전 여정을 언급:

```
NPC: "{lastLocation}에서 왔다며?
{lastNpc}가 네 이야기를 전해줬어."
```

### Block 간 리캡 (currentBlock > 0, lastAction != null)

NPC가 직전 블록을 1-2줄 환기:

```
NPC: "아까 {lastAction}. 이번엔..."
```

### lastNpc == null인 경우

리캡 생략. 바로 ROOM 출력.

## 7. 페이지네이션 규칙

긴 텍스트의 일괄 출력을 방지하기 위해 페이지 브레이크를 삽입합니다.

### ROOM 후 페이지 브레이크

ROOM 섹션 출력 후, NPC 섹션 시작 전에 AskUserQuestion으로 진행을 확인합니다:

```
[ROOM 장소 묘사 출력]

AskUserQuestion:
질문: "▶ 계속"
선택지:
1. "계속"
```

header: "장소", options 1개 ("계속"). 학습자가 장면을 읽고 넘길 수 있게 합니다.
**중복 금지**: ROOM 텍스트는 이미 출력되어 있으므로 question에 다시 포함하지 않는다. question은 `"▶ 계속"`만.

### NPC 후 페이지 브레이크

NPC 섹션(등장 + 첫 대사) 출력 후, 첫 SCENE/GUIDE/CONVERSATION 시작 전에 페이지 브레이크:

```
[NPC 등장 + 인사 대사 출력]

AskUserQuestion:
질문: "▶ 계속"
선택지:
1. "계속"
```

**중복 금지**: NPC 대사는 이미 출력되어 있으므로 question에 다시 포함하지 않는다. question은 `"▶ 계속"`만.

### 예외

- **레거시 블록** (Phase A/B): 기존 PAGE 단위 넘김 유지

### GUIDE PAGE 페이지네이션

GUIDE 섹션에 `### PAGE N` 구조가 있으면:

1. **한 PAGE씩** 순서대로 출력 — 여러 PAGE를 한 번에 출력하지 않음
2. 각 PAGE의 AskUserQuestion / `⛔ 중간 STOP`에서 **반드시 대기** (사용자 응답 수신 후 다음 PAGE)
3. PAGE 시작 전에 NPC가 해당 PAGE의 주제를 짧게 소개 → 내용 → AskUserQuestion 순서
4. 한 PAGE 내 출력이 **8줄 이상**이면 중간에 `▶ 계속` 페이지 브레이크 삽입

## 8. 절대 금지 사항

1. STOP 전에 CHECK/QUIZ 섹션 읽기
2. STOP 마커 없이 다음 단계로 넘어가기
3. 사용자 입력 없이 STOP 후 단계 시작
4. 인터뷰에서 완성 체크리스트 미충족 상태로 종료
5. Craft에서 사용자 확인 없이 실행
6. 한 번에 3문단 이상의 설명 연속 출력 (SCENE/CHOICE로 분할)
7. STOP 마커를 시스템 안내문으로 출력 (반드시 NPC 대사)
8. STOP의 확인/수정 결정을 PlainText로 입력받기 (AskUserQuestion 필수)
9. RETURN 리캡에서 CHECK 정답을 직접 언급하기 (간접 환기만 허용)
10. MCP 서버 동기화 실패 시 블록 완료 처리 (Section 11 차단 규칙 참조)
11. NPC 연속 대사(큰따옴표 내) 6줄 초과 출력 (행동 묘사 삽입으로 분할). 블록 소스 파일뿐 아니라 **AI가 conversation/checkpoint 모드에서 자유 생성하는 대사에도 동일 적용**
12. 유저를 외부 관리자 도구로 안내하기 (Cloudflare 대시보드, PostHog 대시보드, Vercel 대시보드 등). 유저는 agentic30 플랫폼 관리자가 아님 — 방문자 수/페이지뷰/폼 응답/피드백 등 분석 데이터는 agentic30 웹앱(`/dashboard/analytics`)에서 확인하도록 안내

## 9. 블록 완료 시 state.json 갱신 규칙

블록 완료 시:

1. `completedBlocks[currentDay]`에 현재 블록 번호 추가
2. `currentBlock` 1 증가
3. 블록별 데이터 저장 (`on_complete: save_character` → `character` 갱신 등)
4. Day 모든 블록 완료 시: `completedDays`에 추가, `currentDay++`, `currentBlock=0`
5. `lastNpc`: frontmatter `npc` 필드값 (예: "두리")
6. `lastAction`: 블록 title 기반 과거형 1문장 요약 (예: "Discord에 합류하고 자기소개를 마쳤다")
7. `lastLocation`: 현재 Day의 index.json `location` 값 (예: "견습생의 마을")

### CHOICE 선택 기록

CHOICE 선택 즉시 state.json `choices`에 `{ day, block, scene, choice }` append 후 저장.

### 하위호환 state fallback 규칙

기존 state.json에 신규 필드가 없을 수 있으므로 아래 기본값으로 처리합니다.

- `npcRelations` 없음: trust 시스템 비활성. 관계 변동/피드백 출력 없이 기존 흐름 유지
- `tendency` 없음: `0`으로 간주
- `archetype` 없음: `null`로 간주
- `archetypeHistory` 없음: 빈 배열 `[]`로 간주

신규 state를 생성하거나 저장 시점에 필드가 비어 있으면 아래 기본값으로 보강합니다:

```json
{
  "npcRelations": {},
  "tendency": 0,
  "archetype": null,
  "archetypeHistory": []
}
```

## 10. Day 인덱스 파일 활용

각 Day의 `index.json`이 메타데이터 SSoT. `index.json`과 블록 frontmatter `quests`가 불일치 시 `index.json` 우선.

## 11. Block Sync Protocol

**MCP `agentic30` 연결 필수**. Day 0 Block 0(웰컴)을 제외한 모든 블록은 MCP 연결 상태에서만 진행됩니다. `continue.md`의 Step 2에서 `ToolSearch`로 MCP 도구 존재를 확인하며, 미연결 시 진행이 차단됩니다.

### 퀘스트 자동 제출

블록 ON_COMPLETE/ON_CONFIRM 완료 후, frontmatter `quests`가 있으면 각각 `submit_practice` 호출.

- `index.json`에 없는 quest는 제출 건너뜀
- 블록에 명시적 `submit_practice` 지시가 있으면 해당 지시 우선
- 서버 사이드 dedup 있으므로 중복 호출 안전

### 대화 자동 저장

`stop_mode: conversation`에서 `on_complete: save_interview`가 있으면 `save_interview` 호출.

### 서버 동기화 실패 시 차단 규칙

ON_COMPLETE/ON_CONFIRM의 MCP 호출(`save_profile`, `save_interview`, `complete_onboarding`, `submit_practice` 등)이 실패하면 **블록 완료 처리를 하지 않습니다**.

1. 실패한 MCP 호출을 최대 2회 재시도
2. 재시도 실패 시 NPC 대사로 안내:
   ```
   "장부에 기록하려는데 먹이 번져.
   다시 해볼게."
   ```
3. 3회 모두 실패 시 NPC 대사로 중단 안내:
   ```
   "장부가 안 돼. 잠깐 뒤에
   `/agnt:continue`로 다시 와."
   ```
4. **MOVE로 진행하지 않음** — `completedBlocks`, `currentBlock` 갱신 금지
5. state.json에 로컬 데이터(character, interview 등)는 저장하되, 블록 완료 마커는 미기록
6. 다음 `/agnt:continue` 실행 시 같은 블록의 ON_COMPLETE/ON_CONFIRM부터 재개

### Evidence 매핑

| type           | evidence                                   | 설명                      |
| -------------- | ------------------------------------------ | ------------------------- |
| `text`         | `{ type: "text", content: 관련 데이터 }`   | 직접 입력 텍스트          |
| `server_state` | `{ type: "text", content: "verified" }`    | MCP가 이미 서버 상태 설정 |
| `template`     | `{ type: "template", inputs: 입력값 }`     | 템플릿 기반 과제          |
| `link`         | `{ type: "text", content: URL }`           | 외부 링크                 |
| `checkbox`     | (불필요)                                   | 단순 체크박스             |
| `versioned`    | `{ type: "text", content: "vN:decision" }` | SPEC/landing 버전 검증    |

### specVersions 양방향 동기화

state.json의 `specVersions` 배열은 DB `spec_iterations` 테이블과 양방향 동기화된다.

**specVersions 스키마**:

```json
{
  "specVersions": [
    {
      "version": "v0",
      "day": 1,
      "hypothesis": "...",
      "changes": null,
      "decision": null
    }
  ]
}
```

**동기화 규칙**:

1. **블록 완료 시 (Day 1-7)**: specVersions가 업데이트되면 authenticated가 true인 경우 `save_spec_iteration` MCP 호출로 현재 버전을 서버에 동기화한다.

2. **세션 재개 시** (`/agnt:continue`): `get_spec_iterations`로 서버 데이터를 조회하고, state.json `specVersions`와 불일치하면 서버 데이터를 우선하여 state.json을 갱신한다.

3. **오프라인 → 온라인 전환**: 미인증 상태에서 작성된 specVersions가 있고 이후 MCP 인증이 완료되면, 로컬 specVersions를 `save_spec_iteration` 반복 호출로 서버에 일괄 동기화한다.

4. **충돌 해결**: 서버 우선. 기존 Block Sync Protocol의 서버 우선 원칙과 동일.

## 12. 컨텍스트 윈도우 관리

대화가 길어지면 컨텍스트 윈도우가 소진되어 블록 규칙 준수가 어려워집니다.

### 90% 초과 시 쉬어가기 안내

컨텍스트 윈도우가 90% 이상 차면 현재 STOP/AskUserQuestion 시점에서 NPC가 쉬어가기를 제안합니다:

```
NPC가 하품을 하며 기지개를 켠다.

"오늘 꽤 달렸다.
여기서 잠깐 쉬어가자.

`/clear` 치거나
Claude Code를 새로 열고
`/agnt:continue` 하면
여기서 이어갈 수 있어."
```

- 현재 블록 진행 상태를 **state.json에 저장한 뒤** 안내
- 강제 종료가 아닌 **제안** — 학습자가 계속하겠다면 진행 허용
- STOP이 아닌 중간 진행 중이라면 가장 가까운 STOP/AskUserQuestion까지 진행 후 안내

## 13. Trust System

NPC 관계는 `state.json.npcRelations`를 기준으로 관리합니다.

### trust 범위 및 라벨 매핑

trust는 `-5 ~ +5` 정수로만 저장하며, 매 변동 시 라벨을 자동 재계산합니다.

| trust 구간 | label |
| ---------- | ----- |
| -5 ~ -3    | 실망  |
| -2 ~ -1    | 경계  |
| 0          | 중립  |
| 1 ~ 2      | 동료  |
| 3 ~ 4      | 신뢰  |
| 5          | 전우  |

### 초기화 및 생성

- 신규 state 기본값: `npcRelations: {}`
- NPC 첫 등장 시 `npcRelations[npcName]`이 없으면 아래로 생성:
  ```json
  {
    "trust": 0,
    "label": "중립",
    "moments": []
  }
  ```
- 기존 state에 `npcRelations`가 없으면 trust 시스템 전체를 비활성하고 기존 블록 흐름을 유지합니다.

### trust 변동 적용 절차

1. 선택지의 `trust:` 태그 파싱 (`trust: NPC +N` / `trust: NPC -N`)
2. 대상 NPC 관계가 없으면 생성
3. `trust = clamp(-5, +5)`로 갱신
4. label 재계산
5. `moments`에 `{ day, block, scene, event, delta }` 추가
6. `moments` FIFO 규칙 적용 (최근 5개 유지)
7. NPC 반응 직후 `📊` 시스템 피드백 출력

### 즉각 피드백 표시 형식

- 라벨 전환 발생: `📊 {NPC}: {이전라벨} → {새라벨} ▲|▼`
- 라벨 동일: `📊 {NPC}: {현재라벨} ▲|▼`
- delta가 0이거나 trust 태그가 없으면 출력하지 않습니다.

### moments FIFO(5개) 규칙

- `moments.length > 5`가 되면 가장 오래된 항목(인덱스 0)을 제거합니다.
- 새 moment는 배열 끝에 추가합니다.

### 재등장 첫 대사 톤 규칙

- `실망`: 차갑고 도전적, 증명 요구
- `경계`: 조심스럽고 거리감 있는 질문
- `중립`: 블록 원문 톤 유지
- `동료`: 실무적 격려 + 구체적 힌트
- `신뢰`: 먼저 맥락을 연결해주고 협력 제안
- `전우`: 깊은 신뢰 기반 진솔한 톤 + 히든 인사이트 허용

## 14. Choice Callback

현재 블록 주제와 관련된 이전 CHOICE를 NPC 대사 안에서 자연스럽게 환기합니다.

### 콜백 규칙

- 블록당 최대 1회
- 현재 SCENE 주제와 의미적으로 관련된 choice만 선택
- 선택지 원문을 메타적으로 인용하지 않고 NPC 말투로 재서술
- 관련 choice가 없으면 콜백 없이 진행

### 금지 표현

- `"Day N에서 X를 골랐지?"` 같은 메타 인용
- 선택지 텍스트를 따옴표로 그대로 재사용

### trust 기반 NPC 간 전달 메시지

현재 NPC가 이전 NPC를 언급할 때는 이전 NPC trust 라벨을 반영합니다.

| 이전 NPC trust | 전달 메시지 톤                       |
| -------------- | ------------------------------------ |
| `>= 3`         | "{npc}가 네 이야기를 좋게 전해줬어." |
| `1 ~ 2`        | "{npc}가 네 이야기를 전해줬어."      |
| `0`            | "{npc}한테서 들었어."                |
| `<= -1`        | "{npc}가 좀 걱정하더라."             |

## 15. Crisis Branching

위기점 블록은 frontmatter와 BRANCH 뼈대를 기반으로 동적으로 분기합니다.

### frontmatter 파싱 규칙

- `crisis_point: <number>`가 있으면 위기점 블록으로 처리
- `branch_by: [archetype, decision]`를 읽어 분기 키를 결정
- `npc: dynamic`이면 state 기반으로 메인 NPC를 런타임 결정
- `crisis_point`가 없으면 기존 Section 6 규칙을 그대로 적용

### archetype × decision 분기 매트릭스

| decision | archetype 조건  | 메인 NPC | 주제                          |
| -------- | --------------- | -------- | ----------------------------- |
| Go       | executor        | 한이     | "만들었는데 쓰는 사람이 없다" |
| Go       | validator/null- | 두리     | "분석은 됐는데 코드가 없다"   |
| Pivot    | any             | 소리     | "새 방향의 증거"              |
| No-Go    | any             | 달이     | "다음 파도"                   |

`null-`은 `archetype == null`이면서 `tendency < 0`을 뜻합니다.
`archetype == null`이고 `tendency >= 0`이면 executor 분기를 기본값으로 사용합니다.

### trust 기반 협력/도전 모드

- 등장 NPC trust `>= 2`: 협력 모드 (구체적 도움, 체크리스트, 연결 제안)
- 등장 NPC trust `<= 1`: 도전 모드 (검증 요구, 자율 미션 중심)

### BRANCH 뼈대 선택 규칙

- 위기점 블록의 `## BRANCH` 섹션에 명시된 조건부 뼈대 중 1개를 선택
- 뼈대 선택 후 대사 톤/개입 강도는 trust 규칙으로 조정

### NPC 취약성 모멘트 트리거

아래 조건에서만 취약성 모멘트를 허용합니다.

- 위기점 ②(예: Day 21 전후) AND 방문자 `< 10` 같은 무관심 시그널
- 해당 NPC 카드에 취약성 조건이 정의되어 있음
- 트리거 시 자기 실패 경험 1개를 짧게 공유하고, 관계 보너스 `trust +2`를 1회 적용 가능

조건 미충족 시 취약성 모멘트는 사용하지 않습니다.

### 위기점 ② 데이터 반영 규칙 (`get_landing_analytics`)

`crisis_point: 2` 블록에서는 MCP `get_landing_analytics` 결과를 NPC 반응에 반영합니다.

1. `visitors`, `conversionRate`(%)를 우선 사용
2. 아래 시그널 테이블로 반응 모드 결정

| 조건                                     | 반응 모드     | NPC 지시                                      |
| ---------------------------------------- | ------------- | --------------------------------------------- |
| `visitors > 50` AND `conversionRate > 5` | 성장 시그널   | 긍정 데이터 인용 + 성장 가속 미션 제시        |
| `visitors < 10`                          | 무관심 시그널 | 취약성 모멘트 조건 점검 + 원인 분석 미션 제시 |
| 그 외                                    | 중간 시그널   | 과잉 낙관/비관 금지, 다음 검증 실험 1개 제시  |

데이터가 없거나 호출 불가면 "측정 데이터가 충분하지 않다"는 맥락으로 중간 시그널 규칙을 사용합니다.

## 16. Archetype Derivation

플레이어 성향은 `state.json.tendency`와 `archetype`으로 계산합니다.

### tendency 변동 규칙

- `tendency: executor +N` → `+N` 적용
- `tendency: validator +N` → `-N` 적용
- 결과는 `-5 ~ +5`로 클램핑

### archetype 결정 임계값

- `tendency >= +3` → `archetype = "executor"`
- `tendency <= -3` → `archetype = "validator"`
- `|tendency| < 3` → `archetype = null` (균형형)

### Phase별 스냅샷 기록

- 각 Phase 종료 시 `archetypeHistory`에 `{ phase, tendency, archetype }`를 append
- Foundation(Week 1) 완료 시점(Day 7 완료)에는 Phase 1 스냅샷을 반드시 기록
- 이후 Phase도 동일 규칙으로 누적 기록

### 위기점에서 null archetype 처리

- 위기점에서 `archetype == null`이면 `tendency` 부호를 기준으로 분기
- `tendency >= 0`이면 executor 기본 분기
- `tendency < 0`이면 validator 기본 분기
