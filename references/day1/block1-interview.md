---
stop_mode: conversation
title: "AI 코파운더 검증 인터뷰"
npc: 소리
quests:
  - id: d1-interview
    type: main
    title: "AI 코파운더 인터뷰 완료"
    xp: 100
on_complete: save_interview
transition: "핵심 병목까지 점검했습니다. 이제 이 결론을 랜딩 개선 또는 다음 액션 패키지로 정리해봅시다."
---

# AI 코파운더 검증 인터뷰

## ROOM

오솔길을 벗어나 숲 깊은 곳에
다다른다.

고대 나무 뿌리가 의자처럼 솟아
있다.
나뭇잎 틈으로 점점한 빛이 떨어진다.

고요한 공기 위로 바람 소리만
지난다.
젖은 나무 냄새가 얇게 맴돈다.

## NPC

소리가 나무 뿌리 위에 앉아
노트를 넘기다가 이쪽을 본다.

🦉 현자 소리

"자리 잡아.

{{character.project|네 프로젝트}}에서
고른 핵심 문제,
진짜 버틸 수 있는 가설인지
검증할 거야.

정말 그런가?
직접 확인해보자."

## CONVERSATION

**반드시 `references/shared/interview-guide.md`를 Read하세요.**

Day 0에서 확정한
character 데이터와 목표
선언문을 참조합니다.

branchMode가
`asset_audit_interview`,
`bottleneck_diagnosis`,
`launch_planning_coach`이면
blank-slate discovery를 다시 하지 않습니다.

- audit: 기존 랜딩/카피/채널 병목 진단
- diagnosis: 제품 병목 1개 + 실험 1개 도출
- planning: revenue/live 상황의 다음 1주 계획 정리

### 완성 체크리스트

인터뷰는 다음이 **모두** 구체적
답변으로 채워질 때까지 계속합니다:

`discovery_interview`:
- [ ] Day 0에서 확정한 핵심 문제의
      반론 3가지 정리
- [ ] 지금 쓰는 대안/경쟁 도구
      2개 이상 파악
- [ ] 대안을 버리고 새 도구로
      바꾸기 어려운 이유
      (switching cost) 확인
- [ ] 첫 검증 대상 사용자군
      1개 + 접촉 채널 1개 확정
- [ ] 실제로 물어볼 인터뷰 질문
      3개 초안 작성
- [ ] 가설이 틀렸다고 판단할
      실패 조건 1개 정의

`asset_audit_interview`:
- [ ] 현재 랜딩의 핵심 약속과
      CTA 흐름 요약
- [ ] 카피 / 전환 / 채널 중
      가장 큰 병목 1개 확정
- [ ] 지금 수정해야 할
      우선순위 액션 1-3개 정리
- [ ] revise/redeploy 가치가 있는
      실험 1개 정의

`bottleneck_diagnosis` / `launch_planning_coach`:
- [ ] 현재 핵심 지표 1개 확정
- [ ] activation / retention /
      pricing / traffic / focus 중
      병목 1개 확정
- [ ] 다음 1개 실험 또는
      launch 액션 정의
- [ ] 관찰할 metric 1개와
      중단 조건 1개 정의

### 대화 시작

소리가 Day 0 캐릭터 데이터를
참조하여 말한다:

"Day 0에서
{{character.project|프로젝트}}를
고정했지.
{{character.goal|목표}}도
새겼고.

근데 진짜로
지금 방식보다 나아?
반대로 깨보자."

### 인터뷰 진행 원칙

- **턴 수 제한 없음** —
  체크리스트 완성이 목표
- 답변이 추상적이면
  대안/행동/비용으로 구체화
- 각 반론에 대해
  "정말 그런가?"로 2턴 이상
  반박 검증
- "잘 모르겠어요" 선택 시 다른
  각도에서 접근
- 반론 제기:
  "기존 도구로도 되지 않을까?"
  "굳이 바꿀 이유가 있나?"
