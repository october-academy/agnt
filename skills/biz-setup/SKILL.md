---
name: biz-setup
description: >-
  사업자 등록 판단 — 의사결정 트리 + 비용 시뮬레이션. 사업자 등록 여부 판단 시 사용.
---

사업자 등록 판단 가이드. 학습자의 상황을 진단하고 사업자 등록 여부를 안내합니다.

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

### 2. 상황 수집

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  사업자 등록 판단
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

사업자 등록이 필요한지 같이 판단해보자.
몇 가지만 물어볼게.
```

AskUserQuestion: "현재 신분은?"
- A) 학생
- B) 직장인 (정규직)
- C) 프리랜서 / 무직
- D) 병역 복무 중 (산업기능요원/전문연구요원)

AskUserQuestion: "건강보험 상태는?"
- A) 피부양자 (부모님/배우자 직장 건보)
- B) 지역가입자 (본인 납부)
- C) 직장가입자 (본인 직장)
- D) 잘 모르겠어

AskUserQuestion: "현재 매출이 있어?"
- A) 없음 — 아직 검증 중
- B) 소액 (월 50만원 미만)
- C) 중간 (월 50-200만원)
- D) 그 이상

AskUserQuestion: "특별한 상황이 있어?"
- A) 없음
- B) 학자금 대출 수혜 중
- C) 예비창업패키지 지원 중/예정
- D) 겸업금지 조항 있음 (직장인)

AskUserQuestion: "나이가 만 34세 이하야? (청년창업 세액감면 대상 확인)"
- A) 네 (만 15~34세)
- B) 아니오 (만 35세 이상)
- C) 군 복무 경력 있음 — 복무 기간만큼 나이 차감 가능

### 3. 의사결정 분석

`{REFS_DIR}/biz/biz-setup-decision.md` Read.

수집한 답변을 의사결정 트리에 매핑하여 판정(REGISTER/CONSIDER/DELAY)을 도출한다.

### 4. 결과 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  판정: {REGISTER/CONSIDER/DELAY}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{판정별 상세 안내}

{DELAY인 경우}
📋 네 상황에서 주의할 점:
{해당하는 패널티 목록 나열}

💰 사업자 등록 시 예상 월 비용:
{비용 시뮬레이션 — biz-setup-decision.md 기반}

🔄 대안 — 사업자 없이 결제 받기:
{MoR 대안 목록}
상세 비교는 /agnt:tools에서 E) "사업자 없이 결제" 선택.

{REGISTER인 경우}
✅ 간이과세자로 시작하면:
{간이과세자 혜택 안내}

{청년 대상자(만 34세 이하)인 경우, 판정과 관계없이 표시}
──────────────────────────────────────────
🎓 청년창업 세액감면

만 34세 이하 + 해당 업종 최초 창업이면,
소득세를 최대 5년간 50~100% 감면받을 수 있어.

  서울 (과밀억제권역): 50% 감면
  수도권 외곽: 75% 감면
  비수도권: 100% 감면 (소득세 0원)

소프트웨어 개발, 통신판매, 교육 서비스 등
1인 개발자 주요 업종 대부분 해당돼.

⚠️ 자동 적용 아님 — 종합소득세 신고 시 별도 신청
⚠️ 업종 코드가 정확해야 함 — 홈택스에서 확인
──────────────────────────────────────────

{CONSIDER인 경우}
💡 세무사 상담을 추천해:
국세청 126 또는 동네 세무사 초기 상담 (보통 무료)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 5. 면책 고지

항상 출력:
```
⚠️ 이 안내는 일반적인 참고 정보입니다.
개인 상황에 따라 결과가 다를 수 있으며,
구체적인 판단은 세무사 또는 국세청(126)에 문의하세요.
```

### 6. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  사업자 등록 판단 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

판정: {판정}

{다음 단계 안내}
• 결제 도구 비교 → /agnt:tools
• 페이월 설계 → /agnt:offer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 7. state 업데이트 + MCP 제출

state.json 업데이트:
- `tools.business_registration = "{판정 소문자}"` ("registered", "delayed", "considering")
- `meta.last_action = "biz-setup"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-biz-setup"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-biz-setup" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- 사업자 등록을 권하거나 말리지 않는다 — 상황에 맞는 정보를 제공할 뿐
- 면책 고지는 반드시 포함 — 법적/세무 조언이 아님을 명시
- 패널티 목록은 해당 상황에만 표시 — 전부 나열하지 않음
- 비용 시뮬레이션은 보수적으로 — 감면 적용 전 금액 먼저, 감면 후 금액 참고
- state.json Write 먼저 (critical path)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
