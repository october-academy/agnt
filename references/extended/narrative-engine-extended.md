# Narrative Engine Extended Rules

이 파일은 기본 Week 1 공통 흐름 밖에서만 필요한 extended 규칙을 담습니다.
`shared/narrative-engine.md`는 anchor + core engine으로 유지하고, 아래 규칙은 crisis/archetype path에서만 additive로 읽습니다.

## 1. Crisis Branching

위기점 블록은 frontmatter와 BRANCH 뼈대를 기반으로 동적으로 분기합니다.

### frontmatter 파싱 규칙

- `crisis_point: <number>`가 있으면 위기점 블록으로 처리
- `branch_by: [archetype, decision]`를 읽어 분기 키를 결정
- `npc: dynamic`이면 state 기반으로 메인 NPC를 런타임 결정
- `crisis_point`가 없으면 core `shared/narrative-engine.md` 규칙만 사용

### archetype × decision 분기 매트릭스

| decision | archetype 조건  | 메인 NPC | 주제                          |
| -------- | --------------- | -------- | ----------------------------- |
| Go       | executor        | 한이     | "만들었는데 쓰는 사람이 없다" |
| Go       | validator/null- | 두리     | "분석은 됐는데 코드가 없다"   |
| Pivot    | any             | 소리     | "새 방향의 증거"              |
| No-Go    | any             | 달이     | "다음 파도"                   |

`null-`은 `archetype == null`이면서 `tendency < 0`을 뜻합니다.
`archetype == null`이고 `tendency >= 0`이면 executor 분기를 기본값으로 사용합니다.

### trust 기반 협력/도전 모드

- 등장 NPC trust `>= 2`: 협력 모드 (구체적 도움, 체크리스트, 연결 제안)
- 등장 NPC trust `<= 1`: 도전 모드 (검증 요구, 자율 미션 중심)

### BRANCH 뼈대 선택 규칙

- 위기점 블록의 `## BRANCH` 섹션에 명시된 조건부 뼈대 중 1개를 선택
- 뼈대 선택 후 대사 톤/개입 강도는 trust 규칙으로 조정

### NPC 취약성 모멘트 트리거

아래 조건에서만 취약성 모멘트를 허용합니다.

- 위기점 ②(예: Day 21 전후) AND 방문자 `< 10` 같은 무관심 시그널
- 해당 NPC 카드에 취약성 조건이 정의되어 있음
- 트리거 시 자기 실패 경험 1개를 짧게 공유하고, 관계 보너스 `trust +2`를 1회 적용 가능

조건 미충족 시 취약성 모멘트는 사용하지 않습니다.

### 위기점 ② 데이터 반영 규칙 (`get_landing_analytics`)

`crisis_point: 2` 블록에서는 MCP `get_landing_analytics` 결과를 NPC 반응에 반영합니다.

1. `visitors`, `conversionRate`(%)를 우선 사용
2. 아래 시그널 테이블로 반응 모드 결정

| 조건                                     | 반응 모드     | NPC 지시                                      |
| ---------------------------------------- | ------------- | --------------------------------------------- |
| `visitors > 50` AND `conversionRate > 5` | 성장 시그널   | 긍정 데이터 인용 + 성장 가속 미션 제시        |
| `visitors < 10`                          | 무관심 시그널 | 취약성 모멘트 조건 점검 + 원인 분석 미션 제시 |
| 그 외                                    | 중간 시그널   | 과잉 낙관/비관 금지, 다음 검증 실험 1개 제시  |

데이터가 없거나 호출 불가면 "측정 데이터가 충분하지 않다"는 맥락으로 중간 시그널 규칙을 사용합니다.

## 2. Archetype Derivation

플레이어 성향은 `state.json.tendency`와 `archetype`으로 계산합니다.

### tendency 변동 규칙

- `tendency: executor +N` → `+N` 적용
- `tendency: validator +N` → `-N` 적용
- 결과는 `-5 ~ +5`로 클램핑

### archetype 결정 임계값

- `tendency >= +3` → `archetype = "executor"`
- `tendency <= -3` → `archetype = "validator"`
- `|tendency| < 3` → `archetype = null` (균형형)

### Phase별 스냅샷 기록

- 각 Phase 종료 시 `archetypeHistory`에 `{ phase, tendency, archetype }`를 append
- Foundation(Week 1) 완료 시점(Day 7 완료)에는 Phase 1 스냅샷을 반드시 기록
- 이후 Phase도 동일 규칙으로 누적 기록

### 위기점에서 null archetype 처리

- 위기점에서 `archetype == null`이면 `tendency` 부호를 기준으로 분기
- `tendency >= 0`이면 executor 기본 분기
- `tendency < 0`이면 validator 기본 분기
