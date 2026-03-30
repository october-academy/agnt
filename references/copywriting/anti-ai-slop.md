# Anti-AI-Slop 가이드

AI가 생성한 카피는 특유의 패턴이 있다. 이걸 피해야 진짜 사람이 쓴 것처럼 느껴진다.

## Em Dash (—) 과다 사용

AI 모델은 em dash를 극단적으로 많이 쓴다. 일반 사람은 거의 안 쓴다.
→ em dash 대신: 쉼표, 마침표, 괄호를 사용.

## 금지 동사

| 피하기 | 대신 쓰기 |
|--------|----------|
| delve (into) | 살펴보다, 파보다 |
| leverage | 활용하다, 쓰다 |
| utilize | 쓰다 |
| facilitate | 돕다, 가능하게 하다 |
| streamline | 단순화하다, 줄이다 |
| optimize | 개선하다, 나아지게 하다 |
| empower | 돕다, ~할 수 있게 하다 |
| foster | 키우다, 만들다 |
| harness | 활용하다, 쓰다 |
| navigate | 다루다, 해결하다 |

## 금지 형용사

- robust, comprehensive, nuanced, multifaceted
- pivotal, crucial, innovative, cutting-edge
- seamless, holistic, transformative, groundbreaking
- state-of-the-art, next-generation

## 금지 전환어

- furthermore, moreover, additionally
- it's worth noting that...
- at its core...
- in today's digital landscape...
- when it comes to the realm of...
- this begs the question...
- let's delve into...
- that being said...
- it goes without saying...
- needless to say...

## 금지 오프닝

- "In today's fast-paced world..."
- "In an era of..."
- "As we navigate the landscape of..."
- "The world of X is evolving..."
- "When it comes to..."

## 금지 클로징

- "In conclusion..."
- "To sum it up..."
- "At the end of the day..."
- "The bottom line is..."
- "Moving forward..."

## 제거할 필러 단어

almost, very, really, just, quite, rather, somewhat, fairly, pretty much, basically, essentially, literally, actually, definitely, certainly, absolutely, incredibly

## 금지 구조 패턴

- "Whether you're a X, Y, or Z..." → 타겟을 하나만 골라라
- "From X to Y" 나열 → 구체적 하나를 말해라
- "Not only... but also..." → 하나씩 나눠서 말해라
- 형용사/부사를 3개씩 묶는 나열 → AI의 습관. ("빠르고, 쉽고, 강력한" 같은 generic 수식어 3연발을 피하라. 구체적 단계/옵션을 3개 제시하는 것은 괜찮다.)

## 한국어 AI 슬롭 패턴

한국어 카피를 AI로 생성할 때 특히 주의할 패턴:

| 피하기 | 대신 쓰기 |
|--------|----------|
| 혁신적인 | 구체적 결과로 대체 |
| 체계적인 | "3단계로" 같은 구체적 설명 |
| 포괄적인 | "A부터 B까지" 구체적 범위 |
| 최적화된 | "빠른", "가벼운" 등 구체 형용사 |
| ~를 통해 | ~로, ~해서 |
| ~에 대한 깊은 이해 | ~를 안다, ~를 겪어봤다 |
| ~를 제공합니다 | ~를 줍니다, ~가 됩니다 |
| ~를 실현합니다 | ~를 만듭니다, ~가 가능합니다 |
| 원활한 / 원활하게 | 쉬운, 빠른, 막힘없는 |
| 다양한 | 구체적 수량/종류로 대체 |
| 효율적인 | "시간 반으로", "클릭 한 번에" |
| ~의 가치를 극대화 | "~로 더 벌 수 있다" |

### 한국어 AI 냄새 나는 문장 구조

- "~함으로써 ~할 수 있습니다" → "~하면 ~됩니다"
- "이를 통해 사용자는 ~" → "그래서 ~"
- "~하는 것이 중요합니다" → 제거하고 바로 방법 제시
- "보다 나은 ~를 위해" → "~하려면"
- "~에 최적화된 솔루션" → "~를 위해 만들었다"

### Claude에게 카피 생성 시킬 때 쓸 프롬프트

카피를 AI로 생성할 때 이 규칙을 프롬프트에 넣어:

```
다음 규칙을 따라 카피를 써:
- em dash(—) 쓰지 마
- "혁신적인", "체계적인", "포괄적인", "원활한" 쓰지 마
- "~를 통해", "~함으로써", "~하는 것이 중요합니다" 쓰지 마
- 3개씩 나열하지 마 (2개 또는 4개)
- 모든 주장에 구체적 숫자를 넣어
- 수동태 대신 능동태
- 문장당 하나의 아이디어만
```

## 올바른 작성 규칙

1. **Simple > Complex** — "쓰다" not "활용하다", "돕다" not "촉진하다"
2. **Specific > Vague** — "전환율 3.2%" not "크게 개선"
3. **Active > Passive** — "리포트를 생성합니다" not "리포트가 생성됩니다"
4. **Confident > Qualified** — "된다" not "거의 대부분 되는 편이다"
5. **Show > Tell** — 결과를 묘사하지, 부사로 때우지 마
6. **Honest > Sensational** — 가짜 통계나 후기는 신뢰를 깎는다

## 자연스러운 전환 표현 (한국어)

| 상황 | 자연스러운 전환 |
|------|--------------|
| 문제 → 해결 | "그래서 만들었다." / "답은 간단해." |
| 기능 설명 | "이렇게 동작해." / "한 번 해보면 안다." |
| 증거 제시 | "실제로," / "예를 들면," |
| 반론 처리 | "근데 이런 생각 들 수 있어." / "자주 듣는 질문:" |
| 마무리 CTA | "준비됐으면," / "시작은 여기서." |
