오늘의 퀘스트 보드를 MUD 스타일로 표시합니다.

## 실행 절차

1. `.claude/agnt/state.json`을 Read. 없으면 "먼저 `/agnt:continue`로 학습을 시작하세요." 출력.

2. `.claude/agnt/references/day{currentDay}/index.json`을 Read합니다.
   - 성공 시: index.json에서 장소명, 설명, 퀘스트 정보를 가져옵니다 (step 3-4 생략).
   - 실패 시 (파일 없음): fallback으로 step 3-4를 실행합니다.

3. (fallback) `.claude/agnt/references/shared/world-data.md`를 Read해서 현재 Day의 장소명과 설명을 가져옵니다.

4. (fallback) `.claude/agnt/references/day{currentDay}/` 디렉토리의 모든 block*.md 파일을 Read하고, 각 블록에서 퀘스트 정보(제목, XP, 타입)를 추출합니다. YAML frontmatter의 `quests` 필드를 우선 확인하고, 없으면 `## QUEST` 섹션에서 추론합니다.

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

## 규칙
- 한국어 출력
- 히든 퀘스트는 trigger 조건 미충족 시 `[???]`로 표시
- MCP 연결 시 서버 동기화, 미연결 시 로컬 캐시 기반 (경고 표시)
