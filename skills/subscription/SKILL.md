---
user-invocable: false
name: subscription
description: >-
  구독 전략 설계 — niche, paywall, pricing, trial, 플랫폼, 웹 병행 전략을 정한다. 앱/구독형 제품 monetization 설계 시 사용.
---

구독 전략 설계. 1인 개발자가 구독 시장에서 평균 앱으로 버티지 않고, 좁은 문제에서 빠르게 과금 가능한 구조를 고르도록 돕는다.

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
- `artifacts.offer_drafted`가 undefined면 `false`로 처리

### 2. 컨텍스트 수집

state에서 읽기:
- `project.problem`
- `project.icp`
- `project.hypothesis`
- `tools.revenue_model`

`{AGNT_DIR}/journey-brief.md` Read 시도. 있으면 Offer / Competition / Results 섹션 참고.

### 3. 구독 전략 기준 로드

반드시 Read:
- `{REFS_DIR}/benchmarks/subscription-strategy-benchmarks.md`
- `{REFS_DIR}/paywall/paywall-patterns.md`
- `{REFS_DIR}/revenue/revenue-models.md`

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  구독 전략 설계
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

구독 시장은 평균 앱이 버티기 어렵다.
좁은 문제에서 빠른 가치 전달 + 강한 과금 구조를 잡아야 해.

{project.problem이 있으면}
문제: {project.problem}
{project.icp가 있으면}
ICP: {project.icp}
```

### 4. 핵심 진단 질문

AskUserQuestion: "지금 가장 가까운 제품 형태는?"
- A) 세로형 업무 툴 / 프로 유틸
- B) 크리에이터용 Photo & Video 툴
- C) AI 어시스턴트 / 범용 챗형 앱
- D) 게임 / 엔터테인먼트 앱
- E) 아직 제품 형태를 못 정했어

AskUserQuestion: "무료 유저를 많이 안고 가야 할 이유가 있어?"
- A) 없음 — 네트워크 효과/UGC/브랜드 플라이휠이 약해
- B) 조금 있음 — 콘텐츠/SEO로 무료 유입은 가능해
- C) 큼 — 협업, 네트워크 효과, 커뮤니티, UGC가 핵심이야

AskUserQuestion: "가치가 반복적으로 발생하는 방식은?"
- A) 매주/매일 반복되는 업무라 습관형이야
- B) 월 몇 번 쓰는 고가치 문제야
- C) AI/연산 원가가 커서 무료 체험이 부담돼
- D) 아직 잘 모르겠어

AskUserQuestion: "초기 운영 복잡도를 어디까지 감당할 수 있어?"
- A) iOS-first 또는 web-first만
- B) iOS + web 정도는 가능
- C) Android billing recovery까지 직접 운영 가능

### 5. 전략 판정 로직

`subscription-strategy-benchmarks.md` 규칙을 적용해 아래를 결정한다.

1. **시장 선택**
   - 기본값: A) 세로형 업무 툴 / 프로 유틸
   - 디자인/콘텐츠 감각이 강하면 B) Photo & Video를 대안으로 허용
   - D) 게임은 기존 유통 파워나 운영 역량이 없으면 비추천
   - C) AI 어시스턴트는 단독 카테고리로 밀지 말고 vertical workflow 안 기능으로 숨기기

2. **과금 구조**
   - B/C가 아니라면 기본값은 `hard paywall`
   - 단, paywall은 첫 가치 확인 뒤에 보여준다
   - 무료층이 필요한 이유가 강하면 freemium 허용하되, 그 이유를 한 문장으로 검증시킨다

3. **플랜 구성**
   - 기본값: `monthly + annual` 두 개만
   - annual을 기본 강조
   - weekly는 게임/고볼륨 소비형이 아니면 기본 비추천

4. **trial / offer**
   - A) 습관형 문제 → 17~32일 수준의 긴 trial 우선
   - B) 월 몇 번 쓰는 고가치 문제 → 짧은 trial보다 paywall after first value + annual 강조
   - C) AI/원가형 → free trial 축소, 저가 intro offer 또는 paid intro 우선

5. **플랫폼 / 유통**
   - 운영 여력이 작으면 iOS-first 또는 web-first
   - Android를 선택하면 billing recovery를 필수 운영 기능으로 표기
   - 웹 랜딩 + 이메일 수집 + 웹 결제/대기리스트 + 앱 동기화를 기본 설계로 넣는다

### 6. 전략 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  추천 구독 전략
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 추천 lane: {lane}
왜: {시장 선택 근거 2-3문장}

💸 과금 posture: {hard paywall | freemium with reason}
왜: {D35 전환 / retention 관점 근거}

📦 플랜 구성:
- 월간: {monthly guidance}
- 연간: {annual guidance}
- 비추천: {weekly 또는 과도한 플랜 수}

⏱ trial / offer:
- 방식: {long trial | intro offer | no free trial until first value}
- 이유: {trial/offer 근거}

🌐 유통 구조:
- 앱: {iOS-first | web-first | iOS+web | Android 포함}
- 웹: 랜딩 + 이메일 + {웹 CTA/결제/대기리스트 전략}

🤖 AI 포지셔닝:
- "AI 앱"으로 팔지 말고 특정 반복업무 시간을 줄이는 기능으로 숨겨.
- 모델이 좋아질수록 제품이 강해져야 해.

📊 100일 체크포인트:
- D0 activation: {첫 세션 결과물 정의}
- D35 paid conversion: {목표/판정 메모}
- refund / first renewal: {주의 포인트}
- web leads: {수집 목표}
- 90~120일 verdict: continue / pivot / kill 기준

🚫 피할 것:
- 큰 시장에서 평균 앱
- 무료층 운영 이유 없는 freemium
- 3일 trial만 붙여놓고 온보딩 약한 상태
- "AI 어시스턴트"처럼 범용 포지셔닝
```

