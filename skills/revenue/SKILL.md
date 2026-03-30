---
name: revenue
description: >-
  수익 나침반 — 시그널 기반 수익 모델 추천. 수익 모델 선택, 첫 매출 계획 시 사용.
---

수익 나침반. 시그널과 상황을 분석하여 수익 모델을 추천합니다.

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

기본값 보증:
- `tools.revenue_model`이 undefined면 `null`로 처리

### 2. 시그널 자동 수집

state.json에서 시그널 읽기:
- `signals.landing_visits`
- `signals.form_responses`
- `signals.link_clicks`
- `signals.payment_intents`
- `signals.revenue`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `get_growth_report` 호출하여 실제 시그널 데이터 수집
- 로컬 state 시그널과 병합 (MCP 데이터 우선)

### 3. 상황 수집

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  수익 나침반
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{시그널 데이터가 있으면}
📊 현재 시그널:
  방문: {landing_visits}
  폼 응답: {form_responses}
  클릭: {link_clicks}
  결제 시도: {payment_intents}
  매출: {revenue}

{없으면}
아직 시그널 데이터가 없어. 상황 기반으로 추천할게.
```

AskUserQuestion: "제품 유형은?"
- A) SaaS / 웹 앱
- B) 디지털 콘텐츠 (전자책, 템플릿, 가이드)
- C) 앱 / 모바일
- D) 서비스 / 컨설팅
- E) 아직 제품이 없어

AskUserQuestion: "제품에 쓸 수 있는 시간은?"
- A) 주 5시간 미만 (부업)
- B) 주 5-20시간
- C) 주 20시간 이상 (풀타임)

AskUserQuestion: "전문 분야는?"
- A) 개발 (프론트/백/인프라)
- B) 디자인 (UI/UX/그래픽)
- C) 마케팅 / 그로스
- D) 특정 도메인 (교육, 금융, 의료 등)
- E) 없음 / 일반

### 4. 수익 모델 추천

`{REFS_DIR}/revenue/revenue-models.md` Read.

수집한 정보(제품 유형, 시간, 전문 분야, 시그널)를 조건표에 매핑하여 추천한다.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  수익 모델 추천
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🥇 1순위: {모델명}
  이유: {1-2문장}
  예상 가격: {가격대}
  첫 매출 경로: {경로 요약}
  예상 월매출 (6개월 후): {범위}

🥈 2순위: {모델명}
  이유: {1-2문장}
  예상 가격: {가격대}
  첫 매출 경로: {경로 요약}
  예상 월매출 (6개월 후): {범위}

🚫 비추천: {모델명}
  이유: {1-2문장}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. 다음 액션 연결

```
📍 다음 단계:

{1순위가 SaaS/구독이면}
→ 결제 도구 선택: /agnt:tools
→ 페이월 설계: /agnt:offer

{1순위가 컨설팅/용역이면}
→ 오퍼 설계: /agnt:offer
→ 채널 선택: /agnt:channel

{1순위가 전자책/콘텐츠이면}
→ 콘텐츠 전략: /agnt:content
→ 런칭 카피: /agnt:launch-copy

{사업자 관련이면}
→ 사업자 판단: /agnt:biz-setup
```

### 6. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  수익 나침반 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

추천: {1순위 모델명}
가격대: {가격대}

수익 모델은 고정이 아니야.
첫 매출 이후에도 /agnt:revenue를 다시 실행하면
시그널 기반으로 재추천할 수 있어.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 7. state 업데이트 + MCP 제출

state.json 업데이트:
- `tools.revenue_model = "{1순위 모델명}"` (예: "saas", "ebook", "consulting", "cohort", "ads", "sponsor", "affiliate", "template")
- `meta.last_action = "revenue"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-revenue"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-revenue" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- 수익 모델을 강제하지 않는다 — 추천 + 이유를 제시하고 유저가 결정
- 시그널 데이터가 있으면 적극 활용 — MCP get_growth_report 우선
- 예상 매출은 보수적으로 — "잘 되면" 시나리오 금지, 현실적 범위 제시
- "이 모델이 좋다"가 아닌 "네 상황에서 이 모델이 맞는 이유"를 설명
- state.json Write 먼저 (critical path)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
