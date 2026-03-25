# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

NPM 패키지가 아닌 markdown-first 배포 패키지. 빌드/린트/테스트 없음.

- **Claude marketplace plugin**: `commands/*.md`가 `/agnt:*` colon-namespace 커맨드로 동작
- **Agent Skills spec**: `SKILL.md`를 통해 Codex/Claude Code 등에서 `npx skills add`로 설치 가능
- **멀티 에이전트 지원**: Claude Code (`/agnt:*`), Codex (`$agnt-*`), Agent Skills 공통 포맷

## Commands

```bash
# 커맨드/레퍼런스 변경 후 플러그인 재동기화 (root에서)
bun run sync:assistant-assets

# Agent Skills discovery 확인 (SKILL.md 변경 후)
npx skills add packages/agnt --list
```

## Architecture

```
commands/              # /agnt:* 커맨드 (Claude Code가 실행하는 프롬프트)
  ├── start.md         # /agnt:start — 온보딩 + 상태 초기화 + ICP 공감 + v1→v2 마이그레이션
  ├── next.md          # /agnt:next — Navigator 메인 루프 (상태 기반 추천)
  ├── discover.md      # /agnt:discover — 문제 선택 + ICP 정의
  ├── interview.md     # /agnt:interview — 고객 인터뷰 (Mom Test)
  ├── compete.md       # /agnt:compete — 경쟁 분석 (대안 분석, 차별화 매트릭스)
  ├── spec.md          # /agnt:spec — SPEC 작성/이터레이션
  ├── build.md         # /agnt:build — MVP 스코프 가드 (과대 구축 방지)
  ├── landing.md       # /agnt:landing — 랜딩 전략 가이드 (포지셔닝, 카피, CTA, 벤치마크)
  ├── channel.md       # /agnt:channel — 채널 활성화 가이드 (선택, 첫 포스트, 벤치마크)
  ├── content.md       # /agnt:content — 콘텐츠 전략 (유형, 첫 포스트 초안, 주간 리듬)
  ├── offer.md         # /agnt:offer — 오퍼 구성 가이드 (가격, 약속, 반론, 증거 공백)
  ├── launch.md        # /agnt:launch — 7일 론칭 계획 (채널, 일정, 수치 임계값)
  ├── analyze.md       # /agnt:analyze — 성과 판정 (벤치마크 대비 continue/pivot/kill)
  ├── retro.md         # /agnt:retro — 회고 + 다음 루프 설계
  ├── tools.md         # /agnt:tools — 도구 비교 가이드
  └── status.md        # /agnt:status — 현재 상태 대시보드

references/            # 워크플로우 참조 콘텐츠
  ├── tools/           # 도구 비교 가이드
  │   ├── payment-comparison.md    # 결제 솔루션 비교
  │   ├── marketing-channels.md    # 마케팅 채널 비교
  │   ├── analytics-tools.md       # 분석 도구 비교
  │   ├── ad-platforms.md          # 광고 플랫폼 비교
  │   └── no-biz-payment.md        # 사업자 없이 결제
  ├── benchmarks/      # 성과 기준
  │   ├── cpc-benchmarks.md        # CPC 벤치마크
  │   ├── conversion-benchmarks.md # 전환율 벤치마크
  │   └── timeline-benchmarks.md   # PMF 타임라인 사례
  └── shared/          # 공통 레퍼런스
      ├── navigator-engine.md      # Navigator 로직 SSoT (추천, 카운트다운, State Mutation Contract)
      ├── interview-guide.md       # 인터뷰 원칙 (Mom Test, Follow the Thread)
      └── profile-constants.json   # 온보딩 상수

SKILL.md               # Agent Skills spec 엔트리포인트 (name: agnt, v2.0.0)
AGENTS.md              # Repository guidelines
README.md              # 설치/사용법

.claude-plugin/
  ├── plugin.json       # 플러그인 메타 (v2.0.0) + MCP 서버 URL
  └── marketplace.json  # 마켓플레이스 등록 정보
```

## How Commands Work

커맨드 파일은 Claude Code가 직접 실행하는 **프롬프트**. 코드가 아닌 절차적 지시문:

1. `state.json` 읽기 → 현재 상태 확인 (`identity`/`sync` 누락 시 기본값 적용)
2. `ToolSearch`로 MCP `agentic30` 도구 존재 확인
3. `references/`에서 해당 워크플로우 참조 파일 Read
4. `navigator-engine.md` 규칙에 따라 추천/실행
5. 워크플로우 완료 시 `state.json` 갱신 + MCP `submit_practice` 호출

**pending_events 큐잉 패턴** (MCP 미연결 시):

`identity.mode != "synced"` 또는 ToolSearch 실패 시 MCP 직접 호출 대신:
```json
{ "type": "submit_practice", "args": { "quest_id": "wf-*" }, "created_at": "<now()>" }
```
를 `sync.pending_events`에 추가. `/agnt:connect` 완료 시 일괄 플러시(retroactive XP burst).

**Navigator 패턴**: `/agnt:next`가 상태를 읽고 다음 최선 행동을 추천. 고정 순서 없이 상태 기반으로 동작.

**journey-brief 시스템**: `/agnt:next`는 `{AGNT_DIR}/journey-brief.md`를 참조하여 컨텍스트 기반 부가 메시지("왜 + 어떻게")를 생성. 이전 인터뷰 인사이트, 경쟁 분석 결과, 채널 정보 등을 활용하여 추천에 근거를 부여.

