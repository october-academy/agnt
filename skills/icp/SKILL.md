---
user-invocable: true
name: icp
description: >-
  ICP 정의/구체화 — deep-interview 방식으로 Ideal Customer Profile 문서를 작성하고 좁힌다.
---

ICP 문서화 워크플로우. 넓은 타겟이 아니라, 지금 가장 먼저 공략할 고객 세그먼트 1개를 고정합니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색.

### ICP_DOC_PATH

아래 우선순위로 ICP 문서 경로를 결정한다:

1. 현재 작업 디렉토리의 `docs/ICP.md`
2. `docs/`가 없으면 생성 후 `docs/ICP.md`
3. 작업 디렉토리 쓰기가 어렵거나 불명확하면 `{AGNT_DIR}/docs/ICP.md`

## 출력 규칙

내부 로직 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료
- `project.problem == null` → "먼저 `/agnt:discover`로 문제를 정의해." 종료

### 2. 기존 ICP 문서 확인

`ICP_DOC_PATH` Read 시도.

문서가 이미 있고 내용이 `(미작성)` 수준이 아니면:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  기존 ICP 문서가 있어
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

문서: {ICP_DOC_PATH}
현재 ICP: {project.icp || "문서 요약에서 추출"}
버전: {artifacts.icp_versions || 1}
```

AskUserQuestion:
- A) 이어서 구체화할래
- B) 처음부터 다시 쓸래
- C) 이 문서 유지하고 종료할래

C 선택 시 `/agnt:next` 안내 후 종료.

### 3. deep-interview 모드 설명

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ICP deep-interview
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

이 단계의 목표:
1. "누구나"를 버린다
2. 가장 아픈 세그먼트 1개를 고른다
3. 왜 그 세그먼트가 먼저인지 문서로 고정한다

좋은 ICP 문서는 demographics가 아니라
상황, 트리거, 현재 대안, 돈/시간 손실이 들어간다.
```

### 4. deep-interview 질문

순차 AskUserQuestion.
기본은 선택지로 진행하고, 선택지만으로 표현이 안 될 때만 마지막에 한 줄 보정 입력을 받는다.

AskUserQuestion: "핵심 세그먼트에 가장 가까운 쪽은?"
- `project.problem`, `project.icp`, audit 결과를 바탕으로 세그먼트 후보 3-5개를 동적으로 생성
- 마지막 선택지는 항상 `기타 — 직접 입력`

F를 선택한 경우에만:
AskUserQuestion: "세그먼트를 한 줄로 적어줘. 직업 + 상황까지."
- 자유 입력

AskUserQuestion: "그 세그먼트를 가장 잘 좁히는 상황은?"
- 선택한 세그먼트에 맞는 상황 후보 3-5개를 동적으로 생성
- 마지막 선택지는 항상 `기타 — 한 줄 보정`

F를 선택한 경우에만:
AskUserQuestion: "어떤 상황인지 한 줄로 적어줘."
- 자유 입력

AskUserQuestion: "그 사람이 이 문제를 가장 강하게 느끼는 순간은 언제야?"
- 세그먼트와 문제 맥락에서 가능한 트리거 후보 3-5개를 동적으로 생성
- 마지막 선택지는 항상 `기타 — 한 줄 보정`

F를 선택한 경우에만:
AskUserQuestion: "그 순간을 한 줄로 적어줘."
- 자유 입력

AskUserQuestion: "지금 그 사람은 이 문제를 어떻게 해결하고 있어? 돈이나 시간을 어디에 쓰고 있어?"
- 이 ICP가 실제로 쓸 법한 현재 대안 후보 3-5개를 동적으로 생성
- 마지막 선택지는 항상 `기타 — 한 줄 보정`

F를 선택한 경우에만:
AskUserQuestion: "현재 대안을 한 줄로 적어줘."
- 자유 입력

AskUserQuestion: "왜 하필 이 세그먼트를 먼저 잡아야 해? 다른 세그먼트보다 급한 이유가 뭐야?"
- 현재 문제/채널/오퍼 맥락에서 priority reason 후보 3-5개를 동적으로 생성
- 마지막 선택지는 항상 `기타 — 한 줄 보정`

F를 선택한 경우에만:
AskUserQuestion: "왜 먼저 잡아야 하는지 한 줄로 적어줘."
- 자유 입력

AskUserQuestion: "반대로 절대 먼저 잡지 않을 사람은 누구야? 왜 제외해?"
- 현재 ICP와 대비되는 Anti-ICP 후보 3-5개를 동적으로 생성
- 마지막 선택지는 항상 `기타 — 한 줄 보정`

