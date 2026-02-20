# agnt — Agentic30 학습 가이드

30일 안에 실제 유저 100명, 첫 매출 5,000원 달성을 돕는 MUD 스타일 CLI 학습 프로그램.

MUD 게임처럼 퀘스트를 수행하며 실제 프로덕트를 만드는 학습 경험입니다.

## Installation

### Claude Plugin Marketplace

```bash
# Claude Code 안에서:
/plugin marketplace add october-academy/agnt
/plugin install agnt@agnt
```

설치 후 setup 실행:
```bash
bash .claude/plugins/agnt/setup.sh
```

### Manual

```bash
git clone https://github.com/october-academy/agnt.git
cd agnt && bash setup.sh
```

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

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- Google 계정 (MCP 인증용)

## Project

- Website: https://agentic30.app
- Platform: https://github.com/october-academy

## License

MIT
