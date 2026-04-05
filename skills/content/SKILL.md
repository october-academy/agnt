---
user-invocable: false
name: content
description: >-
  콘텐츠 전략 — 유형, 첫 포스트 초안, 주간 리듬. 콘텐츠 기획, 첫 포스트 작성 시 사용.
---

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

- `meta.schema_version != 3` → `/agnt:start`로 안내 후 종료
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
좋은 콘텐츠 = ICP가 "이거 나한테 하는 말이네"라고 느끼고,
"이 계정은 누구를 위한 계정인지"가 바로 보이는 것.

{tools.marketing_channels가 있으면}
활성 채널: {채널 목록}
{없으면}
채널이 아직 없어도 콘텐츠 유형은 먼저 정할 수 있어.
```

### 4. 콘텐츠 유형 소개

```
📝 콘텐츠 유형 4가지

1. BIP (Build In Public)
   "누구를 돕고 있고, 오늘 뭘 배웠다" — 빌드 과정을 공유해.
   → 개발자 커뮤니티에서 가장 자연스러운 방식.
   → 예: "퇴사 후 전업했는데 첫 매출이 없는 1인 개발자를 돕고 싶다. 오늘 인터뷰 3개에서 공통 문제를 봤다."

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

이 스킬은 여기서 멈춘다:
- 콘텐츠 전략
- 첫 포스트 초안
- 주간 리듬

데모 영상은 이 단계에서 갑자기 시나리오를 쓰지 않는다.
나중에 실제로 데모 영상이 필요해지면, Remotion + ElevenLabs 기반 전용 영상 생성 스킬에서 자동 생성하는 흐름이 더 낫다.

### 6. 첫 포스트 3개 초안

유저 선택 + state/journey-brief 데이터를 기반으로 첫 포스트 3개 초안을 생성:

```
📝 첫 포스트 3개 초안

포스트 1 (Audience 선언):
"나는 {project.icp}를 돕고 싶어.
왜냐하면 {project.problem}을 직접 보거나 겪었고,
이 문제를 진지하게 파는 사람이 되고 싶거든."

포스트 2 (문제 관찰 / 인터뷰 인사이트):
"{interview insight 또는 project.problem}
지금까지 들은 공통점은 ___.
기존에는 {경쟁 대안 또는 '그냥 참고 넘김'}으로 버티는 경우가 많더라."

포스트 3 (빌드 업데이트 / 질문):
"지금 {project.name}을 만들면서
{차별점 — compete에서 가져오기, 없으면 project.hypothesis 사용} 방향을 검증 중이야.
비슷한 상황인 사람 있으면 댓글이나 답장으로 자기 상황 알려줘."
```

```
⚠️ 이건 초안이야. 네 말투로 고쳐서 올려.
초기에는 링크/제품 홍보보다 "누구를 위한 계정인지"를 선명하게 만드는 게 목표야.
완벽한 글이 아니라 "계속 올리는 것"이 목표야.
```

{활성 채널에 블로그/뉴스레터가 있으면}
```
📰 블로그/뉴스레터용 확장 주제 3개

글 1: "왜 나는 {project.icp} 문제를 파고 있는가"
글 2: "인터뷰/관찰에서 발견한 공통 패턴 3가지"
글 3: "내가 틀렸던 가설과 지금 바꾼 방향"

원칙:
• SNS 짧은 글과 같은 메시지를 더 길게 푼다.
• 초기 장문 콘텐츠도 제품 소개보다 문제, 관찰, 학습을 먼저 둔다.
• CTA는 구매 유도보다 답장/피드백/대기자 등록 같은 가벼운 행동이 우선이다.
• 나중에 데모 영상을 만들더라도, 메시지는 동일하게 문제와 관찰을 먼저 둔다.
```

### 7. 주간 리듬

```
📅 SNS 운영 리듬 (권장)

핵심은 월/수/금 스케줄이 아니라 "매일 쓰고, 매일 대화하는 것"이야.
BIP는 잘 다듬은 글보다 가볍게라도 계속 올리는 편이 낫다.
뇌를 빼고 짧게 쓰더라도, ICP가 읽을 만한 관찰/문장/질문이면 충분해.

매일 기본 루프:
1. BIP 1개 이상 작성 — 오늘 본 문제, 배운 점, 막힌 점, 가설, 짧은 빌드 로그
2. ICP가 모여 있는 계정 팔로우/관찰
3. 댓글, 답장, 리포스트, 공유로 대화 참여
4. 유용한 정보/맥락 제공 — "내 제품 써봐"보다 "이 문제를 이렇게 보고 있다"가 먼저

⚠️ SNS의 본질적 가치는 발행만이 아니라 상호작용이야.
초기엔 포스트 수보다 "ICP와 실제로 얼마나 많이 부딪혔는지"가 더 중요하다.
모든 글과 상호작용은 ICP를 향해야 한다. 일반 대중에게 말 걸지 말고, 네가 돕고 싶은 사람에게만 말해.
초기 CTA는 제품 링크보다 댓글, 답장, 피드백 요청 같은 가벼운 행동 유도가 더 낫다.
노골적 제품 홍보는 ICP audience가 쌓인 뒤에 늘려.
```

AskUserQuestion: "어떤 운영 방식으로 갈 거야?"
- A) 기본 권장 — 매일 BIP 1개 + 매일 상호작용
- B) 강도 낮춤 — 주 5회 이상 + 매일 상호작용
- C) 내 방식으로 — 자유롭게

### 8. 완료 출력

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  콘텐츠 전략 완료
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

유형: {선택한 유형}
리듬: {선택한 리듬}
첫 포스트: 위 초안을 수정해서 올려.

반응 패턴이 쌓이면 어떤 audience가 붙는지 보이고,
그 다음에 오퍼를 더 정확하게 설계할 수 있어.
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
- BIP는 저마찰로 매일 발행하는 편이 낫다 — 잘 다듬은 소수 포스트보다 빈도가 중요
- SNS 운영의 본질은 발행 + 상호작용이다 — 팔로우, 댓글, 답장, 리포스트, 공유를 작업으로 본다
- 모든 글과 상호작용은 ICP를 향해야 한다
- 초기 CTA는 댓글/답장/피드백 요청 위주로 설계
- 제품 홍보 CTA는 ICP audience가 쌓인 뒤 강화
- state.json Write 먼저 (critical path), journey-brief.md Write 후순위 (learner artifact)
- MCP 호출 실패 시 로컬 state는 저장, 완료 마커 미기록
- 한국어, 반말 톤
