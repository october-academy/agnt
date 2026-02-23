# agnt — Agentic30 Learning Guide

<video src="https://github.com/october-academy/agnt/releases/download/demo-v1/agnt-demo.mp4" controls width="600"></video>

30일 MUD 스타일 학습 프로그램입니다.
핵심은 **MCP 연결 후 명령 실행**입니다.

## Requirements

- Google 계정 (OAuth)
- Claude Code 또는 Codex CLI
- `npx` 사용 가능 환경

## Getting Started

### Claude Plugin Install

```bash
claude plugin marketplace add october-academy/agnt
claude plugin install agnt@agentic30
```

### Codex (npx skills) Install

```bash
npx skills add october-academy/agnt --agent codex --skill agnt -g -y
```

## Update

### Claude (Marketplace + Plugin)

```bash
claude plugin marketplace update agentic30
claude plugin update agnt@agentic30
```

### Codex (npx skills)

```bash
# 업데이트 확인
npx skills check

# 설치된 스킬 업데이트
npx skills update

# (선택) agnt만 최신으로 재설치
npx skills add october-academy/agnt --agent codex --skill agnt -g -y
```

## Quick Start

### Claude Code (`/agnt:*`)

```bash
claude
```

Claude Code에서 `/mcp` 실행 후 `plugin:agnt:agentic30`를 `Authenticate`하고 시작:

```text
/agnt:continue
```

### Codex (`$agnt-*`)

```bash
codex mcp add agentic30 --url https://mcp.agentic30.app/mcp
codex mcp login agentic30
codex mcp list
```

시작:

```text
$agnt-continue
```

`codex mcp list`에서 `agentic30`가 `enabled` + `Auth: OAuth`이면 정상입니다.

## Command Map

| 목적 | Claude | Codex (권장) |
| --- | --- | --- |
| 이어하기 | `/agnt:continue` | `$agnt-continue` |
| 초기화 | `/agnt:init` | `$agnt-init` |
| 오늘 퀘스트 | `/agnt:today` | `$agnt-today` |
| 제출 | `/agnt:submit` | `$agnt-submit` |
| 상태 | `/agnt:status` | `$agnt-status` |

Codex 호환 입력: `$agnt continue`, `$agnt today` 등.

## Uninstall

### Claude Code

```bash
claude mcp remove plugin:agnt:agentic30
claude plugin uninstall agnt@agentic30
claude plugin marketplace remove agentic30
rm -rf ~/.claude/agnt .claude/agnt
rm -rf ~/.claude/plugins/marketplaces/agentic30
rm -rf ~/.claude/plugins/cache/agentic30
```

### Codex

```bash
# global 설치 제거
npx skills remove -g --agent codex --skill agnt -y
# project 설치 시 추가 실행
npx skills remove --agent codex --skill agnt -y

codex mcp logout agentic30
codex mcp remove agentic30

# 선택: 로컬 데이터 정리
rm -rf ~/.codex/agnt .codex/agnt ~/.codex/skills/agnt ~/.agents/skills/agnt
```

## Troubleshooting

- MCP 미연결:
  - Claude: `/mcp`에서 `plugin:agnt:agentic30` 재인증
  - Codex: `codex mcp add/login/list` 재실행
- `references를 찾을 수 없습니다`:
  - 모노레포: `bun run sync:assistant-assets`
  - 외부 사용자: skill/plugin 재설치
- 설치 확인:

```bash
npx skills list
```

## Links

- Website: https://agentic30.app
- Repo: https://github.com/october-academy
- License: MIT
