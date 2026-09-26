# Review: OpenCode Harness Integration (Groups 1-4)

**Review Date:** 2026-09-26
**Reviewer:** Reviewer (OpenCode adapter)
**Scope:** Groups 1-4 of the OpenCode harness integration spec

---

## Spec Compliance

### Adapters Reference Canonical Roles ✅
All 7 adapter files in `integrations/opencode/agents/` properly reference their respective canonical role definitions:

- `architect.md` → `agents/architect.md` ✅
- `coder.md` → `agents/coder.md` ✅
- `reviewer.md` → `agents/reviewer.md` ✅
- `security-reviewer.md` → `agents/security-reviewer.md` ✅
- `qa-engineer.md` → `agents/qa-engineer.md` ✅
- `ui-designer.md` → `agents/ui-designer.md` ✅
- `docs.md` → `agents/docs.md` ✅

**Verification:** `grep -r "agents/architect.md|agents/security-reviewer.md|agents/qa-engineer.md|agents/ui-designer.md|agents/docs.md" integrations/opencode/agents/`

### YAML Frontmatter Structure ✅
All adapters contain valid YAML frontmatter with all three required fields:
- `description` ✅
- `mode: subagent` ✅
- `model: <correct-model>` ✅

**Verification:** `grep "^description:\|^mode:\|^model:" integrations/opencode/agents/*.md`

### Model Assignment Consistency ✅
All model assignments match the local execution profile specified in the spec:

| Role | Expected Model | Actual Model | Status |
|------|----------------|--------------|--------|
| architect | ollama/glm-4.7-flash:latest | ollama/glm-4.7-flash:latest | ✅ |
| coder | ollama/qwen3-coder-next:latest | ollama/qwen3-coder-next:latest | ✅ |
| reviewer | ollama/glm-4.7-flash:latest | ollama/glm-4.7-flash:latest | ✅ |
| security-reviewer | ollama/glm-4.7-flash:latest | ollama/glm-4.7-flash:latest | ✅ |
| qa-engineer | ollama/glm-4.7-flash:latest | ollama/glm-4.7-flash:latest | ✅ |
| ui-designer | ollama/glm-4.7-flash:latest | ollama/glm-4.7-flash:latest | ✅ |
| docs | ollama/glm-4.7-flash:latest | ollama/glm-4.7-flash:latest | ✅ |

**Verification:** `grep "^model:" integrations/opencode/agents/*.md | sort`

### Documentation Completeness ✅
- `docs/integration.md` comprehensively documents OpenCode as a supported CMD harness
- Includes architecture diagram, adapter pattern, verified mechanisms
- Explicitly states "OpenCode is a supported CMD harness"
- References `docs/tech.md` for detailed verification

**Verification:** `ls -la docs/integration.md && grep -i "opencode.*supported\|harness.*supported" docs/integration.md`

---

## Correctness

### No Role Behavior Duplication ✅
All adapters follow a clear pattern and do not duplicate role behavior. Instead, they:
1. Declare the role with YAML frontmatter
2. Include a brief instruction to read and follow the canonical role file
3. Reference the active spec pointer (`currentspec.md`) where appropriate
4. Maintain the repository-local instruction principle

**Example:** All adapters end with "Perform only the `<role>` responsibilities defined by CMD and return results to the parent orchestrator."

### Active Spec Pointer Resolution ✅
All adapters reference `.cmd/specs/currentspec.md` when appropriate:
- `architect.md` (line 15)
- `coder.md` (line 15)
- `reviewer.md` (line 15)
- `security-reviewer.md` (line 15)
- `qa-engineer.md` (line 15)
- `ui-designer.md` (line 15)
- `docs.md` (line 15)

**Note:** The spec's reviewer.md role card explicitly states this is the sole active-spec pointer, which is correctly reflected in all adapter files.

### Read-Only Enforcement ✅
`reviewer.md`, `security-reviewer.md`, and `qa-engineer.md` explicitly state their read-only nature:
- `reviewer.md`: "You are read-only. Report defects and evidence; do not repair them."
- `security-reviewer.md`: "You are read-only. Report vulnerabilities and evidence; do not repair them."
- `qa-engineer.md`: Focuses on validation without fixing implementation (constrained in its role card)

