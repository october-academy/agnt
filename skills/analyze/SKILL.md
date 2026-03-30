---
name: analyze
description: >-
  성과 판정 — 벤치마크 대비 continue/pivot/kill. 성과 분석, 전환율 확인 시 사용.
---

성과 판정. 론칭 결과를 벤치마크와 비교해 continue/pivot/kill 판정을 내립니다.

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
- `!artifacts.launch_planned` (또는 undefined) → "먼저 `/agnt:launch`로 론칭 계획을 세워." (비강제 — 진행 가능)

기본값 보증 (navigator-engine.md 필드 기본값 규칙):
- `artifacts.launch_planned`가 undefined면 `false`로 처리
- `artifacts.last_analyze_loop`가 undefined면 `0`으로 처리
- `artifacts.loops_completed`가 undefined면 `0`으로 처리

### 2. 중복 실행 가드

`artifacts.last_analyze_loop`와 `artifacts.loops_completed`를 비교.

- `last_analyze_loop == loops_completed + 1` → "이미 이 루프의 분석이 있어. 새로 분석할까?"
  - AskUserQuestion: "이전 분석을 덮어쓸까?"
    - A) 새로 분석해
    - B) 이전 분석 유지 — 종료

### 3. 데이터 수집

`ToolSearch`로 `+agentic30` 검색.

**`identity.mode == "synced"` (MCP 연결 시)**:
- `get_landing_analytics` 호출 → 방문자, 전환 데이터 수집
- `get_links` 호출 → 링크 클릭 데이터 수집
- `get_link_analytics` 호출 (링크가 있으면) → 개별 링크 분석
- 수집된 데이터를 요약하여 출력:
  ```
  📊 데이터 자동 수집 완료
  ```

**`identity.mode != "synced"` (MCP 미연결 시)**:
```
📝 MCP 미연결 — 수동 입력 모드
(연결하면 랜딩 분석이 자동화돼: /agnt:connect)
```

AskUserQuestion으로 수동 입력:

이어서 순차 질문:
- "랜딩 방문자 수는?" → 자유 입력 (숫자)
- "이메일/폼 전환 수는?" → 자유 입력 (숫자)
- "유료 결제 수는?" → 자유 입력 (숫자)
- "기간은 며칠?" → 자유 입력 (숫자)

### 4. 벤치마크 로드

`{REFS_DIR}/benchmarks/conversion-benchmarks.md`를 Read.

### 5. 판정

방문자 수와 전환율을 계산하고, 우선순위 순서로 판정한다 (먼저 매칭되는 것 적용):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  성과 판정
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

방문: {N}명 / 전환: {N}명 ({X}%)
벤치마크: 5-15% (이메일) / 1-3% (유료)

판정: {VERDICT}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**판정 로직 (우선순위 순서):**

**TOO EARLY** — 방문 < 100:
```
⏳ TOO EARLY — 데이터 부족

아직 판단하기엔 데이터가 부족해.
최소 100명 데이터가 쌓여야 전환율이 의미 있어.
트래픽을 더 모아.

다음: 채널에 포스트를 계속 올리고, 7일 후 다시 /agnt:analyze
대기하는 동안 `/agnt:content`로 다음 포스트를 계획해봐.
```

**CONTINUE** — 방문 100+ && 전환율 벤치마크 범위 내 (이메일 5%+ 또는 유료 1%+):
```
✅ CONTINUE — 전환율이 벤치마크 범위 안이야

전환율 {X}%는 벤치마크 범위 안이야.
이 방향을 유지하면서 트래픽을 늘려.

다음:
• 채널 추가 → /agnt:channel
• 포스팅 빈도 증가
• 유료 전환 실험 (아직 무료라면)
• 유료 결제가 발생했으면 MCP `record_revenue`로 매출을 기록할 수 있어.
```

**PIVOT** — 방문 100+ && 전환율 < 1% (이메일) 또는 < 0.5% (유료):
```
🔄 PIVOT — 전환이 안 돼

트래픽은 오는데 전환이 안 되고 있어.
오퍼나 랜딩을 바꿔야 해.

체크:
• 헤드라인이 ICP의 문제를 정확히 짚고 있어?
• CTA가 명확해?
• 가격이 너무 높아?

다음: /agnt:retro에서 뭘 바꿀지 정하자.
```

**KILL** — 방문 100+ && 전환 0건 (완전 무반응):
```
❌ KILL — 관심이 없어

100명 이상이 봤는데 전환이 0이야.
채널이 안 맞거나, ICP 자체가 틀렸을 수 있어.

이건 실패가 아니라 데이터야.
"이 조합은 안 된다"를 확인한 거야.

다음: /agnt:retro에서 근본 원인을 점검하자.
```

### 6. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: 템플릿으로 신규 생성.
**파일이 있는 경우**: Results 섹션을 **누적** 추가 (덮어쓰기 아님).

현재 루프 번호: `artifacts.loops_completed + 1`

추가할 섹션:
```markdown
### Results (Loop {N})
- 방문: {N}명
- 전환: {N}명 ({X}%)
- 매출: {금액 또는 "없음"}
- 판정: {TOO EARLY / CONTINUE / PIVOT / KILL}
- 근거: {판정 이유 1줄}
```

### 7. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  분석 완료 — Loop {N}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

판정: {VERDICT}

{판정이 TOO EARLY → "트래픽을 더 모으고 다시 /agnt:analyze"}
{판정이 CONTINUE → "전환이 나오고 있어. 트래픽을 늘려."}
{판정이 PIVOT 또는 KILL → "다음 단계: /agnt:retro — 뭘 바꿀지 정하자."}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 8. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.last_analyze_loop = artifacts.loops_completed + 1`
- `meta.last_action = "analyze"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-analyze-1"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-analyze-1" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- 판정은 벤치마크 기반 — "느낌"으로 판단하지 않는다
- TOO EARLY가 최우선 — 방문 100 미만에서는 다른 판정 불가
- KILL은 방문 100+ 이상에서만 — 데이터 부족 시 성급한 포기 방지
- MCP 미연결 시 수동 입력으로 폴백 — 기능은 동일
- Results는 누적 (Loop 1, Loop 2, ...) — 이전 루프 덮어쓰기 금지
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위 (learner artifact)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
