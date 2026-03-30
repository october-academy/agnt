---
user-invocable: false
name: compete
description: >-
  경쟁 분석 — 대안 매핑 + 차별화 매트릭스. 경쟁 분석, 유사 제품 조사, 차별화 전략 시 사용.
---

경쟁 분석. 네 문제를 이미 풀고 있는 제품/대안을 찾아 차별화 포인트를 정리합니다.

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

내부 로직(경로 탐색, state 파싱, MCP 검색)은 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료
- `project.problem == null` → "/agnt:discover로 문제를 먼저 정의하세요." 종료
- `artifacts.interviews < 1` → "인터뷰를 최소 1건 하면 경쟁 분석이 훨씬 선명해져. /agnt:interview 먼저 추천." (비강제 — 진행 가능)

기본값 보증 (navigator-engine.md 필드 기본값 규칙):
- `artifacts.competitors_analyzed`가 undefined면 `false`로 처리
- `artifacts.content_planned`가 undefined면 `false`로 처리

### 2. 컨텍스트 수집

state에서 읽기:
- `project.problem` — 풀고 있는 문제
- `project.icp` — 타겟 고객
- `project.hypothesis` — 가설

`{AGNT_DIR}/journey-brief.md` Read 시도. 있으면 Interview Insights 섹션에서 "현재 대안" 정보 추출. 없으면 state 기반으로 진행.

### 3. 경쟁 분석 가이드

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  경쟁 분석
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

네 ICP가 지금 이 문제를 해결하는 방법을 찾아봐.
제품일 수도 있고, 엑셀일 수도 있고, 그냥 참는 것일 수도 있어.

문제: {project.problem}
ICP: {project.icp}

{journey-brief에서 Interview Insights가 있으면}
인터뷰에서 나온 현재 대안:
{추출한 현재 대안 목록}
{없으면}
인터뷰에서 "지금 어떻게 해결하고 있어요?"를 물어봤다면
거기서 나온 답이 경쟁 대안이야.
```

### 4. 대안 수집

AskUserQuestion: "비슷한 제품이나 대안 3개를 찾아서 알려줘. (제품명, 무료 도구, '그냥 참음' 등 뭐든 가능)"
- 자유 입력

### 5. 약점 분석

유저가 입력한 각 대안에 대해:

AskUserQuestion: "{대안 이름}의 가장 큰 약점은 뭐야? (ICP 관점에서)"
- 자유 입력

(대안이 3개면 3회 질문. 2개면 2회.)

### 6. 차별화 매트릭스

수집한 데이터를 정리하여 출력:

```
📊 차별화 매트릭스

| | {대안A} | {대안B} | {대안C} | 내 제품 |
|---|---|---|---|---|
| 유형 | {제품/도구/행동} | ... | ... | {project.hypothesis} |
| 핵심 강점 | {추정} | ... | ... | ? |
| ICP 약점 | {유저 입력} | ... | ... | → 여기가 기회 |
| 가격 | {알려진 경우} | ... | ... | ? |
```

### 7. 차별점 확인

```
💡 차별화 포인트

경쟁 대안의 약점이 곧 네 기회야.
ICP가 기존 대안에서 가장 불만인 점을 네 제품이 해결하면 돼.
```

AskUserQuestion: "네가 이들과 다른 이유 1가지를 적어봐. '우리 제품은 ___해서 다르다.'"
- 자유 입력

### 8. 요약 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  경쟁 분석 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

대안 {N}개 분석 완료.
차별점: {유저 입력}

이제 이 차별점을 중심으로 SPEC을 작성해.
다음 단계: /agnt:spec
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 9. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성. Competition 섹션만 채우고 나머지는 `(미작성)` 플레이스홀더.

**파일이 있는 경우**: `## Competition` 섹션을 Replace (덮어쓰기).

Competition 섹션:
```markdown
## Competition
- 대안 1: {이름} — 유형: {유형} / 약점: {ICP 약점}
- 대안 2: {이름} — 유형: {유형} / 약점: {ICP 약점}
- 대안 3: {이름} — 유형: {유형} / 약점: {ICP 약점}
- 내 차별점: {유저 입력 1문장}
```

### 10. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.competitors_analyzed = true`
- `meta.last_action = "compete"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-compete"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-compete" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- agnt가 경쟁 제품을 대신 조사하지 않는다 — ICP가 직접 찾는다
- 인터뷰에서 나온 "현재 대안"을 시작점으로 활용
- "경쟁이 있으면 안 된다"가 아니라 "경쟁이 있으면 차별점이 필요하다"
- "경쟁 없음"도 유효한 답 — "아무도 이 문제를 안 풀고 있다면 왜?"를 질문
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위 (learner artifact)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
