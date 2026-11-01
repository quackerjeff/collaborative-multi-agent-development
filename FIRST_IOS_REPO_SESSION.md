# First iOS Repo Session

This guide shows the first five prompts to use after seeding a new `ios` repository from CMD.

It assumes:
- the repo has already been created with `scripts/seed-repo.sh --type ios`
- you have run `scripts/bootstrap.sh` to generate the Xcode project
- you are in the seeded repository root
- you have replaced the obvious placeholders in `AGENTS.md` and `SYSTEM_CONTEXT.md`

## Before You Start

In the seeded repo:

1. review `AGENTS.md`
2. review `SYSTEM_CONTEXT.md`
3. add any known framework, SDK, contract, or environment facts to `docs/tech.md` (e.g., minimum iOS version, required capabilities, third-party SDK versions)
4. update `project.yml` with your real bundle identifier and development team
5. start your AI coding agent in the repo root

The local `AGENTS.md` should already tell the agent to begin in the `architect` role and then use other roles as needed. In most cases, do not start by micromanaging the role. Start by describing the product outcome and the first slice.

## Prompt 1: Scope The First Slice

Use this first:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want an iOS app for <feature>. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. Extract goals, non-goals, primary user flow, constraints, states, technical risks, and open questions. Do not implement yet.
```

Example:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want an iOS app for tracking daily habits. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should let a user see their habit list, add a new habit, mark a habit complete for today, and see success and error states. Do not implement yet.
```

## Prompt 2: Tighten Missing Decisions

After reviewing the initial spec, answer open questions and ask the agent to revise it.

```text
Revise the active spec with these decisions: <list the answers to open questions, acceptance criteria updates, stack constraints, and any non-goals>.
```

Use this step to lock down platform-specific decisions: data persistence (SwiftData vs Core Data vs UserDefaults), navigation style (NavigationStack vs TabView), and any required iOS capabilities.

## Prompt 3: Force A UI-Designer Pass

Once the scope is acceptable, ask for explicit UI guidance before code starts.

```text
Using the active spec, use the ui-designer role to define the UI guidance for this slice before implementation. Include layout, navigation structure, component hierarchy, empty/loading/success/error states, accessibility expectations, Dynamic Type behavior, and any notable tradeoffs.
```

This is where you correct:
- navigation flow and hierarchy
- information density and visual grouping
- missing states
- labels and terminology
- assumptions about orientation, Dynamic Type, or accessibility

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

If the feature is non-trivial, you can also request a review pass:

```text
Use the reviewer role to check the implemented changes against the active spec and identify correctness or maintainability issues.
```

## Working Pattern

The normal pattern for a seeded `ios` repo is:

1. scope
2. answer open questions
3. define UI guidance
4. execute
5. validate

Do not start with:
- a vague request to "build the whole app"
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
- the main task the app must support
- the first slice boundary
- known platform constraints (minimum iOS version, required capabilities, offline requirements)
- known accessibility or Dynamic Type requirements
- any deadlines or mandated dependencies

Weak inputs:
- "build the app"
- "make it look like the competitor"
- "use SwiftUI" without user/task/scope context

## Minimal Example Session

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want an iOS app for tracking daily water intake. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should let a user log a glass of water, see their daily total, and reset for a new day. Do not implement yet.
```

```text
Revise the active spec with these decisions: use SwiftData for persistence, NavigationStack for navigation, no widgets or complications in slice 1, daily reset happens at midnight local time, and every mutation must show optimistic pending state plus inline error recovery.
```

```text
Using the active spec, use the ui-designer role to define the UI guidance for this slice before implementation. Include layout, navigation structure, component hierarchy, empty/loading/success/error states, accessibility expectations, Dynamic Type behavior, and notable tradeoffs.
```

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```
