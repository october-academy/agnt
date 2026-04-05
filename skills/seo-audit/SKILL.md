---
name: seo-audit
description: >-
  SEO+GEO 점검 → 수정 선택 → 구현. 25개 항목 자동 점검 후 코드 수정 가능 항목을 골라 바로 구현.
---

SEO + GEO 점검 + 자동 수정. 사이트 URL을 25개 항목(P0/P1/P2)으로 자동 점검한 뒤, 미비 항목을 선택하여 바로 구현까지 진행합니다.

## 데이터 경로 결정

### AGNT_DIR (선택적)

1. `.claude/agnt/state.json` Read → 성공 시 **AGNT_DIR = `.claude/agnt`**
2. `~/.claude/agnt/state.json` → **`~/.claude/agnt`**
3. `.codex/agnt/state.json` → **`.codex/agnt`**
4. `~/.codex/agnt/state.json` → **`~/.codex/agnt`**
5. 모두 없으면 → **AGNT_DIR = null** (state 없이 진행)

### REFS_DIR

AGNT_DIR이 있으면 `{AGNT_DIR}/references/` 탐색. null이면:

1. `~/.claude/plugins/marketplaces/agentic30/references/`
2. 없으면 → 내장 지식으로 진행

## 출력 규칙

내부 로직(경로 탐색, state 파싱, MCP 검색)은 무음 처리.

## 점검 항목 (25개)

### P0 — Critical (11개, 각 8점)

| #   | 항목             | 확인 방법                                                   |
| --- | ---------------- | ----------------------------------------------------------- |
| 1   | HTTPS            | URL `https://` 확인                                         |
| 2   | robots.txt       | 주요 경로 Disallow 없음                                     |
| 3   | sitemap.xml      | 접근 가능 + 유효 XML                                        |
| 4   | TTFB             | < 1초                                                       |
| 5   | 모바일 반응형    | viewport 메타 존재                                          |
| 6   | noindex 오용     | 주요 페이지에 noindex 없음                                  |
| 7   | title            | 존재, 60자 이내                                             |
| 8   | h1               | 1개 존재                                                    |
| 9   | meta description | 존재, 155자 이내                                            |
| 10  | OG 태그          | og:title + og:description + og:image (이미지 1200x630 권장) |
| 11  | canonical        | rel="canonical" 설정                                        |

### P1 — Important (10개, 각 5점)

| #   | 항목               | 확인 방법                                       |
| --- | ------------------ | ----------------------------------------------- |
| 12  | LCP                | < 2.5s (Chrome DevTools 또는 Lighthouse)        |
| 13  | CLS                | < 0.1                                           |
| 14  | 이미지 최적화      | 포맷(WebP/AVIF) + lazy loading + alt 텍스트     |
| 15  | Schema (JSON-LD)   | 1개 이상 존재                                   |
| 16  | AI 봇 접근         | robots.txt에서 AI 봇 미차단 (RFC 9309 기준)     |
| 17  | FAQPage Schema     | FAQPage JSON-LD 존재                            |
| 18  | Content-Answer Fit | 정의/단계/비교 블록 중 1개 이상                 |
| 19  | E-E-A-T 시그널     | 후기 섹션, 제작자 프로필, 외부 인용 중 1개 이상 |
| 20  | Trustworthiness    | HTTPS + 개인정보정책 링크 + 연락처/회사 정보    |
| 21  | SSR/SSG            | 서버사이드 렌더링 확인 (AI 크롤러가 JS 미실행)  |

### P2 — Recommended (4개, 각 2점)

| #   | 항목       | 확인 방법                         |
| --- | ---------- | --------------------------------- |
| 22  | 내부 링크  | 3개 이상                          |
| 23  | 외부 링크  | 1개 이상                          |
| 24  | URL 구조   | 짧고 깔끔, 불필요한 파라미터 없음 |
| 25  | Custom 404 | 유용한 404 페이지 존재            |

### AI 봇 접근 (#16) 판정 로직

