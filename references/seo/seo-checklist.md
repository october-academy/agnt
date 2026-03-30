# SEO 점검 체크리스트 (P0/P1/P2)

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
| 10 | OG 태그 3종 | `og:title`, `og:description`, `og:image` | 링크 공유 시 미리보기 깨짐 |
| 11 | canonical URL | `<link rel="canonical">` 설정 | 중복 콘텐츠 패널티 |

## P1 — Important (랭킹에 중요한 요소)

### Technical SEO

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 12 | Core Web Vitals: LCP | < 2.5초 (Largest Contentful Paint) | 사용자 경험 점수 하락 |
| 13 | Core Web Vitals: INP | < 200ms (Interaction to Next Paint) | 상호작용 지연 |
| 14 | Core Web Vitals: CLS | < 0.1 (Cumulative Layout Shift) | 레이아웃 흔들림 |
| 15 | 이미지 최적화 | WebP/AVIF, 압축, lazy loading, alt 텍스트 | 속도 저하 + 접근성 |
| 16 | 리다이렉트 체인 없음 | 301/302 체인 2단계 이하 | 크롤링 예산 낭비 |
| 17 | 깨진 내부 링크 없음 | 404 반환하는 내부 링크 없음 | 크롤링 예산 낭비 + UX |
| 18 | 구조화 데이터 (Schema) | JSON-LD 존재 (FAQPage, SoftwareApplication 등) | 리치 결과 미표시 |

### GEO (AI 검색엔진 최적화)

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 19 | AI 봇 접근 허용 | robots.txt에 GPTBot, ClaudeBot, PerplexityBot Allow | AI 검색에서 인용 안 됨 |
| 20 | FAQPage Schema | JSON-LD FAQPage 존재 | Perplexity, Google AI Overview 가시성 하락 |
| 21 | Content-Answer Fit | 정의/단계/비교 블록 구조 사용 | ChatGPT 인용 확률 하락 (55% 비중) |
| 22 | 통계/숫자 포함 | 페이지에 구체적 데이터 포인트 존재 | AI 가시성 -37% |

### E-E-A-T (콘텐츠 품질)

| # | 항목 | 확인 방법 | 미비 시 영향 |
|---|------|-----------|-------------|
| 23 | Experience (경험) | 직접 경험, 원본 인사이트/데이터, 실제 예시 | 콘텐츠 신뢰도 하락 |
| 24 | Expertise (전문성) | 저자 정보 표시, 정확한 정보, 출처 명시 | 권위 부족 |
| 25 | Authoritativeness (권위) | 다른 사이트에서 인용/링크, 업계 자격 | 도메인 권위 부족 |
| 26 | Trustworthiness (신뢰) | 정확, 투명, 연락처, 개인정보 정책, HTTPS | 신뢰 부족 |

## P2 — Recommended (추가 최적화)

### On-Page SEO

| # | 항목 | 확인 방법 |
|---|------|-----------|
| 27 | 첫 100단어에 핵심 키워드 | 콘텐츠 초반에 주제 명확 |
| 28 | 관련 키워드 사용 | LSI/관련어 자연스럽게 포함 |
| 29 | 내부 링크 | 중요 페이지로의 내부 링크 3개 이상 |
| 30 | 외부 링크 | 권위 있는 외부 소스 링크 1-2개 |
| 31 | URL 구조 | 짧고 키워드 포함, 불필요한 파라미터 없음 |
| 32 | 이미지 파일명 | 설명적 파일명 (IMG_001.jpg → product-dashboard.webp) |

### GEO 추가

| # | 항목 | 확인 방법 |
|---|------|-----------|
| 33 | SpeakableSpecification | 음성 검색용 JSON-LD 스키마 |
| 34 | Brave Search 등록 | brave.com/search에 사이트 인덱싱 |
| 35 | Bing Webmaster Tools 등록 | Copilot 가시성 |
| 36 | PDF 자료 제공 | Perplexity가 PDF 우선 인덱싱 |
| 37 | 30일 이내 콘텐츠 | ChatGPT가 최신 콘텐츠 3.2x 더 인용 |
| 38 | LinkedIn/GitHub 연결 | Copilot 신뢰도 부스트 |

