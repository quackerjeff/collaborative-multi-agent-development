# OpenCode Harness Integration for CMD

## Overview

This document summarizes the verified behaviors and configuration patterns for using OpenCode as a CMD harness. OpenCode 1.18.20 supports CMD role-based subagents via YAML frontmatter configuration.

## Verified OpenCode Behaviors

### Subagent Routing via YAML Frontmatter

**Verified Fact**: OpenCode 1.18.20 routes subagents using YAML frontmatter. The following fields are required:

- `description`: Role description string (required for identification)
- `mode: subagent`: Required for OpenCode subagent routing (required)
- `model`: Model identifier (required for model assignment)

**Example YAML frontmatter:**

```yaml
---
description: CMD architect for research, specification, planning, and task decomposition
mode: subagent
model: ollama/glm-4.7-flash:latest
---
```

### Model Assignment Pattern

The local execution profile for this repository uses:

| Role | Model | YAML field |
|------|-------|------------|
| architect | ollama/glm-4.7-flash:latest | model |
| coder | ollama/qwen3-coder-next:latest | model |
| reviewer | ollama/glm-4.7-flash:latest | model |
| security-reviewer | ollama/glm-4.7-flash:latest | model |
| qa-engineer | ollama/glm-4.7-flash:latest | model |
| ui-designer | ollama/glm-4.7-flash:latest | model |
| docs | ollama/glm-4.7-flash:latest | model |

**Design Decision**: Model assignments are harness-specific configuration, not part of canonical CMD role definitions. Canonical roles in `agents/` do not specify models. OpenCode adapters provide harness-specific model assignments in YAML frontmatter. This allows different harnesses to use different models for the same role without modifying canonical definitions.

### OpenCode Agent Discovery

**Verified Fact:** Project agents in `.opencode/agents/` are discovered after restarting OpenCode. Adding new adapter files requires an OpenCode restart to become available as configurable subagents. (We verified this behavior with OpenCode 1.18.20.)

### Logging and Verification

**Verified Fact**: Successful subagent routing can be verified from OpenCode logs. Look for entries containing:

- `agent`: The agent name (role name)
- `mode=subagent`: Confirms subagent execution mode
- `modelID`: The resolved model identifier

**Example log pattern:**
```
[INFO] providerID=ollama modelID=qwen3-coder-next:latest agent=coder mode=subagent
```

## Adapter Files

All OpenCode adapters are thin bindings to canonical CMD roles. The following adapter files exist:

| File | Canonical Role | Model |
|------|----------------|-------|
| `integrations/opencode/agents/architect.md` | `agents/architect.md` | ollama/glm-4.7-flash:latest |
| `integrations/opencode/agents/coder.md` | `agents/coder.md` | ollama/qwen3-coder-next:latest |
| `integrations/opencode/agents/reviewer.md` | `agents/reviewer.md` | ollama/glm-4.7-flash:latest |
| `integrations/opencode/agents/security-reviewer.md` | `agents/security-reviewer.md` | ollama/glm-4.7-flash:latest |
| `integrations/opencode/agents/qa-engineer.md` | `agents/qa-engineer.md` | ollama/glm-4.7-flash:latest |
| `integrations/opencode/agents/ui-designer.md` | `agents/ui-designer.md` | ollama/glm-4.7-flash:latest |
| `integrations/opencode/agents/docs.md` | `agents/docs.md` | ollama/glm-4.7-flash:latest |

## Canonical Role Definitions

The canonical CMD role definitions live in `agents/` and are harness-independent. OpenCode adapters reference these canonical definitions and add harness-specific YAML frontmatter for model assignment.

| Canonical Role | Location | Harness-Independent |
|----------------|----------|---------------------|
| architect | `agents/architect.md` | Yes |
| coder | `agents/coder.md` | Yes |
| reviewer | `agents/reviewer.md` | Yes |
| security-reviewer | `agents/security-reviewer.md` | Yes |
| qa-engineer | `agents/qa-engineer.md` | Yes |
| ui-designer | `agents/ui-designer.md` | Yes |
| docs | `agents/docs.md` | Yes |

## Subagent Invocation

OpenCode's native subagent support enables role-based invocation without requiring repository-specific orchestration code. Repository-specific primary agents can invoke CMD subagents by role name using OpenCode's native subagent functionality.

## Configuration Constraints

- Do NOT invent unsupported OpenCode configuration mechanisms
- Do NOT modify canonical role definitions
- Do NOT duplicate role behavior in adapters (adapters are thin bindings)
- Do NOT add config.json, loaders, fallback mechanisms, or compatibility layers
- Local model profile (GLM 4.7 Flash, Qwen3-Coder-Next) is a repository-specific choice, not an OpenCode or CMD requirement

## Verification Steps

1. Check adapter files exist in `integrations/opencode/agents/`
2. Verify YAML frontmatter contains `mode: subagent`
3. Confirm model assignments match local execution profile
4. Restart OpenCode after adding new adapter files
5. Check OpenCode logs for `agent`, `mode=subagent`, and `modelID` entries to verify routing
