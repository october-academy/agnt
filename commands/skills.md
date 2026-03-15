스킬트리를 시각화하고 스킬포인트를 투자합니다.

## 데이터 경로 결정

이 커맨드의 모든 파일 경로는 아래 절차로 결정합니다.

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 둘 다 없으면 → "먼저 `/agnt:continue`로 학습을 시작하세요." 출력 후 종료

### REFS_DIR (references 루트)

1. `{AGNT_DIR}/references/shared/classes.json`을 Read 시도 → 성공하면 **REFS_DIR = `{AGNT_DIR}/references`**
2. 실패 시 `~/.claude/plugins/marketplaces/agentic30/references/shared/classes.json` Read 시도 → 성공하면 **REFS_DIR = `~/.claude/plugins/marketplaces/agentic30/references`**
3. 실패 시 `.agents/skills/agnt/references/shared/classes.json` Read 시도 → 성공하면 **REFS_DIR = `.agents/skills/agnt/references`**
4. 실패 시 `~/.codex/skills/agnt/references/shared/classes.json` Read 시도 → 성공하면 **REFS_DIR = `~/.codex/skills/agnt/references`**
5. 둘 다 없으면 에러:
   - "references를 찾을 수 없습니다. Claude Plugin 사용자는 `bun run sync:assistant-assets` 또는 plugin 재설치를, Codex 사용자는 `npx skills add october-academy/agnt --agent codex --skill agnt`를 실행하세요."

## 출력 규칙 (필수)

### 내부 로직 무음 처리

아래 절차는 **유저에게 텍스트를 출력하지 않고** 내부적으로만 수행합니다:

- AGNT_DIR / REFS_DIR 경로 탐색 및 결과
- state.json 파싱 결과
- 파일 Read 성공/실패 여부
- JSON 파싱 결과

## 실행 절차

1. `{AGNT_DIR}/state.json`을 Read. `class`, `skillPoints`, `skills` 필드가 없으면 기본값 처리 (`null`, `0`, `{}`).

2. **기존 스킬 마이그레이션 체크**: `state.skills` 객체에 구 시스템 스킬 ID(예: `goal-setting`, `env-setup`, `customer-discovery` 등 prefix가 `ck-`/`gm-`/`pr-`/`rp-`로 시작하지 않는 ID)가 있으면:
   - 투자된 SP 총량 계산 (모든 스킬 레벨의 합)
   - `state.skillPoints += 투자된 총량` (SP 환불)
   - `state.skills = {}` (리셋)
   - state.json Write
   - 아래 메시지 출력:
   ```
   두리가 장부를 넘기다 고개를 든다.

   "스킬트리가 개편됐어.
   네가 투자한 포인트는 돌려줄게."

   🔄 {환불된SP}포인트가 반환되었습니다.
   ```

3. **직업 미선택 체크**: `state.class`가 null이면:

   ```
   두리가 손을 내젓는다.

   "스킬트리? 직업부터 골라."

   💡 `/agnt:class`로 직업을 선택하세요
   ```
   종료.

4. `{REFS_DIR}/shared/classes.json`을 Read. 현재 직업 정보를 가져옴.
   `{REFS_DIR}/shared/skill-trees/{state.class}.json`을 Read. 현재 직업의 스킬트리 데이터를 가져옴.

5. **헤더 출력**:

   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   {classEmoji} {className}의 스킬트리
   SP: {skillPoints} 포인트 사용 가능
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

