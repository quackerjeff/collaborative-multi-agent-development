# Start From PRD

Use this prompt when a team has a product requirements document and wants an AI coding agent to turn it into the first executable spec instead of jumping straight to implementation.

## Goal

Translate the PRD into the smallest viable end-to-end MVP slice with a clear spec, open questions, technical research needs, and an ordered task plan.

## Instructions

1. Read `AGENTS.md` and follow the repository workflow.
2. Read the PRD and any attached supporting material such as wireframes, flows, constraints, deadlines, mandated stack choices, or external integration requirements.
3. Summarize the PRD in delivery terms:
   - product goals
   - non-goals
   - primary users
   - key user flows
   - constraints
   - assumptions already stated in the PRD
4. Identify what is still missing or ambiguous:
   - acceptance criteria gaps
   - unclear API or data contracts
   - missing edge-case behavior
   - unresolved technical decisions
   - major delivery risks
5. Propose the smallest viable end-to-end MVP slice to build first.
   - It must deliver one clear user outcome
   - It must be testable in isolation
   - It must be small enough to implement as a single spec
   - It must avoid broad platform work unless that platform work is itself the product
6. Ask clarifying questions if required before creating the spec. Do not guess on high-impact product behavior.
7. Use `prompts/scope.md` to create the first implementation spec for that MVP slice.
8. In the spec and task plan:
   - include a research group first
   - include UI design work when the slice changes meaningful user-facing behavior
   - require verified SDK/framework usage in `docs/tech.md`
   - include implementation tasks with explicit acceptance criteria and verify commands
   - include review, security review when appropriate, QA, and documentation groups
9. Stop after creating the spec, task plan, and active spec marker. Do not implement yet.

## Expected Outputs

- A concise PRD-to-delivery summary
- A proposed MVP slice with rationale
- A list of open questions and risks
- `.codex/specs/YYYY-MM-DD-<slug>/spec.md`
- `.codex/specs/YYYY-MM-DD-<slug>/tasks.md`
- `.codex/specs/YYYY-MM-DD-<slug>/decisions.md` when assumptions or tradeoffs need to be recorded
- `.codex/specs/currentspec.md`

## Recommended Invocation

```text
Read AGENTS.md and this PRD. Use prompts/start-from-prd.md to convert it into the first implementation spec for the smallest viable end-to-end MVP slice. Identify missing decisions, technical risks, acceptance-criteria gaps, and required SDK/framework research. Do not implement yet.
```
