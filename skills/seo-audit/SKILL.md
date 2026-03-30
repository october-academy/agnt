---
name: seo-audit
description: >-
  SEO+GEO 점검 — P0/P1/P2 계층, AI 봇 검증, E-E-A-T. SEO 점검, 사이트 진단 시 사용.
---

SEO + GEO 점검. 사이트 URL의 전통 SEO 요소와 AI 검색엔진 최적화를 P0/P1/P2 우선순위로 점검합니다.

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
- `artifacts.landing_deployed == false` → "아직 랜딩을 배포하지 않았어. 먼저 `/agnt:landing`으로 랜딩을 만들고 배포한 다음 다시 와." 종료

기본값 보증 (navigator-engine.md 필드 기본값 규칙):
- `artifacts.seo_audited`가 undefined면 `false`로 처리
- `artifacts.landing_deployed`가 undefined면 `false`로 처리

### 2. URL 입력 + 사이트 유형 확인

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO + GEO 점검
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

전통 SEO + AI 검색엔진 최적화를 같이 점검해줄게.
사이트 URL을 알려줘.
```

AskUserQuestion: "점검할 URL은?"
- 자유 입력 (예: "https://myproduct.com")

AskUserQuestion: "사이트 유형은?"
- A) 랜딩페이지 (1인 개발자 제품)
- B) SaaS / 웹앱
- C) 블로그 / 콘텐츠 사이트
- D) 기타

사이트 유형을 `site_type`에 저장. 유형별 추가 점검 항목이 달라진다.

### 3. 점검 모드 결정 (3-tier 폴백)

`{REFS_DIR}/seo/seo-checklist.md` Read.
`{REFS_DIR}/seo/geo-optimization.md` Read.
`{REFS_DIR}/seo/ai-platform-factors.md` Read.

**Tier 1 — 자동 점검 (gstack /browse):**
gstack /browse가 사용 가능하면 URL에 접속하여 자동 점검.
HTML 소스에서 title, meta description, OG 태그, viewport, h1, canonical, JSON-LD Schema를 파싱.
robots.txt, sitemap.xml 접근을 확인.
응답 시간을 측정.
AI 봇(GPTBot, ClaudeBot, PerplexityBot) 관련 규칙을 robots.txt에서 확인.

**Tier 2 — WebFetch 폴백:**
gstack 불가 시 WebFetch로 HTML을 가져와 동일 항목을 점검.
robots.txt, sitemap.xml은 별도 WebFetch.
**Schema 검증 한계 경고**: WebFetch로는 클라이언트 JS로 주입된 JSON-LD를 감지할 수 없다. 유저에게 Google Rich Results Test 확인을 안내.

**Tier 3 — 수동 체크리스트:**
자동 도구가 모두 불가 시, seo-checklist.md 기반으로 AskUserQuestion을 통해 유저에게 직접 확인.
P0 항목부터 순차적으로 질문.

### 4. P0 점검 — Critical (색인/랭킹 차단 문제)

seo-checklist.md의 P0 항목(11개)을 점검.

각 항목별 결과 기록:
- ✅ 통과 — 정상
- ❌ 미비 — 문제 + 구체적 수정 방법

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  P0 — Critical 점검
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Technical SEO]
{#1 HTTPS}: {✅ 또는 ❌ + 수정 방법}
{#2 robots.txt}: {✅ 또는 ❌}
{#3 sitemap.xml}: {✅ 또는 ❌}
{#4 TTFB}: {✅ 또는 ❌ + 측정값}
{#5 모바일 반응형}: {✅ 또는 ❌}
{#6 noindex 오용}: {✅ 또는 ❌}

[On-Page SEO]
{#7 title 태그}: {✅ 또는 ❌ + 현재값/길이}
{#8 h1 태그}: {✅ 또는 ❌ + 현재값}
{#9 meta description}: {✅ 또는 ❌ + 현재값/길이}
{#10 OG 태그}: {✅ 또는 ❌ + 누락 항목}
{#11 canonical}: {✅ 또는 ❌}
```

