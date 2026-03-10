캐릭터 시트와 월드맵을 표시합니다.

## 데이터 경로 결정

이 커맨드의 모든 파일 경로는 아래 절차로 결정합니다.

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 둘 다 없으면 → "먼저 `/agnt:continue`로 학습을 시작하세요." 출력 후 종료

### REFS_DIR (references 루트)

1. `{AGNT_DIR}/references/shared/world-data.md`를 Read 시도 → 성공하면 **REFS_DIR = `{AGNT_DIR}/references`**
2. 실패 시 `~/.claude/plugins/marketplaces/agentic30/references/shared/world-data.md` Read 시도 → 성공하면 **REFS_DIR = `~/.claude/plugins/marketplaces/agentic30/references`**
3. 실패 시 `.agents/skills/agnt/references/shared/world-data.md` Read 시도 → 성공하면 **REFS_DIR = `.agents/skills/agnt/references`**
4. 실패 시 `~/.codex/skills/agnt/references/shared/world-data.md` Read 시도 → 성공하면 **REFS_DIR = `~/.codex/skills/agnt/references`**
5. 둘 다 없으면 에러:
   - "references를 찾을 수 없습니다. Claude Plugin 사용자는 `bun run sync:assistant-assets` 또는 plugin 재설치를, Codex 사용자는 `npx skills add october-academy/agnt --agent codex --skill agnt`를 실행하세요."

### REFS_PRO_DIR (Pro references, 선택적)

1. `{AGNT_DIR}/references-pro/shared/world-data-extended.md`를 Read 시도 → 성공하면 **REFS_PRO_DIR = `{AGNT_DIR}/references-pro`**
2. 실패 시 `~/.claude/plugins/marketplaces/agentic30-pro/references/shared/world-data-extended.md` Read 시도 → 성공하면 **REFS_PRO_DIR = `~/.claude/plugins/marketplaces/agentic30-pro/references`**
3. 실패 시 `.agents/skills/agnt-pro/references/shared/world-data-extended.md` Read 시도 → 성공하면 **REFS_PRO_DIR = `.agents/skills/agnt-pro/references`**
4. 실패 시 `~/.codex/skills/agnt-pro/references/shared/world-data-extended.md` Read 시도 → 성공하면 **REFS_PRO_DIR = `~/.codex/skills/agnt-pro/references`**
5. 모두 실패 → **REFS_PRO_DIR = null** (Pro 미설치 — 에러 아님)

## 출력 규칙 (필수)

### 내부 로직 무음 처리

아래 절차는 **유저에게 텍스트를 출력하지 않고** 내부적으로만 수행합니다:

- AGNT_DIR / REFS_DIR / REFS_PRO_DIR 경로 탐색 및 결과
- state.json 파싱 결과
- 파일 Read 성공/실패 여부
- MCP ToolSearch 결과
- "Pro 미설치" 등 내부 상태 판정

캐릭터 시트를 즉시 출력합니다. 로딩 메시지 없이 무음 → 캐릭터 시트 바로 표시.

### 에러 메시지 — NPC 대사로 전환

**references 없음** (기존: "references를 찾을 수 없습니다. Claude Plugin 사용자는..."):

```
두리가 도구함을 열다 멈춘다.

"도구가 비어 있어.
설치가 덜 된 것 같아."

🔧 설치 방법:
[Claude Code]
claude plugin marketplace add october-academy/agnt
claude plugin install agnt@agentic30

[Codex]
npx skills add october-academy/agnt --agent codex --skill agnt
```

## 실행 절차

1. `{AGNT_DIR}/state.json`을 Read (경로 결정 단계에서 이미 확인됨).

2. 현재 Day의 장소 정보를 가져옵니다:
   - `{REFS_DIR}/day{currentDay}/index.json`을 Read 시도.
   - 실패하고 REFS_PRO_DIR != null이면: `{REFS_PRO_DIR}/day{currentDay}/index.json` Read 시도.
   - 성공 시: `location`과 `description` 필드 사용.
   - 실패 시: `{REFS_DIR}/shared/world-data.md`를 Read해서 장소명 목록을 가져옵니다. REFS_PRO_DIR != null이면 `{REFS_PRO_DIR}/shared/world-data-extended.md`도 Read해서 합산.

3. `ToolSearch`로 `+agentic30` 검색하여 MCP 연결 확인:
   - **도구 발견됨**: MCP `get_leaderboard`로 서버 최신 데이터 동기화
   - **도구 없음**: 경고 배너 표시 후 로컬 데이터로 계속:
     ```
     ⚠️ MCP 미연결 — 로컬 캐시 데이터입니다. `/mcp`에서 agentic30 서버를 연결하세요.
     ```
     (Codex 사용자는 `codex mcp add agentic30 --url https://mcp.agentic30.app/mcp` 후 `codex mcp login agentic30` 실행)

