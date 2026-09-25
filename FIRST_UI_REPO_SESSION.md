# First UI Repo Session

This guide shows the first five prompts to use after seeding a new `ui` repository from CMD.

It assumes:
- the repo has already been created with `scripts/seed-repo.sh` or `scripts/seed-repo.ps1`
- you are in the seeded repository root
- you have replaced the obvious placeholders in `AGENTS.md` and `SYSTEM_CONTEXT.md`

## Before You Start

In the seeded repo:

1. review `AGENTS.md`
2. review `SYSTEM_CONTEXT.md`
3. add any known framework, stack, contract, or environment facts to `docs/tech.md`
4. start your AI coding agent in the repo root

The local `AGENTS.md` should already tell the agent to begin in the `architect` role and then use other roles as needed. In most cases, do not start by micromanaging the role. Start by describing the product outcome and the first slice.

## Prompt 1: Scope The First Slice

Use this first:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want a UI for <feature>. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. Extract goals, non-goals, primary user flow, constraints, states, technical risks, and open questions. Do not implement yet.
```

Example:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want a UI for managing customer notifications. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should let an admin view notifications, create one notification, and see success and error states. Do not implement yet.
```

## Prompt 2: Tighten Missing Decisions

After reviewing the initial spec, answer open questions and ask the agent to revise it.

```text
Revise the active spec with these decisions: <list the answers to open questions, acceptance criteria updates, stack constraints, and any non-goals>.
```

Use this step to prevent UI and product decisions from being guessed during implementation.

## Prompt 3: Force A UI-Designer Pass

Once the scope is acceptable, ask for explicit UI guidance before code starts.

```text
Using the active spec, use the ui-designer role to define the UI guidance for this slice before implementation. Include layout, interaction flow, component structure, empty/loading/success/error states, responsive behavior, accessibility expectations, and any notable tradeoffs.
```

This is where you correct:
- flow
- information hierarchy
- missing states
- labels and terminology
- assumptions about navigation or responsiveness

## Prompt 4: Execute The Approved Spec

After the scope and UI guidance are acceptable:

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

This should drive the repo through implementation, review, QA, and documentation rather than stopping at code generation.

## Prompt 5: Validate Before You Accept The Slice

Once implementation is done, force a QA pass if it is not already explicit in the output.

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```

If the UI is non-trivial, you can also request a review pass:

```text
Use the reviewer role to check the implemented changes against the active spec and identify correctness or maintainability issues.
```

## Working Pattern

The normal pattern for a seeded `ui` repo is:

1. scope
2. answer open questions
3. define UI guidance
4. execute
5. validate

Do not start with:
- a vague request to "build the whole UI"
- raw implementation before the slice exists
- a role-only instruction with no product goal

## When To Name Roles Explicitly

You usually do not need to tell the agent which role to start with. The local `AGENTS.md` should handle that.

Name a role explicitly when you want a focused pass such as:
- `ui-designer` for flow, layout, and states
- `qa-engineer` for release validation
- `reviewer` for spec compliance and correctness review

## What Good Input Looks Like

Strong inputs:
- the target user
- the main task the UI must support
- the first slice boundary
- known stack constraints
- known accessibility or responsive requirements
- any deadlines or mandated dependencies

Weak inputs:
- "build the frontend"
- "make a dashboard"
- "use AI to design this" without user/task/scope context

## Minimal Example Session

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want a UI for support agents to view open tickets and update ticket priority. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should let a support agent see the ticket list, open a ticket detail view, change priority, and see success and error states. Do not implement yet.
```

```text
Revise the active spec with these decisions: desktop-first web UI, no bulk actions in slice 1, priority values are low/medium/high/urgent, and every mutation must show optimistic pending state plus inline error recovery.
```

```text
Using the active spec, use the ui-designer role to define the UI guidance for this slice before implementation. Include layout, interaction flow, component structure, empty/loading/success/error states, responsive behavior, accessibility expectations, and notable tradeoffs.
```

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```
