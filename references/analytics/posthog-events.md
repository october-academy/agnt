# PostHog 이벤트 가이드

제품 유형별 핵심 추적 이벤트. PostHog JS SDK 코드 스니펫 포함.

## PostHog 설치

### 방법 1: 자동 설치 (추천)

```bash
npx @posthog/wizard
```

프레임워크 자동 감지 → 설정 파일 생성 → API key 입력.

### 방법 2: 수동 설치

```bash
npm install posthog-js
# 또는
bun add posthog-js
```

```typescript
// app/providers.tsx 또는 _app.tsx
import posthog from 'posthog-js'

if (typeof window !== 'undefined') {
  posthog.init('phc_YOUR_KEY', {
    api_host: 'https://us.i.posthog.com',
    person_profiles: 'identified_only',
  })
}
```

## 제품 유형별 핵심 이벤트

### SaaS (웹 앱/대시보드)

| # | 이벤트명 | 설명 | 속성 |
|---|----------|------|------|
| 1 | `signed_up` | 회원가입 완료 | `method`, `referrer` |
| 2 | `onboarding_completed` | 온보딩 완료 | `steps_completed`, `duration_seconds` |
| 3 | `feature_used` | 핵심 기능 사용 | `feature_name`, `is_first_use` |
| 4 | `subscription_started` | 유료 구독 시작 | `plan`, `price`, `billing_cycle` |
| 5 | `subscription_canceled` | 구독 취소 | `reason`, `days_active` |
| 6 | `invite_sent` | 팀원 초대 | `invite_count` |
| 7 | `export_completed` | 데이터 내보내기 | `format`, `row_count` |

```typescript
// SaaS 예시
posthog.capture('signed_up', { method: 'google', referrer: document.referrer })
posthog.capture('feature_used', { feature_name: 'ai_analysis', is_first_use: true })
posthog.capture('subscription_started', { plan: 'pro', price: 9900, billing_cycle: 'monthly' })
```

### 앱 (모바일/데스크톱)

| # | 이벤트명 | 설명 | 속성 |
|---|----------|------|------|
| 1 | `app_opened` | 앱 실행 | `platform`, `version` |
| 2 | `signed_up` | 회원가입 | `method` |
| 3 | `core_action_completed` | 핵심 액션 완료 | `action_type`, `duration_seconds` |
| 4 | `notification_clicked` | 푸시 알림 클릭 | `notification_type` |
| 5 | `purchase_completed` | 인앱 결제 | `product_id`, `price` |
| 6 | `session_ended` | 세션 종료 | `duration_seconds`, `screens_viewed` |

```typescript
posthog.capture('core_action_completed', { action_type: 'match_found', duration_seconds: 12 })
posthog.capture('purchase_completed', { product_id: 'premium_monthly', price: 4900 })
```

### 커머스 (쇼핑몰/마켓플레이스)

| # | 이벤트명 | 설명 | 속성 |
|---|----------|------|------|
| 1 | `product_viewed` | 상품 조회 | `product_id`, `category`, `price` |
| 2 | `added_to_cart` | 장바구니 추가 | `product_id`, `quantity`, `price` |
| 3 | `checkout_started` | 결제 시작 | `cart_total`, `item_count` |
| 4 | `purchase_completed` | 결제 완료 | `order_id`, `total`, `payment_method` |
| 5 | `search_performed` | 검색 실행 | `query`, `results_count` |
| 6 | `review_submitted` | 리뷰 작성 | `product_id`, `rating` |
| 7 | `coupon_applied` | 쿠폰 적용 | `coupon_code`, `discount_amount` |
| 8 | `cart_abandoned` | 장바구니 이탈 | `cart_total`, `item_count` |

```typescript
posthog.capture('product_viewed', { product_id: 'tpl-001', category: 'template', price: 29000 })
posthog.capture('purchase_completed', { order_id: 'ord-123', total: 29000, payment_method: 'card' })
```

### 콘텐츠 (블로그/뉴스레터/강의)

| # | 이벤트명 | 설명 | 속성 |
|---|----------|------|------|
| 1 | `content_viewed` | 콘텐츠 조회 | `content_id`, `content_type`, `category` |
| 2 | `content_completed` | 콘텐츠 완독/완강 | `content_id`, `duration_seconds` |
| 3 | `newsletter_subscribed` | 뉴스레터 구독 | `source` |
| 4 | `share_clicked` | 공유 버튼 클릭 | `content_id`, `platform` |
| 5 | `paywall_hit` | 페이월 노출 | `content_id`, `user_type` |
| 6 | `premium_unlocked` | 프리미엄 결제 | `plan`, `price` |

```typescript
posthog.capture('content_viewed', { content_id: 'post-42', content_type: 'article', category: 'tutorial' })
posthog.capture('paywall_hit', { content_id: 'post-42', user_type: 'free' })
```

### API / 개발자 도구

| # | 이벤트명 | 설명 | 속성 |
|---|----------|------|------|
| 1 | `api_key_created` | API 키 생성 | `plan` |
| 2 | `api_call_made` | API 호출 | `endpoint`, `status_code`, `latency_ms` |
| 3 | `quota_warning` | 쿼터 경고 | `usage_percent`, `plan` |
| 4 | `docs_viewed` | 문서 조회 | `page`, `section` |
| 5 | `sdk_installed` | SDK 설치 | `language`, `version` |
| 6 | `webhook_configured` | 웹훅 설정 | `event_types` |

```typescript
posthog.capture('api_key_created', { plan: 'free' })
posthog.capture('api_call_made', { endpoint: '/v1/analyze', status_code: 200, latency_ms: 120 })
```

## 공통 이벤트 (모든 제품)

| 이벤트명 | 설명 |
|----------|------|
| `$pageview` | 페이지뷰 (자동 추적) |
| `$pageleave` | 페이지 이탈 (자동 추적) |
| `cta_clicked` | CTA 버튼 클릭 |
| `error_occurred` | 에러 발생 |
| `feedback_submitted` | 피드백 제출 |

## 유저 속성 설정

```typescript
// 가입 시 유저 속성 설정
posthog.identify('user-123', {
  email: 'user@example.com',
  plan: 'free',
  signed_up_at: new Date().toISOString(),
})

// 속성 업데이트
posthog.people.set({ plan: 'pro', upgraded_at: new Date().toISOString() })
```

## 핵심 수칙

1. **5-8개만 추적** — 처음부터 50개 이벤트를 넣지 마. 핵심만 먼저
2. **네이밍 일관성** — `snake_case`, 과거형 동사 (`completed`, `started`, `clicked`)
3. **속성은 분석에 필요한 것만** — 개인정보 최소화
4. **$pageview는 자동** — posthog.init 시 `capture_pageview: true` (기본값)
5. **서버 사이드도 고려** — 결제 완료 등 중요 이벤트는 `posthog-node`로 서버에서