- `User-agent: *` + `Allow: /` → ✅ (전체 허용, 명시 규칙 불필요)
- `User-agent: *`에 Disallow만 있고 AI 봇 명시 규칙 없음 → ✅ (나머지 경로 허용)
- AI 봇 명시 Disallow → ❌ + 차단 봇 목록 (GPTBot, ClaudeBot, PerplexityBot 등)
- robots.txt 없음 → ✅

## 실행 절차

### 1. 사전 조건 (Graceful)

AGNT_DIR ≠ null이면 `{AGNT_DIR}/state.json` Read.

- state 없거나 파싱 실패 → 경고 없이 진행

### 2. URL + 사이트 유형

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO + GEO 점검
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

전통 SEO + AI 검색엔진 최적화를 같이 점검해줄게.
```

AskUserQuestion: "점검할 URL은?" — 자유 입력

AskUserQuestion: "사이트 유형은?"

- A) 랜딩페이지 (1인 개발자 제품)
- B) SaaS / 웹앱
- C) 블로그 / 콘텐츠
- D) 기타

### 3. 데이터 수집 (2-tier)

`{REFS_DIR}/seo/seo-checklist.md`, `geo-optimization.md`, `ai-platform-factors.md` Read (있으면).

**Tier 1 — Chrome DevTools MCP (권장):**
`ToolSearch`로 `+chrome-devtools` 검색. 도구 발견 시:

1. `navigate_page`로 URL 접속
2. `evaluate_script`로 메타데이터 일괄 추출 (title, meta desc, OG, canonical, h1, JSON-LD, img alt, lang, viewport, noindex)
3. `performance_start_trace` (`reload: true`, `autoStop: true`) → CWV 측정
4. `lighthouse_audit` → Performance/SEO/Accessibility 점수
5. robots.txt, sitemap.xml은 WebFetch로 별도 확인

**Tier 2 — WebFetch 폴백:**
Chrome DevTools 없으면 WebFetch로 HTML + robots.txt + sitemap.xml 수집.
CWV(#12, #13)는 "측정 불가" 처리 + PageSpeed URL 안내.
**한계 경고**: JS 주입 JSON-LD 감지 불가 → Google Rich Results Test 안내.

Chrome DevTools 미설치 시: "CWV 자동 측정을 위해 `claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest` 설치 권장" 안내.

### 4. P0 점검

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  P0 — Critical
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Technical]
#1  HTTPS: {✅/❌}
#2  robots.txt: {✅/❌ + 차단 경로}
#3  sitemap.xml: {✅/❌ + URL 수}
#4  TTFB: {✅/❌ + 측정값}
#5  모바일 반응형: {✅/❌}
#6  noindex 오용: {✅/❌}

[On-Page]
#7  title: {✅/❌ + 현재값, 길이}
#8  h1: {✅/❌ + 현재값, 개수}
#9  meta description: {✅/❌ + 현재값, 길이}
#10 OG 태그: {✅/❌ + 누락 항목, og:image 사이즈 1200x630 확인}
#11 canonical: {✅/❌}
```

### 5. P1 점검

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  P1 — Important
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Core Web Vitals]
#12 LCP: {측정값 또는 "측정 불가"} (기준: < 2.5s)
#13 CLS: {측정값 또는 "측정 불가"} (기준: < 0.1)
  {Lighthouse 점수 표시. 미측정 시 PageSpeed URL 안내}

[Technical]
#14 이미지 최적화: {포맷, lazy loading, alt 누락 개수}
#15 Schema (JSON-LD): {✅/❌ + 감지된 @type}

[GEO]
#16 AI 봇 접근: {✅/❌ + 판정 근거}
#17 FAQPage Schema: {✅/❌}
#18 Content-Answer Fit: {✅/❌ + 블록 유형}

[E-E-A-T]
#19 E-E-A-T 시그널: {✅/❌ + 감지된 요소}
#20 Trustworthiness: {✅/❌ + 근거}
#21 SSR/SSG: {✅/❌ + 렌더링 방식, CDN}
```

### 6. P2 점검

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  P2 — Recommended
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#22 내부 링크: {개수}
#23 외부 링크: {개수}
#24 URL 구조: {✅/❌}
#25 Custom 404: {✅/❌/"확인 불가"}

[{site_type}별 참고] (점수 미포함)
```

