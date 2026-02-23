# agnt — Agentic30 Learning Guide

30일 안에 실제 유저 100명, 첫 매출 5,000원 달성을 돕는 MUD 스타일 CLI 학습 프로그램입니다.

이 저장소는 아래 3가지 방식으로 동작합니다.

## Install Modes

| 모드 | 용도 | 설치 방법 |
| --- | --- | --- |
| Claude Plugin | `/agnt:*` 슬래시 커맨드 | `claude plugin ...` |
| Codex + Skill | Codex에서 `$agnt-*` 명령(권장) + 자연어 fallback | `npx skills add ... --agent codex` + `codex mcp ...` |
| Agent Skills Spec | 에이전트 공통 포맷 설치 | `npx skills add <owner/repo>` |

## 1) Claude Plugin

### Install

```bash
claude plugin marketplace add october-academy/agnt
claude plugin install agnt@agentic30
```

### MCP OAuth

```bash
claude
```

Claude Code에서 `/MCP` 입력 후:

1. `plugin:agnt:agentic30` 선택
2. `Authenticate` 선택
3. 브라우저에서 Google 로그인
4. 인증 완료 후 `/agnt:continue` 실행

### Commands

| 커맨드 | 설명 |
| --- | --- |
| `/agnt:init` | 진행 상태 초기화 (Day 0부터 다시 시작) |
| `/agnt:continue` | 학습 이어하기 (자동 재개) |
| `/agnt:today` | 오늘의 퀘스트 보드 |
| `/agnt:submit` | 퀘스트 검증 + 제출 |
| `/agnt:status` | 캐릭터 시트 + 월드맵 |

### Update

```bash
claude plugin marketplace update agentic30
claude plugin update agnt@agentic30
```

### Uninstall

```bash
claude mcp remove plugin:agnt:agentic30
claude plugin uninstall agnt@agentic30
claude plugin marketplace remove agentic30
rm -rf ~/.claude/agnt
rm -rf .claude/agnt
rm -rf ~/.claude/plugins/marketplaces/agentic30
rm -rf ~/.claude/plugins/cache/agentic30
```

## 2) Codex + Skill + MCP

Codex에서는 플러그인 대신 Agent Skill + MCP 연결 조합을 사용합니다.

### Install Skill

```bash
npx skills add october-academy/agnt --agent codex --skill agnt -g -y
```

### Connect MCP

```bash
codex mcp add agentic30 --url https://mcp.agentic30.app/mcp
codex mcp login agentic30
codex mcp list
```

`codex mcp list`에서 `agentic30`가 `enabled`이고 `Auth`가 `OAuth`면 준비 완료입니다.

### Start

Codex에서 아래 3가지 방식으로 시작할 수 있습니다.

1. 권장: `$agnt-<subcommand>` 명시형
2. 호환: `$agnt <subcommand>` 공백형
3. fallback: 자연어 요청

### Recommended Command Style (`$agnt-*`)

Codex는 Claude의 slash command가 없으므로, OpenSpec 스타일처럼 `'$agnt-<subcommand>'`를 canonical로 권장합니다.
명시형 호출은 의도 파싱 오류를 줄이고 자동화 스크립트에도 유리합니다.

| Claude Code | Codex canonical | Codex 호환 호출 |
| --- | --- | --- |
| `/agnt:continue` | `$agnt-continue` | `$agnt continue`, `$agnt start`, `$agnt resume` |
| `/agnt:init` | `$agnt-init` | `$agnt init`, `$agnt reset`, `$agnt restart` |
| `/agnt:today` | `$agnt-today` | `$agnt today`, `$agnt quest`, `$agnt board` |
| `/agnt:submit` | `$agnt-submit` | `$agnt submit`, `$agnt check`, `$agnt verify` |
| `/agnt:status` | `$agnt-status` | `$agnt status`, `$agnt progress`, `$agnt profile` |

권장 라우팅 우선순위:

1. `'$agnt-<subcommand>'` canonical 입력
2. `'$agnt <subcommand>'` 호환 입력
3. `'$agnt ...'` 뒤 자연어 의도
4. `'$agnt'` 단독 입력 시 기본값 `continue`

예시:

- `$agnt-continue`
- `$agnt-today`
- `$agnt-submit`
- `$agnt continue` (호환)
- `Agentic30 학습 이어하기` (fallback)

## Troubleshooting (First Run)

### Claude Plugin

- `/agnt:continue`에서 MCP 미연결이 나오면:
  1. `/mcp` 실행
  2. `plugin:agnt:agentic30` 선택
  3. `Authenticate` 재실행
- `references를 찾을 수 없습니다` 오류가 나오면:
  - 모노레포 개발자: `bun run sync:assistant-assets`
  - 외부 사용자: plugin 재설치 후 다시 시도

### Codex

- `codex mcp login agentic30`가 실패하면:
  1. `codex mcp add agentic30 --url https://mcp.agentic30.app/mcp`
  2. `codex mcp login agentic30`
  3. `codex mcp list` 재확인
- 스킬이 보이지 않으면:
  1. `npx skills add october-academy/agnt --list`
  2. `agnt`가 보이면 `--skill agnt`로 재설치

### Agent Skills 공통

- 설치 후 어떤 에이전트에 깔렸는지 확인:

```bash
npx skills list
```

## 3) Agent Skills Spec (Universal)

`agnt`는 [Agent Skills specification](https://agentskills.io/specification) 형태의 `SKILL.md`를 포함합니다.

다른 에이전트에서는 아래처럼 설치할 수 있습니다.

```bash
# 레포의 스킬 목록 확인
npx skills add october-academy/agnt --list

# 특정 에이전트 대상으로 설치 (예: Claude Code + Codex)
npx skills add october-academy/agnt --skill agnt --agent claude-code --agent codex
```

## How It Works

- **Day 0~7** MUD 스타일 탐험: 장소 묘사 → NPC 대화 → 퀘스트 수행
- **레벨 시스템**: Lv.1 견습 프로그래머 ~ Lv.10 Agentic Programmer
- **MCP 연동**: Google OAuth 인증 → 진행 상황 동기화, 리더보드
- **IDD**: 인터뷰 기반 개발(Interview Driven Development)
- **랜딩 배포**: MCP를 통한 랜딩 생성 + 배포

## Requirements

- Google 계정 (MCP OAuth)
- Claude Plugin 모드: [Claude Code](https://claude.ai/code)
- Codex 모드: Codex CLI + `npx skills`

## Project

- Website: https://agentic30.app
- Platform: https://github.com/october-academy

## License

MIT
