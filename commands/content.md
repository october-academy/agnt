콘텐츠 전략. 채널에 뭘 올릴지, 어떤 유형의 콘텐츠를 어떤 리듬으로 올릴지 설계합니다.

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

내부 로직(경로 탐색, state 파싱, MCP 검색)은 무음 처리.

## 실행 절차

### 1. 사전 조건 확인

`{AGNT_DIR}/state.json` Read.

- `meta.schema_version < 2` → `/agnt:start`로 안내 후 종료
- `artifacts.channels_active < 1` → "먼저 `/agnt:channel`로 채널을 정하면 콘텐츠 전략이 선명해져." (비강제 — 진행 가능)

기본값 보증 (navigator-engine.md 필드 기본값 규칙):
- `artifacts.content_planned`가 undefined면 `false`로 처리
- `artifacts.competitors_analyzed`가 undefined면 `false`로 처리

### 2. 컨텍스트 수집

state에서 읽기:
- `project.problem` — 풀고 있는 문제
- `project.icp` — 타겟 고객
- `project.name` — 프로젝트명
- `tools.marketing_channels` — 활성화한 채널 목록

`{AGNT_DIR}/journey-brief.md` Read 시도. 있으면:
- Discovery 섹션에서 문제/ICP 참조
- Competition 섹션에서 차별점 참조
- Interview Insights에서 고객 표현 참조

### 3. 콘텐츠 전략 가이드

출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  콘텐츠 전략
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

채널은 정했어. 이제 거기에 뭘 올릴지 정하자.
좋은 콘텐츠 = ICP가 "이거 나한테 하는 말이네"라고 느끼는 것.

{tools.marketing_channels가 있으면}
활성 채널: {채널 목록}
{없으면}
채널이 아직 없어도 콘텐츠 유형은 먼저 정할 수 있어.
```

### 4. 콘텐츠 유형 소개

```
📝 콘텐츠 유형 4가지

1. BIP (Build In Public)
   "오늘 이걸 만들었다" — 빌드 과정을 공유해.
   → 개발자 커뮤니티에서 가장 자연스러운 방식.
   → 예: "Day 3. 결제 연동 삽질기. Stripe vs Paddle 비교."

2. 교육형
   "이 문제 겪어본 적 있어?" — ICP의 문제를 설명해.
   → 문제를 인식한 사람이 제품을 발견하는 흐름.
   → 예: "혼밥하는 직장인이 매일 겪는 3가지 불편."

3. 비교형
   "기존 대안은 이래서 불편해" — 경쟁 대비 차별점.
   → compete에서 정리한 차별화를 콘텐츠로 전환.
   → 예: "엑셀로 하던 걸 자동화했더니 이런 일이."

4. 사례형
   "인터뷰에서 이런 이야기를 들었어" — 실제 대화 공유.
   → 사회 증명 + 공감. 이름/직함은 익명 처리.
   → 예: "마케터 A씨는 매주 3시간을 이 작업에 쓴대."
```

### 5. 유형 선택

AskUserQuestion: "어떤 유형이 가장 잘 맞아?"
- A) BIP — 만드는 과정 공유
- B) 교육형 — 문제 설명
- C) 섞어서 — 번갈아 올리기

### 5-bis. 데모 영상 시나리오 (선택)

AskUserQuestion: "데모 영상 시나리오도 만들어볼래?"
- A) 만들자 — 타임코드별 장면 지시 + 나레이션 대본
- B) 나중에 — 콘텐츠 전략만 진행

A 선택 시:

AskUserQuestion: "영상 길이는?"
- A) 30초 — 소셜 미디어용 (Reels, Shorts)
- B) 60초 — 제품 소개용
- C) 90초 — 상세 데모용

선택한 길이에 맞는 시나리오를 생성한다:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  데모 영상 시나리오 ({길이}초)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

{30초 기준}
[0:00-0:05] 🎬 훅 — "{문제 한 줄}" (화면: 문제 상황)
[0:05-0:15] 💡 솔루션 — "{제품명}으로 해결" (화면: 제품 첫 화면)
[0:15-0:25] ✨ 핵심 기능 시연 (화면: 주요 기능 동작)
[0:25-0:30] 📍 CTA — "{URL} 에서 써봐" (화면: 로고 + URL)

{60초, 90초는 더 상세한 장면 구성}

🎙️ 나레이션 대본:
"{나레이션 전문}"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📹 촬영/편집 도구:
• Screen Studio — 자동 줌/모션 화면 녹화 (macOS, 유료)
• Recorded (recorded.app/ko) — 자동 줌/편집 화면 녹화 (macOS, 무료 티어)
• OBS Studio — 무료 화면 녹화
• CapCut — 무료 영상 편집 (자막 자동 생성)
• ElevenLabs — AI 나레이션 (무료 티어 있음)
```

