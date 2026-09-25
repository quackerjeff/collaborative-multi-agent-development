# Changelog

## 0.1.0

- Initial release of the Codex multi-agent sample
- Added `AGENTS.md` and markdown role cards
- Established spec state conventions, now maintained under `.cmd/specs/`
- Added standalone guardrail scripts for wrappers, git hooks, or CI

## 0.2.0

- Added a dedicated `ui-designer` role for user-facing flows, layout, states, and frontend handoff
- Added `steering/frontend-design.md` to require explicit design coverage for meaningful UI work
- Updated the orchestration docs to include design as a first-class part of the spec workflow

## 0.3.0

- Added a dedicated `qa-engineer` role for validation planning, regression coverage, and release confidence
- Added `steering/quality-engineering.md` to require explicit QA coverage for non-trivial specs
- Updated the workflow to distinguish code review, security review, and QA validation as separate gates
