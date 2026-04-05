---
user-invocable: false
name: launch-copy
description: >-
  런칭 카피 엔진 — 10채널 카피 + UTM 링크. 런칭 카피, 채널 카피 생성 시 사용.
---

런칭 카피 엔진. 제품 정보를 기반으로 다수 채널 맞춤 런칭 카피를 생성하고 UTM 링크를 연동합니다.

## 데이터 경로 결정

### AGNT_DIR

1. `.claude/agnt/state.json`을 Read 시도 → 성공하면 **AGNT_DIR = `.claude/agnt`**
2. 실패 시 `~/.claude/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.claude/agnt`**
3. 실패 시 `.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `.codex/agnt`**
4. 실패 시 `~/.codex/agnt/state.json` Read 시도 → 성공하면 **AGNT_DIR = `~/.codex/agnt`**
5. 모두 없으면 → "먼저 `/agnt:start`로 시작하세요." 출력 후 종료

### REFS_DIR

`{AGNT_DIR}/references/shared/navigator-engine.md` 존재 여부로 탐색.

## 출력 규칙

내부 로직 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료

기본값 보증:
- `artifacts.launch_copies_generated`가 undefined면 `false`로 처리

### 2. 컨텍스트 자동 수집

`{AGNT_DIR}/journey-brief.md` Read.

있으면:
- Discovery 섹션 → 문제, ICP
- Competition 섹션 → 차별점
- Offer 섹션 → 핵심 약속, 가격

state에서:
- `project.problem`, `project.icp`, `project.hypothesis`
- `tools.marketing_channels` — 이미 활성화한 채널

### 3. 랜딩 URL 입력

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  런칭 카피 엔진
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

10개 채널에 맞는 카피를 한 번에 만들어줄게.

{journey-brief 데이터가 있으면}
📋 수집된 정보:
  문제: {project.problem}
  ICP: {project.icp}
  약속: {offer 핵심 약속 — 있으면}
```

AskUserQuestion: "랜딩 URL은?"
- 자유 입력 (예: "https://myproduct.com")

### 4. 채널 선택

`{REFS_DIR}/tools/marketing-channels.md` Read.

AskUserQuestion: "어떤 채널에 카피를 만들까?"
- A) 전체 — 10개 채널 전부
- B) ICP 맞춤 핵심 채널 묶음
- C) 보조 채널 묶음
- D) 직접 선택 — 원하는 채널을 골라줘

D 선택 시:
AskUserQuestion: "어떤 채널?" (복수 입력 가능)
- marketing-channels.md와 현재 ICP에 맞는 채널 후보를 3-5개 동적으로 생성
- 마지막 선택지만 `기타 채널 — 직접 입력`

### 5. 채널별 카피 생성

선택된 각 채널에 대해, marketing-channels.md의 톤/포맷/글자 가이드에 맞는 카피를 생성한다.

**채널별 규칙:**

| 채널 | 톤 | 포맷 | 글자 가이드 |
|------|-----|------|------------|
| Threads | 반말, 문제 관찰 + 관계 형성 | 텍스트 중심 빌드로그 | 300-500자, 초반엔 홍보보다 ICP 선언 |
| GeekNews | 기술적, 정보형 | "Show GN: {제품} — {설명}" | 제목 + 200자 본문 |
| Product Hunt | 영어, 제품 소개 | 태그라인 + 3줄 설명 | 60자 태그라인 + 300자 |
| Reddit | 개인 경험, 솔직 | "I built X to solve Y" | 300-500자 |
| Hacker News | 기술 깊이, 객관 | "Show HN: {제품} — {설명}" | 제목만 (80자) |
| IndieHackers | 빌더 관점, 투명 | 숫자/지표 포함 | 300-500자 |
| X | 짧고 임팩트 | 1-3문장 + 링크 | 280자 |
| LinkedIn | 프로페셔널 | 문제→해결→CTA | 300-500자 |
| Instagram | 비주얼 우선 | 캡션 | 200-300자, 해시태그 5개 |
| 당근마켓 | 생활 밀착, 지역 | 상품 설명체 | 200-300자 |

**카피는 채널별로 차별화** — 같은 내용을 복붙하지 않는다. 각 채널의 톤과 유저 기대에 맞춘다.

### 6. UTM 링크 생성

`ToolSearch`로 `+agentic30` 검색.

**도구 발견 시 (synced):**
각 채널별 `create_utm_link` 호출:
- `target_url`: 입력한 랜딩 URL
- `utm_source`: 채널명 (소문자, 예: "threads", "geeknews")
- `utm_medium`: "community" 또는 "social"
- `utm_campaign`: "launch-1" (첫 런칭)

생성된 단축 URL을 해당 채널 카피에 삽입.

**도구 없으면:**
원본 랜딩 URL을 카피에 삽입.
```
💡 MCP 연결하면 채널별 UTM 추적 링크를 자동 생성할 수 있어.
→ /agnt:connect
```

### 7. 카피 저장

`{AGNT_DIR}/launch-copies.md` Write.

```markdown
# 런칭 카피 — {project.name}

생성일: {날짜}
랜딩 URL: {URL}

## {채널명}
{카피}
링크: {UTM 링크 또는 원본 URL}

... (채널별 반복)
```

### 8. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  런칭 카피 생성 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{N}개 채널 카피 생성됨:
{채널 목록}

📄 저장 위치: {AGNT_DIR}/launch-copies.md

{UTM 링크 생성됐으면}
🔗 UTM 링크 {N}개 생성됨 — 채널별 클릭 추적 가능

이제 카피를 각 채널에 올려.
올리고 나면 /agnt:analyze로 채널별 성과를 확인할 수 있어.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 9. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.launch_copies_generated = true`
- `artifacts.tracking_links += {UTM 생성 수}` (생성했을 때만)
- `meta.last_action = "launch-copy"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-launch-copy"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-launch-copy" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- 카피는 채널별 차별화 필수 — 복붙 금지
- journey-brief 데이터를 최대한 활용 — 인터뷰 인사이트, 차별점, 오퍼
- 글자 제한은 반드시 준수 (특히 X 280자, GeekNews 제목)
- UTM 파라미터 규칙: utm_source={channel}, utm_medium=community|social, utm_campaign=launch-{loop}
- state.json Write 먼저 (critical path), launch-copies.md Write 후순위
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
