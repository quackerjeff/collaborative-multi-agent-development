# Decisions: OpenCode Harness Integration

## 2026-09-26 — Adapter YAML Frontmatter Model Assignment Pattern
**Context**: Experimental verification shows OpenCode 1.18.20 uses YAML frontmatter model assignment via `description`, `mode=subagent`, and `model` fields to route subagents.
**Decision**: Use YAML frontmatter model assignment as the primary mechanism for OpenCode adapters. All adapters must include these three fields.
**Rationale**: This is the only verified model assignment mechanism. It's stable and allows harness-specific configuration without modifying canonical CMD role definitions.

**Status**: VERIFIED FACT — Do not implement unsupported mechanisms like config.json/loader/fallback unless evidence emerges.

## 2026-09-26 — Canonical Role Harness-Agnostic Design
**Context**: Need to make OpenCode a supported harness without coupling CMD's role definitions to harness-specific details.
**Decision**: CMD roles in `agents/` contain only role responsibilities, behaviors, and specifications. No harness-specific configuration, model assignments, or integration patterns.
**Rationale**: Keeps CMD role definitions portable across harnesses while allowing each harness to provide its own adapters with harness-specific details.

## 2026-09-26 — Secondary Role Adapter Creation
**Context**: Security-reviewer, qa-engineer, ui-designer, and docs roles need to be exposed as OpenCode subagents for spec-driven workflow execution.
**Decision**:
1. Create adapter files for all four roles in `integrations/opencode/agents/`
2. Include `description`, `mode=subagent`, and `model` in YAML frontmatter for each adapter
3. Adapters remain thin bindings to canonical roles with no duplicated behavior
4. All adapters follow the same YAML structure as existing verified adapters (architect, coder, reviewer)
**Rationale**: Consistent exposure pattern for all roles, maintainable separation between canonical definitions and harness bindings.

## 2026-09-26 — Selected Local Execution Profile
**Context**: OpenCode routing experiments verified model assignments via YAML frontmatter.
**Decision**: For this integration profile, use GLM 4.7 Flash for architect, reviewer, security-reviewer, qa-engineer, ui-designer, docs; Qwen3-Coder-Next for coder.
**Rationale**: Selected based on experimental verification. Not an OpenCode or CMD requirement, and not a claim of optimality. Different harnesses or contexts may choose different models for the same role.

**Status**: SELECTED LOCAL PROFILE — Group 1 task documented, implementation uses this profile.

## 2026-09-26 — Primary Agent Orchestration Flexibility
**Context**: Repository-specific primary agents (like QuackTrack) may have various patterns for orchestrating subagents.
**Decision**: Primary agents orchestrate CMD subagents through:
1. Direct subagent invocation by role name (OpenCode's native subagent support)
2. Multi-subagent delegations within the repository-specific agent's implementation
3. External orchestration patterns defined in repository-specific documentation
**Rationale**: Flexible enough to support various orchestration needs without mandating a single pattern. Discovery patterns will emerge from repository-specific requirements.

**Status**: RESEARCH QUESTION — Addressed in Group 1 task 3.

## 2026-09-26 — Documentation of Verified Mechanisms
**Context**: Need clear documentation of how OpenCode harness integration works and what has been verified.
**Decision**: Create comprehensive documentation in docs/integration.md and/or docs/harness-integration.md that:
1. Explains the architecture diagram
2. Details the adapter pattern (YAML frontmatter)
3. Shows verified behavior from experiments
4. Clarifies what has NOT been verified and remains a research question
**Rationale**: Prevents confusion about supported vs unverified mechanisms. Helps future developers understand the design decisions and their basis.

**Status**: Documentation task in Group 4.