6. **3개 탭 렌더링** (스킬트리 JSON의 `tabs` 배열 순서대로):

   각 탭에 대해 아래 형식으로 출력:

   ```
   {tabEmoji} {tabName}
   "{tabDescription}"
   ┌─────────────────────────────────────────┐
   │                                         │
   │  ── Tier 1 ──                           │
   │  {status} {skill1.name} [{lv}/{max}]    │
   │  {status} {skill2.name} [{lv}/{max}]    │
   │       │         │                       │
   │  ── Tier 2 ──                           │
   │  {status} {skill3.name} [{lv}/{max}]    │
   │  {status} {skill4.name} [{lv}/{max}]    │
   │       │         │                       │
   │  ── Tier 3 ──                           │
   │  {status} {skill5.name} [{lv}/{max}]    │
   │  {status} {skill6.name} [{lv}/{max}]    │
   │       └────┬────┘                       │
   │  ── Tier 4 ──                           │
   │  {status} {skill7.name} [{lv}/{max}]    │
   │            │                            │
   │  ── Tier 5 ──                           │
   │  {status} {skill8.name} [{lv}/{max}]    │
   │                                         │
   └─────────────────────────────────────────┘
   ```

   **스킬 상태 아이콘** 결정 로직 (위에서부터 순서대로 평가, 첫 매칭 사용):

   - `state.skills[skillId] >= maxLevel` → `⭐` (MAX)
   - `state.skills[skillId] >= 1` → `✅` (투자됨) + 레벨 표시
   - prerequisites가 모두 충족 (해당 prereq 스킬이 `state.skills`에서 1+) → `⬜` (해금 가능 — SP 유무와 무관)
   - prerequisites가 빈 배열 `[]` (T1 스킬) → `⬜` (항상 해금 가능)
   - 그 외 → `🔒` (잠김 — prerequisites 미충족)

7. **요약 통계**:

   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   📊 스킬 현황: {투자된스킬수}/24 해금 | SP {skillPoints} 남음
   🏆 최고 스킬: {가장 높은 레벨 스킬 3개, "이름 Lv.N" 형식}
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

8. **스킬포인트 투자** (`skillPoints >= 1`일 때만):

   투자 가능한 스킬 목록을 계산합니다:
   - prerequisites가 모두 충족된 스킬 중 (T1 스킬은 항상 충족)
   - 현재 레벨이 maxLevel 미만인 스킬

   투자 가능 스킬이 없으면:
   ```
   💡 현재 투자 가능한 스킬이 없습니다. 더 많은 Day를 완료하세요.
   ```

   투자 가능 스킬이 있으면:
   ```
   🎯 스킬포인트를 투자하시겠습니까?
   ```

   `AskUserQuestion`으로 선택:
   - options: 투자 가능 스킬별 "{tabEmoji} {skillName} ({tabName}) Lv.{현재}→{현재+1}" + "나중에 하기"

   "나중에 하기" 선택 시 종료.

   스킬 선택 시:
   - `state.skills[skillId]`를 +1 (없으면 0에서 1로)
   - `state.skillPoints`를 -1
   - state.json Write

   투자 확인 출력:
   ```
   ✅ {skillName} Lv.{newLevel} 달성!
   ```
   - `skill.levels` 배열이 존재하고 `newLevel - 1 < skill.levels.length`이면: `skill.levels[newLevel - 1]` 출력
   - 그렇지 않으면: `skill.description` 출력

   시너지 표시 (`skill.synergies.receives`가 존재하면):
   ```
   ── 시너지 ──
   ```
   각 시너지에 대해:
   - 보너스 텍스트 결정: `syn.bonus`가 배열이면 `syn.bonus[clamp(소스레벨-1, 0, length-1)]`, 문자열이면 `syn.bonus` 그대로
   - `state.skills[syn.from] >= 1`이면: `✦ {소스스킬이름} (Lv.{소스레벨}) — {보너스텍스트}` (활성)
   - 그렇지 않으면: `○ {소스스킬이름} — {보너스텍스트}` (비활성, 소스레벨=0이므로 bonus[0] 사용)
   소스 스킬 이름은 같은 JSON 파일에서 `syn.from` ID로 조회.

   `skillPoints`가 아직 1+ 남아있으면 step 8을 반복.

## 규칙

- 한국어 출력. 기술 용어는 원문 유지.
- `{REFS_DIR}/shared/skill-trees/{classId}.json`과 `classes.json`의 데이터를 그대로 사용 (하드코딩 금지).
- 탭 렌더링 순서: 스킬트리 JSON의 `tabs` 배열 순서 (Tab 1 → Tab 2 → Tab 3).
- state.json에 `class`, `skillPoints`, `skills` 필드가 없으면 기본값으로 처리.
- 스킬 투자는 반드시 prerequisites 충족을 검증한 후 수행.
- 한 번의 `/agnt:skills` 호출에서 여러 포인트를 연속 투자할 수 있다.
- 구 시스템 스킬 ID 감지 시 자동 마이그레이션 (SP 환불 + skills 리셋).