### Technical 추가

| # | 항목 | 확인 방법 |
|---|------|-----------|
| 39 | 404 커스텀 페이지 | 유용한 404 페이지 (검색/홈 링크) |
| 40 | hreflang (다국어) | 다국어 사이트 시 hreflang 태그 |
| 41 | CDN 사용 | 글로벌 접근 속도 |
| 42 | JavaScript 렌더링 확인 | SPA는 SSR/SSG 필수 (AI 크롤러가 JS 실행 안 함) |

## 사이트 유형별 추가 점검

### SaaS / 웹앱

- [ ] 가격 페이지 Schema (Offer, PriceSpecification)
- [ ] 무료 체험 CTA가 검색 결과에서 보이는가
- [ ] 기능별 랜딩페이지 존재 (long-tail 키워드)
- [ ] 비교 페이지 ("X vs Y")
- [ ] API 문서 색인 허용 (개발자 검색 유입)

### 랜딩페이지 (1인 개발자)

- [ ] 단일 페이지라도 sitemap.xml 존재
- [ ] OG 이미지 1200×630px (링크 공유 최적화)
- [ ] 모바일에서 CTA 버튼 터치 가능 (44×44px 최소)
- [ ] 로딩 3초 이내 (모바일 기준)
- [ ] Google Search Console + NAVER Search Advisor 등록

### 블로그 / 콘텐츠

- [ ] Article Schema (JSON-LD)
- [ ] 저자 프로필 + 전문성 표시
- [ ] 목차 (Table of Contents) 있으면 Jump Link
- [ ] 발행일/수정일 표시
- [ ] 관련 글 내부 링크

## 등급 기준

점수 산정: P0 항목 8점, P1 항목 5점, P2 항목 2점. 만점 대비 비율.

**"해당 없음" 항목 처리**: 사이트 유형에 해당하지 않는 항목(예: 단일 언어 사이트의 hreflang, 음성 검색 미타겟 시 SpeakableSpecification)은 만점 계산에서 **제외**한다. 해당 항목의 배점을 만점에서 빼고 비율을 산출.

| 비율 | 등급 | 판정 |
|------|------|------|
| 90%+ | A | 기본+GEO 완비 — 콘텐츠와 트래픽에 집중 |
| 75-89% | B | 양호 — P1 미비 항목 보완 |
| 60-74% | C | 개선 필요 — P0 항목 우선 해결 |
| 0-59% | D | 긴급 — 색인/크롤링 자체에 문제 |

**P0 Hard Gate**: P0 미비 항목이 1개 이상이면 등급 상한 C. P0 미비 2개 이상이거나 noindex 오용/robots 차단이면 등급 상한 D. 비율 점수가 높아도 P0 미비가 있으면 A/B 등급을 받을 수 없다.

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
og:image 권장: 1200×630px. 생성 도구: Canva, og.dev, @vercel/og.

### robots.txt (AI 봇 포함)
```
User-agent: *
Allow: /
Sitemap: https://example.com/sitemap.xml

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
geo-optimization.md의 템플릿 참조. FAQPage부터 시작.

## Schema Markup 검증 한계

**`WebFetch`로는 구조화 데이터를 확인할 수 없는 경우가 많다.**
많은 CMS/프레임워크가 클라이언트 JS로 JSON-LD를 주입하기 때문.

정확한 확인 방법:
1. 브라우저 도구로 실제 렌더된 HTML 검사
2. Google Rich Results Test
3. Schema.org Validator

## 점검 후 다음 단계

1. P0 미비 항목 즉시 수정
2. Google Search Console + NAVER Search Advisor + Bing Webmaster Tools 등록
3. sitemap 제출
4. P1 항목 보완 (특히 GEO)
5. 1-2주 후 색인 상태 확인
6. 콘텐츠로 검색 유입 확대 → `/agnt:content`