**사이트 유형별 참고**:

- 랜딩페이지: OG 이미지 1200x630, 모바일 CTA 터치(44x44px), 로딩 3초 이내
- SaaS: 가격 페이지 Offer Schema, 기능별 랜딩, 비교 페이지
- 블로그: Article Schema, 저자 프로필, 목차 Jump Link

### 7. 점수 + 결과

점수: P0 8점, P1 5점, P2 2점. 만점 대비 비율.
"해당 없음" 항목은 만점에서 제외. CWV 미측정 시 해당 항목 배점 제외.

```
══════════════════════════════════════════
  SEO + GEO 점검 결과
══════════════════════════════════════════

URL: {URL}  |  유형: {site_type}

──────────────────────────────────────────
  점수: {점수}% ({등급})
──────────────────────────────────────────

  전통 SEO:  {trad}%  [{bar}]
  GEO (AI):  {geo}%   [{bar}]
  E-E-A-T:   {eeat}%  [{bar}]

  A (90%+) | B (75-89%) | C (60-74%) | D (<60%)

✅ 통과: {개수}/{전체}
❌ 미비 (우선순위순):
  {[Px] 항목명 — 1줄 수정 방법}

══════════════════════════════════════════
```

### 8. 수정 항목 선택

미비 0개 → Step 11로.

미비 항목을 카테고리별로 분류하여 AskUserQuestion (Multi-Select):

**🔧 AUTO — 코드로 바로 수정 가능:**

| 대상 항목          | 수정 방법                                           |
| ------------------ | --------------------------------------------------- |
| #7-11 메타데이터   | layout/metadata 파일 수정 (OG 이미지 1200x630 포함) |
| #14 이미지 alt     | img 태그에 alt 추가                                 |
| #15 Schema JSON-LD | head에 JSON-LD 추가/수정                            |
| #16 AI 봇 접근     | robots.txt Disallow 제거 (명시 차단 시에만)         |
| #25 Custom 404     | 404 페이지 생성                                     |

**✏️ SEMI — 콘텐츠 확인 후 구현 (카피/구조 변경이라 유저 승인 필요):**

| 대상 항목              | 필요 입력                                                     |
| ---------------------- | ------------------------------------------------------------- |
| #17 FAQPage            | FAQ 초안 3-5개 생성 → 유저 확인 → JSON-LD + visible 섹션 적용 |
| #18 Content-Answer Fit | 정의/단계/비교 블록 초안 → 유저 확인 후 적용 (전환 카피 보호) |
| #19 E-E-A-T 시그널     | 후기, 제작자 정보, 또는 외부 인용 중 택                       |

```
어떤 항목을 지금 수정할까? (복수 선택 가능)

🔧 코드 수정:
  □ A) #{n} {항목명} — {1줄 설명} [P{x}]
  ...
✏️ 콘텐츠 + 코드:
  □ X) #19 E-E-A-T — 후기/프로필/인용 섹션 추가 [P1]
──────────────────
  □ ALL) 🔧 전체 자동 수정
  □ SKIP) 수정 없이 종료
```

SKIP → Step 11로.
ALL → AUTO 항목 전체 선택.

### 9. 콘텐츠 수집

SEMI 항목이 선택된 경우에만 실행.

**#17 FAQPage 선택 시**:
페이지 콘텐츠를 분석하여 FAQ 3-5개 초안 생성 → AskUserQuestion으로 유저 확인:
"이 FAQ로 진행할까? 수정/삭제/추가해줘."
확인 후 visible FAQ 섹션 + FAQPage JSON-LD 동시 적용.

**#18 Content-Answer Fit 선택 시**:
페이지에 맞는 블록(정의/단계/비교) 초안 생성 → AskUserQuestion으로 유저 확인:
"이 블록을 페이지에 추가할까? 기존 전환 카피와 충돌하지 않는지 확인해줘."

