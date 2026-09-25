# First Platform Repo Session

This guide shows the first five prompts to use after seeding a new `platform` repository from CMD.

It assumes:
- the repo has already been created with `scripts/seed-repo.sh` or `scripts/seed-repo.ps1`
- you are in the seeded repository root
- you have replaced the obvious placeholders in `AGENTS.md` and `SYSTEM_CONTEXT.md`

## Before You Start

In the seeded repo:

1. review `AGENTS.md`
2. review `SYSTEM_CONTEXT.md`
3. add any known infrastructure, CI/CD, environment, security, or deployment facts to `docs/tech.md`
4. start your AI coding agent in the repo root

The local `AGENTS.md` should already tell the agent to begin in the `architect` role and then use other roles as needed. In most cases, do not start by micromanaging the role. Start by describing the platform capability, owning systems, and first slice.

## Prompt 1: Scope The First Slice

Use this first:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want platform support for <feature>. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. Extract goals, non-goals, environments affected, deployment constraints, security concerns, operational risks, technical risks, and open questions. Do not implement yet.
```

Example:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want platform support for deploying a new API service. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should provision the service runtime, CI pipeline, staging deployment path, and basic observability. Do not implement yet.
```

## Prompt 2: Tighten Missing Decisions

After reviewing the initial spec, answer open questions and ask the agent to revise it.

```text
Revise the active spec with these decisions: <list the environment targets, deployment rules, rollback expectations, access constraints, secrets approach, observability requirements, stack constraints, and non-goals>.
```

Use this step to prevent infrastructure, deployment, or security assumptions from being guessed during implementation.

## Prompt 3: Force An Ops And Safety Pass

Once the scope is acceptable, force an explicit pass focused on rollout safety and operational correctness.

```text
Using the active spec, refine the platform design before implementation. Verify environment boundaries, deploy flow, rollback strategy, secrets handling, least-privilege assumptions, observability, drift risks, and validation strategy. Record confirmed patterns in docs/tech.md and update the active spec if needed.
```

This is where you correct:
- environment assumptions
- deployment sequencing
- rollback strategy
- secret and credential handling
- permissions model
- observability coverage
- blast radius and change-management risk

## Prompt 4: Execute The Approved Spec

After the scope and ops design are acceptable:

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

This should drive the repo through implementation, review, security review, QA where appropriate, and documentation rather than stopping at code generation.

## Prompt 5: Validate Before You Accept The Slice

Once implementation is done, force an ops and security validation pass if it is not already explicit in the output.

```text
Use the ops role to review the active spec implementation for deploy readiness, rollback readiness, configuration safety, environment correctness, and operational gaps.
```

```text
Use the security-reviewer role to review the active spec implementation for secrets handling, permissions, exposure risk, and obvious security regressions. Record the findings in security-review.md.
```

You can also force a QA-style validation pass when the platform change has user-visible or release-critical behavior:

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```

## Working Pattern

The normal pattern for a seeded `platform` repo is:

1. scope
2. answer open questions
3. lock deploy and safety behavior
4. execute
5. validate

Do not start with:
- a vague request to "set up infra"
- raw changes before environment, rollback, and security expectations exist
- a role-only instruction with no target platform outcome

## When To Name Roles Explicitly

You usually do not need to tell the agent which role to start with. The local `AGENTS.md` should handle that.

Name a role explicitly when you want a focused pass such as:
- `ops` for deploy and runtime validation
- `security-reviewer` for permissions and secrets review
- `reviewer` for correctness and maintainability review

## What Good Input Looks Like

Strong inputs:
- the platform capability being added or changed
- affected environments
- deployment path expectations
- rollback or migration expectations
- security or compliance constraints
- observability requirements
- any deadlines or mandated tools

Weak inputs:
- "set up CI"
- "add infra"
- "deploy the service" without environment, safety, or operational context

## Minimal Example Session

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want platform support for deploying a new API service. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should provision the service runtime, CI pipeline, staging deployment path, and basic observability. Do not implement yet.
```

```text
Revise the active spec with these decisions: deploy to staging only in slice 1, use GitHub Actions for CI, store secrets in the standard secret manager, require manual approval before promotion, and emit logs plus basic health metrics.
```

```text
Using the active spec, refine the platform design before implementation. Verify environment boundaries, deploy flow, rollback strategy, secrets handling, least-privilege assumptions, observability, drift risks, and validation strategy. Record confirmed patterns in docs/tech.md and update the active spec if needed.
```

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

```text
Use the ops role to review the active spec implementation for deploy readiness, rollback readiness, configuration safety, environment correctness, and operational gaps.
```
