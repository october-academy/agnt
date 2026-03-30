---
user-invocable: false
name: spec
description: >-
  SPEC 작성/이터레이션. 제품 스펙 작성, SPEC 반복 수정 시 사용.
---

SPEC 작성 워크플로우. 인터뷰 인사이트를 바탕으로 제품 스펙을 정리합니다.

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

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료
- `project.problem == null` → `/agnt:discover`로 안내 후 종료
- `artifacts.interviews < 1` → "최소 1회 인터뷰 후 SPEC을 쓰는 게 좋아. `/agnt:interview`를 먼저 해볼래?" (비강제 — 진행 가능)

### 2. SPEC 버전 결정

`artifacts.spec_versions`으로 판단:
- 0 → 첫 SPEC 작성 (v1)
- 1+ → 이터레이션 (v{N+1})

### 3. SPEC 작성 가이드

**v1 (첫 작성):**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPEC v1 작성
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

인터뷰에서 배운 걸 바탕으로 제품 스펙을 정리하자.

문제: {project.problem}
ICP: {project.icp}
인터뷰: {artifacts.interviews}회 완료

SPEC에 포함할 것:
1. 한 줄 설명 — "[ICP]를 위한 [솔루션]"
2. 핵심 기능 3개 — 반드시 필요한 것만
3. 수익 모델 — 어떻게 돈을 벌지
4. 차별점 — 기존 대안 대비 왜 이걸 쓰지
5. MVP 범위 — 2주 안에 만들 수 있는 최소 버전
```

**v2+ (이터레이션):**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPEC v{N+1} 이터레이션
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

이전 SPEC을 개선하자.

뭐가 바뀌었어?
• 추가 인터뷰에서 새 인사이트?
• 기능 우선순위 변경?
• 수익 모델 수정?
• MVP 범위 조정?
```

### 4. SPEC 입력 수집

**참고 예시** (project 데이터 기반):

```
📝 예시 SPEC — 이걸 참고해서 네 버전으로 수정해줘

1. 한 줄 설명: "{project.icp}를 위한 {project.problem} 해결 도구"
2. 핵심 기능: {project.hypothesis에서 추출한 핵심 기능 3개}
3. 수익 모델: {가설에서 추론한 수익 모델}
4. 차별점: {인터뷰에서 발견한 현재 대안 대비 차별화 포인트}
5. MVP 범위: (직접 채워봐)
```

⚠️ 이건 예시일 뿐이야. 특히 MVP 범위는 네가 직접 정해야 해.

AskUserQuestion: "SPEC을 작성해줘. 위 5개 항목을 포함해서."
- 자유 입력 (여러 줄)

### 5. SPEC 리뷰 — 전제 도전

유저 SPEC을 분석하여 피드백:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPEC v{N} 진단
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

숨은 가정:

가정 1: "{ICP}가 {가격}을 낼 거다"
  근거: {인터뷰에서 WTP 답변이 있으면 인용 / 없으면 "—"}
  상태: {확인됨 / 미확인}

가정 2: "기존 대안({현재 대안})보다 나을 거다"
  근거: {인터뷰에서 대안 불만이 나왔으면 인용 / 없으면 "—"}
  상태: {확인됨 / 미확인}

가정 3: "{기간} 안에 MVP를 만들 수 있다"
  근거: {기술 스택이 정해졌으면 표시 / 아니면 "—"}
  상태: {확인됨 / 미정}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5-bis. 가정 검증 (미확인 가정이 있을 때)

"미확인" 가정이 1개 이상이면, 각 미확인 가정에 대해 순차 질문:

AskUserQuestion: "가정 {N}('{가정 내용}')에 대해 — 이미 확인한 데이터가 있어?"
- A) 있어 — 유저 답변으로 가정을 "확인됨"으로 업데이트
- B) 없어 — 검증 방법 제안: {다음 행동}

모든 가정 확인 후 차원별 피드백으로 이동.

### 5-ter. 차원별 피드백

4개 차원(문제 정의, 수익 모델, 차별점, MVP 범위)을 평가한다.

**최약 차원 선정**: 가장 약한 차원 1개를 선택한다. 동점 시 tiebreaker 적용: 수익 모델(WTP와 직결) > 차별점 > 문제 정의 > MVP 범위.

**최약 1개 — 4단 피드백**:
```
✦ {최약 차원}:
  현재: {한 줄 평가}
  부족한 점: {구체적으로 뭐가 빠졌나}
  더 나아지려면: {개선 방향}
  고치면: {예상 결과}
```

**나머지 3개 — 1줄 체크**:
```
✦ {차원}: {한 줄 평가} {✅ 충분 / ⚠️ 보완 필요}
✦ {차원}: {한 줄 평가} {✅ 충분 / ⚠️ 보완 필요}
✦ {차원}: {한 줄 평가} {✅ 충분 / ⚠️ 보완 필요}
```

{"부족한 점"이 2개 차원 이상이면}
수정하면 더 선명해질 거야.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AskUserQuestion: "이 SPEC으로 확정할래, 수정할래?"
- A) 확정 — 저장으로 이동
- B) 수정할래 — 수정 입력 받고 다시 리뷰

### 6. 저장

확정된 SPEC을 `{AGNT_DIR}/specs/spec-v{N}.md`로 Write.

```markdown
# SPEC v{N}
Date: {ISO 8601}

## 한 줄 설명
{내용}

## 핵심 기능
{내용}

## 수익 모델
{내용}

## 차별점
{내용}

## MVP 범위
{내용}
```

state.json 업데이트:
- `artifacts.spec_versions++`
- `meta.last_action` = `"spec"`
- `meta.total_actions++`

### 6-bis. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `## Product` 섹션을 Replace.

Product 섹션:
```markdown
## Product
- SPEC: {SPEC 한 줄 요약 — 제품명 + 핵심 가치}
- MVP 범위: (미작성)
```

### 7. MCP 제출

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `save_spec_iteration` 호출: SPEC 내용 저장
- `submit_practice` 호출: quest_id = `"wf-spec-{N}"` (N ≤ 2일 때만)

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패) (N ≤ 2일 때만):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-spec-{N}" }, "created_at": "<now()>" }
  ```
- state.json 저장

### 인라인 넛지 (1회성)

identity.mode != "synced" AND sync.last_inline_nudge_at == null인 경우:

💾 완료한 퀘스트의 XP를 받으려면 `/agnt:connect`
→ 나중에 연결해도 지금까지의 XP가 한 번에 적립돼.

sync.last_inline_nudge_at = now() 기록

### 8. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPEC v{N} 저장 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

파일: {AGNT_DIR}/specs/spec-v{N}.md

{N == 1이면}
SPEC은 살아있는 문서야. 인터뷰를 더 하거나
피드백을 받으면 `/agnt:spec`으로 v2를 만들어.

다음 단계: /agnt:next
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 규칙

- SPEC은 짧게 — 5개 항목, 각 2-3줄
- "완벽한 SPEC"을 추구하지 않음 — 이터레이션 전제
- 에이전트가 SPEC을 대신 쓰지 않음 — 유저가 쓰고 에이전트가 리뷰
- SPEC을 칭찬하지 않는다 — 포지션 + 근거로 피드백
- 칭찬 금지 표현: "좋은 SPEC이야", "잘 정리했네", "흥미로운 접근이야", "좋은 시작이야", "그것도 가능해"
- 대신: 포지션 먼저("이 가정은 미확인이야") → 근거("WTP 답변 없음") → 행동("인터뷰에서 확인 필요")
- MCP 호출 실패 시 로컬 저장은 유지
- 한국어, 반말 톤
