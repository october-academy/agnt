---
name: tools
description: >-
  도구 비교 가이드 — 결제, 마케팅, 분석, 광고 도구. 도구 비교, 결제 솔루션 선택 시 사용.
---

도구 비교 가이드. 결제, 마케팅, 분석 도구를 비교하고 추천합니다.

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

### 1. 카테고리 선택

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  도구 비교 가이드
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

어떤 도구를 비교할래?
```

AskUserQuestion:
- A) 결제 솔루션 — TossPayments, 래피드, 포트원, Lemon Squeezy, Polar
- B) 마케팅 채널 — Threads, GeekNews, OKKY, 당근, Meta Ads
- C) 분석 도구 — PostHog, GA, Amplitude
- D) 광고 플랫폼 — Meta, Google, 네이버
- E) 사업자 없이 결제 — 래피드, Groble, 외화 MoR
- F) Build in Public — BIP 전략, 채널별 포스트 가이드

### 2. 참조 파일 로드

선택에 따라 해당 참조 파일을 Read:

| 선택 | 파일 |
|------|------|
| A | `{REFS_DIR}/tools/payment-comparison.md` |
| B | `{REFS_DIR}/tools/marketing-channels.md` |
| C | `{REFS_DIR}/tools/analytics-tools.md` |
| D | `{REFS_DIR}/tools/ad-platforms.md` |
| E | `{REFS_DIR}/tools/no-biz-payment.md` |
| F | `{REFS_DIR}/tools/bip-guide.md` |

파일이 없으면:
```
⚠️ 이 가이드는 아직 준비 중이야.
references 업데이트 후 다시 시도해줘.
```

### 2-bis. 사업자 등록 상태 연동

state.json에서 `tools.business_registration` 읽기 (기본값: null).

- `"delayed"` → 카테고리 A 선택 시 E) "사업자 없이 결제"를 우선 안내:
  ```
  💡 사업자 보류 상태야. E) "사업자 없이 결제"를 먼저 볼래?
  래피드, MoR 서비스로 사업자 없이 결제를 받을 수 있어.
  ```
- `"registered"` → 카테고리 A 선택 시 토스페이먼츠/포트원 우선 추천:
  ```
  💡 사업자 등록 완료 상태 — TossPayments, 포트원 중심으로 비교할게.
  ```
- `null` → 카테고리 A 또는 E 선택 시 안내 추가:
  ```
  💡 사업자 등록 여부가 아직 결정 안 됐으면 /agnt:biz-setup으로 먼저 판단해봐.
  지금은 전체 비교를 보여줄게.
  ```

### 3. 비교 표시

참조 파일의 내용을 읽고, 유저 상태에 맞게 추천을 개인화한다.

state.json에서 참고:
- `project.problem` — 어떤 제품인지
- `project.icp` — 누구에게 파는지
- `tools.payment` / `tools.analytics` — 이미 선택한 도구

출력 형식:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  {카테고리명} 비교
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{참조 파일 내용 기반 비교표}

💡 추천:
네 상황({project.problem} → {project.icp})에서는
{추천 도구}가 적합해. 이유: {1줄 근거}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 4. 선택 기록 (선택적)

AskUserQuestion: "도구를 선택했어?"
- A) {추천 도구}로 갈게 — state에 기록
- B) 다른 걸로 갈게 — 어떤 건지 입력
- C) 아직 고민 중 — 기록 안 함

선택 시 state.json 업데이트:
- 결제 → `tools.payment` = 선택한 도구명
- 분석 → `tools.analytics` = 선택한 도구명
- 마케팅 → `tools.marketing_channels` 배열에 추가

### 5. 다른 카테고리 안내

```
다른 도구도 비교할래? `/agnt:tools`를 다시 실행해.
```

## 규칙

- 도구 비교는 **객관적 사실** 기반 — 가격, 기능, 제한사항
- 추천은 **유저 상황에 맞게** 개인화 (1인 개발자, 사업자 유무, 예산)
- 특정 도구를 강하게 푸시하지 않음 — 장단점 모두 표시
- state 업데이트는 유저가 선택한 경우에만
- 한국어, 반말 톤
