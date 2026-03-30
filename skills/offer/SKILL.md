---
name: offer
description: >-
  오퍼 구성 가이드 — 가격, 약속, 반론 처리, 증거 공백. 오퍼 설계, 가격 설정 시 사용.
---

오퍼 구성 가이드. 이걸 얼마에, 어떤 약속으로 팔 건지 설계합니다.

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

기본값 보증 (navigator-engine.md 필드 기본값 규칙):
- `artifacts.offer_drafted`가 undefined면 `false`로 처리
- `artifacts.launch_planned`가 undefined면 `false`로 처리
- `artifacts.last_analyze_loop`가 undefined면 `0`으로 처리
- `artifacts.loops_completed`가 undefined면 `0`으로 처리

### 2. 컨텍스트 수집

state에서 읽기:
- `project.problem` — 풀고 있는 문제
- `project.icp` — 타겟 고객
- `project.hypothesis` — 가설

SPEC 파일 읽기 시도: `{AGNT_DIR}/specs/spec-v*.md` (최신 버전). 없으면 state 기반으로 진행.

### 3. 오퍼 구성 가이드

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  오퍼 설계
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

오퍼 = 누구에게 + 뭘 약속하고 + 얼마에 팔 건지.
"기능"이 아니라 "약속"을 파는 거야.

문제: {project.problem}
ICP: {project.icp}
```

### 4. 핵심 약속

```
📝 핵심 약속 공식

"이 제품을 쓰면 {ICP}는 {결과}를 얻는다."

예시:
• "혼밥하는 직장인은 점심 친구를 5분 안에 찾는다."
• "1인 개발자는 코드 리뷰 시간을 절반으로 줄인다."
• "사업자 없는 개발자는 디지털 제품을 바로 판다."

네 경우:
  ICP: {project.icp}
  → 약속 초안: "{ICP}는 {hypothesis에서 추출한 결과}를 얻는다."
```

### 5. 가격 가설

`{REFS_DIR}/tools/payment-comparison.md`를 Read.

```
💰 가격 설계

가격 모델 3가지:
• 무료 체험 → 유료 전환: 가치 확인 후 결제 (리스크 낮음)
• 일회성 결제: $29-99 범위. 단순하지만 재구매 없음
• 구독: $5-29/월. 반복 매출이지만 이탈 관리 필요

📊 1인 개발자 첫 제품 기준:
• 평균 가격대: $5-29/월 또는 $29-99 일회성
• 첫 가격은 낮게 시작해. 올리는 건 쉽지만 내리는 건 어려워.
• "무료로 충분한가?" 질문에 "아니"라면 유료의 이유가 있는 거야.

결제 도구 비교는 /agnt:tools에서 확인할 수 있어.
```

### 6. 반론 대응

```
🛡️ "안 살" 이유 3가지 예상

ICP가 거절하는 이유를 미리 적어봐:

1. "비슷한 게 있잖아" → 차별점: ___
2. "나한테 필요 없어" → 문제 증거: ___
3. "비싸" → 가치 대비 가격: ___

인터뷰에서 나온 실제 반론이 있으면 그걸 써.
없으면 위 3가지를 추정으로 채워.
```

### 7. 증거 공백

{signals.link_clicks == 0이면}
⚠️ 아직 클릭 데이터가 없어. 오퍼 설계는 가능하지만, 가격 검증은 실제 트래픽 후에 해야 해.

```
⚠️ 증거 공백 — 아직 증명 못 한 것

솔직하게 적어:
• ICP가 실제로 돈을 낼 의향이 있는지? (검증됨 / 미검증)
• 비슷한 솔루션 대비 왜 이걸 써야 하는지? (검증됨 / 미검증)
• 가격이 적정한지? (검증됨 / 미검증)

