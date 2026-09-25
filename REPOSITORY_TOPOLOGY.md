# Repository Topology Guide

This document explains how to choose between a monorepo and multiple repositories when using Collaborative Multi-Agent Development (CMD), and how to keep AI workflow guidance aligned across a multi-repo system.

## Recommendation Summary

CMD does not require a monorepo. It works with either a monorepo or multiple repositories.

Choose repository topology based on:
- system boundaries
- team ownership
- release cadence
- security and compliance boundaries
- how often changes must land across components together

For AI-assisted delivery, prefer the simplest topology that preserves clear ownership and stable boundaries.

In practice:
- Start with a monorepo or modular monolith when product boundaries are still moving.
- Split into multiple repositories when services are genuinely independent in ownership, release cycle, runtime, or compliance boundary.
- Avoid splitting early just because the runtime architecture may eventually be distributed.

## Monorepo vs Multi-Repo

### Prefer a Monorepo When

Use a monorepo when:
- the same team frequently changes multiple components together
- contracts and shared types change often
- frontend and backend must evolve in lockstep
- cross-cutting refactors are common
- the system is still being discovered and boundaries are not yet stable

Benefits for AI-assisted development:
- broader local context for planning and implementation
- easier contract tracing across components
- simpler repo-level specs for vertical slices
- fewer synchronization failures between service boundaries

Costs:
- larger codebase context
- stricter repository hygiene needed
- more care required around ownership boundaries inside one repo

### Prefer Multiple Repositories When

Use multiple repositories when:
- services are owned by different teams
- services release independently
- interfaces are stable and versioned
- operational, security, or compliance boundaries differ
- some repos must remain isolated from others

Benefits:
- clear ownership
- independent release management
- narrower blast radius for changes
- easier enforcement of service-specific controls

Costs for AI-assisted development:
- less ambient context per session
- higher risk of contract drift
- more explicit handoff documentation required
- more coordination work across repos

## Recommended Default

If you are unsure, prefer a well-structured monorepo or modular monolith first.

Move to multiple repositories only when you can state a concrete reason such as:
- separate team ownership
- materially different deployment cadence
- a security boundary
- a compliance boundary
- a stable service contract that can evolve independently

## Using CMD Across Multiple Repositories

For a multi-repo system, do not rely on a central CMD repository as the only place where workflow instructions live.

That usually looks attractive at first, but it creates practical problems:
- the agent may not have the shared repo in session context
- relative links break across environments and clones
- local repo rules become implicit instead of explicit
- the service repo becomes dependent on external documentation availability
- versioning the workflow with the code becomes harder

A better pattern is a hybrid model:
- keep one central CMD repository as the canonical source
- place a thin local CMD bootstrap in every service repository
- sync shared workflow files from the canonical source on a deliberate cadence
- allow each service repository to add local context and overrides

## Recommended Hybrid Model

### Canonical Shared CMD Repository

Keep one central repository as the source of truth for shared workflow assets:
- role cards
- prompt templates
- steering documents
- guardrails
- common examples
- topology and workflow guidance

This repo should change relatively slowly and be reviewed like internal platform guidance.

### Thin Local Bootstrap in Each Service Repository

Each service repository should still contain a minimal local CMD footprint.

At minimum:
- `AGENTS.md`
- `.codex/specs/`
- `SYSTEM_CONTEXT.md`
- `docs/tech.md`
- optionally synced copies of `agents/`, `prompts/`, `steering/`, and `scripts/guardrails/`

The local files should answer:
- what this repo owns
- what it depends on
- which upstream and downstream systems matter
- where the canonical CMD source lives
- which local constraints override shared defaults

## What To Put In Each Satellite Repository

For each service repository, create these local files.

### `AGENTS.md`

This should be local to the repository. It should not merely say "go read another repo" and stop.

It should include:
- the default role flow for this repo
- the path or URL of the canonical shared CMD source
- the rule that local repo instructions take precedence when they conflict with shared guidance
- which local documents must be read first

Example structure:

