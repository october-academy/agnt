# GEO — Generative Engine Optimization

AI 검색엔진(ChatGPT, Perplexity, Google AI Overview, Claude, Copilot)에서 인용되기 위한 최적화.
Princeton University 연구(arXiv:2311.09735, KDD 2024) 기반.

**주의**: 아래 수치는 해당 연구의 특정 실험 조건(BrightData 벤치마크, 특정 쿼리셋)에서 측정된 결과이며, 도메인/쿼리/콘텐츠에 따라 실제 효과는 달라질 수 있다. 방향성의 참고 지표로 활용할 것.

## 9가지 최적화 방법 + 효과

| 방법 | 가시성 향상 | 설명 |
|------|:---------:|------|
| Cite Sources | **+40%** | 권위 있는 출처/참고문헌 추가 |
| Statistics Addition | **+37%** | 구체적 숫자, 데이터 포인트, 정량적 정보 포함 |
| Quotation Addition | **+30%** | 전문가 인용 + 출처 명시 |
| Authoritative Tone | **+25%** | 자신감 있고 전문적인 톤으로 작성 |
| Easy-to-understand | **+20%** | 복잡한 개념을 쉽게 풀어서 설명 |
| Technical Terms | **+18%** | 도메인 특화 전문 용어 적절히 사용 |
| Unique Words | **+15%** | 어휘 다양성 + 독특한 표현 사용 |
| Fluency Optimization | **+15-30%** | 가독성, 흐름, 문법 품질 개선 |
| ~~Keyword Stuffing~~ | **-10%** | 전통 SEO와 달리 키워드 반복은 가시성을 **떨어뜨림** |

## 최적 조합

- **최대 효과**: Fluency + Statistics = 최고 부스트
- **안전한 조합**: Cite Sources + Easy-to-understand + Statistics
- **피하기**: Keyword Stuffing은 AI 검색에서 역효과

## 도메인별 권장 조합

| 도메인 | 권장 방법 | 비권장 |
|--------|----------|--------|
| 기술/개발 | Technical Terms + Statistics + Cite Sources | Easy-to-understand (이미 기술적 독자) |
| 헬스케어 | Easy Language + Statistics + Citations | Technical Terms (일반인 대상) |
| 비즈니스/마케팅 | Authoritative Tone + Statistics + Quotations | Keyword Stuffing |
| 교육 | Easy-to-understand + Fluency + Examples | 과도한 Technical Terms |

## 콘텐츠 구조 패턴

### Definition Block — "X가 뭐야?" 쿼리용

```
[용어]는 [1문장 정의]. [1-2문장 설명]. [간단한 맥락].
```

### Step-by-Step Block — "X 어떻게 해?" 쿼리용

```
1. **[단계명]**: [1-2문장 명확한 행동]
2. **[단계명]**: [1-2문장 명확한 행동]
3. **[단계명]**: [1-2문장 명확한 행동]
```

### Comparison Table Block — "X vs Y" 쿼리용

```
| 항목 | [옵션 A] | [옵션 B] |
|------|---------|---------|
| 가격 | ... | ... |
| 장점 | ... | ... |
```

### Self-Contained Answer Block

```
**[주제/질문]**: [맥락 없이도 이해되는 완전한 답변. 2-3문장.]
```

## AI 봇 접근 허용 (robots.txt)

```
User-agent: GPTBot           # OpenAI ChatGPT
User-agent: ChatGPT-User     # ChatGPT 브라우징
User-agent: PerplexityBot    # Perplexity
User-agent: ClaudeBot        # Anthropic Claude
User-agent: anthropic-ai     # Anthropic 크롤러
User-agent: Google-Extended   # Google Gemini / AI Overview
User-agent: Bingbot          # Microsoft Copilot
Allow: /
```

**주의**: AI 봇을 Disallow하면 해당 AI 검색에서 사이트가 인용되지 않음.

## JSON-LD Schema 템플릿 (1인 개발자용)

### FAQPage (가장 효과적)

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "이 제품은 누구를 위한 건가요?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "퇴사 후 전업한 1인 개발자로 아직 첫 매출이 없는 분을 위해 만들었습니다."
      }
    }
  ]
}
```

### SoftwareApplication

```json
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "제품명",
  "applicationCategory": "카테고리",
  "operatingSystem": "Web",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "KRW"
  }
}
```

### WebPage + SpeakableSpecification (음성 검색)

```json
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "speakable": {
    "@type": "SpeakableSpecification",
    "cssSelector": ["h1", ".hero-description", ".faq-answer"]
  }
}
```
