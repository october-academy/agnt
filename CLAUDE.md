# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

Claude marketplace plugin (NOT npm 패키지). 빌드 없음. `commands/*.md`가 `/agnt:*` colon-namespace 커맨드로 동작하며, `references/`가 MUD 스타일 학습 콘텐츠를 담고 있다.

## Commands

```bash
# 커맨드/레퍼런스 변경 후 플러그인 재동기화 (root에서)
bun run sync:assistant-assets
```

빌드, 린트, 테스트 없음. 마크다운 전용 패키지.

## Architecture

```
commands/              # /agnt:* 커맨드 (Claude Code가 실행하는 프롬프트)
  ├── init.md          # /agnt:init — 진행 상태 초기화 (Day 0 재시작)
  ├── continue.md      # /agnt:continue — 메인 학습 루프 (블록 순차 진행)
  ├── today.md         # /agnt:today — 퀘스트 보드 표시
  ├── submit.md        # /agnt:submit — 퀘스트 검증 + MCP 제출
  └── status.md        # /agnt:status — 캐릭터 시트 + 월드맵

references/            # 학습 콘텐츠 (커맨드가 Read해서 사용)
  ├── day0-7/          # Day별 블록 파일 (block*.md + index.json)
  └── shared/          # 공통 레퍼런스
      ├── narrative-engine.md   # 블록 처리 규칙 SSoT (STOP, 페이지네이션, 톤)
      ├── npcs.md               # NPC 캐릭터 카드 (말투, 성격, 금지사항)
      ├── world-data.md         # Day별 장소, 레벨/칭호, 스킬 해금
      ├── interview-guide.md    # 인터뷰 블록 원칙 (Mom Test, Follow the Thread)
      └── landing-design-guide.md  # 랜딩페이지 생성 디자인 가이드

.claude-plugin/
  ├── plugin.json       # 플러그인 메타 + MCP 서버 URL 정의
  └── marketplace.json  # 마켓플레이스 등록 정보
```

## How Commands Work

커맨드 파일은 Claude Code가 직접 실행하는 **프롬프트**. 코드가 아닌 절차적 지시문:

1. `state.json` 읽기 → 현재 Day/Block 결정
2. `ToolSearch`로 MCP `agentic30` 도구 존재 확인 (Day 0 Block 0 제외)
3. `references/`에서 해당 블록 마크다운 Read
4. `narrative-engine.md` 규칙에 따라 NPC 대화 + STOP + AskUserQuestion 진행
5. 블록 완료 시 `state.json` 갱신 + MCP `submit_practice` 호출

## Block File Format

모든 블록 파일(`references/day*/block*.md`)은 YAML frontmatter + 섹션 구조:

```yaml
---
stop_mode: full | conversation | checkpoint   # 블록 진행 모드
title: "블록 제목"
npc: 두리                                      # npcs.md에서 해당 카드 참조
quests:                                        # 선택: 이 블록의 퀘스트
  - id: d0-goal
    type: main
    title: "목표 선언문 작성"
    xp: 50
transition: "다음 블록 안내 메시지"
on_complete: save_character                    # 선택: 완료 시 추가 동작
---
```

### stop_mode별 섹션 구조

| Mode | 구조 | 용도 |
|------|------|------|
| `full` (Teach) | ROOM → NPC → SCENE(들) → TASK → STOP → RETURN → CHECK → MOVE | 개념 교육 + 퀴즈 |
| `conversation` (Talk) | ROOM → NPC → CONVERSATION → SUMMARY → STOP → ON_COMPLETE → MOVE | 인터뷰/대화 |
| `checkpoint` (Craft) | ROOM → NPC → GUIDE → PREVIEW → STOP → ON_CONFIRM → MOVE | 산출물 생성 |

## Day Index Files

각 Day의 `index.json`이 메타데이터 SSoT. 블록 frontmatter의 `quests`와 불일치 시 **index.json 우선**.

```json
{
  "day": 0,
  "location": "견습생의 마을",
  "blocks": [{ "file": "block0-welcome.md", "title": "..." }],
  "quests": [{ "id": "d0-goal", "type": "main", "title": "...", "xp": 50 }]
}
```

## State Management

런타임 상태: `.claude/agnt/state.json` (사용자 로컬, gitignored)

```json
{
  "currentDay": 0,
  "currentBlock": 0,
  "completedDays": [],
  "completedBlocks": {},
  "choices": [],
  "character": null,
  "interview": null,
  "authenticated": false
}
```

- 서버 동기화: MCP `agentic30` 서버와 Block Sync Protocol (`narrative-engine.md` Section 11)
- MCP 호출 실패 시 블록 완료 처리 금지 (로컬 데이터는 저장, 완료 마커 미기록)

## MCP Integration

플러그인이 `plugin.json`에서 HTTP MCP 서버를 선언:

```json
{ "mcpServers": { "agentic30": { "type": "http", "url": "https://mcp.agentic30.app/mcp" } } }
```

커맨드들은 `ToolSearch`로 `+agentic30` 검색하여 MCP 도구 로딩 후 사용:
- `get_leaderboard` — 서버 상태 동기화, 리더보드
- `submit_practice` — 퀘스트 완료 제출
- `save_profile`, `save_interview` — 프로필/인터뷰 데이터 저장
- `complete_onboarding` — 온보딩 완료
- `verify_discord` — Discord 연동 검증
- `deploy_landing` — 랜딩페이지 배포

## Key Conventions

- **커맨드 변경 후 반드시 `bun run sync:assistant-assets`** 실행
- 블록 파일 추가/수정 시 해당 Day의 `index.json`도 동기화
- NPC 대사는 `npcs.md` 카드와 일관되어야 함 (입버릇, 말투, 금지사항)
- 템플릿 변수 `{{variable}}` — `state.json` 데이터로 보간 (narrative-engine.md Section 2)
- 출력 톤: 2인칭 현재형 문어체 반말, 웹소설 포맷 (~20자/줄)
