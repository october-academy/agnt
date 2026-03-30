Revenue Readiness Audit — 45분 진단으로 프로젝트를 평가하고 맞춤 Track을 추천합니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색 (navigator-engine.md의 Section 2 참조).

## 출력 규칙

내부 로직(경로 탐색, state 파싱, MCP 검색)은 무음 처리.

## 실행 절차

### 0. state 확인 + resume 체크

`{AGNT_DIR}/state.json` Read.
- `meta.schema_version != 3` → "먼저 `/agnt:start`를 실행하세요." 종료

**Resume 체크**: `audit_progress`가 null이 아니면 중단된 세션이 있다.

AskUserQuestion:
- A) 이어서 진행 — `audit_progress.current_step`부터 시작 (해당 Step으로 이동)
- B) 처음부터 다시 — `audit_progress = null`로 초기화 후 Step 1부터

**이미 완료된 Audit**: `audit_result`가 null이 아니면:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  이미 Audit를 완료했어
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Track: {audit_result.track}
Verdict: {audit_result.verdict}
자기 평가: {audit_result.user_confidence}/5
```

AskUserQuestion:
- A) 다시 진단할래 — audit_result, audit_progress 초기화 후 Step 1부터
- B) 이대로 유지 — `/agnt:next`를 안내하고 종료

### Step 1: 프로젝트 진단 (15분)

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Revenue Readiness Audit
  Step 1/4 · 프로젝트 진단
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

45분이면 끝나. 4단계로 네 프로젝트를 진단하고
가장 빠른 매출 경로를 찾아줄게.
```

**기존 project.* 데이터가 있는 경우**:

```
이전에 정의한 내용이 있어:
  문제: {project.problem}
  ICP: {project.icp}
  가설: {project.hypothesis}
```

AskUserQuestion: "이 내용으로 진행할까, 새로 정의할까?"
- A) 이대로 진행 — Step 2로 이동
- B) 새로 정의 — 아래 질문 진행

**질문 (project.* 없거나 새로 정의 선택 시)**:

순차 AskUserQuestion:

**Q1**: "지금 만들고 있는 것 (또는 만들고 싶은 것)은 뭐야?"
- 자유 입력

**Q2**: "이걸 쓸 사람은 누���야? 최대한 구체적으로. (나이, 직업, 상황, 겪는 고통)"
- 자유 입력

**Q3**: "이 사람에게 팔려면 어떤 형태여야 해? 그리고 얼마면 살까?"
- 자유 입력

**Q4**: "지금까지 ��증해본 게 있어? (인터뷰, 랜딩 테스트, 사전 판매 등)"
- A) 있어 — 구체��으로 입력받음
- B) 아직 없어

**Q5**: "기술 스택은? 그리고 시장은 국내? 해외?"
- 자유 입력

수집한 답변을 저장:
- Q1 → `project.problem` (핵심 문제 추출)
- Q2 → `project.icp`
- Q3 → `project.hypothesis`
- `project.name`은 Q1에서 자동 생성 (짧은 프로젝트명)

**audit_progress 저장**: `{ current_step: 2, data: { q1~q5 답변 } }` → state.json Write

### Step 2: 시장 판정 (10분)

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Step 2/4 · 시장 판정
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

네가 알려준 정보를 바탕으로 시장을 판정할게.
몇 가지 더 물어볼게.
```

순차 AskUserQuestion:

**Q6**: "네 ICP ({project.icp})가 이 문제를 해결하려고 지금 뭘 하고 있어? 어떤 대안을 쓰고 있어?"
- 자유 입력

**Q7**: "그 대안의 가장 큰 불만은 뭐야? 뭐가 부족해?"
- 자유 입력

**Q8**: "네 제품이 그 대안보다 나은 점은 딱 하나만 말하면?"
- 자유 입력

**한국 시장 구조적 제약 체크** (Q5에서 국내 시장인 경우):

`{REFS_DIR}/biz/biz-setup-decision.md` Read하여 한국 시장 특수 상황 확인.

출력: "한국 시장이면 결제 수단 확보가 관건이야. 사업자 등록 없이도 가능한 방법이 있어 — 나중에 `/agnt:biz-setup`에서 안내할게."

**audit_progress 저장**: `{ current_step: 3, data: { ... q6~q8 답변 추가 } }` → state.json Write

### Step 3: 판정 + 맞춤 경로 (15분)

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Step 3/4 · 판정 + 맞춤 경로
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**판정 로직** (Step 1 + Step 2 답변 기반):

수집한 데이터를 종합하여 아래 기준으로 판정:

| 신호 | buyer_exists (Track A) | buyer_uncertain (Track B) | buyer_absent (Track C) |
|------|----------------------|-------------------------|----------------------|
| 기존 검증 시도 | 있음 (인터뷰/랜딩/사전판매) | 일부 있음 | 없음 |
| 경쟁/대안 | 있고 불만 명확 | 있지만 불만 불명확 | 없거나 무료 대안 충분 |
| ICP 구체성 | 이름 대면 떠오름 | 집단은 알지만 개인 불명 | "누구나" |
| 가격 가설 | 금액까지 언급 | "돈 낼 것 같다" 수준 | 가격 언급 없음 |
| 차별점 | 1문장으로 명확 | 설명 필요 | 불명확 |

3개 이상 해당하는 verdict를 선택한다. 동점이면 buyer_uncertain (Track B).

**AI 판정 실패 시**: fallback to Track C (가장 보수적).

**판정 출력**:

```
═════════════════════════════════════════��
  Revenue Readiness Audit 결과