4. 아래 형식으로 캐릭터 시트 출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
🧙 캐릭터 시트
━━━━━━━━━━━━━━━━━━━━━━━━━━
  Lv.{level} {title}
  XP: {xp}/{nextLevelXp}
  [{████░░░░░░}] {percent}%

  🎯 {character.project}
  📌 {character.goal}
  🧬 성향: {archetypeLabel} {tendencyBar}
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

4-1. `builderContext` 또는 `branchMode`가 있으면 아래 섹션을 추가합니다:

```
🧭 Builder 상태
  모드: {branchMode|recommendedMode|discovery_interview}
  진입 단계: {builderContext.entryMode|null}
  자산 단계: {builderContext.assetStage|null}
  현재 병목: {builderContext.primaryBottleneck|null}
  오퍼 타입: {builderContext.offerType|null}
  monetization rail: {builderContext.monetizationRail|null}
  strongest proof: {builderContext.monetizationProof.summary|null}
  latest decision: {builderContext.latestDecision.summary|null}
  next proof target: {state.nextProofTarget|builderContext.latestDecision.nextStep|null}
```

5. 스킬 해금 상태:

```
🔧 스킬 목록
  {✅/🔒} save_profile (Lv.1)
  {✅/🔒} connect_discord (Lv.1)
  {✅/🔒} verify_discord (Lv.1)
  {✅/🔒} verify_server_state (Lv.1)
  {✅/🔒} save_interview (Lv.1)
  {✅/🔒} submit_practice (Lv.1)
  {✅/🔒} get_leaderboard (Lv.1)
  {✅/🔒} get_learning_context (Lv.1)
  {✅/🔒} save_spec_iteration (Lv.1)
  {✅/🔒} get_spec_iterations (Lv.1)
  {✅/🔒} deploy_landing (Lv.3)
  {✅/🔒} get_landing_analytics (Lv.3)
  {✅/🔒} create_utm_link (Lv.3)
```

6. NPC 관계 맵:

`state.json.npcRelations`가 있으면 각 NPC의 trust 라벨과 게이지 바를 출력합니다.
`npcRelations`가 없거나 비어 있으면 `"아직 쌓인 관계가 없습니다."`를 출력합니다.

게이지 바는 `-5 ~ +5`를 11칸으로 매핑합니다:

- 예: `실망(-3)` → `██░░░░░░░░░`
- 예: `중립(0)` → `░░░░░█░░░░░`
- 예: `전우(5)` → `░░░░░░░░░██`

출력 형식:

```
🤝 NPC 관계 맵
  두리: 동료 (+2) [░░░░░███░░░]
  소리: 경계 (-1) [███░░░░░░░░]
```

7. archetype / tendency 섹션:

`tendency`가 없으면 `0`으로 간주, `archetype`이 없으면 `null(균형)`로 간주합니다.

라벨 규칙:

- `executor` → `실행형`
- `validator` → `검증형`
- `null` → `균형`

출력 형식:

```
🧬 성향
  현재: 실행형 (+4) [░░░░░██████░]
  아크: P1 실행형(+3) → P2 검증형(-4)
```

`archetypeHistory`가 없거나 비어 있으면 `아크` 줄은 생략 가능합니다.

8. ASCII 월드맵 (동적 생성):

`{REFS_DIR}/shared/world-data.md`의 Day별 장소 테이블을 Read합니다. REFS_PRO_DIR != null이면 `{REFS_PRO_DIR}/shared/world-data-extended.md`도 Read해서 합산합니다. 두 테이블의 Day 행을 합쳐서 전체 월드맵을 구성합니다.

각 Day에 대해:

- `completedDays`에 포함 → ✅
- `currentDay`와 같으면 → 👉 (현재 위치)
- 그 외 → 🔒

```
🗺️ 월드맵
  ✅ Day 0: 견습생의 마을
  ✅ Day 1: 발견의 숲
  👉 Day 2: 검증의 광장  ← 현재 위치
  🔒 Day 3: 설계의 탑
  ...
```

완료=✅, 현재=👉, 미개방=🔒

9. 퀘스트 진행률:

```
📈 전체 진행률: {completedQuests}/{totalQuests} ({percent}%)
```

## 규칙

- MCP 연결 시 서버 동기화, 미연결 시 로컬 캐시 기반 (경고 표시)
- 서버 `syncState.builderContext`가 있으면 로컬 `builderContext`를 갱신해서 표시합니다.
- 한국어 출력
