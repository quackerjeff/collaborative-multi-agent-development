# Service AI Workflow

Use the shared Collaborative Multi-Agent Development (CMD) framework as the base workflow standard for this repository.

## Canonical Shared CMD Source

Point this repository to the canonical shared CMD source used by your organization.

Examples:
- `../cmd-shared/`
- internal Git URL
- internal documentation portal location

Record the real source here before using this file.

Canonical workflow source:
- `<replace-with-canonical-cmd-location>`

## Read Order

Before starting non-trivial work, read in this order:

1. `SYSTEM_CONTEXT.md`
2. `docs/tech.md`
3. local `AGENTS.md`
4. then the shared CMD guidance referenced above

If a spec is already active, also read:

5. `.codex/specs/currentspec.md`
6. the active spec directory files

## Precedence

When instructions conflict, use this order:

1. active spec under `.codex/specs/...`
2. local `AGENTS.md`
3. local `SYSTEM_CONTEXT.md`
4. local `docs/tech.md`
5. copied or linked shared CMD assets
6. generic agent defaults

Local repository rules override shared defaults.

## Repository Scope

This repository owns:
- `<business capability>`
- `<service boundaries>`
- `<primary deployable or runtime>`

This repository depends on:
- `<upstream services>`
- `<downstream services>`
- `<shared libraries or platform dependencies>`

This repository does not own:
- `<adjacent capabilities owned elsewhere>`

## Default Workflow

1. For non-trivial work, create or resume a spec under `.codex/specs/`.
2. Keep the active spec slug in `.codex/specs/currentspec.md`.
3. Break work into ordered groups in `tasks.md`.
4. For meaningful user-facing work, define UI behavior before implementation is finalized.
5. Verify SDK, framework, dependency, and integration usage before coding and record confirmed patterns in `docs/tech.md`.
6. Execute implementation tasks.
7. Run review, security review when needed, and QA validation before final documentation.
8. Finish by updating docs and clearing `.codex/specs/currentspec.md`.

## Local Rules

- Do not guess service contracts. Verify owned APIs, events, schemas, and integration patterns first.
- Do not change behavior in adjacent systems unless the active spec explicitly covers the cross-repo impact.
- Do not treat this repo in isolation when the feature crosses boundaries. Document companion repos, contracts, and rollout dependencies in the active spec.
- Keep implementation specs local to this repository even when related work exists in other repositories.
- Update `SYSTEM_CONTEXT.md` when repo ownership, boundaries, or dependency assumptions change materially.

## Local Documents

Required local documents:
- `SYSTEM_CONTEXT.md`
- `docs/tech.md`

Optional but recommended local documents:
- `docs/contracts.md`
- `docs/runbook.md`
- `docs/deploy.md`
- `docs/testing.md`

## Cross-Repo Work

When a feature spans multiple repositories:

- scope the change in this repo's local spec
- list companion repos and linked specs in `decisions.md`
- identify contract dependencies explicitly
- sequence rollout and compatibility expectations
- avoid hiding cross-repo assumptions in chat only

## Notes For Maintainers

Before adopting this file:

- replace placeholders
- point to the real canonical CMD source
- tailor the repository scope
- add repo-specific constraints
- remove sections that do not apply