```md
# Service AI Workflow

Use the shared CMD framework as the base workflow standard for this repository.

Canonical workflow source:
- ../cmd-shared/    
  or
- internal docs / repo URL

Read in this order:
1. `SYSTEM_CONTEXT.md`
2. `docs/tech.md`
3. local `AGENTS.md`
4. then shared CMD guidance referenced above

Local repository rules override shared defaults when they conflict.

This repository owns:
- ...

This repository depends on:
- ...
```

### `SYSTEM_CONTEXT.md`

This is the most important file for multi-repo AI work.

It should describe:
- the business capability this repo owns
- system boundaries
- upstream systems
- downstream systems
- API or event contracts owned here
- links to source-of-truth contract docs
- deployment environments
- operational risks
- adjacent repositories the agent may need to know about

### `docs/tech.md`

Use this for confirmed patterns only:
- framework usage
- package choices
- known integration constraints
- verified API usage
- deployment or runtime caveats

### Local Spec Directory

Keep `.codex/specs/` local to the repo.

Even in a multi-repo system, implementation specs should live beside the code being changed. Cross-repo work can reference companion specs in other repos, but do not centralize all active specs into one external repo.

## How To Keep Repositories Aligned

Good options, in descending order of practicality:

### Option 1. Copy and Sync Deliberately

Copy the shared CMD assets into each repo and update them intentionally when the canonical source changes.

Good when:
- repo autonomy matters
- teams do not want Git submodules
- local customization is expected

Recommended for most teams.

### Option 2. Git Subtree

Use a subtree to pull shared CMD assets into each repo.

Good when:
- you want shared history for the scaffold
- you want easier updates than manual copy
- your team is comfortable with subtree workflows

This is often the best technical compromise.

### Option 3. Git Submodule

Use a submodule only if your team already handles submodules well.

Risks:
- developers forget to initialize or update it
- broken onboarding flow
- the agent may encounter missing files in partially initialized clones

Usually not the best default.

### Option 4. External Link Only

Do not make this your primary model.

A repo that only links to shared CMD without local bootstrap instructions is fragile. The AI and the humans both lose local clarity.

## Recommended Standard for Satellite Repositories

For most multi-repo systems, use this standard:

1. Maintain one canonical shared CMD repository.
2. Copy or subtree the shared `agents/`, `prompts/`, `steering/`, and `scripts/guardrails/` into each service repo.
3. Keep a local `AGENTS.md` in every repo.
4. Keep a local `SYSTEM_CONTEXT.md` in every repo.
5. Keep active specs in the local repo.
6. Document local overrides explicitly instead of silently modifying shared files.

## Local Override Rule

In a satellite repository, precedence should be:

1. active spec under `.codex/specs/...`
2. local `AGENTS.md`
3. local `SYSTEM_CONTEXT.md` and `docs/tech.md`
4. copied or linked shared CMD assets
5. generic agent defaults

This keeps the agent grounded in the codebase it is actually changing.

## What To Avoid

Avoid these patterns:
- a service repo with no local `AGENTS.md`
- a service repo that depends on a path outside the clone to be intelligible
- centralizing all active specs outside the code repo being changed
- splitting repos before ownership and contracts are stable
- assuming AI alignment comes from shared files alone rather than from clear local context

## Suggested Rollout Pattern

If you expect several repos in one system:

1. Establish the canonical CMD repo.
2. Define a standard satellite layout.
3. Create `AGENTS.md` and `SYSTEM_CONTEXT.md` templates for service repos.
4. Seed each service repo with the shared workflow assets.
5. Add service-specific context and local rules.
6. Review and refresh the shared assets on a scheduled cadence.

Starter templates for steps 3 and 4 are provided in:
- `templates/SATELLITE_AGENTS.md`
- `templates/SYSTEM_CONTEXT.md`

If you want repeatable service-repo creation, use `scripts/seed-repo.sh` together with the manifests under `templates/profiles/`.

## Bottom Line

A common CMD source is a good idea.

Using that common source as the only place where instructions live is not.

Use a shared canonical CMD repository plus thin local repo bootstrap files. That gives you alignment without sacrificing local clarity, versioning, or execution reliability.
