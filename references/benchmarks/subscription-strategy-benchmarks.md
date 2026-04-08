# Subscription Strategy Benchmarks — SOSA 2026

RevenueCat **State of Subscription Apps 2026**와 사용자 요약을 바탕으로, 1인 개발자가 구독형 앱 전략을 고를 때 바로 쓰는 결정 규칙만 압축했다.

## 1) 시장 현실

- 상위 25% 앱은 전년 대비 **80% 성장**, 하위 25%는 **33% 감소**.
- 상위 10%는 **306%+ 성장**.
- 신규 구독 앱 런칭 수는 2022년 이후 약 **7배** 증가.
- 신규 앱의 2년 내 **$1K MRR 도달률은 17.3%**, **$10K는 4.6%**뿐.

### 해석

평균 앱으로는 버티기 어렵다.
1인 개발자는 **큰 시장에서 무난한 앱**이 아니라, **좁은 문제에서 강한 ROI와 빠른 activation**을 만드는 쪽으로 가야 한다.

## 2) 카테고리 선택 규칙

### 기본값: 세로형 업무 툴 / 프로 유틸

- Business는 **76.5%가 pure subscription**.
- 보고서 코멘트에서도 monetization/retention이 강한 카테고리로 해석된다.
- 속도는 느릴 수 있다. Business의 **$1K MRR 도달 중간값은 113일**.

### 대안: Photo & Video

- 신규 앱 중 **$1K MRR 도달 비율 21.4%**로 가장 높다.
- 디자인/콘텐츠 감각이 강할 때 선택 가치가 있다.

### 기본 비추천: Gaming (첫 앱 기준)

- Gaming은 **40.5%만 pure subscription**.
- consumable **27.5%**, 세 가지 혼합 **9.6%**로 구조가 복잡하다.
- weekly 비중이 높아 volume/ops/cancel 대응 난이도가 높다.

## 3) Freemium vs Hard Paywall

- hard paywall의 D35 download→paid 전환은 **10.7%**
- freemium은 **2.1%**
- 하지만 1년 retention은 거의 비슷하다.

### 결정 규칙

무료층이 아래 셋 중 하나를 만들지 못하면 freemium을 기본값으로 두지 않는다.

1. 네트워크 효과
2. UGC / SEO 플라이휠
3. 강한 브랜드/상단 퍼널 확대

그게 아니면 **첫 가치 확인 뒤 hard paywall**이 기본이다.

## 4) Trial / Intro Offer

- **17일 이상 trial**은 짧은 trial보다 trial-to-paid가 훨씬 높다.
  - 장기 trial: **42.5%**
  - 4일 이하: **25.5%**
- 3일 trial 취소의 **55.4%가 Day 0**에 발생한다.
- trial starts도 대부분 Day 0에 몰린다.

### 결정 규칙

- **습관형 제품** → 긴 trial 우선
- **AI / 고원가 제품** → free trial 남발 금지, 저가 intro offer / paid intro 우선
- **모든 경우** → 온보딩은 기능 설명이 아니라 **첫 세션 결과물**을 만들어야 한다

## 5) Pricing / Packaging

- 플랜은 **monthly + annual** 두 개가 기본
- annual은 monthly보다 RPI가 훨씬 좋다 (보고서/전문가 코멘트 기준 약 2배 수준)
- high price 앱은 전환이 더 높을 수 있지만 refund와 첫 renewal 리스크도 같이 오른다

### 결정 규칙

- 싸게 팔지 말고 **비싸도 납득되는 ROI**를 만든다
- annual을 기본 강조한다
- weekly는 소비형/게임형이 아니면 기본 비추천
- 가격을 낮추는 대신 문제의 비용과 urgency를 더 선명하게 만든다

## 6) Web + App 병행

- top-performing Tier 5 앱의 **41%**가 웹 매출을 만든다
- hobby Tier 1은 **1.3%** 수준
- 전체 매출 비중은 아직 낮아도, 웹은 discovery와 lead capture의 핵심이다

### 결정 규칙

1인 개발자는 앱스토어만 믿지 않는다.
기본 설계는 아래다.

1. 웹 랜딩
2. 이메일 수집 또는 웹 checkout
3. 구매 의도 있는 유저만 앱으로 연결
4. 앱/웹 entitlement 동기화

## 7) AI 포지셔닝

- AI 앱은 payer value가 높다
- 하지만 retention은 더 낮다
  - annual retained subscribers: **AI 21.1% vs non-AI 30.7%**
  - monthly retained subscribers: **AI 6.1% vs non-AI 9.5%**

### 결정 규칙

- "AI 앱" 자체를 파는 대신, **특정 workflow를 해결하는 vertical product**를 만든다
- AI는 headline이 아니라 engine이다
- 모델 성능이 올라갈수록 제품이 강해져야 한다

## 8) 플랫폼 선택

- Google Play cancellation의 **32.2%**가 billing failure
- App Store는 **15.2%**
- D35 download-to-paid도 App Store가 Google Play보다 훨씬 높다

### 결정 규칙

리소스가 작으면:
- **iOS-first** 또는
- **web-first**

Android를 하면 billing recovery는 "나중에"가 아니라 **출시 필수 운영 기능**이다.

## 9) 90~120일 판정

- 전체 median 기준:
  - launch → **$1K MRR 58일**
  - launch → **$10K MRR 109일**
- 하지만 category별 편차가 매우 크다

### 결정 규칙

1인 개발자는 2주 단위 감정 평가를 하지 않는다.
**90~120일** 동안 아래를 보고 kill / continue / pivot를 결정한다.

1. D0 activation
2. D35 paid conversion
3. refund rate
4. first renewal / retained subscribers
5. web leads / email capture

숫자가 안 나오면 기능 추가보다 **문제 재선정**이 더 큰 레버일 수 있다.
