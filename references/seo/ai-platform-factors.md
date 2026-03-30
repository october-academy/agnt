# AI 플랫폼별 랭킹 팩터

각 AI 검색엔진이 콘텐츠를 인용할 때 어떤 요소를 중시하는지 정리.

## ChatGPT (OpenAI)

SE Ranking 연구 (129K 도메인):

| 팩터 | 비중 | 설명 |
|------|:----:|------|
| Content-Answer Fit | **55%** | ChatGPT 응답 스타일에 콘텐츠가 맞는가 (가장 중요!) |
| On-Page Structure | 14% | H1, meta, 내부 링크 등 페이지 구조 |
| Domain Authority | 12% | 도메인 전체의 신뢰도/권위 |
| Query Relevance | 12% | 검색 의도와의 관련성 |
| Content Consensus | 7% | 다른 소스들과 일치하는 정보 |

**핵심**: Content-Answer Fit이 55%다. ChatGPT가 답할 법한 형태로 콘텐츠를 구조화해야 한다.

**Freshness**: 30일 이내 콘텐츠가 인용될 확률 3.2x 높음.

## Claude (Anthropic)

| 팩터 | 설명 |
|------|------|
| 검색 엔진 | **Brave Search** 사용 (Google/Bing 아님!) |
| Crawl-to-Refer 비율 | 38,065:1 (매우 선택적) |
| 인용 기준 | 사실적 밀도, 정확성, 명확성 중시 |
| 최적화 | Brave Search에 인덱싱 필수 |

**핵심**: Claude는 Google이 아니라 Brave Search를 쓴다. Brave에 사이트가 인덱싱되어 있어야 한다.

## Perplexity

3-Layer 리랭킹 아키텍처:

| Layer | 역할 |
|-------|------|
| L1 | 기본 관련성 검색 (키워드 매칭) |
| L2 | 전통적 랭킹 팩터 점수화 |
| L3 | ML 모델로 품질 평가 (전체 결과셋 폐기 가능) |

| 팩터 | 설명 |
|------|------|
| FAQ Schema (JSON-LD) | 가장 선호하는 구조화 데이터 |
| PDF 문서 | 일반 웹페이지보다 우선순위 높음 |
| 발행 속도 | 자주 업데이트하는 사이트 선호 |
| Domain Authority | 중요하지만 콘텐츠 품질이 더 중요 |

## Google AI Overview

| 팩터 | 설명 |
|------|------|
| Schema Markup | 가장 큰 레버 — **30-40% 가시성 향상** |
| 전통 Top 10과 겹침 | ~15%만 겹침 (별도 최적화 필요) |
| E-E-A-T | 경험/전문성/권위/신뢰 강하게 반영 |
| 구조화된 답변 | "정의 → 단계 → 주의사항" 형태 선호 |

## Microsoft Copilot

| 팩터 | 설명 |
|------|------|
| 검색 엔진 | Bing 인덱스 사용 |
| LinkedIn/GitHub | 프로필 존재가 신뢰도 부스트 |
| 페이지 속도 | 2초 미만 로딩 필수 (임계값) |
| Bing Webmaster Tools | 등록 권장 |

## 1인 개발자를 위한 실행 우선순위

```
[P0] 즉시
  □ robots.txt에 AI 봇 Allow 확인
  □ FAQPage JSON-LD Schema 추가
  □ 페이지에 구체적 숫자/통계 포함
  □ Brave Search에 사이트 등록

[P1] 이번 주
  □ Google Search Console + Bing Webmaster Tools 등록
  □ 콘텐츠에 Definition Block / Step-by-Step Block 적용
  □ 30일 이내 날짜의 콘텐츠 발행
  □ LinkedIn 또는 GitHub 프로필에 제품 링크

[P2] 다음 주
  □ SpeakableSpecification 추가
  □ 경쟁사 대비 Comparison Table 작성
  □ PDF 버전 자료 제공 (Perplexity 최적화)
```