### 7. 다음 액션 연결

```
📍 다음 단계:

1. niche/ICP를 더 좁히기 → /agnt:discover 또는 /agnt:icp
2. 과금 구조 문장으로 확정 → /agnt:offer
3. paywall 메시지와 랜딩 연결 → /agnt:landing
4. 결제/스택 고르기 → /agnt:tools
5. activation / conversion 계측 → /agnt:analytics-setup
```

### 8. journey-brief.md 업데이트

`{AGNT_DIR}/journey-brief.md` Read 시도.

없으면 신규 생성 가능.

Subscription Strategy 섹션을 아래 형식으로 Write/Update:

```markdown
### Subscription Strategy
- 추천 lane: {lane}
- 문제 형태: {선택값}
- paywall: {hard paywall | freemium with reason}
- 플랜: monthly + annual
- trial/offer: {전략}
- 플랫폼: {전략}
- 웹 병행: {전략}
- AI 포지셔닝: {전략}
- 100일 판정: D0 activation / D35 conversion / refund / renewal / web leads
```

### 9. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  구독 전략 설계 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

추천 lane: {lane}
paywall: {chosen posture}
플랫폼: {chosen platform}

이제 중요한 건 평균 개선이 아니라 문제 재선정과 첫 가치 전달 속도야.
다음은 /agnt:offer 또는 /agnt:landing으로 이어가.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 10. state 업데이트 + MCP 제출

state.json 업데이트:
- `tools.revenue_model = "subscription"`
- `meta.last_action = "subscription"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-subscription"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-subscription" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- 기본 stance는 "좁은 문제 + 빠른 가치 + 강한 과금"이다
- 숫자는 과장하지 말고 benchmark를 decision rule로 쓴다
- freemium은 네트워크 효과/브랜드/UGC 이유가 없으면 기본 비추천
- 앱 카테고리 추천은 무조건 칭찬하지 말고 운영 복잡도까지 포함해 포지션을 테이킹한다
- AI는 기능 엔진으로 다루고, 제품 카테고리로 과대 포장하지 않는다
- state.json Write 먼저, journey-brief.md는 학습 산출물
- MCP 실패 시 로컬 state 저장, 완료 마커 미기록
- 한국어, 반말 톤
