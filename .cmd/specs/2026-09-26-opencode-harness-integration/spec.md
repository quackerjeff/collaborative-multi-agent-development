# OpenCode Harness Integration for CMD

## Context

We have experimental verification that OpenCode 1.18.20 can function as a CMD harness with local model mappings:
- architect → ollama/glm-4.7-flash:latest
- coder → ollama/qwen3-coder-next:latest
- reviewer → ollama/glm-4.7-flash:latest

Existing thin adapters exist at `integrations/opencode/agents/` but need redesign to make OpenCode a supported harness integration without making CMD's role definitions model-specific.

Verified OpenCode behaviors (OpenCode 1.18.20 routing experiments):
- architect → GLM 4.7 Flash, mode=subagent
- coder → Qwen3-Coder-Next, mode=subagent
- reviewer → GLM 4.7 Flash, mode=subagent
- Per-agent YAML frontmatter `model` field works for routing
- `.opencode/agents/` project agents are discovered after restarting OpenCode
- Active spec convention remains `.cmd/specs/currentspec.md`
- The existing integrations/opencode/agents/ adapters are experimental
- New project agent files became available after restarting OpenCode

## Goal

Make OpenCode a supported CMD harness integration without making CMD's core role definitions model- or harness-specific.

## Requirements

- CMD role definitions under `agents/` remain canonical and harness-independent
- OpenCode adapters must be thin runtime bindings, not duplicate role definitions
- Local model assignments are OpenCode execution profile choices, not CMD role properties
- Secondary roles (security-reviewer, qa-engineer, ui-designer, docs) must be exposed as OpenCode subagents
- Repository-specific primary agents (e.g., QuackTrack) must remain accessible and consistent with adapter patterns
- Do NOT invent unsupported OpenCode configuration mechanisms
- Verify OpenCode-specific behavior before designing around it
- Do not redesign `.cmd/specs/currentspec.md`
- Do not implement adapters or integration code in this task
- Limit local-model profile to GLM 4.7 Flash and Qwen3-Coder-Next

## Constraints

- Must follow CMD spec-driven workflow
- Must maintain harness-independence of CMD role definitions
- No duplication of canonical role behavior
- All verified OpenCode behaviors are assumptions until validated
- OpenCode version is 1.18.20
- Model assignments in YAML frontmatter are the baseline mechanism for verified behavior
- Repository-specific agents remain in repository-specific locations
- The local-model profile (GLM 4.7 Flash for architect, reviewer, security-reviewer, qa-engineer, ui-designer, docs; Qwen3-Coder-Next for coder) is the selected local execution profile, not an OpenCode or CMD requirement, and not a claim that these models are optimal

## Design

### Architecture Overview

```
agents/                    (canonical, harness-independent)
  ├── architect.md         (role definition, not harness-specific)
  ├── coder.md             (role definition, not harness-specific)
  ├── reviewer.md          (role definition, not harness-specific)
  ├── security-reviewer.md (role definition, not harness-specific)
  ├── qa-engineer.md       (role definition, not harness-specific)
  ├── ui-designer.md       (role definition, not harness-specific)
  └── docs.md              (role definition, not harness-specific)

integrations/opencode/
  └── agents/              (thin adapters with YAML frontmatter model assignment)
      ├── architect.md     (references agents/architect.md, harness-specific frontmatter with model)
      ├── coder.md         (references agents/coder.md, harness-specific frontmatter with model)
      ├── reviewer.md      (references agents/reviewer.md, harness-specific frontmatter with model)
      ├── security-reviewer.md (new, references agents/security-reviewer.md, harness-specific frontmatter with model)
      ├── qa-engineer.md   (new, references agents/qa-engineer.md, harness-specific frontmatter with model)
      ├── ui-designer.md   (new, references agents/ui-designer.md, harness-specific frontmatter with model)
      └── docs.md          (new, references agents/docs.md, harness-specific frontmatter with model)

.agents/                   (if present, for repository-specific agents)
```

### Canonical Role Definition