- 소리 말투: 반문형, "정말
  그런가?", 답을 먼저 주지 않음

### 금지 사항

- Day 0처럼 문제 3개를
  처음부터 다시 탐색하는 진행
- "~하면 사용하시겠어요?" 류의
  미래 의향 질문
- 5턴 만에 "충분히
  이해했습니다"로 조기 종료
- 체크리스트를 읽듯이
  기계적으로 질문하기

## SUMMARY

소리가 노트를 펼치며 정리한다:

"정리해볼게.
정말 그런지 확인해봐."

```
📋 검증 인터뷰 요약
━━━━━━━━━━━━━━━
🧱 반론 3가지:
  1. {반론}
  2. {반론}
  3. {반론}

🔁 현재 대안/경쟁:
  - {대안 1}
  - {대안 2}
  - 전환비용: {왜 바꾸기 어려운지}

🎯 검증 계획:
  - 첫 대상: {누구}
  - 채널: {어디서 만날지}
  - 질문 3개: {Mom Test 기반}
  - 실패 조건: {틀렸다고 볼 기준}
```

`asset_audit_interview` 요약 형식:

```
📋 랜딩 진단 요약
━━━━━━━━━━━━━━━
🧱 현재 약속:
  - 핵심 카피: {요약}
  - CTA 흐름: {요약}

🎯 핵심 병목:
  - {conversion | copy | channel}
  - 근거: {신호 2-3개}

⚡ 다음 액션:
  - revise/redeploy 수정 1: {액션}
  - 수정 2: {액션}
  - 실험 1개: {검증할 것}
```

`bottleneck_diagnosis` / `launch_planning_coach` 요약 형식:

```
📋 병목 진단 요약
━━━━━━━━━━━━━━━
📈 현재 지표:
  - 핵심 metric: {metric}
  - 최근 신호: {요약}

🎯 핵심 병목:
  - {activation | retention | pricing | traffic | focus}

⚡ 다음 액션:
  - 실험/launch 액션: {1개}
  - 관찰할 지표: {metric}
  - 중단 조건: {stop rule}
```

소리: "이게 맞아?"

## STOP

소리가 노트를 덮으며 말한다.

"확인해봐.
정말 이게 맞는지."

AskUserQuestion:
질문: 소리가 묻는다. "인터뷰 요약이
맞아?"

1. "확인"
2. "수정 요청"

⛔ STOP — "현자 소리가 기다립니다."

## ON_COMPLETE

AskUserQuestion에서
"확인"을 선택했을 때만
ON_COMPLETE를 수행합니다.
"수정 요청"이면
CONVERSATION으로 돌아가
보완 후 SUMMARY → STOP을
반복합니다.

1. 학습자 확인 결과를 반영합니다.

2. state.json에
   interview 데이터를
   저장합니다.

3. 인증 상태면 MCP `save_interview`를 호출합니다:
   - topic: "AI 코파운더
     검증 인터뷰"
   - turns: 대화 턴 수
   - summary: 위 요약
     텍스트
   - branchMode가 있으면
     `mode`, `builderBrief`,
     `primaryBottleneck`,
     `activeExperiment`도 함께 전달합니다

4. 인증 상태면 MCP `submit_practice`를 호출합니다:
   - `submit_practice({ questId: "d1-interview", day: 1, evidence: { type: "text", content: "interview_saved" } })`

## MOVE

소리가 노트를 품에 넣고
숲 외곽 방향을 가리킨다.

"좋아.
핵심 문제를 찾았어.
전망대로 가자."

좁은 오솔길을 따라 오르막을 오른다.
나뭇가지 사이로 빛줄기가 넓어진다.
발밑 돌이 미끄럽게 굴러간다.
어디선가 새소리가 가까이 번진다.

저 위로 나무 난간이 보인다.
소리가 걸음을 멈추며 말한다.
"여기야. 세상을 내려다보자."
