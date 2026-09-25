# Operational Flow

## Starting Workflow

1. Prepare the inputs.
   Give the agent:
   - the PRD
   - any wireframes or mockups
   - technical constraints
   - known deadlines
   - any mandated stack choices

2. Start with scoping, not coding.
   First prompt:

   ```text
   Read AGENTS.md and this PRD. Use prompts/scope.md to create the first implementation spec for the smallest end-to-end MVP slice. Extract goals, non-goals, user flows, constraints, open questions, technical risks, and missing acceptance criteria.
   ```

3. Require the agent to define slice 1.
   The first spec should be one thin vertical slice, not the whole product. For example:
   - auth only
   - task creation only
   - dashboard read-only only
   - one billing flow only

4. Resolve ambiguity before execution.
   After the first scope pass, review what the agent flags:
   - unclear product behavior
   - missing API contracts
   - missing edge cases
   - missing success metrics
   - risky assumptions

   If needed, answer those questions before any implementation starts.

5. Define UI behavior before implementation when the slice is user-facing.
   If the slice includes new screens, forms, flows, dashboards, navigation changes, or meaningful component behavior, create wireframes, mocks, or structured UI guidance before coding starts.

   Use AI-generated wireframes or UI guidance after the slice is scoped, not directly from the raw PRD alone. The PRD defines product intent; the UI design step turns that into implementable screens, states, hierarchy, and accessibility expectations.

   At minimum, the design step should define:
   - primary flow
   - layout or component structure
   - empty, loading, success, and error states
   - mobile or responsive expectations
   - accessibility expectations

   For this repository, use:
   - `agents/ui-designer.md` for the UI-design role
   - `steering/frontend-design.md` for the design planning rules

6. Require technical research.
   Before coding, the agent should verify:
   - framework patterns
   - SDK usage
   - package versions
   - external service integration patterns

   Those findings should go into `docs/tech.md`.

7. Approve the spec and task plan.
   The agent should produce:
   - `spec.md`
   - `tasks.md`
   - `decisions.md`

   Review that plan like you would review a design doc.

8. Then execute.
   Once the slice is well-scoped, run:

   ```text
   Use prompts/execute.md to execute the active spec to completion.
   ```

## What the Agent Should Produce From a PRD

From the PRD, you want the agent to convert product language into delivery artifacts:

- Product summary
- MVP slice proposal
- User stories / flows
- Non-goals
- Acceptance criteria
- Technical design
- Risks
- Open questions
- Ordered implementation tasks
- Review / QA / docs gates

## How To Choose The First Slice

Pick the smallest slice that proves the architecture and delivers visible value. Good slice properties:

- one primary user
- one clear entry point
- one complete outcome
- minimal dependencies
- testable in isolation

Bad first slices are horizontal platform work with no usable outcome unless the platform itself is the product.

## UI Design Timing

For meaningful user-facing work, UI design should happen after the PRD has been analyzed and the first slice has been scoped, but before implementation starts.

Recommended sequence:

1. Read the PRD
2. Scope the first MVP slice
3. Generate wireframes, mocks, or structured UI guidance for that slice
4. Review and correct the flow, states, and hierarchy
5. Implement against the approved UI guidance

Use low-fidelity wireframes when the team needs clarity on flow and states. Use higher-fidelity mocks when the team needs stronger alignment on layout, hierarchy, branding, or stakeholder review.

Do not wait until code is underway to define the UI. That usually pushes product decisions into implementation, where they are slower and more expensive to correct.

## Suggested Team Operating Loop

For each new product or major feature:

1. PRD
2. Scope spec
3. Define UI guidance when the work is user-facing
4. Resolve open questions
5. Verify technical assumptions
6. Approve task plan
7. Execute
8. Review
9. QA
10. Docs
11. Next slice

## Recommended Prompt Set

For a brand new project:

```text
Read AGENTS.md and this PRD. Use prompts/scope.md to propose:
- the smallest viable end-to-end MVP slice
- a spec for that slice
- missing decisions in the PRD
- technical risks
- the ordered task plan
Do not implement yet.
```

After review:

```text
Revise the spec based on these decisions: ...
```

Then:

```text
Use prompts/execute.md to execute the active spec to completion.
```

## What This Prevents

This process mainly prevents:

- trying to build the whole PRD at once
- vague requirements turning into guessed behavior
- AI inventing framework usage
- implementation starting before acceptance criteria exist
- teams mistaking code generation for delivery readiness
