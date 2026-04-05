---
user-invocable: true
name: design-system
description: >-
  디자인 시스템 정의/구체화 — docs/design-system.md를 만들고, 색상/타이포/컴포넌트/광고 에셋 규칙까지 고정한다.
---

디자인 시스템 문서화 워크플로우. 그냥 예쁜 화면이 아니라, 랜딩·광고·OG·제품 UI에 공통으로 쓰는 시각 규칙을 고정합니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색.

### DESIGN_SYSTEM_DOC_PATH

아래 우선순위로 디자인 시스템 문서 경로를 결정한다:

1. 현재 작업 디렉토리의 `docs/design-system.md`
2. `docs/`가 없으면 생성 후 `docs/design-system.md`
3. 작업 디렉토리 쓰기가 어렵거나 불명확하면 `{AGNT_DIR}/docs/design-system.md`

## 출력 규칙

내부 로직 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료
- `project.problem == null` → "먼저 `/agnt:discover`로 문제를 정의해." 종료

기본값 보증:

- `artifacts.design_system_defined`가 undefined면 `false`로 처리

### 2. 기존 문서 확인

`DESIGN_SYSTEM_DOC_PATH` Read 시도.

문서가 이미 있고 `(미작성)` 수준이 아니면:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  기존 디자인 시스템 문서가 있어
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

문서: {DESIGN_SYSTEM_DOC_PATH}
현재 프로젝트: {project.name || "미정"}
버전: {artifacts.design_system_versions || 1}
```

AskUserQuestion:

- A) 이어서 구체화할래
- B) 처음부터 다시 쓸래
- C) 이 문서 유지하고 종료할래

C 선택 시 `/agnt:next` 안내 후 종료.

### 3. 디자인 시스템 목표 설명

출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Design System
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

이 단계의 목표:
1. 제품의 첫인상을 한 줄로 고정한다
2. 색상/타이포/컴포넌트 규칙을 문서화한다
3. 랜딩, 제품 UI, OG, 광고 에셋이 같은 제품처럼 보이게 한다

좋은 디자인 시스템은 단순한 색상표가 아니라
누구에게 어떤 인상을 줘야 하는지까지 들어간다.
```

### 4. 핵심 질문

순차 AskUserQuestion.
기본은 선택지로 진행하고, 마지막에만 한 줄 보정 입력을 받는다.

AskUserQuestion: "지금 제품이 줘야 하는 첫인상에 가장 가까운 건?"

- `project.icp`, `project.problem`, 현재 랜딩 톤을 바탕으로 3-5개 후보 생성
- 예: `실행적`, `대담함`, `신뢰감`, `차분함`, `장난기`
- 마지막 선택지는 항상 `기타 — 직접 입력`

F를 선택한 경우에만:

AskUserQuestion: "첫인상을 한 줄로 적어줘."

AskUserQuestion: "가장 가까운 시각 스타일은?"

- 예: `Neo-Brutalism`, `Clean SaaS`, `Editorial`, `Playful Consumer`, `Warm Utility`
- 마지막 선택지는 항상 `기타 — 직접 입력`

F를 선택한 경우에만:

AskUserQuestion: "스타일을 한 줄로 적어줘."

AskUserQuestion: "강조색 톤은 어느 쪽이 맞아?"

- 예: `오렌지/레드`, `블루`, `그린`, `모노톤 + 포인트 1색`, `브랜드 고유색`
- 마지막 선택지는 항상 `기타 — 직접 입력`

AskUserQuestion: "타이포 느낌은?"

- 예: `굵고 강한 헤드라인`, `깔끔한 산세리프`, `에디토리얼 대비`, `모노/코드 친화`, `부드럽고 친근한 톤`
- 마지막 선택지는 항상 `기타 — 직접 입력`

AskUserQuestion: "컴포넌트 인상은?"

- 예: `두꺼운 테두리 + 하드 섀도우`, `미니멀`, `둥근 카드`, `평면적`, `입체적`
- 마지막 선택지는 항상 `기타 — 직접 입력`

AskUserQuestion: "광고/OG 에셋까지 연결할 때 가장 중요한 규칙은?"

- 예: `숫자를 크게`, `헤드라인 1개만`, `제품 화면 노출`, `로고 고정`, `색 포인트는 1개만`
- 마지막 선택지는 항상 `기타 — 직접 입력`

