문제 선택 + ICP 정의 워크플로우. 풀 문제를 찾고, 타겟 고객을 정의하고, 가설을 세웁니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색 (navigator-engine.md의 Section 2 참조).

## 출력 규칙

내부 로직(경로 탐색, state 파싱, MCP 검색)은 무음 처리.

## 실행 절차

### 1. state 확인

`{AGNT_DIR}/state.json` Read.
- `meta.schema_version < 2` → "먼저 `/agnt:start`로 업그레이드하세요." 종료

### 2. 이미 problem이 있는 경우

`project.problem`이 null이 아니면:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  이미 문제를 정의했어
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

문제: {project.problem}
ICP: {project.icp}
가설: {project.hypothesis}
```

AskUserQuestion:
- A) 새로운 문제로 다시 시작할래 — 3단계로 이동
- B) 이대로 진행할래 — `/agnt:next`를 안내하고 종료

### 3. 문제 발견 워크플로우

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  팔리는 문제 찾기
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

좋은 문제의 3가지 조건:
1. 누군가 지금 이 순간 겪고 있다
2. 기존 대안이 불만족스럽다
3. 돈을 내고 해결할 의향이 있다
```

### 4. 문제 선택 (3단계 질문)

**Q1**: "어떤 문제를 풀고 싶어?"

AskUserQuestion:
- A) 내가 직접 겪은 문제가 있어
- B) 주변에서 본 문제가 있어
- C) 아이디어는 있는데 문제인지 모르겠어
- D) 아무것도 없어 — 찾는 것부터 도와줘

**D를 선택한 경우** — 발견 가이드:
```
아이디어가 없는 건 정상이야.
문제를 찾는 3가지 방법:

1. 불편 일기: 오늘 하루 불편했던 순간 3개를 적어봐
2. 커뮤니티 관찰: GeekNews, OKKY, Threads에서
   "~하고 싶은데", "~가 불편한데" 패턴 찾기
3. 기존 제품 리뷰: 경쟁 제품 리뷰에서 불만 패턴 찾기
```

AskUserQuestion: "위 방법 중 하나를 시도해봐. 뭘 발견했어?"
- 자유 입력

**A/B/C를 선택한 경우** — 구체화:

AskUserQuestion: "구체적으로 어떤 문제야? 상황을 설명해줘."
- 자유 입력

### 5. ICP 정의

유저 답변을 받은 후:

```
좋아. 이제 그 문제를 겪는 사람을 구체화하자.
```

AskUserQuestion: "그 문제 때문에 마지막으로 돈이나 시간을 쓴 사람 1명을 떠올려봐. 그 사람의 직업이 뭐야? 어떤 상황이야?"
- 자유 입력

### 5-bis. ICP 구체성 확인

ICP 답변 후, 아래 조건에 **하나라도** 해당하면 1회 후속 질문:

**Push-back 발동 조건** (rule-based):
- 답변이 집합명사만 포함 ("개발자", "직장인", "20대", "프리랜서")
- 구체적 상황/맥락이 없음 (직업만 있고 상황 없음)

**Push-back**:
"ICP가 너무 넓어. 가설 검증이 어려워져.
그 사람이 어떤 상황에 있는 사람이야? 예를 들면 '3년차 프론트엔드, 사이드프로젝트 경험 없음'처럼."

Push-back은 1회만. 재답변 후 진행.

### 6. 가설 수립

```
마지막으로, 가설을 세우자.
"[ICP]가 [문제]를 해결하기 위해 [솔루션]에 [금액]을 낼 것이다"
```

AskUserQuestion: "위 형식으로 가설을 적어봐. 금액은 대략적이어도 돼."
- 자유 입력

### 6-bis. Challenge (선택)

가설이 수립된 후:

AskUserQuestion: "이 가설을 한 번 뒤집어볼까?"
- A) 해보자
- B) 건너뛰고 다음으로

**A 선택 시**:
```
이 가설의 가장 취약한 가정은 뭐야?

• 아무도 이 문제를 신경 안 쓴다면?
• 기존 대안으로 충분히 만족하는 사람이 대다수라면?
• "{ICP}가 {금액}을 낼 거다" — 이걸 지지하는 신호를 하나라도 봤어?
```

AskUserQuestion: "이 가설에서 가장 확인 안 된 가정 하나를 꼽아봐."
- 자유 입력

답변에 관계없이:
```
이걸 확인하는 게 /agnt:interview의 목적이야.
```

**B 선택 시**: 바로 7단계로 진행.

### 7. 요약 + 저장

수집한 답변을 정리하여 출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  문제 정의 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📌 문제: {정리된 문제}
👤 ICP: {정리된 타겟}
💡 가설: {정리된 가설}

이 가설이 맞는지 확인하려면 실제 사람과 대화해야 해.
다음 단계: /agnt:interview
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

state.json 업데이트:
- `project.problem` = 정리된 문제
- `project.icp` = 정리된 ICP
- `project.hypothesis` = 정리된 가설
- `project.name` = 문제에서 추출한 짧은 프로젝트명 (2-4 단어)
- `meta.last_action` = `"discover"`
- `meta.total_actions++`

### 7-bis. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**`decision-brief.md`가 있고 `journey-brief.md`가 없으면**: 파일명 변경 후 사용.
**파일이 있는 경우**: `## Discovery` 섹션을 Replace.

Discovery 섹션:
```markdown
## Discovery
- 문제: {정리된 문제}
- ICP: {정리된 ICP}
- 가설: {정리된 가설}
- 취약 가정: {6-bis A선택 답변 or "(미선택)"}
```

### 8. MCP 제출

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `save_interview` 호출: problem, icp, hypothesis를 저장
- `submit_practice` 호출: quest_id = `"wf-discover"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-discover" }, "created_at": "<now()>" }
  ```
- state.json 저장

### 인라인 넛지 (1회성)

identity.mode != "synced" AND sync.last_inline_nudge_at == null인 경우:

💾 완료한 퀘스트의 XP를 받으려면 `/agnt:connect`
→ 나중에 연결해도 지금까지의 XP가 한 번에 적립돼.

sync.last_inline_nudge_at = now() 기록

## 규칙

- 유저 답변을 그대로 저장하지 않고 **정리해서** 저장 (핵심만 추출)
- 질문은 짧고 직접적으로 — 프레임워크 용어 사용하지 않음
- 가설을 칭찬하지 않는다 — 가설은 아직 검증되지 않은 추측이야
- 칭찬 금지 표현: "좋은 아이디어야", "흥미로운 문제야", "좋은 시작이야", "잘 잡았어"
- 대신: 팩트 기술만. "이 문제를 겪는 사람이 있다는 건 아직 확인 안 됨"
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
