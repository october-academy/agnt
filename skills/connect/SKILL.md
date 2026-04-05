---
user-invocable: false
name: connect
description: >-
  Agentic30 계정 연결 — 웹 가입 + MCP 인증. 연결, MCP 연결, 동기화 시 사용.
disable-model-invocation: true
---

Agentic30 계정 연결 — 웹 가입 + MCP 인증을 단일 플로우로 처리합니다.

## 데이터 경로 결정

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

## 출력 규칙

### 내부 로직 무음 처리

아래 절차는 **유저에게 텍스트를 출력하지 않고** 내부적으로만 수행합니다:

- AGNT_DIR 경로 탐색 및 결과
- state.json 파싱 결과
- 파일 Read 성공/실패 여부
- MCP ToolSearch 결과
- identity/sync 기본값 적용 여부

## 실행 절차

### 1. state 읽기

`{AGNT_DIR}/state.json`을 Read.

- 파일이 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료
- JSON 파싱 실패 시 → "state.json이 손상됐어. `/agnt:start`를 실행해." 출력 후 종료
- `meta.schema_version != 3` → "먼저 `/agnt:start`를 실행하세요." 출력 후 종료

v3 스키마가 아니면 `/agnt:start`를 먼저 실행해야 한다.

### 2. identity.mode 분기

`identity.mode` 값에 따라 분기:

---

#### 분기 A: "synced" — 이미 연결됨

`ToolSearch`로 `+agentic30` 검색하여 `get_user_info` 호출.

호출 성공 시:

- `identity.mcp.connected = true`, `identity.mcp.last_checked_at = now()` 갱신
- pending_events 플러시 (4단계)로 이동

호출 실패 시 (도구 없음 또는 인증 오류):

- `identity.mode = "registered"`, `identity.mcp.connected = false` 갱신
- state.json Write
- 출력:

```
연결이 끊겼어. MCP 재인증이 필요해.
```

→ 분기 B의 Step B로 이동

---

#### 분기 B: "registered" — 웹 가입 완료, MCP 미연결

출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MCP 연결만 하면 돼
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

웹 가입은 완료했어. MCP만 연결하면 XP가 쌓이기 시작해.
```

→ Step B로 이동

---

#### 분기 C: "guest" — 미가입, 미연결

**Step A: 웹 가입 안내**

출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Agentic30 연결
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

연결하면 이런 게 생겨:
  - 완료한 퀘스트의 XP가 한 번에 적립돼
  - UTM 추적 링크로 채널별 성과를 자동 측정해
  - 리더보드에서 동료 진행 현황을 볼 수 있어

🔗 https://agentic30.app/signup — Google로 30초 가입
```

AskUserQuestion: "가입했어?"

- A) 완료했어 → `identity.mode = "registered"` 저장 후 Step B로
- B) 나중에 할게 → 아래 출력 후 종료:

```
언제든 `/agnt:connect`로 다시 연결할 수 있어.
지금까지 한 작업은 로컬에 저장돼 있어.
```

---

### Step B: MCP 인증 안내

출력 (환경 감지 없이 양쪽 모두 표시):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  MCP 인증
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Claude Code]
  /mcp → agentic30 선택 → Google 인증

[Codex]
  codex mcp add agentic30 --url https://mcp.agentic30.app/mcp
  codex mcp login agentic30
```

AskUserQuestion: "인증 완료했어?"

- A) 완료했어 → Step C로
- B) 잘 안 돼 → 아래 출력 후 종료:

```
MCP 서버 URL: https://mcp.agentic30.app/mcp

연결이 안 되면:
  - /mcp 목록에 agentic30이 없으면 → Claude Code 설정에서 MCP 서버를 추가해
  - 인증 페이지가 안 열리면 → 브라우저 팝업 차단 해제 후 다시 시도해

해결 후 `/agnt:connect`를 다시 실행해.
```

---

### Step C: 연결 확인

`ToolSearch`로 `+agentic30` 검색하여 `get_user_info` 호출.

**성공 시:**

- `identity.mode = "synced"`
- `identity.mcp.connected = true`
- `identity.mcp.last_checked_at = now()`
- state.json Write
- 4단계(플러시)로 이동

**실패 시 (도구 없음 또는 인증 오류):**

- `identity.mode = "registered"` 유지 (가입은 했으므로)
- `identity.mcp.connected = false`
- state.json Write
- 출력:

```
아직 연결이 안 됐어. 위 단계를 다시 확인해봐.

