# Tasks: OpenCode Harness Integration for CMD

Spec: `.cmd/specs/2026-09-26-opencode-harness-integration/spec.md`

## Group 1: Research and OpenCode Behavior Verification

- [x] Verify OpenCode subagent routing via YAML frontmatter mechanism | `.opencode/agents/*.md`
  - **Accept**: Confirmed that YAML frontmatter fields `description`, `mode=subagent`, and `model` successfully assign models in OpenCode 1.18.20
  - **Verify**: Review existing adapter files and execution logs
  - **Constraints**: Document all verified routing behaviors. Include source citations from logs. Do NOT invent unverified mechanisms.

**Verification Result**: OpenCode 1.18.20 routes subagents using YAML frontmatter. Verified through:
- Examination of existing adapter files (`architect.md`, `coder.md`, `reviewer.md`)
- Confirmed fields: `description`, `mode=subagent`, `model`
- Execution logs show `agent`, `mode=subagent`, and `modelID` Confirming the routing mechanism

- [x] Investigate adapter file format and validation requirements | `integrations/opencode/agents/*.md`
  - **Accept**: Documented exact YAML frontmatter syntax verified to work: `description`, `mode=subagent`, `model`
  - **Verify**: Check existing adapter files for confirmed working patterns
  - **Constraints**: Do NOT implement validation; only research and document. Include examples of verified adapters.

**Research Finding**: Adapter format uses YAML frontmatter with required fields:
- `description`: Role description string
- `mode: subagent`: Required for subagent routing
- `model`: Model identifier (e.g., `ollama/glm-4.7-flash:latest`)
- Content: Instructional text referencing canonical role definition

- [x] Research repository-specific primary agent location | `agents/`, `.opencode/agents/`, repository root
  - **Accept**: Documented where repository-specific agents (e.g., QuackTrack) are defined and how they invoke subagents
  - **Verify**: Search for primary agent definitions and subagent invocations
  - **Constraints**: Do not modify agent definitions during research. Document any existing orchestrations.

**Research Finding**: Repository-specific agents are expected to be defined in repository-specific locations (`.opencode/agents/` if present). CMD role names provide the contract for subagent invocation. OpenCode's native subagent support enables role-based invocation without requiring repository-specific orchestration code.

- [x] Create research findings document | `docs/tech.md`
  - **Accept**: `docs/tech.md` contains verified OpenCode subagent configuration patterns and routing evidence
  - **Verify**: `cat docs/tech.md | grep -i "opencode"`
  - **Constraints**: Include only verified facts with source citations. Reference the local execution profile: architect, reviewer, security-reviewer, qa-engineer, ui-designer, docs → GLM 4.7 Flash; coder → Qwen3-Coder-Next. Do NOT include unverified mechanisms.

## Group 2: Create remaining OpenCode adapters

- [x] Create OpenCode adapter for security-reviewer role | `integrations/opencode/agents/security-reviewer.md`
  - **Accept**: New adapter file exists with YAML frontmatter (description, mode=subagent, model)
  - **Verify**: `ls -la integrations/opencode/agents/security-reviewer.md`
  - **Constraints**: Thin adapter referencing `agents/security-reviewer.md`. No duplication of role behavior.

- [x] Create OpenCode adapter for qa-engineer role | `integrations/opencode/agents/qa-engineer.md`
  - **Accept**: New adapter file exists with YAML frontmatter (description, mode=subagent, model)
  - **Verify**: `ls -la integrations/opencode/agents/qa-engineer.md`
  - **Constraints**: Thin adapter referencing `agents/qa-engineer.md`. No duplication of role behavior.

- [x] Create OpenCode adapter for ui-designer role | `integrations/opencode/agents/ui-designer.md`
  - **Accept**: New adapter file exists with YAML frontmatter (description, mode=subagent, model)
  - **Verify**: `ls -la integrations/opencode/agents/ui-designer.md`
  - **Constraints**: Thin adapter referencing `agents/ui-designer.md`. No duplication of role behavior.

- [x] Create OpenCode adapter for docs role | `integrations/opencode/agents/docs.md`
  - **Accept**: New adapter file exists with YAML frontmatter (description, mode=subagent, model)
  - **Verify**: `ls -la integrations/opencode/agents/docs.md`
  - **Constraints**: Thin adapter referencing `agents/docs.md`. No duplication of role behavior.

## Group 3: Verify model assignment consistency

- [x] Ensure model assignments are consistent across all adapters | `integrations/opencode/agents/*.md`
  - **Accept**: All adapters use either GLM 4.7 Flash:latest or Qwen3-Coder-Next:latest as configured
  - **Verify**: `grep "^model:" integrations/opencode/agents/*.md`
  - **Constraints**: This is verification, not implementation. Align with research findings in tech.md.

**Verification Result**: All 7 adapters verified:
- `architect`: ollama/glm-4.7-flash:latest
- `coder`: ollama/qwen3-coder-next:latest
- `security-reviewer`: ollama/glm-4.7-flash:latest
- `qa-engineer`: ollama/glm-4.7-flash:latest
- `ui-designer`: ollama/glm-4.7-flash:latest
- `docs`: ollama/glm-4.7-flash:latest
- `reviewer`: ollama/glm-4.7-flash:latest

## Group 4: Documentation update

- [x] Update integration documentation for OpenCode harness | `docs/integration.md`, `README.md`
  - **Accept**: Documentation explains OpenCode as supported CMD harness, how to use adapters, and how subagents are invoked
  - **Verify**: `grep -i "opencode" docs/integration.md && grep -i "harness" README.md`
  - **Constraints**: Do not document unverified mechanisms. Include YAML frontmatter model assignment pattern. Reference canonical roles in agents/.

- [x] Document adapter pattern and harness-independence principle | `docs/harness-integration.md` (new) or integration.md
  - **Accept**: Clear explanation of how canonical roles remain harness-independent, and adapters provide harness-specific bindings
  - **Verify**: Readability of documentation
  - **Constraints**: Include examples of architecture diagram and adapter structure.

  **DEVIATION NOTE**: Per task acceptance criteria "Create/expand docs/harness-integration.md (new) or integration.md", we chose to comprehensively document in docs/integration.md. Separate harness-integration.md was not created to avoid duplication. Documented deviation in this QA report.

## Group 5: Code review gate

- [x] Code review of all implementation groups | `.cmd/specs/2026-09-26-opencode-harness-integration/review.md`
  - **Accept**: Reviewer returned PASS verdict. Critical findings: 0. Warnings: 0.
  - **Verify**: `grep -i "verdict.*pass" .cmd/specs/2026-09-26-opencode-harness-integration/review.md`
  - **Constraints**: Do NOT proceed to next group until this passes. Maximum 3 review cycles.

## Group 6: QA validation gate

- [x] Validate OpenCode integration behavior and completeness | `.cmd/specs/2026-09-26-opencode-harness-integration/qa.md`
  - **Accept**: QA report documents validation scenarios, coverage, and passes verdict
  - **Verify**: `grep -i "verdict.*pass" .cmd/specs/2026-09-26-opencode-harness-integration/qa.md`
  - **Constraints**: OpenCode may require manual testing in its environment. Document test procedures in QA report.

## Group 7: Specification completion

- [x] Delete .cmd/specs/currentspec.md | `.cmd/specs/currentspec.md`
  - **Accept**: currentspec.md file removed, spec complete
  - **Verify**: `test ! -f .cmd/specs/currentspec.md`
  - **Constraints**: All other groups must pass review before deletion.