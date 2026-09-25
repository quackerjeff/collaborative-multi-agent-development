# First Worker Repo Session

This guide shows the first five prompts to use after seeding a new `worker` repository from CMD.

It assumes:
- the repo has already been created with `scripts/seed-repo.sh` or `scripts/seed-repo.ps1`
- you are in the seeded repository root
- you have replaced the obvious placeholders in `AGENTS.md` and `SYSTEM_CONTEXT.md`

## Before You Start

In the seeded repo:

1. review `AGENTS.md`
2. review `SYSTEM_CONTEXT.md`
3. add any known runtime, queue, scheduler, integration, deployment, or environment facts to `docs/tech.md`
4. start your AI coding agent in the repo root

The local `AGENTS.md` should already tell the agent to begin in the `architect` role and then use other roles as needed. In most cases, do not start by micromanaging the role. Start by describing the background job behavior, triggering mechanism, and first slice.

## Prompt 1: Scope The First Slice

Use this first:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want a background worker for <feature>. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. Extract goals, non-goals, triggers, inputs, outputs, failure handling, retry behavior, constraints, technical risks, and open questions. Do not implement yet.
```

Example:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want a background worker for sending scheduled reminder emails. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should poll for due reminders, send one outbound email per due reminder, mark successful sends, and record failures. Do not implement yet.
```

## Prompt 2: Tighten Missing Decisions

After reviewing the initial spec, answer open questions and ask the agent to revise it.

```text
Revise the active spec with these decisions: <list the trigger rules, retry policy, idempotency expectations, failure handling, persistence decisions, deployment assumptions, stack constraints, and non-goals>.
```

Use this step to prevent worker behavior, retries, or operational assumptions from being guessed during implementation.

## Prompt 3: Force An Operational Design Pass

Once the scope is acceptable, force an explicit pass focused on runtime behavior and operational safety.

```text
Using the active spec, refine the worker design before implementation. Verify triggers, concurrency assumptions, idempotency strategy, retry and dead-letter behavior, observability, deploy expectations, and test strategy. Record confirmed patterns in docs/tech.md and update the active spec if needed.
```

This is where you correct:
- scheduling or event triggers
- retry rules
- idempotency
- duplicate processing risk
- timeout and failure behavior
- logging, metrics, and alerting expectations
- deployment assumptions

## Prompt 4: Execute The Approved Spec

After the scope and operational design are acceptable:

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

This should drive the repo through implementation, review, ops validation, QA, and documentation rather than stopping at code generation.

## Prompt 5: Validate Before You Accept The Slice

Once implementation is done, force a QA pass if it is not already explicit in the output.

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```

For worker repos, an ops-oriented review is usually useful too:

```text
Use the ops role to review the active spec implementation for deploy readiness, runtime configuration, observability, rollback risk, and operational gaps.
```

You can also force a security pass when the worker handles sensitive data or external integrations:

```text
Use the security-reviewer role to review the active spec implementation for secret handling, external integration risk, and misuse exposure. Record the findings in security-review.md.
```

## Working Pattern

The normal pattern for a seeded `worker` repo is:

1. scope
2. answer open questions
3. lock runtime and retry behavior
4. execute
5. validate

Do not start with:
- a vague request to "build the job"
- raw coding before trigger and failure behavior exist
- a role-only instruction with no runtime or business behavior context

## When To Name Roles Explicitly

You usually do not need to tell the agent which role to start with. The local `AGENTS.md` should handle that.

Name a role explicitly when you want a focused pass such as:
- `ops` for runtime and deployment review
- `security-reviewer` for secret and integration review
- `qa-engineer` for release validation

## What Good Input Looks Like

Strong inputs:
- what triggers the worker
- what input it consumes
- what output or side effect it produces
- retry and failure expectations
- idempotency or deduplication rules
- operational constraints
- any deadlines or mandated dependencies

Weak inputs:
- "build the worker"
- "process events"
- "send background jobs" without trigger, state, or outcome details

## Minimal Example Session

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want a background worker for sending scheduled reminder emails. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should poll for due reminders, send one outbound email per due reminder, mark successful sends, and record failures. Do not implement yet.
```

```text
Revise the active spec with these decisions: run every minute, retries are capped at 3 attempts with exponential backoff, processing must be idempotent per reminder id, failed sends are recorded for manual retry later, and local development can use an in-memory scheduler stub.
```

```text
Using the active spec, refine the worker design before implementation. Verify triggers, concurrency assumptions, idempotency strategy, retry and dead-letter behavior, observability, deploy expectations, and test strategy. Record confirmed patterns in docs/tech.md and update the active spec if needed.
```

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```
