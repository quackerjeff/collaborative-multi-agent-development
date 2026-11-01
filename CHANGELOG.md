# Changelog

## Unreleased

- Added `ios` repository type to `seed-repo.sh` for native iOS projects using SwiftUI and XcodeGen
- Added iOS scaffold templates: `project.yml`, SwiftUI entry point, asset catalogs, Info.plist, and starter test
- Added `scripts/bootstrap.sh` generation for iOS repos to install XcodeGen, generate the Xcode project, and resolve SPM dependencies
- Added iOS-specific `.gitignore` template
- Added `copy_gitignore()` to `seed-repo.sh` for type-aware gitignore selection
- Added `FIRST_IOS_REPO_SESSION.md` walkthrough
- Updated `BOOTSTRAPPING.md` with iOS documentation

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
