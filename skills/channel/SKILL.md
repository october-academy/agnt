---
name: channel
description: >-
  채널 활성화 가이드 — 채널 선택, 첫 포스트, 벤치마크. 마케팅 채널 선택, 첫 포스트 계획 시 사용.
---

채널 활성화 가이드. 어디에, 어떻게 보여줄지 안내합니다.

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
- `!artifacts.landing_deployed` → "랜딩이 아직 없어. `/agnt:landing`으로 먼저 랜딩 전략을 세워." (비강제 — 진행 가능)

### 2. 채널 번호 결정

`artifacts.channels_active`로 N번째 채널 결정.
- N = `artifacts.channels_active + 1`
- N > 2여도 추가 채널 가능 (quest 보상은 2회까지)

### 3. 마케팅 채널 가이드 로드

`{REFS_DIR}/tools/marketing-channels.md`를 Read. 없으면 내장 가이드 사용.

### 4. 채널 추천

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  채널 {N}번째 활성화
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ICP: {project.icp}
{이미 활성화한 채널이 있으면: "현재 채널: {tools.marketing_channels}"}
```

AskUserQuestion: "누구에게 보여줄 거야?"
- A) 한국 개발자
- B) 한국 일반 사용자
- C) 글로벌 개발자
- D) 글로벌 일반

**타겟별 추천**:

A) 한국 개발자:
```
📍 추천 채널

1순위: Threads — 즉시 시작 가능, 한국 인디해커 커뮤니티 활발
2순위: GeekNews — Show GN으로 개발자 대상 고품질 트래픽
   ⚠️ 가입 후 7일 대기 필요. 지금 가입해둬.

{N==1이면}
처음이면 Threads부터 시작해. 진입 장벽이 가장 낮아.
```

B) 한국 일반:
```
📍 추천 채널

1순위: Threads — 알고리즘 기반 도달, 한국 유저 다수
2순위: 당근마켓 — 지역 기반 서비스에 적합
```

C) 글로벌 개발자:
```
📍 추천 채널

1순위: Product Hunt — 론칭 표준. 하루 트래픽 폭발 + SEO
   ⚠️ 가입 후 1주 대기. 지금 가입.
2순위: Hacker News — Show HN으로 기술적 제품 소개
```

D) 글로벌 일반:
```
📍 추천 채널

1순위: Product Hunt — 글로벌 론칭 표준
2순위: X (Twitter) — 영어 BIP에 적합
```

### 5. 채널 선택

AskUserQuestion: "어떤 채널로 시작할래?"
- 자유 입력 (추천 채널 중 선택 또는 다른 채널)

### 6. 첫 포스트 가이드

선택한 채널에 맞는 첫 포스트 템플릿:

**Threads**:
```
📝 Threads 첫 포스트 템플릿

---
나는 [문제]를 풀고 있어.
[ICP]를 위한 [솔루션]을 만들고 있는데,
[인터뷰에서 발견한 인사이트 1줄].

[스크린샷 또는 진행 상황]

관심 있으면 댓글 달아줘. 링크는 댓글에.
---

팁:
• 링크를 본문에 넣지 마 — 알고리즘이 억제해. 댓글에 넣어.
• 스크린샷을 넣으면 도달이 2-3배.
• 체류 시간이 핵심 — 짧은 글보다 긴 글이 유리.
```

**GeekNews**:
```
📝 GeekNews Show GN 템플릿

---
Show GN: {project.name} — {SPEC 한 줄 설명}

[제품 소개 2-3문단]
- 왜 만들었는지 (문제)
- 어떻게 다른지 (차별점)
- 기술 스택 (개발자 커뮤니티이므로)

[URL]
---

팁:
• 기술적 깊이가 있는 글이 업보트를 받아.
• 프로젝트당 1회 — 버전 업데이트마다 재게시 금지.
• ⚠️ 가입 후 7일 대기 필수.
```

**Product Hunt**:
```
📝 Product Hunt 론칭 체크리스트