══════════════════════════════════════════

VERDICT: {verdict 한국어}
  buyer_exists → "7일 안에 구매자를 만날 수 있어"
  buyer_uncertain → "가능성은 있지만 검증이 필요해"
  buyer_absent → "아직 구매자가 보이지 않아 — 문제부터 찾자"

근거:
  1. {reason_1}
  2. {reason_2}
  3. {reason_3}

──────────────────────────────────────────
  Revenue Readiness Score
──────────────────────────────────────────

  {1-10 점수}  [{ASCII bar 10칸}]

  Track A (buyer_exists): 8-10
  Track B (buyer_uncertain): 4-7
  Track C (buyer_absent): 1-3

──────────────────────────────────────────
  맞춤 경로: Track {track}
────────────────────────────────────────��─

{Track 설명}

Track A (5일): 문제가 명확하고 바로 빌드
  → 랜딩 → 결제 → 런칭 → 분석 → 수익 확정

Track B (7-8일): 문제가 있지만 검증 필요
  → ICP 인터뷰 → SPEC → 랜딩 → BIP → 결제 → 런칭 → 분석

Track C (10일): 아직 문제를 찾는 중
  → 문제 발견 → 인터뷰 → BIP → SPEC → 랜딩 → SEO → 결제 → 분석 → 런칭 → 광고

══════════════════════════════════════════
```

AskUserQuestion: "이 판정이 맞아?"
- 1~5 점수 (1 = 전혀 아님, 5 = 정확함)

답변을 `audit_result.user_confidence`에 저장.

user_confidence가 1-2인 경우:
"판정이 안 맞다고 느끼면 `/agnt:audit`를 다시 실행해도 돼. 아니면 이 Track으로 시작하고 나중에 방향을 바꿔도 괜찮아."

**audit_result 저장**:
```json
{
  "track": "A" | "B" | "C",
  "verdict": "buyer_exists" | "buyer_uncertain" | "buyer_absent",
  "user_confidence": 1-5,
  "reasons": ["reason_1", "reason_2", "reason_3"],
  "completed_at": "ISO8601"
}
```

**audit_progress 초기화**: `null` (완료했으므로)

state.json Write.

### Step 4: 커뮤니티 연결 (5분)

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Step 4/4 · 커뮤니티
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

혼자 하면 느려. 같은 여정을 걷는 사람들이 있어.

  October Academy — 1인 개발자 학습 커뮤니티
  https://october-academy.com

  Agentic Garage Seoul — 에이전틱 빌더 밋업
  https://lu.ma/agentic-garage-seoul

  Discord — 실시간 소통
  https://discord.gg/october-academy

지금 안 들어가도 돼. 나중에 막힐 때 찾아가면 돼.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. Journey-brief 기록

`{AGNT_DIR}/journey-brief.md` Read 시도.
- 없으면 navigator-engine.md의 journey-brief 템플릿으로 새로 생성
- 있으면 기존 파일 사용

`## Audit` 섹션을 Replace:

```markdown
## Audit
- Track: {audit_result.track}
- Verdict: {audit_result.verdict} — {verdict 한국어 설명}
- Revenue Readiness Score: {점수}/10
- 근거:
  1. {reason_1}
  2. {reason_2}
  3. {reason_3}
- 진단일: {audit_result.completed_at}
```

journey-brief.md Write.

### 6. 완료 + MCP 제출

`meta.last_action = "audit"`
`meta.total_actions++`
state.json Write.

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice("wf-audit")` 호출
- 실패 시 `sync.pending_events`에 큐잉

도구 없으면:
- `sync.pending_events`에 `{ type: "submit_practice", args: { quest_id: "wf-audit" }, created_at: now() }` 추가

완료 출력:
```
══════════════════════════════════════════
  Audit 완료
══════════════════════════════════════════

Track {track} · {verdict 한국어}

다음 명령:
/agnt:next — Track {track} 맞춤 다음 행동 추천
/agnt:status — 현재 상태 확인
══════════════════════════════════════════
```

## 규칙

- Audit는 `project.*`를 소유한다. Track A/B 유저는 `/agnt:discover`를 별도로 실행할 필요 없음
- AI가 Track을 판정하지 못하면 fallback to Track C (가장 보수적)
- `audit_progress`는 각 Step 완료 시마다 저장 (세션 중단 시 resume 가능)
- `audit_result` 저장 시 `audit_progress`를 null로 초기화
- 한국어 출력, 기술 용어 원문 유지
- 반말 톤
- `identity`, `sync` 필드가 state에 없으면 navigator-engine.md 기본값 사용
