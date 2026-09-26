# OpenCode Harness Integration

## Overview

OpenCode is a supported CMD harness. This document describes how to use OpenCode with the CMD role definitions.

## Architecture Overview

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
      ├── architect.md     (references agents/architect.md, YAML frontmatter with model)
      ├── coder.md         (references agents/coder.md, YAML frontmatter with model)
      ├── reviewer.md      (references agents/reviewer.md, YAML frontmatter with model)
      ├── security-reviewer.md (references agents/security-reviewer.md, YAML frontmatter with model)
      ├── qa-engineer.md   (references agents/qa-engineer.md, YAML frontmatter with model)
      ├── ui-designer.md   (references agents/ui-designer.md, YAML frontmatter with model)
      └── docs.md          (references agents/docs.md, YAML frontmatter with model)
```

### Canonical Roles (Harness-Independent)

CMD role definitions in `agents/` remain canonical and harness-independent. These files contain role responsibilities, behaviors, and specifications for how a subagent should function when executing as that role.

```
agents/
├── architect.md         (role definition, not harness-specific)
├── coder.md             (role definition, not harness-specific)
├── reviewer.md          (role definition, not harness-specific)
├── security-reviewer.md (role definition, not harness-specific)
├── qa-engineer.md       (role definition, not harness-specific)
├── ui-designer.md       (role definition, not harness-specific)
└── docs.md              (role definition, not harness-specific)
```

### OpenCode Adapters (Thin Bindings)

OpenCode adapters in `integrations/opencode/agents/` are thin runtime bindings with YAML frontmatter that specify model assignments. Adapters reference canonical role definitions and add harness-specific configuration.

```
integrations/opencode/agents/
├── architect.md         (references agents/architect.md, YAML frontmatter with model)
├── coder.md             (references agents/coder.md, YAML frontmatter with model)
├── reviewer.md          (references agents/reviewer.md, YAML frontmatter with model)
├── security-reviewer.md (references agents/security-reviewer.md, YAML frontmatter with model)
├── qa-engineer.md       (references agents/qa-engineer.md, YAML frontmatter with model)
├── ui-designer.md       (references agents/ui-designer.md, YAML frontmatter with model)
└── docs.md              (references agents/docs.md, YAML frontmatter with model)
```

### OpenCode Adapter YAML Frontmatter Pattern

Each adapter file uses YAML frontmatter with the following required fields:

```yaml
---
description: CMD <role> for <responsibilities>
mode: subagent
model: ollama/<model-id>:<tag>
---

You are the OpenCode adapter for the CMD <role> role.

[Instructional content referencing the canonical role definition]
```

**Required fields:**
- `description`: Role description string
- `mode: subagent`: Required for OpenCode subagent routing
- `model`: Model identifier (e.g., `ollama/glm-4.7-flash:latest`)

**Verified behavior:** OpenCode 1.18.20 routes subagents using YAML frontmatter. Logs show `agent`, `mode=subagent`, and `modelID` entries confirming routing.

## Local Execution Profile

The selected local execution profile for this repository uses:

| Role | Model |
|------|-------|
| architect | ollama/glm-4.7-flash:latest |
| coder | ollama/qwen3-coder-next:latest |
| reviewer | ollama/glm-4.7-flash:latest |
| security-reviewer | ollama/glm-4.7-flash:latest |
| qa-engineer | ollama/glm-4.7-flash:latest |
| ui-designer | ollama/glm-4.7-flash:latest |
| docs | ollama/glm-4.7-flash:latest |

This profile is a repository-specific choice, not an OpenCode or CMD requirement. Different harnesses or repositories may choose different models for the same role.

## Agent Discovery

During testing with OpenCode 1.18.20, newly added project agents became available after restarting OpenCode.

## Subagent Invocation

OpenCode's native subagent support enables role-based invocation. Repository-specific primary agents can invoke CMD subagents by role name using OpenCode's native subagent functionality.

### Verifying Subagent Routing

Check OpenCode logs for entries containing:
- `agent`: The agent name (role name)
- `mode=subagent`: Confirms subagent execution mode
- `modelID`: The resolved model identifier

**Example log entry:**
```
[INFO] providerID=ollama modelID=qwen3-coder-next:latest agent=coder mode=subagent
```

## Integration Files

| Location | Purpose |
|----------|---------|
| `agents/*.md` | Canonical role definitions (harness-independent) |
| `integrations/opencode/agents/*.md` | OpenCode thin adapters with YAML frontmatter |
| `docs/tech.md` | Verified OpenCode behaviors and configuration patterns |
| `docs/integration.md` | This file |

## Constraints

- Do NOT modify canonical role definitions
- Do NOT duplicate role behavior in adapters
- Do NOT add config.json, loaders, fallback mechanisms, or compatibility layers
- Do NOT invent unsupported OpenCode configuration mechanisms
