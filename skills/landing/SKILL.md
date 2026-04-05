---
name: landing
description: >-
  랜딩 전략 가이드 — VOC 통합, 15+ 헤드라인 공식, Anti-AI-slop. 랜딩페이지 계획/전략 시 사용.
---

랜딩 전략 가이드. 인터뷰 인사이트와 카피 공식을 활용해 팔리는 랜딩페이지를 설계합니다.

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

### 2. 컨텍스트 수집 (VOC 통합)

state에서 읽기:

- `project.problem` — 풀고 있는 문제
- `project.icp` — 타겟 고객
- `project.hypothesis` — 가설

SPEC 파일 읽기 시도: `{AGNT_DIR}/specs/spec-v*.md` (최신 버전). 없으면 state 기반으로 진행.

journey-brief.md 읽기 시도: `{AGNT_DIR}/journey-brief.md`.

- `## Interview` 섹션이 있으면 인터뷰 인사이트 추출 (고객 언어, 고통 표현, 놀라운 발견)
- `## Audit` 섹션이 있으면 Track 정보 + Simplifier Insight 추출
- `## Compete` 섹션이 있으면 경쟁 분석 결과 추출

**VOC (Voice of Customer) 활용 규칙:**

- 인터뷰에서 나온 고객의 **실제 표현**을 카피에 사용. 패러프레이즈하지 마.
- 고객이 쓴 단어가 마케팅 용어보다 항상 낫다.
- 인터뷰 데이터가 없으면 project 데이터로 진행 (비강제).

### 3. 트래픽 컨텍스트

AskUserQuestion: "사람들이 이 랜딩을 어디서 보게 될 것 같아?"

- A) SNS에서 링크 공유 (Threads, Twitter, Facebook)
- B) 검색으로 유입 (Google, Naver)
- C) 커뮤니티 게시물 (Discord, 카카오, 슬랙)
- D) 광고 (Meta, Google Ads)
- E) 아직 모르겠어

**트래픽 컨텍스트별 카피 조정:**

- SNS: 헤드라인이 공유 텍스트가 된다 → 호기심 유발 + 구체성
- 검색: 키워드가 H1에 포함되어야 함
- 커뮤니티: 문제 공감 → 해결책 순서가 중요
- 광고: 광고 카피와 랜딩 메시지 일치 (Message Match)

### 4. 헤드라인 작성

`{REFS_DIR}/copywriting/copy-frameworks.md` Read.

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

**컨텍스트 기반 헤드라인 3개 생성:**

copy-frameworks.md의 15+ 공식 중에서 프로젝트에 맞는 3가지 카테고리를 골라 각각 헤드라인 초안 생성:

```
📝 헤드라인 초안 (3개)

A) [Outcome-Focused]
   "{ICP}의 {핵심 가치}"
   근거: {왜 이 공식을 골랐는지}

B) [Problem-Focused]
   "{문제}에 지쳤다면"
   근거: {인터뷰 인사이트 또는 state 기반}

C) [Specificity-Focused]
   "{구체적 방법/시간/대상}"
   근거: {실제 데이터가 있으면 숫자 사용, 없으면 숫자 없이 구체성만}
```

AskUserQuestion: "어떤 방향이 맞아? (A/B/C) 아니면 수정하고 싶은 점?"

### 5. 서브헤드라인 + 페이지 구조

선택된 헤드라인을 기반으로 서브헤드라인 작성:

```
서브헤드: 현재 대안의 약점 → 우리가 어떻게 다른지
공식: "기존에는 {현재 대안}. 대신 {우리 차별점}."
```

**11개 섹션 구조 안내:**

```
📋 랜딩 구조 (이 순서대로)

1. ▶ Hero — 헤드라인 + 서브헤드 + CTA 버튼
   → 스크롤 없이 보여야 함. CTA 필수.

2. Social Proof Bar — 있는 것만 (가짜 금지)
   → 숫자, 로고, 한 줄 추천. 없으면 섹션 자체 생략.

3. Problem — ICP가 겪는 문제를 구체적으로
   {인터뷰 데이터가 있으면}
   → "인터뷰에서 이런 표현이 나왔어: '{실제 표현}'"
   {없으면}
   → "~하느라 시간 낭비하고 있지 않아?"

4. How It Works — 3단계 이내
   → 복잡한 것을 단순하게. 각 단계가 1문장.

5. Key Benefits — 2-3개 (기능 X, 변환 O)
   → "~를 할 수 있다" 아닌 "~가 된다"
   → 전: {고통} → 후: {해결된 상태}

6. Testimonial — 실제 인용
   → 인터뷰 참여자 허락받은 인용, 베타 사용자
   → 없으면 이 섹션 생략 (가짜 증거 금지)

7. Use Cases / Personas — "이런 사람에게 딱"
   → 2-3개 구체적 사용 시나리오

8. Comparison — 대안 대비 차이
   → 표 또는 Before/After. 경쟁 분석 있으면 활용.

9. Case Study Snippet — 구체적 결과
   → "A씨는 2주 만에 첫 결제를 받았다"
   → 없으면 생략.

10. FAQ — 반론 처리 (3-5개)
    → 가장 흔한 이유: "비싸", "시간 없어", "다른 것도 있는데"

11. ▶ Final CTA — 보증 + 행동 요청
    → Hero CTA와 동일. 불안 해소 문구 추가.
```

### 6. CTA 설계

```
🎯 CTA 설계

공식: [Action Verb] + [What They Get] + [Qualifier]

네 경우:
  목표: {CTA 컨텍스트별 추천}
  추천 CTA: "{구체적 CTA 문안}"
```

**강한/약한 CTA 체크:**

