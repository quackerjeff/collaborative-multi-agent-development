# Tasks: Account Settings Refresh

Spec: `.cmd/specs/2026-07-12-account-settings-refresh/spec.md`

## Group 1: Research and baseline
- [ ] Research and document current frontend and API patterns | `docs/tech.md`
  - **Accept**: `docs/tech.md` documents the relevant page/component patterns, form handling approach, and any API contracts used by the settings experience
  - **Verify**: `rg -n 'settings|form|api|validation' docs/tech.md`
  - **Constraints**: Do not invent framework or API behavior; verify from the codebase and docs first

- [ ] Capture current acceptance and regression risks | `.cmd/specs/2026-07-12-account-settings-refresh/decisions.md`
  - **Accept**: `decisions.md` records the key user scenarios, known risks, and any assumptions that need to stay visible throughout implementation
  - **Verify**: `rg -n 'scenario|risk|assumption' .cmd/specs/2026-07-12-account-settings-refresh/decisions.md`
  - **Constraints**: Keep notes short and operational

## Group 2: UI design
- [ ] Design the account settings flow and component states | `docs/ui/account-settings-refresh.md`
  - **Accept**: Guidance covers layout, copy hierarchy, validation, loading/error/success states, mobile behavior, accessibility notes, and implementation handoff for the refreshed settings page
  - **Verify**: `rg -n 'loading|error|success|mobile|accessibility|validation' docs/ui/account-settings-refresh.md`
  - **Constraints**: Reuse existing navigation and form patterns where possible; do not invent a parallel design system

## Group 3: Implementation
- [ ] Implement the refreshed settings layout and interaction states | `src/pages/settings*`, `src/components/settings*`
  - **Accept**: The settings page reflects the approved design guidance, renders clear sections, and handles loading/error/success states for each save action
  - **Verify**: `npm test -- settings`
  - **Constraints**: Follow `docs/ui/account-settings-refresh.md`; do not substitute undocumented UI behavior

- [ ] Add or update tests for validation and save behavior | `tests/`, `src/**/*.test.*`
  - **Accept**: Automated tests cover field validation, successful save behavior, and failed save behavior for the refreshed settings experience
  - **Verify**: `npm test -- settings`
  - **Constraints**: Reference the exact user-visible behaviors from the spec and UI guidance

## Group 4: Review gate
- [ ] Code review of all implementation groups | `.cmd/specs/2026-07-12-account-settings-refresh/review.md`
  - **Accept**: Reviewer has written findings to `review.md` with verdict PASS. Zero critical findings, zero warnings.
  - **Verify**: `grep -i 'verdict.*pass' .cmd/specs/2026-07-12-account-settings-refresh/review.md`
  - **Constraints**: Do NOT proceed to the next group until this passes. Maximum 3 review cycles.

- [ ] Security review of the implementation | `.cmd/specs/2026-07-12-account-settings-refresh/security-review.md`
  - **Accept**: Security reviewer has written findings to `security-review.md` with verdict PASS.
  - **Verify**: `grep -i 'verdict.*pass' .cmd/specs/2026-07-12-account-settings-refresh/security-review.md`
  - **Constraints**: Focus on input handling, auth assumptions, and secrets exposure

## Group 5: QA gate
- [ ] Validate implemented behavior and regression coverage | `.cmd/specs/2026-07-12-account-settings-refresh/qa.md`
  - **Accept**: QA report documents happy path, validation errors, retry behavior, keyboard flow, mobile layout, automated coverage, residual gaps, release confidence, and a PASS/FAIL verdict
  - **Verify**: `grep -i 'verdict.*pass\\|verdict.*fail' .cmd/specs/2026-07-12-account-settings-refresh/qa.md`
  - **Constraints**: Do not mark complete if core acceptance criteria cannot be exercised in the available environment

## Group 6: Documentation update
- [ ] Update documentation for spec changes | `README.md`, `docs/`
  - **Accept**: README and relevant docs reflect the refreshed settings experience and any new testing or validation conventions introduced by the work
  - **Verify**: `grep -r 'TODO\|FIXME\|PLACEHOLDER' README.md docs/ || true`
  - **Constraints**: Do not document descoped behaviors or unvalidated claims