□ 가입 후 1주 대기 완료
□ 제품 페이지 작성 (tagline, description, images)
□ 헌터(Hunter) 확보 시도 — 팔로워 많은 유저가 소개하면 도달 증가
□ 론칭일 결정 — PST 00:01 (한국 17:01)
□ 팀원/지인에게 업보트 요청 (규정상 허용)

효과: #1 제품 시 10,000-50,000 방문. 상위 5위 = 1,000-5,000.
```

**그 외 채널**: marketing-channels.md의 전략 섹션에서 해당 채널 정보를 요약하여 제공.

### 7. BIP 가이드 안내

```
💡 Build in Public (BIP) 전략

한 번 포스트하고 끝이 아니야.
빌드 과정을 계속 공유하는 게 1인 개발자 마케팅의 핵심이야.

자세한 가이드: /agnt:tools → "Build in Public" 선택
```

### 8. 벤치마크

```
📊 성과 기준

Threads: 팔로워 500명 기준 포스트당 1,000-5,000 노출. 클릭 1-3%.
GeekNews: 프론트페이지 시 1,000-5,000 방문.
Product Hunt: #1 시 10,000-50,000 방문. 상위 5위 1,000-5,000.

첫 주에 랜딩 100클릭이면 좋은 시작이야.
```

### 9. 첫 포스트 확인

AskUserQuestion: "첫 포스트를 올렸어?"
- A) 올렸어 — 다음으로
- B) 아직 — 올리고 올게

**A 선택 시**:

UTM 링크 분기:

=== `identity.mode == "synced"` ===
`ToolSearch`로 `+agentic30` 검색 → `create_utm_link` 호출:
- `target_url` 결정:
  1. `{AGNT_DIR}/journey-brief.md` Read → `## Market` 섹션에서 `- 랜딩 URL: ` 뒤의 URL 추출
  2. URL 없으면 AskUserQuestion: "랜딩 URL을 입력해줘 (예: https://example.com)"
- `utm_source`: 선택한 채널 slug (예: "threads", "geeknews", "producthunt")
- `utm_medium`: `"social"`
- `utm_campaign`: `"launch-loop-{artifacts.loops_completed + 1}"`

```
📎 추적 링크: https://a30.link/{code}
→ 이 링크로 올리면 어디서 클릭이 오는지 자동 추적돼.
```

=== `identity.mode != "synced"` ===
```
⚠️ 추적 링크 없이 올리면 채널별 성과를 측정할 수 없어.
`/agnt:connect`로 연결하면 UTM 링크를 자동 생성해줘.
→ 지금 안 해도 나중에 가능.
```

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  채널 {N} 활성화 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

채널: {선택한 채널}

Agentic30 Discord에서 같은 단계 학습자와 교류할 수 있어.

{N < 2이면}
다음 단계: /agnt:channel (채널 {N+1}/2)
{N >= 2이면}
2개 채널 활성화 완료!
다음 단계: /agnt:next
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**B 선택 시**:
```
괜찮아. 첫 포스트가 가장 어려운 법이야.
완벽할 필요 없어. 올리면 다시 `/agnt:channel`을 실행해.
```
종료.

### 9-bis. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성.
**파일이 있는 경우**: `## Market` 섹션 내 `- 채널:` 라인을 Replace.

```markdown
- 채널: {유저가 선택한 채널} ({N}번째)
```

### 10. state 업데이트 + MCP 제출

A 선택 시:

state.json 업데이트:
- `artifacts.channels_active++`
- `tools.marketing_channels` 배열에 선택한 채널 추가
- `meta.last_action = "channel"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시 (N ≤ 2일 때만):
- `submit_practice` 호출: quest_id = `"wf-channel-{N}"`
- N > 2이면 MCP 제출 건너뜀

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패), N ≤ 2일 때만:
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-channel-{N}" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- agnt가 포스트를 대신 올리지 않는다 — ICP가 직접 한다
- 채널별 첫 포스트 템플릿은 state의 project 데이터로 개인화
- 채널 추가 횟수 제한 없음 (2회 이상도 가능, quest 보상만 2회까지)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
