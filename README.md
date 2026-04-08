# agnt — Agentic30 Learning Guide

[![agnt demo](https://assets.october-academy.com/agnt-demo-thumbnail.jpg)](https://assets.october-academy.com/agnt-demo.mp4)

## 이게 뭔가요?

**agnt**는 Claude Code나 Codex 같은 AI 코딩 도구 안에서 바로 실행되는 **솔로프리너(1인 개발자) 커리큘럼**입니다.
터미널을 벗어나지 않고, AI와 대화하면서 30일 동안 실제 프로덕트를 만들어 나갑니다.
목표는 단순합니다: **30일 안에 실제 유저 100명, 첫 매출 5,000원.**

별도 웹사이트에서 영상을 보는 게 아니라, 매일 주어지는 퀘스트를 코딩 환경에서 직접 수행합니다.
AI 코파운더가 인터뷰를 하고, 랜딩페이지를 만들어주고, 진행 상황을 추적합니다.

## 어떻게 진행되나요?

매일 하나의 주제에 집중합니다. 각 Day는 2-4개의 단계(블록)로 나뉘고,
단계마다 AI가 개념을 설명하고, 질문하고, 직접 해볼 과제를 줍니다.

과제를 완료하면 XP를 얻고, 레벨이 올라갑니다.
진행 상태는 서버에 동기화되어 어디서든 이어할 수 있습니다.

## 커리큘럼 (Week 1 — 무료)

| Day | 주제 | 하는 일 |
|-----|------|---------|
| **Day 0** | 시작하기 | 회원가입, 캐릭터(관심 분야) 설정, 목표 선언, Discord 합류 |
| **Day 1** | 현재 상태 진단 | Revenue Readiness Audit으로 문제/ICP/가설을 진단하고 이번 주에 검증할 CTA 1개를 정함 |
| **Day 2** | ICP 구체화 + 고객 검증 | deep-interview로 `docs/ICP.md` 작성, Mom Test 방식으로 실제 피드백 수집 준비 |
| **Day 3** | BIP 시작 | Threads/X/블로그 등에서 누구를 돕는지 선명하게 선언하고, 첫 글·관계 형성 리듬·글감 구조를 정함 |
| **Day 4** | 제품 설계 + 랜딩 메시지 | 수집한 피드백 기반으로 SPEC v1을 쓰고 랜딩의 핵심 메시지를 정리 |
| **Day 5** | 오퍼와 가격 가설 | 핵심 약속, 가격 가설, 무료/유료 경계를 정해 첫 오퍼 초안을 만듦 |
| **Day 6** | Product Analytics | PostHog와 핵심 이벤트를 세팅하고 데모 영상/분석 준비를 마침 |
| **Day 7** | 론칭 계획 + 회고 | 7일 론칭 계획과 채널별 카피를 만들고 Week 1 회고와 Week 2 계획을 정리 |

Day 8부터는 유료 구독으로 Day 30까지 이어집니다.

## Requirements

- Google 계정 (OAuth 로그인용)
- Node.js 18+ 설치 (`npx` 포함)
- 아래 중 하나:
  - **Claude Code** — Claude Pro 또는 Max 플랜 구독 필요
  - **Codex CLI** — ChatGPT Plus, Pro, 또는 Team 플랜 구독 필요

## Getting Started

### Claude Code

```bash
# 1. 설치
claude plugin marketplace add october-academy/agnt
claude plugin install agnt@agentic30

# 2. Claude Code 실행
claude
```

Claude Code 안에서:

```text
# 3. MCP 인증 (필수 — 최초 1회)
/mcp
→ plugin:agnt:agentic30 선택 → Authenticate → 브라우저에서 Google 로그인

# 4. 시작
/agnt:continue
```

### Codex

```bash
# 1. 설치
npx skills add october-academy/agnt --agent codex --skill agnt -g -y

# 2. MCP 인증 (필수 — 최초 1회)
codex mcp add agentic30 --url https://mcp.agentic30.app/mcp
codex mcp login agentic30
codex mcp list   # agentic30가 enabled + Auth: OAuth이면 정상

# 3. 시작
codex
$agnt-continue
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

## Command Map

| 목적            | Claude              | Codex (권장)        |
| --------------- | ------------------- | ------------------- |
| 시작/온보딩     | `/agnt:start`       | `$agnt-start`       |
| 다음 행동       | `/agnt:next`        | `$agnt-next`        |
| 문제 발견       | `/agnt:discover`    | `$agnt-discover`    |
| ICP 정의        | `/agnt:icp`         | `$agnt-icp`         |
| 디자인 시스템   | `/agnt:design-system` | `$agnt-design-system` |
| 고객 인터뷰     | `/agnt:interview`   | `$agnt-interview`   |
| 경쟁 분석       | `/agnt:compete`     | `$agnt-compete`     |
| SPEC 작성       | `/agnt:spec`        | `$agnt-spec`        |
| MVP 빌드        | `/agnt:build`       | `$agnt-build`       |
| 랜딩 전략       | `/agnt:landing`     | `$agnt-landing`     |
| 채널 활성화     | `/agnt:channel`     | `$agnt-channel`     |
| 콘텐츠 전략     | `/agnt:content`     | `$agnt-content`     |
| 오퍼 설계       | `/agnt:offer`       | `$agnt-offer`       |
| 론칭 계획       | `/agnt:launch`      | `$agnt-launch`      |
| 성과 분석       | `/agnt:analyze`     | `$agnt-analyze`     |
| 회고            | `/agnt:retro`       | `$agnt-retro`       |
| 도구 비교       | `/agnt:tools`       | `$agnt-tools`       |
| 상태            | `/agnt:status`      | `$agnt-status`      |
| Agentic30 연결  | `/agnt:connect`     | `$agnt-connect`     |
| Meta 광고 세팅  | `/agnt:meta-ads-setup` | `$agnt-meta-ads-setup` |
| 구독 전략       | `/agnt:subscription` | `$agnt-subscription` |

Codex 호환 입력: `$agnt continue`, `$agnt today` 등.

## Uninstall

### Claude Code

```bash
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