미검증 항목이 있을수록 첫 거래의 리스크를 낮춰. 무료 체험, 소량 판매, 조기 피드백 — 증거를 모으는 방법을 먼저 설계해.
```

### 8. 오퍼 수집

AskUserQuestion: "핵심 약속을 한 문장으로 정리해줘."
- 자유 입력

AskUserQuestion: "어떤 가격 모델로 갈 거야?"
- A) 무료 체험 → 유료 전환
- B) 일회성 결제
- C) 구독

AskUserQuestion: "가격은?"
- 자유 입력 (예: "월 9,900원", "$29 일회성")

### 8-bis. 핵심 약속 구체성 체크

유저가 입력한 핵심 약속 문장을 아래 고정 기준으로 판정한다 (기준의 변경/완화 금지, 한국어 활용형 인식은 LLM에 위임):

**부족 기준** (1개 이상 해당 시 1회 보완 요청):
- ICP 관련 명사구 미포함 (project.icp에서 추출한 핵심 명사의 어간이 문장에 없음)
- 결과/변화를 나타내는 동사 어간 미포함 (얻/줄/찾/만들/늘/높/낮 등 — 활용형 포함 매칭)
- 15자 미만

1개 이상 해당 시:

AskUserQuestion: "'[ICP]는 [결과]를 얻는다' 형식으로 다시 정리해줄 수 있어?"
- 자유 입력

보완 후 재보완 금지 — 재답변 내용과 관계없이 진행.

### 8-ter. 페이월 카피 생성 (선택)

AskUserQuestion: "페이월 카피도 만들어볼래?"
- A) 만들자 — 헤드라인/CTA/보증 문구 생성
- B) 나중에 — 오퍼만 저장

A 선택 시:

`{REFS_DIR}/paywall/paywall-patterns.md` Read.

오퍼 데이터(핵심 약속, 가격, ICP)를 기반으로 생성:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  페이월 카피
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📝 헤드라인 3변형:
1. (결과 약속) {헤드라인}
2. (고통 직격) {헤드라인}
3. (비교 대조) {헤드라인}

🔘 CTA 버튼 3변형:
1. {CTA}
2. {CTA}
3. {CTA}

✅ 가치 불릿:
• {기능 → 이점 → 감정}
• {기능 → 이점 → 감정}
• {기능 → 이점 → 감정}

🛡️ 환불/보증 문구:
{환불 보증 문구}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`{AGNT_DIR}/paywall-copy.md` Write.

MCP synced 시:
- `save_spec_iteration` 호출: type = `"paywall"`, content = 카피 전문

### 9. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `### Offer` 섹션만 업데이트.

Offer 섹션:
```markdown
### Offer
- 제품: {project.name} — {project.hypothesis}
- 핵심 약속: {유저 입력}
- 가격: {유저 입력 가격} ({모델})
- 증거 공백: {미검증 항목}
```

### 10. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  오퍼 설계 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

약속: {유저 입력}
가격: {유저 입력}

이제 이 오퍼를 들고 사람들 앞에 나갈 차례야.
다음 단계: /agnt:launch — 론칭 계획 세우기
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 11. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.offer_drafted = true`
- `meta.last_action = "offer"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-offer"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-offer" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- agnt가 가격을 대신 정하지 않는다 — ICP가 직접 결정한다
- 가이드는 짧고 직접적으로 — 비즈니스 이론이 아닌 실행 지침
- SPEC이 있으면 활용, 없으면 state 기반으로 진행 (비강제)
- 벤치마크는 "정상 범위"를 알려주는 것이 목적 — 절대 기준 아님
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위 (learner artifact)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
- 오퍼를 칭찬하지 않는다 — "좋은 오퍼야", "잘 잡았네", "적절한 가격이야", "좋은 약속이야", "가격이 잘 잡혔네", "반론 대응이 잘 됐어" 사용 금지
- 대신: 포지션("이 가격이 적정한지는") → 근거("ICP가 결정해") → 행동("증거 공백 섹션에서 미검증 항목 확인해")