AskUserQuestion: "절대 피해야 할 톤은?"

- 예: `AI 슬롭 느낌`, `보라색 SaaS 클리셰`, `너무 차가운 엔터프라이즈`, `장난스러운 밈 톤`, `지나친 그라데이션`
- 마지막 선택지는 항상 `기타 — 직접 입력`

### 4-bis. 최소 보정 입력

AskUserQuestion: "문서에 꼭 남겨야 할 브랜드/비주얼 맥락이 있어? 없으면 '없어'라고 해."

### 5. 문서 정리 원칙

응답을 그대로 붙이지 말고 아래 원칙으로 정리:

- 첫 문단에 제품 인상 한 줄
- 색상은 `역할` 기준으로 정리 (`background`, `foreground`, `accent`, `muted`)
- 타이포는 `용도` 기준으로 정리 (`hero`, `section`, `body`, `mono`)
- 컴포넌트는 `버튼`, `카드`, `배지`, `섹션 배경` 정도의 공통 규칙만 먼저 정의
- 광고/OG/소셜 에셋 규칙을 별도 섹션으로 분리
- 금지 규칙을 명확히 적어 재해석 비용을 줄여

### 6. 저장

`DESIGN_SYSTEM_DOC_PATH`에 Write.

문서 형식:

```markdown
# Design System

> 제품 전체에 공통으로 쓰는 시각 규칙 문서.

## 1. Brand Summary
...

## 2. Design Principles
...

## 3. Color System
...

## 4. Typography
...

## 5. Components
...

## 6. Layout & Motion
...

## 7. Asset Rules
...

## 8. Anti-Patterns
...
```

`Asset Rules`에는 최소 아래가 들어가야 한다:

- OG 이미지 톤
- Meta 광고 이미지 톤
- 썸네일/배너에서 고정해야 할 규칙
- 로고/제품 화면/카피 우선순위

state.json 업데이트:

- `artifacts.design_system_defined = true`
- `artifacts.design_system_versions = (기존 값 + 1, 최소 1)`
- `meta.last_action = "design-system"`
- `meta.total_actions++`

### 6-bis. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

파일이 없으면 navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
파일이 있으면 `## Design System` 섹션을 Replace 또는 추가.

```markdown
## Design System
- 스타일 키워드: {핵심 3개}
- 색상 포인트: {accent / background / foreground}
- 타이포 톤: {headline / body}
- 컴포넌트 규칙: {버튼/카드 핵심}
- 에셋 규칙: {광고/OG 핵심 규칙}
- 문서: {DESIGN_SYSTEM_DOC_PATH}
```

### 7. downstream 연결 안내

완료 출력에서 아래를 분명히 말한다:

- `/agnt:landing`은 이 문서의 톤을 참조해야 한다
- `/agnt:meta-ads-setup`은 이 문서의 `Asset Rules`를 우선 참조해야 한다
- 제품 톤이 흔들릴 때는 이 문서부터 갱신해야 한다

### 8. MCP 제출

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:

- `submit_practice` 호출: quest_id = `"wf-design-system"`

도구 없으면:

- `sync.pending_events`에 추가:
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-design-system" }, "created_at": "<now()>" }
  ```

### 9. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  디자인 시스템 문서 저장 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

문서: {DESIGN_SYSTEM_DOC_PATH}
스타일 키워드: {핵심 3개}

이제 랜딩, 제품 UI, 광고 에셋을 같은 제품처럼 만들 수 있어.
다음:
- 랜딩 톤 정리 → /agnt:landing
- Meta 광고/에셋 초안 → /agnt:meta-ads-setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 규칙

- `docs/design-system.md`는 참고 메모가 아니라 재사용 가능한 작업 문서여야 한다
- 현재 제품과 무관한 예시 스타일을 그대로 복사하지 말고, `project.problem`, `project.icp`, 현재 톤에 맞게 다시 쓴다
- 색상값보다 역할 정의가 먼저다
- 광고/OG/소셜 에셋 규칙을 반드시 문서에 포함해 downstream 산출물에 연결한다
- 내부 추론은 보여주지 말고, 결정된 규칙만 간결하게 출력한다