**Codex 호환**: 커맨드 내 `ToolSearch`, `AskUserQuestion`, `/mcp` 등 Claude Code 문구는 Codex에서 호환 처리됨 (상세: `SKILL.md` "Agent Compatibility Rules")

## State Management

### 경로 결정 로직 (모든 커맨드 공통)

#### AGNT_DIR (state + data 루트)

아래 순서로 탐색. 첫 번째 성공한 경로 사용:

1. `.claude/agnt/state.json` → project scope (모노레포 개발자)
2. `~/.claude/agnt/state.json` → user scope (Claude Code 외부 유저)
3. `.codex/agnt/state.json` → project scope (Codex)
4. `~/.codex/agnt/state.json` → user scope (Codex)
5. 모두 없으면 → Claude Code: `~/.claude/agnt`, Codex: `~/.codex/agnt` (기본값)

#### REFS_DIR (references 루트)

`navigator-engine.md` 존재 여부로 탐색:

1. `{AGNT_DIR}/references/`
2. `~/.claude/plugins/marketplaces/agentic30/references/`
3. `.agents/skills/agnt/references/`
4. `~/.codex/skills/agnt/references/`
5. 모두 없으면 에러

### state.json 스키마 (v3)

```json
{
  "identity": {
    "mode": "guest",
    "mcp": { "connected": false, "last_checked_at": null }
  },
  "sync": {
    "pending_events": [],
    "last_synced_at": null,
    "last_inline_nudge_at": null,
    "last_cta_nudge_at": null
  },
  "project": {
    "name": null,
    "problem": null,
    "icp": null,
    "hypothesis": null
  },
  "artifacts": {
    "interviews": 0,
    "spec_versions": 0,
    "competitors_analyzed": false,
    "landing_deployed": false,
    "content_planned": false,
    "offer_drafted": false,
    "channels_active": 0,
    "tracking_links": 0,
    "launch_planned": false,
    "last_analyze_loop": 0,
    "loops_completed": 0
  },
  "signals": {
    "interview_insights": 0,
    "landing_visits": 0,
    "form_responses": 0,
    "link_clicks": 0,
    "payment_intents": 0,
    "revenue": 0
  },
  "tools": {
    "payment": null,
    "analytics": null,
    "marketing_channels": []
  },
  "meta": {
    "authenticated": false,
    "started_at": null,
    "last_action": null,
    "total_actions": 0,
    "schema_version": 3
  }
}
```

**identity.mode 3-value enum:**
- `"guest"`: 미가입, 미연결 (초기 상태)
- `"registered"`: 웹 가입 완료, MCP 미연결
- `"synced"`: 웹 가입 + MCP 인증 완료

**pending_events 형식** (`submit_practice`만 큐잉):
```json
{ "type": "submit_practice", "args": { "quest_id": "wf-discover" }, "created_at": "2026-03-25T00:00:00.000Z" }
```
최대 50건. 초과 시 FIFO 제거.

- v1(RPG) state 감지 시 `/agnt:start`에서 자동 마이그레이션
- v2 state → `/agnt:start` 실행 시 v3으로 자동 마이그레이션 (`identity`/`sync` 섹션 추가)
- `navigator-engine.md`의 State Mutation Contract 준수
- MCP 호출 실패 시 로컬 state 저장, 완료 마커 미기록 (fail-closed)

## MCP Integration

플러그인이 `plugin.json`에서 HTTP MCP 서버를 선언:

```json
{
  "mcpServers": {
    "agentic30": { "type": "http", "url": "https://mcp.agentic30.app/mcp" }
  }
}
```

커맨드들은 `ToolSearch`로 `+agentic30` 검색하여 MCP 도구 로딩 후 사용:

- `submit_practice` — 워크플로우 완료 제출 (quest_id: `wf-*`)
- `save_interview` — 인터뷰 데이터 저장
- `save_spec_iteration` — SPEC 버전 저장
- `complete_onboarding` — 온보딩 완료
- `get_leaderboard` — 리더보드 조회
- `get_landing_analytics` — 랜딩 방문/폼 분석
- `get_links` — 링크 클릭 조회
- `get_link_analytics` — 개별 링크 클릭 분석
- `create_utm_link` — UTM 단축 링크 생성 (`/agnt:channel` synced 모드에서 자동 호출)
- `deploy_landing` — 랜딩페이지 배포

**`/agnt:connect` 플로우** (3단계):

1. **Step A — 웹 가입**: `https://agentic30.app/signup` 안내 → 가입 확인 시 `identity.mode = "registered"`
2. **Step B — MCP 인증**: Claude Code `/mcp` 또는 Codex `codex mcp add/login agentic30`
3. **Step C — 연결 확인**: ToolSearch +agentic30 → `get_user_info` 호출 성공 시 `identity.mode = "synced"` + pending_events 플러시

플러시 동작: `sync.pending_events` 순회 → 각 `submit_practice` 호출 → 성공 시 이벤트 제거, 실패 시 이벤트 유지 → XP burst + 레벨업 감지.

## Key Conventions

- **커맨드 변경 후 반드시 `bun run sync:assistant-assets`** 실행
- 퀘스트 ID 네이밍: `wf-{workflow}-{n}` (예: `wf-interview-1`)
- 출력 톤: 2인칭 반말, 짧고 직접적. 프레임워크 용어보다 행동 지시
- 한국어 진행, 기술 용어(MCP, OAuth, CLI, SPEC)는 원문 유지
- 카운트다운: `meta.started_at` 기준 Day D/30 표시 (30일 초과 시 잠금 없음)
