---
inclusion: always
---

# Quality Engineering

## Principle

Code review is not enough. Every non-trivial spec should answer a separate question: how do we know the finished change actually behaves correctly for users and operators?

## When to Add a QA Task

Add a dedicated `qa-engineer` task when work includes any of the following:

- New user-facing flows or changed existing behavior
- Bug fixes where regression risk matters
- Multi-step workflows, stateful behavior, or error recovery
- Deploy-affecting changes that need smoke validation
- Changes spanning multiple components or services

Small internal refactors with strong automated coverage may not need a separate QA task, but the spec should make that explicit.

## Required QA Output

QA work should produce a validation record in `.cmd/specs/<slug>/qa.md` that covers:

- What was validated
- Which checks were automated versus manual
- Which important scenarios remain unverified
- Findings by severity
- Release confidence and final verdict

## Planning Rule

For most non-trivial specs, the workflow should be:

1. Research
2. UI design when needed
3. Implementation
4. Code review
5. Security review when applicable
6. QA validation
7. Documentation

QA may run after security review or in parallel with it when the workstreams are independent, but QA must complete before the spec is considered done.

## Acceptance Criteria for QA Tasks

Every QA task should specify:

- What scenarios must be validated
- Which commands or flows prove the result
- What environments or browsers matter
- Where the report will be written

Example:

```markdown
- [ ] Validate onboarding flow and regression coverage | `.cmd/specs/<slug>/qa.md`
  - **Accept**: QA report documents happy path, validation errors, retry behavior, mobile layout, and automated test coverage for the onboarding flow
  - **Verify**: `grep -i 'verdict.*pass\\|verdict.*fail' .cmd/specs/<slug>/qa.md`
  - **Constraints**: Do not mark complete if core acceptance criteria cannot be exercised in the available environment
```
