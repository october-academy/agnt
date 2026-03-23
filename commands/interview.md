고객 인터뷰 워크플로우. Mom Test 원칙으로 실제 고객과 대화하여 가설을 검증합니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색.

## 출력 규칙

내부 로직 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 2` → `/agnt:start`로 안내 후 종료
- `project.problem == null` → "먼저 `/agnt:discover`로 문제를 정의하세요." 종료

### 2. 인터뷰 번호 결정

현재 `artifacts.interviews` 값으로 N번째 인터뷰 결정.
- N = `artifacts.interviews + 1`
- N > 3이면 추가 인터뷰 (제한 없음, quest 보상은 3회까지)

### 3. 인터뷰 가이드 표시

`{REFS_DIR}/shared/interview-guide.md`를 Read (없으면 내장 원칙 사용).

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  고객 인터뷰 {N}회차
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

문제: {project.problem}
ICP: {project.icp}

인터뷰 핵심 원칙 (Mom Test):
• 과거 경험만 묻는다 — "마지막으로 그 문제를 겪었을 때..."
• 미래 의향 질문 금지 — "사용하시겠어요?"는 거짓 긍정
• 칭찬이 아닌 행동을 끌어낸다

준비할 것:
1. ICP에 해당하는 사람 1명을 찾아라
2. 15-20분 대화할 시간을 잡아라
3. 아래 질문 가이드를 참고해라
```

### 4. 질문 가이드

```
📋 질문 가이드 (5개 핵심 질문)

1. "{problem} 관련해서 마지막으로 뭘 했어요?"
   → 실제 행동 확인

2. "그때 가장 힘들었던 부분은 뭐였어요?"
   → 진짜 고통점 발견

3. "지금은 어떻게 해결하고 있어요?"
   → 현재 대안 파악

4. "그 방법에서 가장 불만족스러운 점은?"
   → 대안의 약점 확인

5. "이 문제 해결에 돈을 쓴 적 있어요? 얼마나?"
   → 지불 의향 검증
```

### 5. 인터뷰 실행

AskUserQuestion: "인터뷰 준비가 됐어?"
- A) 됐어. 인터뷰를 진행했어 — 결과 입력으로 이동
- B) 아직 — 사람을 찾는 방법을 알려줘

**B 선택 시** — 찾기 가이드:
```
ICP를 찾는 곳:
• 주변 지인 중 해당하는 사람
• 관련 온라인 커뮤니티 (OKKY, GeekNews, Reddit)
• Threads / LinkedIn DM
• 오프라인 모임 / 밋업

팁: "인터뷰해주세요"보다 "조언 좀 구하고 싶어요"가 응답률 높아.
15분이면 충분해.
```

다시 AskUserQuestion: "준비되면 알려줘."
- A) 인터뷰를 진행했어

### 6. 결과 수집

AskUserQuestion: "인터뷰에서 가장 중요한 발견 3가지를 적어줘. (누구와 했는지, 뭘 배웠는지)"
- 자유 입력

### 7. 인사이트 정리 + 피드백

유저 입력을 분석하여:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  인터뷰 {N} 결과 분석
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📌 핵심 발견:
{유저 입력에서 추출한 인사이트 요약}

💡 가설 검증 상태:
• 확인된 것: {가설과 일치하는 발견}
• 도전받는 것: {가설과 다른 발견}
• 새로 발견한 것: {예상 밖 인사이트}

{N < 3이면}
다음 단계: /agnt:interview (인터뷰 {N+1}/3)
{N == 3이면}
3회 인터뷰 완료! 이제 패턴이 보일 거야.
다음 단계: /agnt:spec
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 8. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.interviews++`
- `signals.interview_insights++`
- `meta.last_action` = `"interview"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-interview-{N}"` (N ≤ 3일 때만)
- N > 3이면 MCP 제출 건너뜀 (추가 인터뷰는 보상 없음)

도구 없으면: MCP 미연결 안내.

## 규칙

- 인터뷰는 에이전트가 하는 게 아니라 **유저가 실제 사람과** 한다
- 에이전트는 가이드 + 결과 분석만 수행
- Mom Test 원칙 위반하는 질문이 보이면 피드백 (미래 의향 질문 등)
- 인터뷰 횟수 제한 없음 (3회 이상도 가능, quest 보상만 3회까지)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
