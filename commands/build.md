MVP 스코프 가드. 과대 구축을 방지하고, 핵심만 만들도록 돕습니다.

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

- `meta.schema_version < 2` → `/agnt:start`로 안내 후 종료
- `artifacts.spec_versions < 1` → "먼저 `/agnt:spec`으로 SPEC을 작성하면 MVP 범위가 명확해져." (비강제 — 진행 가능)

### 1-bis. 재방문 감지

`meta.last_action == "build"`이고 `meta.started_at` 기준 7일 이상 경과한 경우:

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  빌드 체크포인트
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

지난번 MVP 범위를 정했어. 진행 상황을 점검하자.
```

AskUserQuestion: "핵심 기능 완성했어?"
- A) 완성했어 → "좋아. 이제 랜딩을 만들 차례야. /agnt:landing"
- B) 아직 만들고 있어 → "계속 진행해. 완성되면 다시 /agnt:build"
- C) 다른 기능도 추가하고 있어 → 과대 구축 경고 (아래)

**C 선택 시**:
```
⚠️ 과대 구축 감지

"그건 MVP에 없었는데?"
추가한 기능을 적어봐.
```

AskUserQuestion: "어떤 기능을 추가했어?"
- 자유 입력

```
그 기능은 유저가 오고, 돈을 내고 나서 추가해.
지금은 핵심 기능만 마무리하고 랜딩을 만들어.
```

A 선택 시 → 7-bis로 건너뜀 (journey-brief Write 후 완료).
B 선택 시 → 종료.
C 선택 시 → 경고 후 종료.

재방문이 아닌 경우 → 기존 흐름 (3단계 스코프 가드) 진행.

### 2. SPEC 읽기

`{AGNT_DIR}/specs/spec-v*.md` 최신 버전을 Read. 없으면 state 기반으로 진행.

### 3. 스코프 가드

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MVP 스코프 가드
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

만들 줄 아는 게 함정이야.
만들 수 있으니까 계속 기능을 추가하게 돼.
이 워크플로우는 "여기서 멈춰"를 정하는 거야.

문제: {project.problem}
ICP: {project.icp}
{SPEC이 있으면: "SPEC: v{N} — {한 줄 설명}"}
```

### 4. 핵심 기능 확인

AskUserQuestion: "지금 만들려는 핵심 기능 3개가 뭐야?"
- 자유 입력

### 5. 스코프 축소

유저 답변을 분석하여:

```
📋 스코프 점검

네가 말한 기능:
{유저 입력 요약}

질문:
• 이 중 ICP가 "이거 없으면 안 돼"라고 할 기능은 딱 1개만 고르면?
• 나머지 2개를 빼도 ICP가 가치를 느낄 수 있어?
• 2주 안에 만들 수 있어?
```

AskUserQuestion: "1개만 남긴다면 뭐야?"
- 자유 입력

### 6. MVP 체크리스트 생성

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MVP 체크리스트
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

핵심 기능: {유저가 선택한 1개}

□ {핵심 기능} 구현
□ 최소한의 UI (예쁠 필요 없음)
□ 랜딩페이지 연결
□ 사용법 안내 (1문단이면 충분)

⚠️ 아래는 MVP에서 제외:
• {유저가 말한 나머지 기능들}
• 완벽한 디자인
• 에러 처리 100%
• 자동화/최적화

이것들은 유저가 오고, 돈을 내고 나서 추가해.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 7. 안티패턴 경고

```
🚫 과대 구축 경고 신호

스스로 점검해봐:
• "이것도 있어야 할 것 같은데..." → 없어도 된다.
• "한 번에 다 만들면 시간 절약..." → 안 된다. 쪼개라.
• "디자인을 좀 더 다듬고..." → 지금이 가장 좋은 때야.
• "버그를 다 잡고 나서..." → 유저가 쓰면서 잡는 게 빠르다.

MVP의 목표: 유저가 "이거 쓸래"라고 말하게 만드는 것.
"이거 예쁘네"가 아님.
```

### 7-bis. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `## Product` 섹션 내 `- MVP 범위:` 라인을 Replace.

```markdown
- MVP 범위: {유저가 선택한 핵심 기능 1개}
```

### 8. 완료

```
다음 단계:
• 만들고 나면 → /agnt:landing (랜딩 전략)
• 이미 랜딩이 있으면 → /agnt:channel (채널 활성화)
• 현재 상태 확인 → /agnt:next
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

state.json 업데이트:
- `meta.last_action = "build"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-build"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-build" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- agnt가 코드를 대신 쓰지 않는다 — ICP가 직접 만든다
- 스코프 축소가 목적 — 기능 추가를 유도하지 않음
- SPEC이 있으면 활용, 없으면 직접 질문으로 수집
- "2주 안에 만들 수 있는 것"이 기준
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
