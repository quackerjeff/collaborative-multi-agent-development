# OpenCode Harness Integration — Architectural Summary

**Date**: 2026-09-26
**Task**: Re-evaluate active CMD specification for OpenCode harness integration
**Status**: Specification updated and corrected

---

## Corrected Architecture

### Key Correction: Removed Unverified Centralization Pattern

**Previous approach (REJECTED)**:
- Proposed `integrations/opencode/config.json` as central model mapping source
- Proposed adapter loader and fallback mechanism for backward compatibility
- Proposed warning system for missing config.json
- Proposed `config.json` modelMappings for all roles and repository agents

**Corrected approach (VERIFIED)**:
- Model assignments are **YAML frontmatter fields** in adapter files themselves
- OpenCode 1.18.20 routes subagents using `description`, `mode=subagent`, and `model` fields
- No central configuration file is required or verified
- No adapter loader, loader fallback, or warning system needed

### Supported Pattern: YAML Frontmatter Model Assignment

**Verified Fact from experiments**:
```yaml
---
description: CMD architect for research, specification, planning, and task decomposition
mode: subagent
model: ollama/glm-4.7-flash:latest
---
```

This is the only mechanism we have verified working. It's stable and reliable.

### Architecture Diagram (Corrected)

```
agents/                    (canonical, harness-independent)
  ├── architect.md         (role definition, no harness-specific fields)
  ├── coder.md             (role definition, no harness-specific fields)
  ├── reviewer.md          (role definition, no harness-specific fields)
  ├── security-reviewer.md (role definition, no harness-specific fields)
  ├── qa-engineer.md       (role definition, no harness-specific fields)
  ├── ui-designer.md       (role definition, no harness-specific fields)
  └── docs.md              (role definition, no harness-specific fields)

integrations/opencode/
  └── agents/              (harness-specific adapters with YAML frontmatter models)
      ├── architect.md     (includes description, mode=subagent, model)
      ├── coder.md         (includes description, mode=subagent, model)
      ├── reviewer.md      (includes description, mode=subagent, model)
      ├── security-reviewer.md (new, includes frontmatter with model)
      ├── qa-engineer.md   (new, includes frontmatter with model)
      ├── ui-designer.md   (new, includes frontmatter with model)
      └── docs.md          (new, includes frontmatter with model)
```

### Design Principles Maintained

1. **Canonical roles remain harness-independent** — no model assignments in `agents/*`
2. **Adapters are thin bindings** — reference canonical roles but add harness-specific frontmatter
3. **Verified mechanisms only** — use what we've tested, don't invent configuration patterns
4. **No centralization** — model per adapter, not per central config

---

## Distinction: Verified Behavior vs Design Decisions

### VERIFIED OPENCODE BEHAVIOR

These are confirmed through experimentation:

1. **Subagent routing mechanism** — OpenCode 1.18.20 uses YAML frontmatter to route subagents by matching adapter file names to role names
2. **Required frontmatter fields** — `description`, `mode=subagent`, and `model` successfully assign models
3. **Agent discovery** — New project agent files become available after restarting OpenCode
4. **Active spec convention** — `.cmd/specs/currentspec.md` remains the canonical pointer
5. **Log visibility** — Execution logs show `agent`, `mode=subagent`, and `modelID` confirming routing

### CMD DESIGN DECISIONS

These are architectural choices independent of OpenCode:

1. **Canonical role harness-agnosticism** — CMD roles contain only responsibilities and behaviors
2. **Adapter pattern** — Harnesses provide thin bindings that reference canonical roles
3. **Secondary role exposure** — Security-reviewer, qa-engineer, ui-designer, docs must be exposed for spec workflows
4. **Model profile flexibility** — Repository can choose models per role, but for this context we're using GLM 4.7 Flash and Qwen3-Coder-Next

### UNRESOLVED RESEARCH QUESTIONS

These require investigation in Group 1:

1. **Repository-specific primary agent location** — Where exactly are agents like QuackTrack defined? In `.opencode/agents/` or elsewhere? How do they invoke subagents?
2. **Model profile appropriateness** — Is GLM 4.7 Flash appropriate for all roles, or should different models be used for different responsibilities?
3. **Cross-harness model assignment patterns** — Does this YAML frontmatter approach work across OpenCode versions, or are there other valid patterns we haven't discovered?
4. **Multi-harness portability** — How easily can these adapters be adapted to work with other CMD-supported harnesses?

---

## Remaining Research Questions

1. **Primary Agent Definition and Orchestration**
   - Where are repository-specific agents defined?
   - Do they currently invoke subagents? If so, how?
   - What patterns should we adopt for orchestrating multiple subagents?

2. **Model Profile Optimization**
   - Are the current choices (GLM 4.7 Flash for all non-coder roles, Qwen3-Coder-Next for coder) optimal?
   - Should different roles use different models based on task complexity and requirements?
   - Are there model capabilities or performance characteristics that suggest different assignments?

3. **Adapter Portability**
   - Will this YAML frontmatter approach be stable across OpenCode versions?
   - Are there alternative valid configuration patterns we haven't verified?
   - How would we adapt adapters if OpenCode changes its subagent routing mechanism?

---

## Implementation Task Groups

### Group 1: Research and OpenCode Behavior Verification (RESEARCH-ONLY)
- Verify YAML frontmatter routing mechanism
- Investigate adapter file format
- Research primary agent location and orchestration
- Determine model profile appropriateness
- Create research findings in docs/tech.md

**Stop Condition**: All research completed, findings documented. No implementation allowed.

### Group 2: Create Remaining OpenCode Adapters (IMPLEMENTATION)
- Create security-reviewer adapter
- Create qa-engineer adapter
- Create ui-designer adapter
- Create docs adapter

**Expected Adapters**:
- All four adapters must match the structure of existing verified adapters
- Each includes `description`, `mode=subagent`, and `model` in YAML frontmatter
- Content references canonical roles in `agents/*`

### Group 3: Verify Model Assignment Consistency
- Ensure all adapters use consistent model choices
- Align with research findings in docs/tech.md
- Verify only GLM 4.7 Flash and Qwen3-Coder-Next are used

### Group 4: Documentation Update
- Update docs/integration.md
- Create/expand docs/harness-integration.md with architecture and pattern documentation
- Explain verified mechanisms and research questions

### Group 5: Code Review Gate
- Delegated to reviewer role
- Must achieve PASS before proceeding

### Group 6: QA Validation Gate
- Delegated to qa-engineer role
- Validate integration behavior and completeness

### Group 7: Specification Completion
- Delete .cmd/specs/currentspec.md
- All previous groups must pass

---

## Summary

**What we fixed**:
- Removed unverified `config.json` and adapter loader patterns
- Confirmed YAML frontmatter as the only verified model assignment mechanism
- Clarified that model assignments are harness-specific, not role-specific
- Maintained harness-independence of canonical CMD roles

**What remains as research**:
- Primary agent location and orchestration patterns
- Model profile optimization
- Adapter portability across OpenCode versions
- Alternative configuration patterns we haven't discovered

**What we won't implement**:
- Central config.json for model mappings
- Adapter loader with fallback warnings
- Model discovery or compatibility layer
- Any OpenCode mechanism not verified through experimentation

The specification now correctly reflects verified OpenCode behavior while maintaining CMD's harness-agnostic design principles.