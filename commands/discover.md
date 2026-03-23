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
- `meta.schema_version != 2` → "먼저 `/agnt:start`로 업그레이드하세요." 종료

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

AskUserQuestion: "그 문제를 가장 절실하게 겪는 사람은 누구야? (나이, 직업, 상황, 예산)"
- 자유 입력

### 6. 가설 수립

```
마지막으로, 가설을 세우자.
"[ICP]가 [문제]를 해결하기 위해 [솔루션]에 [금액]을 낼 것이다"
```

AskUserQuestion: "위 형식으로 가설을 적어봐. 금액은 대략적이어도 돼."
- 자유 입력

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

### 8. MCP 제출

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `save_interview` 호출: problem, icp, hypothesis를 저장
- `submit_practice` 호출: quest_id = `"wf-discover"`

도구 없으면:
```
⚠️ MCP 미연결 — 로컬에만 저장했어. /mcp에서 연결하면 서버에도 기록돼.
```

## 규칙

- 유저 답변을 그대로 저장하지 않고 **정리해서** 저장 (핵심만 추출)
- 질문은 짧고 직접적으로 — 프레임워크 용어 사용하지 않음
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