```
✅ 강한 CTA:
  "무료 체험 시작하기" / "30일 스프린트 참가하기"
  "{제품명} 시작하기" / "가이드 받기"

❌ 약한 CTA (피하기):
  "제출" / "가입하기" / "더 알아보기" / "시작하기" / "여기를 클릭"
```

### 7. JTBD Four Forces 체크

`{REFS_DIR}/copywriting/copy-frameworks.md`의 JTBD Four Forces 섹션 참조.

```
🔄 전환 심리 체크

Push (현재 불만):  네 카피가 이걸 건드려? → {Problem 섹션}
Pull (새 매력):   네 카피가 이걸 보여줘? → {Benefits 섹션}
Habit (관성):    네 카피가 이걸 깨? → {Comparison 섹션}
Anxiety (불안):  네 카피가 이걸 해소해? → {FAQ + 보증}

{빠진 Force가 있으면}
⚠️ {Force}이 카피에 빠져 있어. {해당 섹션}에서 다뤄야 해.
```

### 8. Anti-AI-Slop 체크

`{REFS_DIR}/copywriting/anti-ai-slop.md` Read.

```
🚫 AI 냄새 제거 체크

카피를 쓸 때 이것만 피해도 상위 50%:

• Em dash(—) 과다 사용 → 쉼표나 마침표로
• "혁신적인", "포괄적인", "탁월한" → 구체적 결과로
• "기능 나열형" → 기능이 문제를 어떻게 푸는지
• ICP가 모르는 전문 용어 → 고객 언어로
• CTA 없는 랜딩 → 예쁜 소개 페이지 ≠ 랜딩
• 3개씩 나열 → AI 습관. 2개 또는 4개.
```

### 9. Seven Sweeps 안내 (카피 완성 후 사용)

```
📊 카피 품질 체크 (Seven Sweeps)

카피를 다 쓴 후에 이 7개 차원으로 점검해.
지금은 구조만 잡는 단계니까, 카피를 쓴 다음에
다시 /agnt:landing을 실행하면 Seven Sweeps로 점검해줄게.

1. Clarity     — 초등학생도 이해?
2. Voice       — 톤 일관? AI냄새 없음?
3. So What     — 모든 문장이 "왜?" 대답?
4. Prove It    — 주장에 근거 있음?
5. Specificity — "많은" 대신 숫자?
6. Emotion     — "이건 나 얘기다" 느낌?
7. Zero Risk   — 안 할 이유 제거?

상세: {REFS_DIR}/copywriting/seven-sweeps.md
```

**카피 완성 상태에서 재실행 시**: `{REFS_DIR}/copywriting/seven-sweeps.md` Read하여 각 sweep 항목을 카피에 대입하여 구체적 피드백 제공.

### 10. 벤치마크

`{REFS_DIR}/benchmarks/conversion-benchmarks.md` Read.

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

### 11. 실행/검증 준비

AskUserQuestion: "지금 상태가 어디까지 왔어?"

- A) 공개 가능한 초안/페이지가 있어
- B) 카피 전략만 확정했고 아직 안 만들었어
- C) 아직 구조만 잡았어

**A 선택 시**:

```
좋아. 지금은 배포 등록보다 메시지 정리가 핵심이야.
공개 URL은 `/agnt:channel`이나 `/agnt:launch-copy`에서 필요할 때 넣으면 돼.
다음 단계: /agnt:channel — 어디에 보여줄지 정하기
```

**B 선택 시**:

```
좋아. 카피 방향이 잡혔으면 바로 초안을 만들면 돼.
Notion, Carrd, 직접 코딩, 기존 웹사이트 수정 — 뭐든 괜찮아.

다음 단계:
- 공개할 채널부터 정하려면 `/agnt:channel`
- SEO/GEO 점검이 필요하면 `/agnt:seo-audit`
```

**C 선택 시**:

```
괜찮아. 완벽할 필요 없어.
최소 버전은 Hero → Problem → CTA 이 3개면 충분해.

구조를 다듬은 뒤 다시 `/agnt:landing`으로 카피를 재점검해도 돼.
```

A/B/C 모두 journey-brief.md에 전략 메모를 저장한다 (아래 11-bis 참조).

### 11-bis. journey-brief.md Write

**A/B/C 모두 실행** (전략 메모 저장):

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `## Market` 섹션 내 `- 헤드라인:`, `- CTA:`, `- 트래픽 소스:` 라인을 Replace.

```markdown
- 헤드라인: {선택된 헤드라인}
- CTA: {설정된 CTA}
- 트래픽 소스: {선택된 트래픽 컨텍스트}
```

### 12. state 업데이트

state.json 업데이트:

- `meta.last_action = "landing"`
- `meta.total_actions++`

배포 완료 플래그, URL 등록, 자동 후속 실행은 기록하지 않는다.

## 규칙

- agnt가 랜딩을 대신 만들거나 배포하지 않는다 — ICP가 직접 한다
- 가이드는 짧고 직접적으로 — 마케팅 이론 아닌 실행 지침
- SPEC이 있으면 활용, 없으면 state 기반으로 진행 (비강제)
- 인터뷰 데이터가 있으면 고객 언어를 카피에 직접 활용
- 헤드라인은 반드시 3개 대안을 제시하고 근거를 밝힘
- Seven Sweeps는 카피 초안 완성 후 적용
- Anti-AI-slop 규칙 적용 — AI 냄새 나는 카피는 전환율을 깎는다
- 가짜 증거 금지 — 후기, 숫자, 사례가 없으면 해당 섹션 생략
- 벤치마크는 "정상 범위"를 알려주는 것이 목적 — 절대 기준 아님
- 이 스킬은 전략/카피 메모만 저장하고, 배포 완료 상태나 자동 후속 실행은 기록하지 않는다
- 한국어, 반말 톤