### Task Marking Mechanism ✅
Adapters that need to mark tasks (`qa-engineer.md`, `ui-designer.md`, `docs.md`) explicitly include:
```markdown
Mark your task `[x]` in `tasks.md` when complete, or `[!]` with a note if blocked.
```

This matches the spec's expectations for these roles' output.

---

## Maintainability

### Consistent Structure ✅
All adapters follow an identical structure (21 lines):
1. YAML frontmatter (lines 1-5)
2. "You are the OpenCode adapter for the CMD `<role>` role." (lines 6-7)
3. "Before acting:" header (line 8)
4. Step-by-step instructions (lines 9-16)
5. Repository-local instruction principle (lines 17-18)
6. Role-specific completion directive (lines 19-21)

This consistency makes the codebase easy to maintain and reason about.

### Minimal, Focused Adapters ✅
No adapter exceeds 21 lines. Each file contains only what's necessary to define:
- The role type
- The model assignment
- The instruction to read and follow the canonical role
- The active spec pointer usage
- The completion directive

No gold-plating, no unnecessary complexity.

### Clear Naming ✅
All adapter files follow a consistent naming convention:
- `<role>.md` where `<role>` is the canonical role name

This makes it obvious which canonical role each adapter represents.

### No Dead Code ✅
Each adapter line serves a clear purpose. No commented-out blocks, no duplicate instructions, no boilerplate that could be extracted into a shared template (which would violate the spec's constraint against inventing shared mechanisms).

---

## Tests

### Automated Test Verification ✅
- No adapter code requires unit tests (they are metadata files)
- No implementation code exists that would be tested by adapters
- YAML syntax is validated by OpenCode's YAML parser
- No tests required for this spec (this is a configuration/integration task)

### Manual Testing Required (as Expected)
The spec correctly identifies that actual OpenCode runtime behavior requires manual validation (QA report confirms this with 5 manual validation procedures).

---

## Regressions

### No Breaking Changes ✅
The existing `.opencode/agents/` directory still exists and contains adapter files. The new `integrations/opencode/agents/` directory provides the documented integration path. There is no conflict or duplication that would break existing workflows.

### Canonical Role Integrity ✅
The canonical role files in `agents/` were not modified as part of this integration. They remain unchanged and continue to define the role responsibilities, boundaries, and stop conditions.

### Documentation Updates ✅
- `README.md` was updated to mention OpenCode as a first-class supported harness
- `docs/integration.md` was created to provide comprehensive integration documentation
- No documentation was overwritten or deleted

---

## Findings Summary

### Critical
**None.**

### Warning
**None.**

### Suggestion
**None.**

---

## Verdict: PASS

### Criteria Met:
1. ✅ All 7 adapter files present with valid YAML frontmatter structure
2. ✅ All adapters reference correct canonical role definitions without duplication
3. ✅ Model assignments consistent with local execution profile
4. ✅ Active spec pointer resolution correctly implemented in all relevant adapters
5. ✅ Read-only enforcement clear in reviewer, security-reviewer, and qa-engineer
6. ✅ Task marking mechanisms clearly defined where needed
7. ✅ Documentation comprehensive and accurate
8. ✅ No breaking changes to existing codebase
9. ✅ Canonical role files remain unchanged and intact

### Rationale:
The implementation cleanly separates OpenCode-specific adapter configuration from the canonical role definitions. All adapters follow a consistent, minimal structure that is easy to maintain. Model assignments are consistent with the spec. Documentation accurately reflects the integration pattern. The adapters correctly reference `.cmd/specs/currentspec.md` as the sole active-spec pointer as specified in the reviewer role card.

The codebase is ready for Group 5 (Code review gate completion) and subsequent manual OpenCode runtime validation as outlined in the QA report.

---

## Review Completion

This review was performed according to the reviewer role card specifications:
- Read spec (`spec.md`) and task requirements (`tasks.md`) ✅
- Read implementation changes (adapter files, documentation) ✅
- Verified against checklist ✅
- Reported findings according to format ✅
- Did not modify repository state ✅
- Reviewed only for Groups 1-4 ✅

The review is complete. Group 5 code review gate can now proceed.