**#19 E-E-A-T 선택 시**:
AskUserQuestion: "어떤 E-E-A-T 시그널을 추가할까?"

- A) 후기/사례 — "이름, 한 줄 후기, 결과를 알려줘"
- B) 제작자 프로필 — "이름, 소개, 경력/자격을 알려줘"
- C) 둘 다

입력/확인받은 콘텐츠를 구현에 사용.

### 10. 구현

**프로젝트 판별**: 점검 URL이 현재 작업 디렉토리 프로젝트인지 확인.

- 프로젝트 외부 → 수정 코드 스니펫만 제공하고 Step 11로.
- 프로젝트 내부 → 대상 파일 탐색 후 직접 수정.

**파일 탐색**:

- 메타데이터: layout 파일 (Next.js `metadata` export, Astro frontmatter 등)
- robots.txt: `public/robots.txt` 또는 `app/robots.ts`
- JSON-LD: 기존 `script[type="application/ld+json"]` 위치
- 페이지 콘텐츠: 해당 페이지 컴포넌트
- 이미지: `<img>` 태그가 있는 컴포넌트

**수정 원칙**:

- 프로젝트 기존 코드 스타일/패턴 준수
- SEO 관련 변경만 — 구조적 리팩토링 금지
- FAQPage/Content-Answer Fit: SEMI 항목 — Step 9에서 유저 승인받은 초안만 적용
- AI 봇 접근: `User-agent: *` + `Allow: /`이면 수정 불필요. 명시 Disallow만 제거.

각 항목 완료 시:

```
✅ #{n} {항목명} — {변경 파일}
```

전체 완료 후 TypeScript 프로젝트면 typecheck 실행. 에러 시 즉시 수정.

### 11. 완료

**외부 작업 가이드** (코드로 해결 불가한 최적화 안내):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  외부 작업 가이드
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ Google Search Console — search.google.com/search-console
□ NAVER Search Advisor — searchadvisor.naver.com
□ Bing Webmaster Tools — bing.com/webmasters (Copilot 가시성)
□ Brave Search 등록 — brave.com/search/submit (Claude 검색 소스)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**GEO 팁** (geo_score < 50%이고 미수정 GEO 항목이 남아있으면):

```
AI 검색에서 인용되려면:
1. FAQPage Schema (+Perplexity, AI Overview)
2. Content-Answer Fit (+55% ChatGPT 인용)
3. 구체적 숫자/통계 (+37% 가시성)
```

**journey-brief.md + state** (AGNT_DIR ≠ null):

- `{AGNT_DIR}/journey-brief.md` `## Market > ### SEO` 추가/갱신
- state.json: `artifacts.seo_audited = true`, `meta.last_action = "seo-audit"`, `meta.total_actions++`
- MCP `submit_practice` (wf-seo-audit) 또는 `sync.pending_events` 큐잉

**완료 출력**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SEO + GEO 점검 {수정 시: "+ 수정"} 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{수정 시: ✅ N개 수정, 📊 이전%→예상% (등급→등급)}
{미비 남아있으면: → 남은 N개는 배포 후 /seo-audit 재실행}

{등급별 다음 행동:
  A: SEO+GEO 완비. → /agnt:channel로 첫 트래픽을 보내봐.
  B: 양호. → /agnt:channel로 커뮤니티 유입 시작하면서 남은 P1 보완.
  C: P0부터 수정 후 재실행. 수정 완료되면 /agnt:channel로 유입 시작.
  D: 색인 문제. P0 즉시 수정 필수. 수정 후 재점검.}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 규칙

- 점수를 부풀리지 않는다 — 미비는 미비로
- 애매하면 보수적 판정 (미비로)
- AI 봇: RFC 9309 — `User-agent: *` + `Allow: /`이면 전체 허용, 명시 규칙 불필요
- Schema 검증 한계 명시 (JS 주입 감지 불가)
- 구현 시 기존 코드 스타일 준수, SEO 변경만
- 기존 기능 깨뜨리지 않음 — 수정 후 typecheck 필수
- AGNT_DIR null이면 state/journey-brief skip
- 한국어, 반말 톤
