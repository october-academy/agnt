# agnt — Agentic30 학습 가이드

30일 안에 실제 유저 100명, 첫 매출 5,000원 달성을 돕는 MUD 스타일 CLI 학습 프로그램.

MUD 게임처럼 퀘스트를 수행하며 실제 프로덕트를 만드는 학습 경험입니다.

## Installation

```bash
claude plugin marketplace add october-academy/agnt
claude plugin install agnt@agentic30
```

설치 시 MCP 서버와 커맨드가 자동으로 등록됩니다.

## Commands

| 커맨드 | 설명 |
|--------|------|
| `/agnt:continue` | 학습 이어하기 (자동 재개) |
| `/agnt:today` | 오늘의 퀘스트 보드 |
| `/agnt:submit` | 퀘스트 검증 + 제출 |
| `/agnt:status` | 캐릭터 시트 + 월드맵 |

## How it works

- **Day 0~7** MUD 스타일 탐험: 장소 묘사 → NPC 대화 → 퀘스트 수행
- **레벨 시스템**: Lv.1 견습 프로그래머 ~ Lv.10 Agentic Programmer
- **MCP 서버 연동**: Google OAuth 인증 → 진행 상황 동기화, 리더보드
- **인터뷰 기반 개발(IDD)**: AI 코파운더와 대화하며 아이디어 검증
- **랜딩페이지 배포**: MCP를 통해 직접 랜딩페이지 생성 + 배포

## Interview Driven Development (IDD)

Agentic30의 핵심 방법론. TDD가 테스트로 시작하듯, IDD는 인터뷰로 시작합니다.

코드 작성 전에 "무엇을, 왜 만드는가?"를 명확히 하여 3개월 낭비를 1주일로 단축합니다.

![IDD Workflow](https://agentic30.app/blog/images/idd/idd-workflow.jpg)

### 6단계 워크플로우

| 단계 | 산출물 | 핵심 질문 |
|------|--------|---------|
| 인터뷰 | 요구사항 | "무엇을, 왜 만드는가?" |
| 스펙 | SPEC.md | "해결할 문제와 범위는?" |
| 계획 | plan.md | "어떻게, 어떤 순서로?" |
| 개발 | 코드 | "태스크별 구현" |
| 배포 | 릴리즈 | "사용자에게 전달" |
| 성과 검증 | KPI/피드백 | "의도대로 작동하는가?" |

각 단계에서 정보가 부족하면 이전 단계로 돌아가는 **피드백 루프**가 핵심입니다.

### 인터뷰 5가지 주제

1. **문제 정의 & 핵심 가치** — 무엇을, 왜 만드는가?
2. **타겟 사용자 & 페르소나** — 누가 쓰는가?
3. **핵심 기능 & 사용자 여정** — 어떤 경험을 제공하는가?
4. **기술 스택 & 제약사항** — 어떤 제약 안에서 만드는가?
5. **MVP 범위 & 우선순위** — 첫 버전에 뭐가 들어가는가?

자세한 내용: [IDD 방법론 소개](https://agentic30.app/blog/idd)

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- Google 계정 (MCP 인증용)

## Project

- Website: https://agentic30.app
- Platform: https://github.com/october-academy

## License

MIT
