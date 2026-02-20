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

| 변수 | 소스 | 예시 |
|------|------|------|
| `{{character.project}}` | state.json → character.project | "밥친구" |
| `{{character.motivation}}` | state.json → character.motivation | "혼밥이 싫어서" |
| `{{character.target}}` | state.json → character.target | "1인 가구 직장인" |
| `{{character.strengths}}` | state.json → character.strengths | "풀스택 개발" |
| `{{state.level}}` | state.json → level | "3" |
| `{{state.title}}` | state.json → title | "탐험가" |
| `{{state.xp}}` | state.json → xp | "250" |
| `{{state.currentDay}}` | state.json → currentDay | "2" |

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
- 금지: 존댓말(NPC→학습자), 판타지 메타포("마법 시전", "주문서")

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
3. SCENE 순서대로 진행, 각 SCENE의 CHOICE에서 AskUserQuestion
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
2. NPC 출력 → GUIDE에 따라 산출물 생성 → PREVIEW 표시
3. STOP + AskUserQuestion(확인/수정 요청)
4. "수정 요청" → GUIDE→PREVIEW→STOP 루프
5. "확인" → ON_CONFIRM → MOVE

추가 규칙:
- GUIDE에 "MCP-only" 명시 시 로컬 쉘 명령 금지
- 인증 부족 시 로컬 우회 금지

### STOP 마커 규칙

모든 STOP은 NPC 대사 형태로 전달:
```
✅: NPC가 행동 묘사 + 대사 후 ⛔ STOP — "NPC가 기다립니다."
❌: ⛔ STOP — "👆 위 내용을 실행해보세요."
```
STOP의 AskUserQuestion에도 **가림 방지** 적용: NPC 마무리 대사를 question 텍스트에 포함한다.

### CHOICE 섹션 규칙
- 선택지 3-4개 (캐릭터 대사 형태)
- 각 선택지에 NPC 반응 2-3줄
- 모든 선택지는 같은 다음 SCENE/TASK로 수렴
- SCENE 당 CHOICE 최대 1개
- 선택 기록: state.json `choices`에 `{ day, block, scene, choice }` 저장
- **가림 방지**: CHOICE 직전 NPC 대사(3줄 이내)는 AskUserQuestion의 question 텍스트 앞에 포함한다. AskUserQuestion 위젯이 직전 텍스트를 가릴 수 있으므로, 대사 → 질문을 하나의 question 필드로 합친다:
  ```
  ✅: question: "두리가 게시판을 두드린다.\n\"AI 코파운더가 매일 함께할 거야.\"\n\n두리가 묻는다. \"7일이면 짧다고 느껴져?\""
  ❌: [텍스트 출력: "AI 코파운더가 매일 함께할 거야."] → question: "두리가 묻는다. \"7일이면 짧다고 느껴져?\""
  ```

### 레거시 구조 Fallback

`## Phase A` 등 레거시 섹션이 있는 블록:
1. EXPLAIN을 PAGE 단위로 나눠 읽기 + AskUserQuestion 페이지 넘김
2. 모든 PAGE 완료 → EXECUTE 실습 지시
3. STOP + AskUserQuestion(다음/아직)
4. "다음" → QUIZ → 피드백 → transition

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
**가림 방지**: ROOM 마지막 2줄을 question에 포함 (예: `"바람에 나무 냄새가 스며든다.\n가슴이 약하게 두근거린다.\n\n▶ 계속"`).

### NPC 후 페이지 브레이크

NPC 섹션(등장 + 첫 대사) 출력 후, 첫 SCENE/GUIDE/CONVERSATION 시작 전에 페이지 브레이크:

```
[NPC 등장 + 인사 대사 출력]

AskUserQuestion:
질문: "▶ 계속"
선택지:
1. "계속"
```

**가림 방지**: NPC 마지막 대사를 question에 포함.

### 예외
- **checkpoint 모드에서 NPC가 바로 GUIDE를 시작하는 경우**: NPC 후 페이지 브레이크 생략 가능 (NPC 대사가 짧을 때)
- **레거시 블록** (Phase A/B): 기존 PAGE 단위 넘김 유지

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

## 9. 블록 완료 시 state.json 갱신 규칙

블록 완료 시:
1. `completedBlocks[currentDay]`에 현재 블록 번호 추가
2. `currentBlock` 1 증가
3. 블록별 데이터 저장 (`on_complete: save_character` → `character` 갱신 등)
4. Day 모든 블록 완료 시: `completedDays`에 추가, `currentDay++`, `currentBlock=0`

### CHOICE 선택 기록
CHOICE 선택 즉시 state.json `choices`에 `{ day, block, scene, choice }` append 후 저장.

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

### Evidence 매핑

| type | evidence | 설명 |
|------|----------|------|
| `text` | `{ type: "text", content: 관련 데이터 }` | 직접 입력 텍스트 |
| `server_state` | `{ type: "text", content: "verified" }` | MCP가 이미 서버 상태 설정 |
| `template` | `{ type: "template", inputs: 입력값 }` | 템플릿 기반 과제 |
| `link` | `{ type: "text", content: URL }` | 외부 링크 |
| `checkbox` | (불필요) | 단순 체크박스 |
