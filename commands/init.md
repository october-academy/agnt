진행 상태를 초기화하고 Day 0부터 다시 시작합니다.

## 데이터 경로 결정

이 커맨드의 모든 파일 경로는 아래 절차로 결정합니다.

### AGNT_DIR (state + data 루트)

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 둘 다 없으면 기본값:
   - Claude Code 실행 시 **AGNT_DIR = `~/.claude/agnt`**
   - Codex 실행 시 **AGNT_DIR = `~/.codex/agnt`**

## 출력 규칙 (필수)

### 내부 로직 무음 처리

아래 절차는 **유저에게 텍스트를 출력하지 않고** 내부적으로만 수행합니다:

- AGNT_DIR 경로 탐색 및 결과
- state.json 파싱 결과
- 파일 Read 성공/실패 여부

### 에러 메시지 — NPC 대사로 전환

파싱 실패 등 에러 상황에서는 기술적 메시지 대신 NPC 대사를 사용합니다:

```
두리가 장부를 들여다보다 고개를 젓는다.

"장부가 좀 이상해.
새로 쓸게."
```

## 실행 절차

1. `{AGNT_DIR}/state.json`을 Read합니다.
   - 파일이 없으면 `{AGNT_DIR}/state.json`에 기본 상태를 생성 (디렉토리 없으면 함께 생성)하고 아래 메시지를 출력한 뒤 종료:
     ```
     📦 초기 상태를 만들었습니다.
     이제 `/agnt:continue`로 Day 0부터 시작하세요.
     ```
   - 파싱 실패 시 `{AGNT_DIR}/state.json.bak`으로 백업 후 기본 상태로 재생성합니다.

2. 현재 진행 요약을 표시합니다.
   - Day/Block, 완료 Day 수, 보유 XP(없으면 0)를 한 줄씩 보여줍니다.

3. AskUserQuestion으로 초기화 의사를 확인합니다:
   - 질문: `정말 처음부터 다시 시작할까요?`
   - 선택지:
     1. `네, 전체 진행을 초기화합니다.`
     2. `아니요, 현재 진행을 유지합니다.`

4. 사용자가 `아니요`를 선택하면:
   - 상태 파일은 변경하지 않고 아래 메시지 출력 후 종료:
     ```
     진행 상태를 유지합니다.
     계속하려면 `/agnt:continue`를 실행하세요.
     ```

5. 사용자가 `네`를 선택하면:
   - 기존 state를 `{AGNT_DIR}/state.json.bak`으로 백업(덮어쓰기 허용)
   - `{AGNT_DIR}/state.json`을 아래 기본값으로 Write:
     ```json
     {
       "currentDay": 0,
       "currentBlock": 0,
       "completedDays": [],
       "completedBlocks": {},
       "choices": [],
       "character": null,
       "interview": null,
       "authenticated": false,
       "level": 1,
       "title": "견습생",
       "xp": 0,
       "npcRelations": {},
       "tendency": 0,
       "archetype": null,
       "archetypeHistory": []
     }
     ```

6. 초기화 완료 메시지를 출력합니다:

   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🔄 새 여정을 시작합니다
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   진행 상태를 Day 0으로 초기화했습니다.
   필요하면 이전 상태는 `{AGNT_DIR}/state.json.bak`에서 복구할 수 있습니다.

   다음 명령:
   `/agnt:continue`
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

## 규칙

- 기본값 생성/초기화 시 state 스키마를 정확히 유지합니다.
- 사용자 확인 없이 상태를 삭제/초기화하지 않습니다.
- 한국어로 출력합니다.
- 이 커맨드는 **로컬 state만** 초기화합니다. 서버 리더보드/제출 기록은 유지됩니다.