### 5. P1 점검 — Important (랭킹 중요 요소)

seo-checklist.md의 P1 항목(15개)을 점검.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  P1 — Important 점검
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Core Web Vitals]
{#12 LCP}: {측정값} → {Good/Needs Improvement/Poor} (기준: < 2.5s)
{#13 INP}: {측정값 또는 "측정 불가"} (기준: < 200ms)
{#14 CLS}: {측정값 또는 "측정 불가"} (기준: < 0.1)

[Technical]
{#15 이미지 최적화}: {WebP? lazy loading? alt?}
{#16 리다이렉트 체인}: {✅ 또는 ❌}
{#17 깨진 내부 링크}: {✅ 또는 ❌}
{#18 Schema (JSON-LD)}: {✅ 또는 ❌ + 타입}

[GEO — AI 검색엔진 최적화]
{#19 AI 봇 접근}: {✅ 또는 ❌ + 어떤 봇이 차단됨}
{#20 FAQPage Schema}: {✅ 또는 ❌}
{#21 Content-Answer Fit}: {✅ 또는 ❌ + 정의/단계/비교 블록 여부}
{#22 통계/숫자 포함}: {✅ 또는 ❌}

[E-E-A-T]
{#23 Experience}: {✅ 또는 ❌}
{#24 Expertise}: {✅ 또는 ❌}
{#25 Authoritativeness}: {✅ 또는 ❌}
{#26 Trustworthiness}: {✅ 또는 ❌}
```

### 6. P2 점검 — Recommended

seo-checklist.md의 P2 항목 중 사이트 유형에 해당하는 것만 점검.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  P2 — Recommended
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[On-Page]
{해당 항목들}

[GEO 추가]
{해당 항목들}

[{site_type}별 추가 점검]
{사이트 유형에 맞는 추가 항목}
```

### 7. 점수 산정 + 결과 출력

점수 산정: P0 항목 8점, P1 항목 5점, P2 항목 2점. 만점 대비 비율로 등급 산출.

```
══════════════════════════════════════════
  SEO + GEO 점검 결과
══════════════════════════════════════════

URL: {입력한 URL}
사이트 유형: {site_type}

──────────────────────────────────────────
  점수: {점수}% ({등급})
──────────────────────────────────────────

  전통 SEO:  {trad_score}%  [{bar}]
  GEO (AI):  {geo_score}%   [{bar}]
  E-E-A-T:   {eeat_score}%  [{bar}]

──────────────────────────────────────────
  등급: {A/B/C/D}
──────────────────────────────────────────
  A (90%+): 기본+GEO 완비 — 콘텐츠와 트래픽에 집중
  B (75-89%): 양호 — P1 미비 항목 보완
  C (60-74%): 개선 필요 — P0 항목 우선 해결
  D (0-59%): 긴급 — 색인/크롤링 자체에 문제

✅ 통과 항목: {개수}/{전체}
  {통과한 항목 나열}

❌ 미비 항목 (우선순위순):
  [P0] {미비 항목 + 구체적 수정 방법}
  [P1] {미비 항목 + 구체적 수정 방법}
  [P2] {미비 항목 + 구체적 수정 방법}

══════════════════════════════════════════
```

### 8. GEO 최적화 가이드

geo_score가 50% 미만이면 GEO 가이드 출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  GEO 최적화 가이드
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

AI 검색엔진에서 인용되려면:

1. 구체적 숫자/통계 추가 (+37% 가시성)
   → 페이지에 데이터 포인트가 있어야 AI가 인용할 수 있어.

2. FAQPage Schema 추가 (+Perplexity, Google AI Overview)
   → geo-optimization.md의 JSON-LD 템플릿 참조.

3. robots.txt에 AI 봇 허용
   → GPTBot, ClaudeBot, PerplexityBot Allow

4. Content-Answer Fit
   → "X가 뭐야?" 질문에 바로 답하는 문장 구조.
   → ChatGPT 인용의 55%가 이 구조에 의존.

상세: /agnt:tools → 분석 도구 섹션 참조
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 9. OG 이미지 미비 안내

og:image가 없거나 비어있으면:

```
⚠️ OG 이미지가 없어. 링크 공유 시 미리보기가 깨져.

무료 생성 도구:
• Canva — canva.com (1200×630 템플릿)
• og.dev — 코드 기반 동적 OG 이미지
• @vercel/og — Vercel 프로젝트용

OG 이미지 설정 후 다시 점검해봐.
```

### 10. AI 봇 차단 경고

robots.txt에서 AI 봇이 Disallow되어 있으면:

```
⚠️ AI 봇이 차단되어 있어!

차단된 봇: {차단된 봇 목록}

이 봇들이 차단되면 해당 AI 검색에서 네 사이트가 인용되지 않아.
의도적으로 차단한 거라면 괜찮지만, 아니라면 robots.txt를 수정해:

User-agent: GPTBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: PerplexityBot
Allow: /
```

### 11. 사이트 유형별 추가 권고

**랜딩페이지 (1인 개발자)**:
```
□ 단일 페이지라도 sitemap.xml 존재
□ OG 이미지 1200×630px
□ 모바일 CTA 터치 가능 (44×44px 최소)
□ 로딩 3초 이내 (모바일)
□ Google Search Console + NAVER Search Advisor 등록
```

**SaaS / 웹앱**:
```
□ 가격 페이지에 Offer Schema
□ 무료 체험 CTA가 검색 결과에서 보임
□ 기능별 랜딩페이지 (long-tail 키워드)
□ 비교 페이지 ("X vs Y")
□ API 문서 색인 허용
```

**블로그 / 콘텐츠**:
```
□ Article Schema (JSON-LD)
□ 저자 프로필 + 전문성 표시
□ 목차 Jump Link
□ 발행일/수정일 표시
□ 관련 글 내부 링크
```

### 12. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `## Market` 섹션에 `### SEO` 서브섹션을 추가 또는 Replace.

SEO 섹션:
```markdown
### SEO
- 점검 URL: {URL}
- 점수: {점수}% ({등급})
- 전통 SEO: {trad_score}% | GEO: {geo_score}% | E-E-A-T: {eeat_score}%
- P0 미비: {미비 항목 요약}
- P1 미비: {미비 항목 요약}
- 점검일: {날짜}
```

### 13. 완료 출력 + state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.seo_audited = true`
- `meta.last_action = "seo-audit"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-seo-audit"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-seo-audit" }, "created_at": "<now()>" }
  ```
- state.json 저장

완료 출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO + GEO 점검 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{등급에 따른 메시지}

A: 기본 SEO + GEO 완비됐어. 콘텐츠로 검색 유입을 확대하자 → /agnt:content
B: 양호해. P1 미비 항목을 보완하고 다시 /agnt:seo-audit 해봐.
C: P0 항목부터 수정해. 수정 후 다시 /agnt:seo-audit 실행.
D: 색인 자체에 문제야. P0 항목 즉시 수정 필수.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 규칙

- 점수를 부풀리지 않는다 — 미비 항목은 미비로 표시
- 자동 점검 결과가 애매하면 보수적으로 판정 (미비로)
- OG 이미지는 반드시 체크 — 링크 공유 시 가장 체감 큰 항목
- AI 봇 차단 여부는 반드시 체크 — 2026년에 AI 검색 미최적화는 기회 손실
- Schema 자동 검증 한계를 유저에게 명시 (클라이언트 JS 주입 감지 불가)
- P0 → P1 → P2 순서로 점검하고 보고
- 전통 SEO, GEO, E-E-A-T 세 영역 점수를 분리 표시
- 사이트 유형별 추가 권고 포함
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
