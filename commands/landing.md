랜딩 전략 가이드. 랜딩페이지에 뭘 써야 하는지, 어떻게 구성해야 하는지 안내합니다.

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
- `artifacts.spec_versions < 1` → "SPEC 없이도 진행할 수 있지만, `/agnt:spec`으로 정리하면 랜딩 카피가 선명해져." (비강제 — 진행 가능)

### 2. 컨텍스트 수집

state에서 읽기:
- `project.problem` — 풀고 있는 문제
- `project.icp` — 타겟 고객
- `project.hypothesis` — 가설

SPEC 파일 읽기 시도: `{AGNT_DIR}/specs/spec-v*.md` (최신 버전). 없으면 state 기반으로 진행.

### 3. 랜딩 전략 가이드

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  랜딩페이지 전략
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

네 제품을 처음 본 사람이 3초 안에 "이건 나를 위한 거다"라고
느끼게 만드는 게 랜딩의 전부야.

문제: {project.problem}
ICP: {project.icp}
```

### 4. 헤드라인 공식

```
📝 헤드라인 작성법

공식: "[ICP]를 위한 [핵심 가치]"

예시:
• "혼밥하는 직장인을 위한 점심 친구 매칭"
• "코드 리뷰 시간을 절반으로 줄여주는 AI"
• "사업자 없이 디지털 제품을 파는 가장 쉬운 방법"

네 경우:
  ICP: {project.icp}
  핵심 가치: {SPEC의 한 줄 설명 또는 project.hypothesis에서 추출}

  → 헤드라인 초안: "{ICP}를 위한 {핵심 가치}"
```

### 5. 필수 섹션 체크리스트

```
📋 랜딩 필수 섹션 (이 순서대로)

1. Hero — 헤드라인 + 서브헤드 + CTA 버튼
   서브헤드: 현재 대안의 약점 → 우리가 어떻게 다른지
   "기존에는 [현재 대안]. 대신 [우리 차별점]."

2. Problem — ICP가 겪는 문제를 구체적으로
   인터뷰에서 나온 실제 표현을 사용해.
   "~하느라 시간 낭비하고 있지 않아?"

3. Solution — 핵심 기능 3개 이내
   기능 나열이 아니라, 각 기능이 문제를 어떻게 해결하는지.

4. Social Proof — 있으면
   인터뷰 참여자 인용, 베타 사용자 수, 커뮤니티 반응.
   없으면 이 섹션 생략 (가짜 증거 금지).

5. CTA — 명확한 하나의 행동
   이메일 수집 / 대기리스트 / 무료 체험 / 결제
```

### 6. CTA 설계

```
🎯 CTA 선택 가이드

목표에 따라 CTA를 결정해:

아직 제품 없음 → "이메일 남기기" (관심 검증)
MVP 있음, 무료 → "지금 시작하기" (사용 검증)
MVP 있음, 유료 → "무료 체험 시작" 또는 "구매하기" (결제 검증)

⚠️ 안티패턴:
• CTA가 2개 이상 → 어느 것도 안 누름. 하나만.
• "더 알아보기" → 약함. 구체적 행동으로.
• CTA 버튼이 스크롤 없이 안 보임 → Hero에 반드시 포함.
```

### 7. 안티패턴 경고

```
🚫 이것만 피해도 상위 50%

• 기능 나열 — "AI 기반 자동화, 실시간 분석, 대시보드..."
  → 대신: 기능이 ICP의 문제를 어떻게 푸는지
• 전문 용어 — ICP가 모르는 단어 금지
• CTA 없는 랜딩 — 예쁜 소개 페이지 ≠ 랜딩
• 완벽주의 — 첫 버전은 Notion 페이지여도 됨. 올리는 게 먼저.
```

### 8. 벤치마크

`{REFS_DIR}/benchmarks/conversion-benchmarks.md`를 Read.

```
📊 성과 기준 — "잘 되고 있는 건가?"

방문 → 이메일 수집: 5-15%가 정상 (100명 방문, 5-15명 수집)
방문 → 유료 구매: 1-3%가 정상 (100명 방문, 1-3명 구매)

100명 미만 방문에서는 전환율을 판단하지 마.
최소 200-300명 데이터가 쌓여야 의미 있어.

전환율 < 1% → 오퍼 또는 헤드라인 재검토
전환율 1-3% → 보통 (최적화 여지)
전환율 3-5% → 좋음 (트래픽 늘려라)
전환율 5%+ → 탁월함
```

### 9. 랜딩 확인

AskUserQuestion: "랜딩을 만들었어?"
- A) 만들었어 — URL 입력
- B) 아직 — 만들고 올게

**A 선택 시**:
AskUserQuestion: "URL을 알려줘."
- 자유 입력

URL을 받으면:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  랜딩 등록 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

URL: {입력된 URL}

이제 사람들에게 보여줄 차례야.
다음 단계: /agnt:channel — 어디에 보여줄지 정하기
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**B 선택 시**:
```
괜찮아. 완벽할 필요 없어.
Notion 페이지, Carrd, 직접 코딩 — 뭐든 돼.
핵심은 올리는 것. 만들면 다시 `/agnt:landing`을 실행해.
```
종료.

### 9-bis. journey-brief.md Write

A 선택 시 (URL 입력한 경우)만 실행:

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `## Market` 섹션 내 `- 랜딩 URL:` 라인을 Replace.

```markdown
- 랜딩 URL: {입력된 URL}
```

### 10. state 업데이트 + MCP 제출

A 선택 시 (URL 입력한 경우):

state.json 업데이트:
- `artifacts.landing_deployed = true`
- `meta.last_action = "landing"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-landing"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-landing" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- agnt가 랜딩을 대신 만들거나 배포하지 않는다 — ICP가 직접 한다
- 가이드는 짧고 직접적으로 — 마케팅 이론 아닌 실행 지침
- SPEC이 있으면 활용, 없으면 state 기반으로 진행 (비강제)
- 벤치마크는 "정상 범위"를 알려주는 것이 목적 — 절대 기준 아님
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