연결 확인 후 `/agnt:connect`를 다시 실행해.
```

종료.

---

### 4. pending_events 플러시

(연결 성공 후 실행)

`sync.pending_events` 배열을 읽어 미동기화 퀘스트 제출을 일괄 처리.

**플러시 사전 확인 — get_user_info 호출:**

`get_user_info` MCP 도구 호출 → `syncState`에서 현재 레벨/XP 기록 (레벨업 감지용).

**이벤트 순회 (순차 처리):**

`sync.pending_events` 배열을 순서대로 순회. 각 이벤트에 대해:

```
이벤트 형식: { type: "submit_practice", args: { quest_id: "wf-*" }, created_at: "..." }
```

- `submit_practice(quest_id)` MCP 호출
- 성공: 이벤트를 processed 목록에 추가, 배열에서 제거
- 실패: 이벤트 유지, 에러 기록, 다음 이벤트로 계속

`sync.pending_events = 실패_이벤트_잔존`
`sync.last_synced_at = now()`
state.json Write.

**플러시 후 state 서버 동기화:**

`sync_agnt_state` MCP 호출로 로컬 state를 서버에 백업:

- `project`: state.project (problem, icp, hypothesis, name)
- `auditResult`: state.audit_result (있으면)
- `artifacts`: state.artifacts 스냅샷 (interviews, spec_versions, offer_drafted, channels_active, loops_completed)
- `schemaVersion`: state.meta.schema_version

실패 시 무시 (백업이므로 critical path 아님).

**플러시 후 확인 — get_user_info 재호출:**

`get_user_info` 호출 → 플러시 전 레벨/XP와 비교하여 변화 감지.

```
gained_xp = 현재 total_xp - 이전 total_xp
level_changed = 현재 level != 이전 level
```

### 5. 완료 출력

**플러시 이벤트가 있었던 경우:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  연결 완료!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

레벨: Lv.{현재 level} {title}{level_changed ? " — 레벨업!" : ""}
XP: {total_xp}{gained_xp > 0 ? " (+" + gained_xp + ")" : ""}

동기화: {flushed_count}건 전송{failed_count > 0 ? " / " + failed_count + "건 재시도 필요" : ""}

대시보드: https://agentic30.app/dashboard
동료 현황: /agnt:status에서 리더보드 확인
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**플러시 이벤트가 없었던 경우 (pending_events가 비어 있음):**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  연결 완료!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

레벨: Lv.{level} {title}
XP: {total_xp}

이제 퀘스트를 완료하면 XP가 자동으로 쌓여.

대시보드: https://agentic30.app/dashboard
다음 행동: /agnt:next
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**failed_count > 0인 경우 추가 안내:**

```
⚠️ {failed_count}건은 전송 실패했어.
다시 `/agnt:connect`를 실행하면 재시도해.
```

## 규칙

- `complete_onboarding`은 호출하지 않음 — 웹 온보딩 위저드(agentic30.app)가 처리
- `save_interview`, `save_spec_iteration`은 플러시 대상이 아님 — 로컬 파일(journey-brief.md, specs/)에 이미 보존됨
- pending_events 플러시는 submit_practice만 처리 (고정 형식: `{ quest_id: "wf-*" }`)
- 개별 이벤트 실패 시 실패 이벤트만 유지, 나머지는 제거 후 계속 처리
- 플러시 완료 후 `sync_agnt_state` MCP 호출로 project/audit_result/artifacts를 서버에 백업 (실패 시 무시)
- identity.mode 전이: `guest` → (가입 확인 후) `registered` → (MCP 인증 후) `synced`
- MCP 호출 실패 시 로컬 state는 저장, identity.mode는 최대한 진전된 상태로 유지
- 한국어 출력, 기술 용어(MCP, OAuth, CLI, XP) 원문 유지
- 반말 톤
