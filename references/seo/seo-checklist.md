# SEO 점검 체크리스트 (25항목)

## P0 — Critical (색인/랭킹을 차단하는 문제)

### Technical SEO

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 1 | HTTPS | URL이 `https://`로 시작 | 브라우저 경고 + 검색 순위 하락 |
| 2 | robots.txt 허용 | `/robots.txt`에서 주요 경로 `Disallow` 없음 | 크롤러 차단 → 색인 불가 |
| 3 | sitemap.xml 존재 | `/sitemap.xml` 접근 가능 + 유효한 XML | 새 페이지 발견 지연 |
| 4 | 응답 속도 (TTFB) | 첫 응답 1초 이내 | 이탈률 증가 + 크롤링 예산 낭비 |
| 5 | 모바일 반응형 | viewport 메타 + 반응형 레이아웃 | 모바일 검색 순위 하락 (모바일 우선 색인) |
| 6 | noindex 오용 확인 | 주요 페이지에 `noindex` 태그 없음 | 의도치 않은 색인 제외 |

### On-Page SEO

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 7 | `<title>` 태그 | 존재, 60자 이내, 핵심 키워드 앞 배치 | 검색 결과 제목 누락/잘림 |
| 8 | `<h1>` 태그 | 페이지당 1개, 핵심 키워드 포함 | 검색엔진이 페이지 주제 파악 못 함 |
| 9 | `<meta description>` | 존재, 155자 이내, CTA 포함 | 검색 결과 설명 자동 생성 (CTR 하락) |
| 10 | OG 태그 3종 | `og:title`, `og:description`, `og:image` (1200x630 권장) | 링크 공유 시 미리보기 깨짐 |
| 11 | canonical URL | `<link rel="canonical">` 설정 | 중복 콘텐츠 패널티 |

## P1 — Important (랭킹에 중요한 요소)

### Core Web Vitals

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 12 | LCP | < 2.5초 (Largest Contentful Paint) | 사용자 경험 점수 하락 |
| 13 | CLS | < 0.1 (Cumulative Layout Shift) | 레이아웃 흔들림 |

### Technical SEO

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 14 | 이미지 최적화 | WebP/AVIF, 압축, lazy loading, alt 텍스트 | 속도 저하 + 접근성 |
| 15 | 구조화 데이터 (Schema) | JSON-LD 존재 (Organization, Course 등) | 리치 결과 미표시 |

### GEO (AI 검색엔진 최적화)

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 16 | AI 봇 접근 허용 | robots.txt에서 AI 봇이 차단(Disallow)되지 않음 | AI 검색에서 인용 안 됨 |
| 17 | FAQPage Schema | JSON-LD FAQPage 존재 | Perplexity, Google AI Overview 가시성 하락 |
| 18 | Content-Answer Fit | 정의/단계/비교 블록 구조 사용 | ChatGPT 인용 확률 하락 (55% 비중) |

### E-E-A-T (콘텐츠 품질)

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 19 | E-E-A-T 시그널 | 후기/사례 섹션, 제작자 프로필, 외부 인용 중 1개 이상 | 콘텐츠 신뢰도/권위 하락 |
| 20 | Trustworthiness | HTTPS + 개인정보정책 링크 + 연락처/회사 정보 | 신뢰 부족 |
| 21 | SSR/SSG | 서버사이드 렌더링 확인 (AI 크롤러가 JS 미실행) | AI 검색 인용 불가 + 초기 색인 지연 |

## P2 — Recommended (추가 최적화)

| # | 항목 | 확인 방법 |
|---|------|-----------|
| 22 | 내부 링크 | 중요 페이지로의 내부 링크 3개 이상 |
| 23 | 외부 링크 | 권위 있는 외부 소스 링크 1개 이상 |
| 24 | URL 구조 | 짧고 키워드 포함, 불필요한 파라미터 없음 |
| 25 | Custom 404 | 유용한 404 페이지 (홈 링크 포함) |

## 사이트 유형별 추가 점검 (점수 미포함, 참고용)

### 랜딩페이지 (1인 개발자)

