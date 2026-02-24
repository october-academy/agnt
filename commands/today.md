오늘의 퀘스트 보드를 MUD 스타일로 표시합니다.

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

퀘스트 보드를 즉시 출력합니다. 로딩 메시지 없이 무음 → 퀘스트 보드 바로 표시.

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

2. `{REFS_DIR}/day{currentDay}/index.json`을 Read 시도.
   - 성공 시: index.json에서 장소명, 설명, 퀘스트 정보를 가져옵니다 (step 3-4 생략).
   - 실패하고 REFS_PRO_DIR != null이면: `{REFS_PRO_DIR}/day{currentDay}/index.json` Read 시도. 성공 시 step 3-4 생략.
   - 둘 다 없으면: fallback으로 step 3-4를 실행합니다.

3. (fallback) `{REFS_DIR}/shared/world-data.md`를 Read해서 현재 Day의 장소명과 설명을 가져옵니다. 없으면 REFS_PRO_DIR != null일 때 `{REFS_PRO_DIR}/shared/world-data-extended.md`에서 가져옵니다.

4. (fallback) `{REFS_DIR}/day{currentDay}/` 디렉토리의 모든 block\*.md 파일을 Read합니다. 없으면 REFS_PRO_DIR != null일 때 `{REFS_PRO_DIR}/day{currentDay}/`에서 Read합니다. 각 블록에서 퀘스트 정보(제목, XP, 타입)를 추출합니다. YAML frontmatter의 `quests` 필드를 우선 확인하고, 없으면 `## QUEST` 섹션에서 추론합니다.

5. state.json의 `completedBlocks[currentDay]`와 대조하여 완료 상태를 판정합니다.

6. 아래 형식으로 출력:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Day {N} -- {장소명}
━━━━━━━━━━━━━━━━━━━━━━━━━━

⚔️ 메인 퀘스트
  {✅/⬜} {퀘스트명}       +{XP} XP
  {✅/⬜} {퀘스트명}       +{XP} XP

⭐ 사이드 퀘스트
  {✅/⬜} {퀘스트명}       +{XP} XP

❓ 히든 퀘스트
  ??? 조건을 만족하면 발견

━━━━━━━━━━━━━━━━━━━━━━━━━━
🧙 Lv.{level} {title} | {xp} XP
📊 [{bar}] {completed}/{total}
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

7. `ToolSearch`로 `+agentic30` 검색하여 MCP 연결 확인:
   - **도구 발견됨**: MCP `get_leaderboard`로 서버 데이터 동기화 후 최신 레벨/XP 표시
   - **도구 없음**: 경고 배너 표시 후 로컬 데이터로 계속:
     ```
     ⚠️ MCP 미연결 — 로컬 캐시 데이터입니다. `/mcp`에서 agentic30 서버를 연결하세요.
     ```
     (Codex 사용자는 `codex mcp add agentic30 --url https://mcp.agentic30.app/mcp` 후 `codex mcp login agentic30` 실행)

## 규칙

- 한국어 출력
- 히든 퀘스트는 trigger 조건 미충족 시 `[???]`로 표시
- MCP 연결 시 서버 동기화, 미연결 시 로컬 캐시 기반 (경고 표시)
