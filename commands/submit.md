현재 Day의 퀘스트를 검증하고 제출합니다.

## 데이터 경로 결정

이 커맨드의 모든 파일 경로는 아래 절차로 결정합니다.

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 둘 다 없으면 → "먼저 `/agnt:continue`로 학습을 시작하세요." 출력 후 종료

### REFS_DIR (references 루트)

1. `{AGNT_DIR}/references/shared/narrative-engine.md`를 Read 시도 → 성공하면 **REFS_DIR = `{AGNT_DIR}/references`**
2. 실패 시 `~/.claude/plugins/marketplaces/agentic30/references/shared/narrative-engine.md` Read 시도 → 성공하면 **REFS_DIR = `~/.claude/plugins/marketplaces/agentic30/references`**
3. 실패 시 `.agents/skills/agnt/references/shared/narrative-engine.md` Read 시도 → 성공하면 **REFS_DIR = `.agents/skills/agnt/references`**
4. 실패 시 `~/.codex/skills/agnt/references/shared/narrative-engine.md` Read 시도 → 성공하면 **REFS_DIR = `~/.codex/skills/agnt/references`**
5. 둘 다 없으면 에러:
   - "references를 찾을 수 없습니다. Claude Plugin 사용자는 `bun run sync:assistant-assets` 또는 plugin 재설치를, Codex 사용자는 `npx skills add october-academy/agnt --agent codex --skill agnt`를 실행하세요."

## 실행 절차

1. `{AGNT_DIR}/state.json`을 Read (경로 결정 단계에서 이미 확인됨).

1-1. **MCP 연결 확인**:

- `ToolSearch`로 `+agentic30` 검색
- **도구 없음**: "⛔ MCP 서버 연결이 필요합니다. Claude Code는 `/mcp`, Codex는 `codex mcp add/login`으로 agentic30 서버를 연결하세요." 출력 후 종료
- **도구 발견됨**: 정상 진행

2. `{REFS_DIR}/day{currentDay}/index.json`을 Read합니다.
   - 성공 시: index.json의 `quests` 필드에서 퀘스트 목록과 검증 정보를 가져옵니다 (step 3 생략).
   - 실패 시 (파일 없음): fallback으로 step 3을 실행합니다.

3. (fallback) `{REFS_DIR}/day{currentDay}/` 의 모든 block\*.md를 Read. YAML frontmatter의 `quests` 필드를 우선 확인하고, 없으면 `## QUEST` 섹션에서 퀘스트와 검증 규칙을 추출합니다.

4. 퀘스트별 로컬 검증 수행:
   - **file_exists**: 파일 시스템에서 해당 파일 존재 확인
   - **url_format**: URL 형식 regex 검증
   - **content_quality**: 파일을 Read하여 내용 품질 평가 (구조, 분량, 핵심 요소)
   - **text/template**: state.json 또는 관련 파일에서 데이터 존재 확인
   - **server_state**: MCP 검증 필요 표시

5. 검증 결과를 표시:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 퀘스트 검증 -- Day {N}
━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✅ {퀘스트명}       +{XP} XP
  ❌ {퀘스트명}       미충족
     → {실패 이유 + 가이드}
  ⏭️ {퀘스트명}       서버 확인 필요
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

6. 통과한 퀘스트를 MCP `submit_practice`로 제출:
   - questId, evidence(type + data) 전달
   - 응답의 XP, 레벨업, 해금 스킬 표시

7. 레벨업 발생 시:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━
⬆️ 레벨 업!
🧙 Lv.{prev} → Lv.{new}
📛 "{new_title}"
🔓 해금: {skill_names}
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

8. state.json 갱신: 서버 syncState 반영.

## 규칙

- 로컬 검증 실패 시 서버 제출하지 않음
- 이미 완료된 퀘스트는 "✅ 이미 완료" 표시
- 한국어 출력. 실패 가이드는 구체적으로
