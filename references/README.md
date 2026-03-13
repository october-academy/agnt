# AGNT Week 1 Reference Taxonomy

Week 1 authored references are divided into three classes.

## 1. Core learner assets

기본 `/agnt:*` 학습 흐름에서 직접 읽는 자산입니다.

- `day*/index.json`
- `day*/block*-*.md`
- `shared/narrative-engine.md`
- `shared/world-data.md`
- `shared/npcs.md`
- `shared/interview-guide.md`
- `shared/week1-reading-list.md`

규칙:

- `shared/narrative-engine.md`, `shared/world-data.md`는 command discovery anchor로 유지합니다.
- `/agnt:continue`는 기본적으로 core learner asset만 로드합니다.

## 2. Runtime-only assets

MCP generation/deploy/runtime helper가 읽는 자산입니다. 기본 learner path에 포함하지 않습니다.

- `runtime/landing-design-guide.md`
- `runtime/promotion-channels-guide.md`
- `runtime/threads-writing-guide.md`

기존 `shared/*.md` 경로에는 짧은 forwarding 문서만 남겨 legacy 참조를 안내합니다.

## 3. Extended assets

위기점, archetype, 취약성 모멘트, Pro additive path처럼 조건부로만 합산되는 자산입니다.

- `extended/narrative-engine-extended.md`
- `extended/npcs-extended.md`
- `references-pro/shared/npcs-extended.md`
- `references-pro/shared/world-data-extended.md`

규칙:

- core Week 1 path는 extended asset 없이 동작해야 합니다.
- active block이나 progression context가 extended behavior를 요구할 때만 additive로 읽습니다.