F를 선택한 경우에만:
AskUserQuestion: "제외할 세그먼트를 한 줄로 적어줘."
- 자유 입력

AskUserQuestion: "이 ICP가 맞다면, 가격/채널/메시지 중 뭐가 달라져야 해?"
- ICP가 downstream decision에 주는 영향 후보 3-5개를 동적으로 생성
- 가격, 채널, 메시지, 제품 범위 중 실제로 갈릴 만한 축만 고른다
- 마지막 선택지는 항상 `기타 — 한 줄 보정`

F를 선택한 경우에만:
AskUserQuestion: "무엇이 달라져야 하는지 한 줄로 적어줘."
- 자유 입력

AskUserQuestion: "아직 확인 안 된 가장 큰 가정 2개는 뭐야?"
- 지금까지 선택된 답변에서 파생되는 미확인 가정 후보 3-5개를 동적으로 생성
- 마지막 선택지는 항상 `기타 — 한 줄 보정`

F를 선택한 경우에만:
AskUserQuestion: "확인 안 된 가정을 한 줄로 적어줘."
- 자유 입력

### 4-bis. 최소 자유 입력 보정

선택지로 다 표현되지 않은 핵심 nuance가 있을 때만:

AskUserQuestion: "문서에 꼭 남겨야 할 한 줄 맥락이 있어? 없으면 '없어'라고 해."
- 자유 입력

### 5. 문서 초안 정리

유저 답변을 그대로 붙이지 말고 아래 원칙으로 정리:

- 핵심 세그먼트 이름은 3-8단어
- 기준은 체크리스트처럼 작성
- 현재 대안은 구체적 행동으로 적기
- Anti-ICP는 최소 2개 이상
- Downstream Decisions는 가격/채널/포지셔닝까지 연결
- Open Questions는 인터뷰에서 검증할 질문 형태로 끝내기
- 선택지 응답을 우선 사용하고, 자유 입력은 선택지의 빈칸을 메우는 용도로만 쓴다

### 6. 저장

`packages/agnt/references/shared/icp-template.md`를 읽어 형식을 맞춘 뒤, `ICP_DOC_PATH`에 Write.

문서 형식:

```markdown
# Ideal Customer Profile (ICP)

> deep-interview로 계속 구체화하는 작업 문서.

## ICP ≠ Persona
...

## Current ICP: {세그먼트 이름}
...

## Needs / Haves / Don't Needs
...

## Anti-ICP
...

## Persona Snapshot
...

## Downstream Decisions
...

## Signals To Validate
...

## Open Questions
...
```

state.json 업데이트:

- `project.icp` = 문서의 Current ICP 한 줄 요약
- `project.hypothesis` = `"[ICP]가 [문제]를 해결하기 위해 [현재 대안 대비 더 나은 해결책]에 비용 또는 시간을 쓸 것이다"` 형식으로 정리
- `artifacts.icp_defined = true`
- `artifacts.icp_versions = (기존 값 + 1, 최소 1)`
- `meta.last_action = "icp"`
- `meta.total_actions++`

### 6-bis. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

파일이 없으면 navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
파일이 있으면 `## ICP` 섹션을 Replace.

```markdown
## ICP
- 핵심 세그먼트: {세그먼트 이름}
- 트리거: {문제를 가장 강하게 느끼는 순간}
- 현재 대안: {현재 해결 방식}
- 제외 세그먼트: {Anti-ICP 핵심 2개}
- 검증할 가정: {Open Questions 핵심 2개}
- 문서: {ICP_DOC_PATH}
```

### 7. MCP 제출

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `save_interview` 호출: problem, icp, hypothesis 저장
- `submit_practice` 호출: quest_id = `"wf-icp"`

도구 없으면:
- `sync.pending_events`에 추가:
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-icp" }, "created_at": "<now()>" }
  ```

### 8. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ICP 문서 저장 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

문서: {ICP_DOC_PATH}
현재 ICP: {project.icp}

이제 누구를 인터뷰할지 기준이 생겼어.
다음 단계: /agnt:interview
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 규칙

- 이 스킬은 broad audience를 허용하지 않는다
- ICP는 demographic이 아니라 상황 기반으로 좁힌다
- docs/ICP.md는 참고용이 아니라 작업 문서다 — 인터뷰 후 계속 수정 가능
- 칭찬 금지. "좋은 ICP야" 대신 "아직 넓다/현재 대안이 비어 있다"처럼 팩트로 말한다
- 외부 `deep-interview` 스킬이 없더라도, 이 스킬 자체가 deep-interview 방식으로 진행한다
- 한국어, 반말 톤