- [ ] OG 이미지 1200x630px (링크 공유 최적화)
- [ ] 모바일에서 CTA 버튼 터치 가능 (44x44px 최소)
- [ ] 로딩 3초 이내 (모바일 기준)
- [ ] Google Search Console + NAVER Search Advisor 등록

### SaaS / 웹앱

- [ ] 가격 페이지 Schema (Offer, PriceSpecification)
- [ ] 무료 체험 CTA가 검색 결과에서 보이는가
- [ ] 기능별 랜딩페이지 존재 (long-tail 키워드)
- [ ] 비교 페이지 ("X vs Y")

### 블로그 / 콘텐츠

- [ ] Article Schema (JSON-LD)
- [ ] 저자 프로필 + 전문성 표시
- [ ] 목차 (Table of Contents) Jump Link
- [ ] 발행일/수정일 표시

## 등급 기준

점수 산정: P0 항목 8점, P1 항목 5점, P2 항목 2점. 만점 대비 비율.

**"해당 없음" 항목 처리**: 사이트 유형에 해당하지 않거나 측정 불가한 항목(예: CWV 미측정)은 만점 계산에서 **제외**.

| 비율 | 등급 | 판정 |
|------|------|------|
| 90%+ | A | 기본+GEO 완비 — 콘텐츠와 트래픽에 집중 |
| 75-89% | B | 양호 — P1 미비 항목 보완 |
| 60-74% | C | 개선 필요 — P0 항목 우선 해결 |
| 0-59% | D | 긴급 — 색인/크롤링 자체에 문제 |

**P0 Hard Gate**: P0 미비 1개 이상 → 등급 상한 C. P0 미비 2개 이상 또는 noindex 오용/robots 차단 → 등급 상한 D.

## 항목별 개선 방법

### HTTPS
- Vercel/Cloudflare/Netlify: 기본 제공
- 자체 서버: Let's Encrypt 무료 인증서 → `certbot`

### title 태그
```html
<title>혼밥 친구 찾기 — 5분 안에 점심 파트너 매칭 | 밥친구</title>
```
핵심 키워드 앞 배치, 브랜드명 뒤에 `|`로 구분, 60자 이내.

### meta description
```html
<meta name="description" content="직장인 점심 고민 해결. 5분 안에 점심 파트너를 찾아주는 앱. 무료로 시작하세요.">
```
문제 → 해결 → CTA 구조. 155자 이내.

### OG 태그
```html
<meta property="og:title" content="밥친구 — 혼밥 끝내는 점심 매칭">
<meta property="og:description" content="5분 안에 근처 점심 파트너를 찾아줍니다">
<meta property="og:image" content="https://example.com/og-image.png">
```
og:image 권장: 1200x630px. 생성 도구: Canva, og.dev, @vercel/og.

### robots.txt (AI 봇 포함)

**기본**: `User-agent: *` + `Allow: /`이면 AI 봇 포함 모든 봇이 이미 허용됨. 명시 규칙 불필요.
```
User-agent: *
Allow: /
Sitemap: https://example.com/sitemap.xml
```

**`*`에 제한이 있고 AI 봇만 예외를 줄 때**만 명시 규칙 추가:
```
User-agent: *
Disallow: /api
Disallow: /admin
Sitemap: https://example.com/sitemap.xml

# AI 봇은 전체 허용 (API 문서 포함)
User-agent: GPTBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: PerplexityBot
Allow: /
```

### sitemap.xml
Next.js: `app/sitemap.ts` 또는 `next-sitemap`. Astro: `@astrojs/sitemap`.
Google Search Console + NAVER Search Advisor에 제출.

### Schema (JSON-LD)
geo-optimization.md의 FAQPage 템플릿 참조.

## Schema Markup 검증 한계

**`WebFetch`로는 구조화 데이터를 확인할 수 없는 경우가 많다.**
많은 CMS/프레임워크가 클라이언트 JS로 JSON-LD를 주입하기 때문.

정확한 확인 방법:
1. Chrome DevTools MCP로 실제 렌더된 HTML 검사
2. Google Rich Results Test
3. Schema.org Validator
