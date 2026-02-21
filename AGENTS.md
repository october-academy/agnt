# Repository Guidelines

## Project Structure & Module Organization
`packages/agnt` is a content-first Claude plugin package for Agentic30.
- `commands/*.md`: slash-command behavior prompts (`init`, `continue`, `today`, `submit`, `status`).
- `references/day*/`: day-based curriculum content. Each day includes `index.json` plus `block*-*.md` files.
- `references/shared/*.md`: reusable narrative, interview, and world-building rules.
- `.claude-plugin/*.json`: plugin and marketplace metadata.
- `README.md`: installation, authentication, and command usage.

## Build, Test, and Development Commands
Run from monorepo root (`/Users/yuhogyun/prj/agentic30`).
- `bun install`: install workspace dependencies.
- `bun run dev`: start Turbo dev pipelines.
- `bun run lint` and `bun run format`: run linting/formatting checks.
- `bun run test` and `bun run test:e2e`: run workspace and Playwright suites.
- `bunx playwright test e2e/<file>.spec.ts`: run targeted E2E first.
- `bun run sync:assistant-assets`: sync shared assistant assets after skill/MCP edits.

## Coding Style & Naming Conventions
- Write instructions in concise, deterministic Korean; keep technical terms (MCP, OAuth, CLI) in English.
- Keep Markdown/JSON Prettier-friendly (2-space indentation in JSON).
- Use established naming patterns:
  - day folders: `references/dayN/`
  - blocks: `blockX-topic.md`
  - quest IDs: `d<day>-<slug>` (example: `d0-discord-join`)
- Preserve fail-closed wording for protected flows (authentication required before actions).

## Testing Guidelines
- Verify each `references/day*/index.json` maps to existing block files.
- Smoke-test core commands in Claude Code after edits (`/agnt:today`, `/agnt:continue`).
- For onboarding/curriculum updates, run targeted Playwright tests in `e2e/`, then broader suites if needed.

## Commit & Pull Request Guidelines
- Use prefixes seen in history: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`.
- Keep commits scoped to one logical change (content, command prompt, or metadata).
- PRs should include a short summary, touched paths, test evidence, and screenshots/log snippets for visible behavior changes.

## Security & Configuration Tips
- Never commit secrets, OAuth artifacts, or tokens.
- Review `.claude-plugin` metadata changes carefully, especially MCP endpoint/auth settings.
- Do not weaken signature/auth validation instructions in command prompts.
