# Multi-Agent Development Framework

A structured, role-based framework for AI-assisted software development.

The framework defines a spec-driven development process, specialized agent roles,
handoff boundaries, reusable workflow prompts, repository guidance, and guardrails.
These workflow concepts are independent of any particular model or agent harness.

Codex is a first-class supported harness. `AGENTS.md` remains the Codex-native
entry point and tells Codex how to run the workflow, where to store specs, which
role cards to use, and which steering documents to follow.

Other agent harnesses may use the same role definitions, specifications, steering
rules, prompts, skills, and guardrails through harness-specific integration.

## Overview

This sample keeps eight core roles:

| Role | Responsibility |
|------|----------------|
| `architect` | Research, planning, spec creation, orchestration |
| `ui-designer` | User flows, visual hierarchy, interaction states, frontend handoff |
| `coder` | Feature implementation and tests |
| `ops` | Infrastructure, CI/CD, containers, operational changes |
| `reviewer` | Correctness, maintainability, and spec compliance review |
| `qa-engineer` | Validation strategy, regression coverage, scenario testing, release confidence |
| `security-reviewer` | Security-only review |
| `docs` | README, architecture docs, runbooks, and inline docs |

Typical flow:

```text
architect -> ui-designer + coder + ops -> reviewer -> security-reviewer + qa-engineer -> docs -> architect
```

When the active harness supports subagents, the architect should delegate parallel work using the role cards in `agents/`. When subagents are unavailable, the same roles can be executed sequentially while preserving their responsibilities, boundaries, review gates, and stop conditions.

For product-surface work, `ui-designer` should usually participate before code is finalized so `coder` is implementing a defined interaction rather than inventing one. For non-trivial delivery work, `qa-engineer` should validate behavior after implementation instead of treating code review alone as the release gate.

## Repository Model

This sample uses a few simple conventions:

| Concern | Convention |
|---------|------------|
| Repository instructions | `AGENTS.md` |
| Role definitions | Markdown role cards in `agents/` |
| Active spec work | `.cmd/specs/...` |
| Reusable workflows | Prompt templates in `prompts/` |
| Policy enforcement helpers | Guardrail scripts in `scripts/guardrails/` |

See [OPERATIONAL_FLOW.md](OPERATIONAL_FLOW.md) for the delivery sequence and [REPOSITORY_TOPOLOGY.md](REPOSITORY_TOPOLOGY.md) for monorepo vs multi-repo guidance.

For multi-repo systems, use the starter templates in [templates/SATELLITE_AGENTS.md](templates/SATELLITE_AGENTS.md) and [templates/SYSTEM_CONTEXT.md](templates/SYSTEM_CONTEXT.md) when seeding service repositories.
Use [BOOTSTRAPPING.md](BOOTSTRAPPING.md), [scripts/seed-repo.sh](scripts/seed-repo.sh), and [scripts/seed-repo.ps1](scripts/seed-repo.ps1) to create new service repositories from CMD profiles on macOS/Linux or Windows.
For a concrete prompt flow after seeding a frontend repo, see [FIRST_UI_REPO_SESSION.md](FIRST_UI_REPO_SESSION.md).
For a concrete prompt flow after seeding an API repo, see [FIRST_API_REPO_SESSION.md](FIRST_API_REPO_SESSION.md).
For a concrete prompt flow after seeding a worker repo, see [FIRST_WORKER_REPO_SESSION.md](FIRST_WORKER_REPO_SESSION.md).
For a concrete prompt flow after seeding a platform repo, see [FIRST_PLATFORM_REPO_SESSION.md](FIRST_PLATFORM_REPO_SESSION.md).
For a step-gated GitHub pull request review workflow, see [HOW_TO_PR_REVIEW.md](HOW_TO_PR_REVIEW.md).

## Quick Start

1. Put this directory at the root of the project you want an AI coding agent to work on, or copy its contents into an existing repository.
2. Make the guardrail scripts executable:

```bash
chmod +x scripts/guardrails/*.sh
```

3. Start your AI coding agent in the repository root. For Codex:

```bash
codex
```

4. Ask the agent to read [AGENTS.md](AGENTS.md) and begin with one of the workflow prompts in `prompts/`.

Example:

```text
Read AGENTS.md, then use prompts/scope.md to open a new spec for ...
```

## Repository Structure

```text
├── AGENTS.md                # Repository instructions and orchestration rules
├── agents/                  # Role cards for architect, ui-designer, coder, reviewer, qa-engineer, ops, docs
├── prompts/                 # Reusable workflow prompts for agent sessions
├── steering/                # Global behavioral rules referenced by AGENTS.md
├── skills/                  # Agent-agnostic domain knowledge files
├── scripts/guardrails/      # Standalone guardrail utilities for wrappers/CI/git hooks
├── templates/               # Starter files and manifests for seeding satellite service repositories
├── BOOTSTRAPPING.md
├── FIRST_API_REPO_SESSION.md
├── FIRST_PLATFORM_REPO_SESSION.md
├── FIRST_UI_REPO_SESSION.md
├── FIRST_WORKER_REPO_SESSION.md
├── HOW_TO_PR_REVIEW.md
├── README.md
├── OPERATIONAL_FLOW.md
├── REPOSITORY_TOPOLOGY.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
└── LICENSE
```

## Specs and Issues

Specs live under `.cmd/specs/`:

```text
.cmd/specs/currentspec.md
.cmd/specs/YYYY-MM-DD-<slug>/
  spec.md
  tasks.md
  review.md
  security-review.md
  qa.md
  decisions.md
```

This repository includes a complete example spec at [`.cmd/specs/2026-07-12-account-settings-refresh/`](.cmd/specs/2026-07-12-account-settings-refresh/) showing how `ui-designer`, `coder`, `reviewer`, `security-reviewer`, `qa-engineer`, and `docs` fit together in one realistic feature workflow.

Issue investigation folders live at:

```text
issues/YYYY-MM-DD-<slug>/
  report.md
  summary.md
```

## Guardrails

The guardrails are provided as standalone scripts rather than assuming a specific runtime hook system.

Use them in one of three ways:

1. From a harness wrapper or hook mechanism
2. From git hooks or pre-commit checks
3. From CI jobs that validate generated changes

See [scripts/guardrails/README.md](scripts/guardrails/README.md).

## Prompts

The files in `prompts/` are reusable workflow definitions:

| Prompt | Purpose |
|--------|---------|
| `scope.md` | Start a new spec and task plan |
| `execute.md` | Run the active spec to completion |
| `diagnose.md` | Test-first bug fixing from `issues/` reports |
| `flywheel.md` | Review correction patterns and improve repo guidance |

Treat these as prompt templates: paste them into the session or tell the agent to follow a specific file.

## Skills

The `skills/` directory is copied over unchanged because it is already agent-agnostic. Those files work as reference material regardless of which coding agent is driving the session.

## UI Design

UI design is treated as a first-class role in this framework. Use [agents/ui-designer.md](agents/ui-designer.md) together with [steering/frontend-design.md](steering/frontend-design.md) when a spec changes user-facing screens, flows, or component behavior.

## Quality Engineering

Quality engineering is distinct from code review in this sample. Use [agents/qa-engineer.md](agents/qa-engineer.md) together with [steering/quality-engineering.md](steering/quality-engineering.md) when a spec needs scenario validation, regression coverage, or a clearer release-confidence signal.
