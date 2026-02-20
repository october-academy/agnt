---
name: agnt
description: "Agentic30 — 30일 독립 개발자 여정. MUD 게임처럼 퀘스트를 수행하며 실제 프로덕트를 만드는 CLI 학습 경험."
---

# agnt — Agentic30 학습 가이드

30일 안에 실제 유저 100명, 첫 매출 5,000원 달성을 돕는 MUD 스타일 CLI 학습 프로그램.

## Setup

이 스킬을 사용하기 전에 **setup.sh**를 실행하여 레퍼런스 파일을 설치해야 합니다:

```bash
# 프로젝트 루트에서 실행
bash <(curl -s https://raw.githubusercontent.com/october-academy/agnt/main/setup.sh)
```

또는 Claude Plugin Marketplace로 설치:
```
/plugin marketplace add october-academy/agnt
/plugin install agnt@agnt
```

## Commands

| 커맨드 | 설명 |
|--------|------|
| `/agnt:continue` | 학습 이어하기 (자동 재개) |
| `/agnt:today` | 오늘의 퀘스트 보드 |
| `/agnt:submit` | 퀘스트 검증 + 제출 |
| `/agnt:status` | 캐릭터 시트 + 월드맵 |

## How it works

- Day 0~7 MUD 스타일 탐험: 장소 묘사 → NPC 대화 → 퀘스트 수행
- 레벨/칭호 시스템 (Lv.1 견습 프로그래머 ~ Lv.10 Agentic Programmer)
- MCP 서버 연동: 진행 상황 서버 동기화, 리더보드, 랜딩페이지 배포
- 인터뷰 기반 개발(IDD): AI 코파운더와 대화하며 아이디어 검증
