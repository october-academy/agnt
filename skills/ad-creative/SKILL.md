---
user-invocable: false
name: ad-creative
description: >-
  광고 소재 Lab — 3변형 + 가설 태그 + 예산 추천. 광고 소재, Meta/Google 광고 카피 작성 시 사용.
---

광고 소재 Lab. Meta/Google Ads용 광고 카피 3개 변형을 생성하고 예산 가이드를 안내합니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색.

## 출력 규칙

내부 로직 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료

기본값 보증:
- `artifacts.ad_creatives_generated`가 undefined면 `false`로 처리

### 2. 채널 + 목표 선택

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  광고 소재 Lab
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

광고 카피 3개 변형을 만들어줄게.
각 변형에 테스트 가설을 달아서,
어떤 각도가 먹히는지 알 수 있게.
```

AskUserQuestion: "어떤 플랫폼?"
- A) Meta (Facebook/Instagram)
- B) Google Ads (검색)
- C) 둘 다

AskUserQuestion: "광고 목표는?"
- A) 가입/리드 수집
- B) 구매/결제
- C) 앱 설치
- D) 문의/상담

### 3. 컨텍스트 수집

state에서 읽기:
- `project.problem` — 풀고 있는 문제
- `project.icp` — 타겟 고객
- `project.hypothesis` — 가설

`{AGNT_DIR}/journey-brief.md` Read 시도. 있으면:
- Offer 섹션에서 핵심 약속, 가격 참조
- Competition 섹션에서 차별점 참조

### 4. 3개 변형 생성

`{REFS_DIR}/tools/ad-platforms.md` Read.
`{REFS_DIR}/benchmarks/cpc-benchmarks.md` Read.

**3가지 각도:**

1. **문제 직격** — ICP의 고통을 직접 언급
   - 가설: "고통을 느끼는 사람이 클릭한다"
2. **결과 강조** — 제품 사용 후 결과를 약속
   - 가설: "결과를 보여주면 전환된다"
3. **사회적 증거** — 다른 사람들의 반응/수치를 활용
   - 가설: "다른 사람이 쓰면 신뢰된다"

**채널별 글자 제한 준수:**

| 플랫폼 | 요소 | 글자 제한 |
|--------|------|-----------|
| Meta | 헤드라인 | 40자 |
| Meta | 본문 | 125자 |
| Meta | CTA | 플랫폼 제공 선택지 |
| Google 검색 | 헤드라인 | 30자 × 3개 |
| Google 검색 | 설명 | 90자 × 2개 |

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  광고 소재 3개 변형
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

변형 A: 문제 직격 🏷️ #pain-point
{플랫폼별 포맷에 맞춘 카피}

변형 B: 결과 강조 🏷️ #outcome
{플랫폼별 포맷에 맞춘 카피}

변형 C: 사회적 증거 🏷️ #social-proof
{플랫폼별 포맷에 맞춘 카피}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. 예산 분배 추천

cpc-benchmarks.md 기반으로 예산 가이드를 제공한다.

```
💰 예산 가이드

추천 테스트 예산: ₩{금액} ({기간})
• 일예산: ₩{금액}
• 테스트 기간: 2주 (최소 50클릭)
• 예상 CPC: ₩{업종 평균}

📊 테스트 방법:
1. 3개 변형을 동시에 돌려
2. 2주 후 CTR과 CPC 비교
3. CPC ₩{기준} 이하 + CTR {기준}% 이상이면 스케일
4. 전부 안 되면 → 소재 교체, 타겟 조정

⚠️ 손절 기준:
CPC가 업종 평균의 2배를 넘으면 멈추고 소재를 바꿔.
```

### 6. 카피 저장

`{AGNT_DIR}/ad-creatives.md` Write.

```markdown
# 광고 소재 — {project.name}

생성일: {날짜}
플랫폼: {선택한 플랫폼}
목표: {선택한 목표}

## 변형 A: 문제 직격 #pain-point
{카피}

## 변형 B: 결과 강조 #outcome
{카피}

## 변형 C: 사회적 증거 #social-proof
{카피}

## 예산 가이드
{예산 추천 요약}
```

### 7. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  광고 소재 생성 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3개 변형 생성됨:
A) 문제 직격  B) 결과 강조  C) 사회적 증거

📄 저장 위치: {AGNT_DIR}/ad-creatives.md

광고 세팅이 필요하면 /agnt:tools에서 D) "광고 플랫폼" 비교.
결과 분석은 /agnt:analyze.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 8. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.ad_creatives_generated = true`
- `meta.last_action = "ad-creative"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-ad-creative"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-ad-creative" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- 글자 제한은 반드시 준수 — Meta 40/125, Google 30×3/90×2
- 3개 변형은 반드시 다른 각도 — 같은 카피의 문구 변경이 아닌 관점 변경
- 가설 태그는 각 변형에 필수 — A/B 테스트의 가설로 활용
- 검증 전 광고 금지 경고 — 인터뷰 + 랜딩 전환율 확인 후 광고 권고
- state.json Write 먼저 (critical path), ad-creatives.md Write 후순위
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