CMD roles in `agents/` should NOT contain:
- Harness-specific configuration
- Model assignments (move these to harness-level adapters)
- Direct integration patterns

They should contain role responsibilities, behaviors, and specifications for how a subagent should function when executing as that role.

### Adapter Design

OpenCode adapters will be YAML frontmatter files with:
- `description`: Role description
- `mode: subagent`: Required for OpenCode subagent routing
- `model`: (REQUIRED) Model assignment for OpenCode's execution profile
- Content: Reference to canonical role definition and instruction to follow it

Example structure:
```yaml
---
description: CMD architect for research, specification, planning, and task decomposition
mode: subagent
model: ollama/glm-4.7-flash:latest
---

You are the OpenCode adapter for the CMD architect role.

Before acting:

1. Read the repository's `AGENTS.md`.
2. Read `SYSTEM_CONTEXT.md` and `docs/tech.md` when present.
3. Read and follow `agents/architect.md`.
4. Read and follow the applicable policies under `steering/`.
5. Resolve the active spec through `.cmd/specs/currentspec.md` when the requested workflow requires an active spec.

The repository's local instructions and explicit user authorization remain authoritative.

Do not treat the existence of a CMD spec as authorization to perform work beyond the user's explicit request.

Perform only the architect responsibilities defined by CMD. Return your findings, decisions, specification work, or task decomposition to the parent orchestrator.
```

### Model Assignment Pattern

The verified behavior uses YAML frontmatter model assignment:

**Verified Fact**: OpenCode subagent routing in 1.18.20 (experimental):
- architect → GLM 4.7 Flash, mode=subagent
- coder → Qwen3-Coder-Next, mode=subagent
- reviewer → GLM 4.7 Flash, mode=subagent
- Per-agent YAML frontmatter `model` field works for routing
- Logs show `agent`, `mode=subagent`, and `modelID` entries confirming routing

**Design Decision**: Model assignments are harness-specific configuration, not part of canonical CMD role definitions.
- Canonical roles in `agents/` do NOT specify models
- OpenCode adapters provide harness-specific model assignments in YAML frontmatter
- This allows different harnesses to use different models for the same role without modifying canonical definitions

### Secondary Subagent Exposure

Security-reviewer, qa-engineer, ui-designer, and docs roles must be exposed as OpenCode subagents for spec-driven workflow execution.

**Design Decision**:
1. Create adapter files for all four roles in `integrations/opencode/agents/`
2. Include `model` field in YAML frontmatter for each adapter
3. Adapters remain thin bindings to canonical roles with no duplicated behavior
4. Repository-specific primary agents can invoke these subagents by role name consistent with OpenCode subagent discovery

### Primary Agent Orchestration

Repository-specific primary agents (e.g., QuackTrack) can orchestrate CMD subagents through:
1. Direct subagent invocation by role name (OpenCode's native subagent support)
2. Multi-subagent delegations within the repository-specific agent's implementation
3. External orchestration patterns documented in repository-specific documentation

The configuration must not mandate a single pattern; this should emerge from repository-specific requirements.

## Risks

### Subagent Routing Behavior (OpenCode 1.18.20)

Verified: YAML frontmatter `description`, `mode=subagent`, and `model` fields successfully route subagents. Logs confirm `agent`, `mode=subagent`, and `modelID` entries.

### Cross-Repository Agent Orchestration

Repository-specific primary agents may have existing patterns for orchestrating subagents. Must investigate without disrupting existing behavior.

### Primary Agent Definition Location

Repository-specific agents (e.g., QuackTrack) are expected to be defined in `.opencode/agents/` or other repository-specific locations. Must ensure consistency with adapter patterns.

### Model Profile Limitation

The local execution profile (GLM 4.7 Flash for architect, reviewer, security-reviewer, qa-engineer, ui-designer, docs; Qwen3-Coder-Next for coder) is a selected choice for this repository, not an OpenCode or CMD requirement, and not a claim of optimality. Different harnesses or repositories may choose different models for the same role.