# SEO 기본 점검 체크리스트

랜딩페이지/프로덕트 사이트의 SEO 기본 요소 10개 항목 점검.

## 점검 항목 (총 100점)

| # | 항목 | 배점 | 확인 방법 | 미비 시 영향 |
|---|------|------|-----------|-------------|
| 1 | HTTPS | 10 | URL이 `https://`로 시작 | 브라우저 경고 + 검색 순위 하락 |
| 2 | `<title>` 태그 | 10 | 60자 이내, 핵심 키워드 포함 | 검색 결과에서 제목 누락/잘림 |
| 3 | `<meta description>` | 10 | 155자 이내, CTA 포함 | 검색 결과 설명 자동 생성 (제어 불가) |
| 4 | OG 태그 3종 | 15 | `og:title`, `og:description`, `og:image` 존재 | 링크 공유 시 미리보기 깨짐 |
| 5 | viewport 메타 | 5 | `<meta name="viewport" content="width=device-width, initial-scale=1">` | 모바일 검색 순위 하락 |
| 6 | `<h1>` 태그 | 10 | 페이지당 1개, 핵심 키워드 포함 | 검색엔진이 페이지 주제 파악 못 함 |
| 7 | robots.txt | 10 | `/robots.txt` 접근 가능, 주요 경로 허용 | 크롤러 차단 → 색인 불가 |
| 8 | sitemap.xml | 10 | `/sitemap.xml` 존재, 유효한 XML | 새 페이지 발견 지연 |
| 9 | canonical URL | 10 | `<link rel="canonical">` 또는 자동 설정 | 중복 콘텐츠 패널티 가능 |
| 10 | 응답 속도 | 10 | 첫 응답(TTFB) 1초 이내 | 이탈률 증가 + 크롤링 예산 낭비 |

## 등급 기준

| 점수 | 등급 | 판정 |
|------|------|------|
| 90-100 | A | 기본 SEO 완비 — 콘텐츠 최적화에 집중 |
| 70-89 | B | 양호 — 미비 항목 보완 후 재점검 |
| 50-69 | C | 개선 필요 — 검색 노출에 불리한 상태 |
| 0-49 | D | 긴급 — 기본 요소부터 세팅 필요 |

## 항목별 개선 방법

### 1. HTTPS

- Vercel/Cloudflare/Netlify: 기본 제공 (설정 불필요)
- 자체 서버: Let's Encrypt 무료 인증서 → `certbot` 설치
- 확인: 브라우저 주소창 자물쇠 아이콘

### 2. title 태그

```html
<title>혼밥 친구 찾기 — 5분 안에 점심 파트너 매칭 | 밥친구</title>
```

- 핵심 키워드를 앞에 배치
- 브랜드명은 뒤에 `|`로 구분
- 60자 초과 시 검색 결과에서 잘림

### 3. meta description

```html
<meta name="description" content="직장인 점심 고민 해결. 위치 기반으로 5분 안에 점심 파트너를 찾아주는 앱. 무료로 시작하세요.">
```

- 155자 이내
- 문제 → 해결 → CTA 구조
- 검색 결과 클릭률(CTR)에 직접 영향

### 4. OG 태그 3종

```html
<meta property="og:title" content="밥친구 — 혼밥 끝내는 점심 매칭">
<meta property="og:description" content="5분 안에 근처 점심 파트너를 찾아줍니다">
<meta property="og:image" content="https://example.com/og-image.png">
```

- og:image 권장 크기: 1200×630px
- 이미지 없으면 링크 공유 시 텍스트만 표시 → 클릭률 급감

**OG 이미지 생성 도구:**
- [Canva](https://canva.com) — 무료, 1200×630 템플릿 검색
- [og.dev](https://og.dev) — 코드 기반 동적 OG 이미지 생성
- Vercel OG Image Generation — `@vercel/og` 패키지
- 직접 만들기: Figma/Sketch에서 1200×630 프레임

### 5. viewport 메타

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

- Next.js/Astro: 기본 포함 (확인만)
- 없으면 모바일에서 데스크톱 레이아웃으로 표시 → 모바일 검색 순위 하락

### 6. h1 태그

- 페이지당 1개만 사용
- 핵심 키워드를 자연스럽게 포함
- title 태그와 유사하되 동일하지 않게

### 7. robots.txt

```
User-agent: *
Allow: /
Sitemap: https://example.com/sitemap.xml
```

- `/robots.txt` URL로 직접 접근 가능해야 함
- `Disallow: /` 실수 주의 — 전체 차단됨

### 8. sitemap.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/</loc>
    <lastmod>2026-03-30</lastmod>
  </url>
</urlset>
```

- Next.js: `next-sitemap` 패키지 또는 `app/sitemap.ts`
- Astro: `@astrojs/sitemap`
- Google Search Console에서 제출

### 9. canonical URL

```html
<link rel="canonical" href="https://example.com/page">
```

- Next.js: `metadata.alternates.canonical` 설정
- 동일 콘텐츠의 여러 URL이 있을 때 검색엔진에 원본을 알려줌

### 10. 응답 속도

- TTFB 1초 이내 목표
- 확인: Chrome DevTools → Network → 첫 번째 요청의 Waiting(TTFB)
- 느리면: CDN 사용, 서버 리전 최적화, 정적 생성(SSG) 고려

## 점검 후 다음 단계

1. 미비 항목 수정
2. Google Search Console에 사이트 등록 + sitemap 제출
3. NAVER Search Advisor에 사이트 등록
4. 1-2주 후 색인 상태 확인
5. 블로그/콘텐츠로 검색 유입 확대 → `/agnt:content`
