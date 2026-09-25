# First API Repo Session

This guide shows the first five prompts to use after seeding a new `api` repository from CMD.

It assumes:
- the repo has already been created with `scripts/seed-repo.sh` or `scripts/seed-repo.ps1`
- you are in the seeded repository root
- you have replaced the obvious placeholders in `AGENTS.md` and `SYSTEM_CONTEXT.md`

## Before You Start

In the seeded repo:

1. review `AGENTS.md`
2. review `SYSTEM_CONTEXT.md`
3. add any known framework, runtime, contract, persistence, or environment facts to `docs/tech.md`
4. start your AI coding agent in the repo root

The local `AGENTS.md` should already tell the agent to begin in the `architect` role and then use other roles as needed. In most cases, do not start by micromanaging the role. Start by describing the business behavior, contract surface, and first slice.

## Prompt 1: Scope The First Slice

Use this first:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want an API for <feature>. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. Extract goals, non-goals, API contracts, validation rules, persistence needs, constraints, technical risks, and open questions. Do not implement yet.
```

Example:

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want an API for task management. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should let a client create a task and list tasks, including request validation, error responses, and persistence. Do not implement yet.
```

## Prompt 2: Tighten Missing Decisions

After reviewing the initial spec, answer open questions and ask the agent to revise it.

```text
Revise the active spec with these decisions: <list the API contract answers, validation rules, persistence decisions, auth assumptions, acceptance criteria updates, stack constraints, and non-goals>.
```

Use this step to prevent API behavior, error handling, or contract details from being guessed during implementation.

## Prompt 3: Force A Contract And Testability Pass

Once the scope is acceptable, force an explicit design pass focused on the API contract and validation behavior.

```text
Using the active spec, refine the API contract before implementation. Verify request and response shapes, validation behavior, status codes, error structure, persistence assumptions, and test strategy. Record confirmed patterns in docs/tech.md and update the active spec if needed.
```

This is where you correct:
- request and response payloads
- status codes
- validation rules
- auth assumptions
- error model
- persistence boundaries
- testing expectations

## Prompt 4: Execute The Approved Spec

After the scope and contract are acceptable:

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

This should drive the repo through implementation, review, security review where needed, QA, and documentation rather than stopping at code generation.

## Prompt 5: Validate Before You Accept The Slice

Once implementation is done, force a QA pass if it is not already explicit in the output.

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```

For backend work, a security-focused pass is often warranted too:

```text
Use the security-reviewer role to review the active spec implementation for auth, input validation, secret handling, and obvious misuse risk. Record the findings in security-review.md.
```

You can also force a correctness pass:

```text
Use the reviewer role to check the implemented changes against the active spec and identify correctness or maintainability issues.
```

## Working Pattern

The normal pattern for a seeded `api` repo is:

1. scope
2. answer open questions
3. lock the contract and validation behavior
4. execute
5. validate

Do not start with:
- a vague request to "build the backend"
- raw coding before the slice and contract exist
- a role-only instruction with no business behavior or interface definition

## When To Name Roles Explicitly

You usually do not need to tell the agent which role to start with. The local `AGENTS.md` should handle that.

Name a role explicitly when you want a focused pass such as:
- `security-reviewer` for auth, secret, and misuse review
- `qa-engineer` for release validation
- `reviewer` for spec compliance and correctness review

## What Good Input Looks Like

Strong inputs:
- the client or user of the API
- the endpoint or workflow the API must support
- the first slice boundary
- known validation or auth requirements
- known persistence constraints
- known stack or runtime constraints
- any deadlines or mandated dependencies

Weak inputs:
- "build the service"
- "make some endpoints"
- "create a REST API" without behavior, contract, or scope context

## Minimal Example Session

```text
Read AGENTS.md, SYSTEM_CONTEXT.md, and docs/tech.md. I want an API for task management. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end slice. The first slice should let a client create a task and list tasks, including request validation, error responses, and persistence. Do not implement yet.
```

```text
Revise the active spec with these decisions: request body is {\"title\": \"string\"}, title is required and trimmed with max length 200, response returns generated integer id and completed=false, no auth in slice 1, and storage can be in-memory for the first slice.
```

```text
Using the active spec, refine the API contract before implementation. Verify request and response shapes, validation behavior, status codes, error structure, persistence assumptions, and test strategy. Record confirmed patterns in docs/tech.md and update the active spec if needed.
```

```text
Read AGENTS.md and use prompts/execute.md to execute the active spec to completion.
```

```text
Use the qa-engineer role to validate the active spec. Create or update qa.md with coverage, findings, residual risks, and a clear release-confidence verdict.
```
