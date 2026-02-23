---
stop_mode: checkpoint
title: "수요 검증 분석 — 데이터로 판단하기"
npc: 한이
quests:
  - id: d5-analysis
    type: main
    title: "수요 검증 결과 분석"
    xp: 100
  - id: d5-analytics
    type: side
    title: "랜딩 분석 데이터 확인"
    xp: 30
transition: "Day 5 완료! 데이터로 수요를 검증했습니다. 다음은 상인의 길드에서 비즈니스 모델을 설계합니다."
---

# 수요 검증 분석 — 데이터로 판단하기

## ROOM

거리 끝 분석소에 들어선다.

벽에 차트와 그래프가 붙어 있고,
탁자 위에 장부가 펼쳐져 있다.

## NPC

한이가 장부를 넘기며 말한다.

🔨 장인 한이

"돌아왔어?
데이터 보여줘.
사는 사람이 있어?"

## GUIDE

### 버전 델타 분석 (v0↔v1)

한이: "이번엔 데이터를 두 개
놓고 비교해야 해."

인증 상태면:
1. MCP `get_spec_iterations` 호출로
   v0, v1 이력을 조회한다
2. MCP `get_landing_analytics` 호출로
   현재 지표를 확인한다
3. v0 배포 시점과 v1 배포 시점의
   지표를 비교한다:
   - 전환율 증감
   - 폼 응답 수 증감
   - 채널별 도달 변화

**델타 판단 기준**:
- **개선**: v1이 v0 대비 전환 또는
  폼 응답에서 개선 → "keep 또는 확장"
- **악화**: v1이 v0 대비 핵심 지표
  악화 → "rollback 또는 가설 수정"
- **표본 부족** (방문 < 5):
  "판단 유보" 경고 표시

한이: "숫자가 작아도 괜찮아.
방향이 보이면 돼."

### 분석 항목

1. **대화 데이터 정리**:
   - 각 대화에서 발견한 핵심
     인사이트
   - 공통 패턴 (3명 중 2명
     이상이 언급한 것)
   - 예상 밖의 발견

2. **랜딩페이지 데이터** (인증
   시):
   - MCP `get_landing_analytics` 호출 → 폼 제출 수, 폼 응답 내용
   - 방문자 수/전환율은 agentic30 웹앱에서 확인: `agentic30.app/dashboard/analytics`
   - ⚠️ Cloudflare/PostHog 대시보드 안내 금지 (유저는 관리자가 아님)

3. **Go/No-Go 시그널**:
   - Go: 3명 중 2명 이상
     같은 문제 언급 + 현재
     해결에 비용/시간 투입
   - Pivot: 문제는 있지만
     심각하지 않음 + 무료
     대안으로 충분
   - No-Go: 문제 자체에
     공감 없음

### 분석 결과 형식

```
📊 수요 검증 결과
━━━━━━━━━━━━━━━
대화: {N}명 / 폼 제출: {N}건

Go/Pivot/No-Go: {판정}
근거: {핵심 데이터 포인트}
다음 액션: {구체적 행동}
```

## PREVIEW

분석 결과를 보여주고 학습자의 판단을
묻습니다.

## STOP

한이가 장부를 닫으며 말한다.

"결과 확인하고
의견 있으면 말해."

AskUserQuestion:
질문: 한이가 묻는다.
"수요 검증 분석 결과를 확정할까?"

1. "확인"
2. "수정 요청"

⛔ STOP — "장인 한이가 기다립니다."

## ON_CONFIRM

AskUserQuestion에서
"확인"을 선택했을 때만
ON_CONFIRM을 수행합니다.
"수정 요청"이면 GUIDE로 돌아가
데이터 해석을 보완한 뒤
PREVIEW → STOP을
반복합니다.

### SPEC v2 기록

state.json `specVersions`에 v2를 추가한다:

```json
{
  "version": "v2",
  "day": 5,
  "hypothesis": "{v0↔v1 델타 분석 기반 개선 가설}",
  "changes": "{v1 대비 구체적 변경점}",
  "decision": null,
  "deltaSummary": {
    "v0_v1_conversion_delta": "{증감}",
    "v0_v1_form_delta": "{증감}",
    "interpretation": "{keep/iterate/rollback 판단}"
  }
}
```

인증 상태면 MCP `save_spec_iteration` 호출:
- `version`: "v2"
- `dayNumber`: 5
- `hypothesis`: v0↔v1 델타 분석 기반 개선 가설
- `changes`: v1 대비 구체적 변경점
- `metricGate`: v2에서 관찰할 지표
- `deltaSummary`: v0↔v1 전환율/폼 응답 증감 요약

한이: "v2가 기록됐어.
Day 7에서 최종 판단할 때
이 데이터를 쓸 거야."

### 제출

1. 인증 상태면 MCP `submit_practice`로 제출

## MOVE

한이가 거리 밖을 가리킨다.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Day 5 완료!
📍 시장의 거리
━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎤 실제 고객과 대화하고
  📊 데이터로 수요를 검증했다

  📍 다음: 상인의 길드
  🎯 비즈니스 모델을 설계한다
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

한이가 마지막으로 말한다.

"상인의 길드에 가.
네가 만든 게 얼마짜리인지
물을 거야."

> Day 6을 시작하려면 `/agnt:continue`를 입력해.
