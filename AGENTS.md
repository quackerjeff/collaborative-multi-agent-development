# Multi-Agent Development Framework

This file is the canonical repository-level entry point for AI coding agents
using the Multi-Agent Development Framework. Harnesses that do not discover
`AGENTS.md` automatically should be configured or prompted to read it before
starting repository work.

Use this repository as a spec-driven multi-agent workspace. The canonical role
definitions live in `agents/`, and the canonical workflow policies live in
`steering/`. Agents must apply those shared definitions rather than inventing
alternate role behavior.

When the active harness supports subagents, instantiate the appropriate roles
using the role cards in `agents/`. When subagents are unavailable, execute the
same roles sequentially while preserving their responsibilities, boundaries,
review gates, and stop conditions.

## Default Mode

Act as the `architect` role first. Read:

1. `steering/spec-workflow.md`
2. `steering/sdk-verification.md`
3. `steering/testing.md`
4. `steering/frontend-design.md`
5. `steering/quality-engineering.md`
6. `agents/architect.md`

Use the other role cards in `agents/` when delegating or switching modes:

- `agents/coder.md`
- `agents/ui-designer.md`
- `agents/ops.md`
- `agents/reviewer.md`
- `agents/qa-engineer.md`
- `agents/security-reviewer.md`
- `agents/docs.md`

## Workflow

1. For non-trivial work, create or resume a spec under `.cmd/specs/`.
2. Keep the active spec slug in `.cmd/specs/currentspec.md`.
3. Break work into ordered groups in `tasks.md`.
4. If subagents are available, delegate independent implementation tasks in parallel using the role cards above.
5. For meaningful user-facing work, plan explicit UI design tasks before or alongside implementation.
6. Run review, then security review. Run QA validation when required by `steering/quality-engineering.md`, before documentation.
7. Finish by updating docs and clearing `.cmd/specs/currentspec.md`.

## Rules

- Do not guess SDK or framework APIs. Verify them first and write confirmed patterns to `docs/tech.md`.
- Do not leave user-facing behavior underspecified. Use `ui-designer` tasks to define flows, states, and accessibility expectations.
- Do not treat passing unit tests as sufficient evidence when work requires scenario validation. Add `qa-engineer` tasks when required by `steering/quality-engineering.md`; otherwise make the decision to omit a separate QA task explicit in the spec.
- Treat `steering/*.md` as mandatory repo policy.
- Treat `skills/**/SKILL.md` as reusable reference material.
- Use `prompts/*.md` as workflow templates when the user asks to scope, execute, diagnose, or run the flywheel.
- Use `scripts/guardrails/*.sh` from wrappers, git hooks, or CI when you need policy enforcement outside the chat loop.
- When this framework is copied into a service repository, keep a local `AGENTS.md` in that repository and add a local `SYSTEM_CONTEXT.md` describing repo ownership, boundaries, dependencies, and contracts.
- If a service repository also references a shared canonical CMD source, local repo instructions and the active spec take precedence over shared defaults.

## Delegation

When subagents are available:

- Give each subagent the active spec path and the exact task lines it owns.
- Use `ui-designer` for layout, flows, states, visual hierarchy, and accessibility handoff on frontend work.
- Use `coder` for implementation and tests.
- Use `ops` for infrastructure, pipelines, and deploy-related work.
- Use `reviewer` for correctness and maintainability review.
- Use `qa-engineer` for validation planning, scenario coverage, regression checks, and release confidence.
- Use `security-reviewer` for security-only review.
- Use `docs` for final documentation updates.

When subagents are not available:

- Stay in one session and execute the same roles sequentially.
- Preserve the same review gates and stop conditions.