`{AGNT_DIR}/demo-script.md` Write.

### 6. 첫 포스트 3개 초안

유저 선택 + state/journey-brief 데이터를 기반으로 첫 포스트 3개 초안을 생성:

```
📝 첫 포스트 3개 초안

포스트 1 (문제 공유):
"{project.problem} 때문에 고생한 적 있어?
나는 {project.icp}로서 이걸 매일 겪는데,
기존에는 {경쟁 대안 또는 '그냥 참는 것'}밖에 없었어."

포스트 2 (솔루션 티저):
"{project.name}을 만들고 있어.
{차별점 — compete에서 가져오기, 없으면 project.hypothesis 사용}
기존 {대안}과 다른 점은 ___."

포스트 3 (CTA):
"{project.name} 써볼 사람? [링크]
{핵심 한 줄 — project.hypothesis에서 추출}
피드백 주면 다음 버전에 바로 반영할게."
```

```
⚠️ 이건 초안이야. 네 말투로 고쳐서 올려.
완벽한 글이 아니라 "올리는 것"이 목표야.
```

### 7. 주간 리듬

```
📅 주간 콘텐츠 리듬 (선택 사항)

월: BIP / 진행상황 — "이번 주에 이걸 만들었다"
수: 교육형 / 인사이트 — "이 문제가 왜 중요한지"
금: CTA / 제품 소개 — "써봐. 링크는 여기."

⚠️ 매일 올리지 않아도 돼.
주 2-3개면 충분해. 핵심은 CTA가 있는 글이 주 1회 이상.
```

AskUserQuestion: "이 리듬으로 갈 거야?"
- A) 이 리듬으로 — 주 3회
- B) 더 적게 — 주 1-2회
- C) 내 방식으로 — 자유롭게

### 8. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  콘텐츠 전략 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

유형: {선택한 유형}
리듬: {선택한 리듬}
첫 포스트: 위 초안을 수정해서 올려.

올리기 시작하면 클릭이 쌓이고,
클릭이 쌓이면 오퍼를 설계할 수 있어.
다음 단계: 포스트를 올리고 → /agnt:offer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 9. journey-brief.md Write

`{AGNT_DIR}/journey-brief.md` Read 시도.

**파일이 없는 경우**: navigator-engine.md의 journey-brief 템플릿으로 신규 생성. Market 섹션의 콘텐츠 전략만 채움.

**파일이 있는 경우**: `## Market` 섹션 내 `- 콘텐츠 전략:` 라인을 Replace.

콘텐츠 전략 항목:
```
- 콘텐츠 전략: {유형} / {리듬} / 첫 포스트 3개 초안 작성됨
```

### 10. state 업데이트 + MCP 제출

state.json 업데이트:
- `artifacts.content_planned = true`
- `meta.last_action = "content"`
- `meta.total_actions++`

`ToolSearch`로 `+agentic30` 검색.

도구 발견 시:
- `submit_practice` 호출: quest_id = `"wf-content"`

도구 없으면 (`identity.mode != "synced"` 또는 ToolSearch 실패):
- `sync.pending_events`에 추가 (50건 초과 시 가장 오래된 이벤트 제거):
  ```json
  { "type": "submit_practice", "args": { "quest_id": "wf-content" }, "created_at": "<now()>" }
  ```
- state.json 저장

## 규칙

- agnt가 콘텐츠를 대신 작성하지 않는다 — 초안 제시 + ICP가 수정/작성
- journey-brief의 Discovery, Competition 데이터를 적극 활용
- "완벽한 글"이 아니라 "올리는 것"이 목표
- BIP는 개발자 ICP에게 가장 자연스러운 유형 — 추천하되 강제하지 않음
- CTA가 있는 글이 주 1회 이상이어야 트래픽이 전환으로 이어짐
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위 (learner artifact)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
