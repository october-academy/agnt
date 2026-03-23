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

- `meta.schema_version != 2` → `/agnt:start`로 안내 후 종료
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

AskUserQuestion: "SPEC을 작성해줘. 위 5개 항목을 포함해서."
- 자유 입력 (여러 줄)

### 5. SPEC 리뷰 + 피드백

유저 입력을 분석하여 피드백:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SPEC v{N} 리뷰
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{유저 SPEC 요약}

✅ 좋은 점:
{구체적이고 실행 가능한 부분}

⚠️ 개선 제안:
{모호하거나 빠진 부분 — 구체적 질문으로}

💡 체크:
• 이 MVP를 2주 안에 만들 수 있어? 기능이 너무 많지 않아?
• ICP가 이걸 보고 "이거 필요해"라고 할까?
• 경쟁 제품 대비 뭐가 다른지 한 문장으로 말할 수 있어?
```

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

### 7. MCP 제출

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `save_spec_iteration` 호출: SPEC 내용 저장
- `submit_practice` 호출: quest_id = `"wf-spec-{N}"` (N ≤ 2일 때만)

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
- MCP 호출 실패 시 로컬 저장은 유지
- 한국어, 반말 톤
