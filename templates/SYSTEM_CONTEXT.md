# System Context

Use this file to ground AI agents in what this repository is, what it owns, and how it fits into the larger system.

Keep this file concise, factual, and current.

## Repository Identity

- Repository name: `<repo-name>`
- Service or application name: `<service-name>`
- Primary language(s): `<languages>`
- Primary framework(s): `<frameworks>`
- Deployable unit: `<api|worker|web app|library|batch job|mobile app|other>`

## Business Capability

This repository exists to:
- `<capability 1>`
- `<capability 2>`
- `<capability 3>`

Primary user or system served:
- `<user persona, client system, or internal platform consumer>`

## What This Repo Owns

- `<owned APIs>`
- `<owned background jobs>`
- `<owned database schema or migrations>`
- `<owned UI surfaces>`
- `<owned events or messages>`

## What This Repo Does Not Own

- `<adjacent service boundaries>`
- `<shared platform responsibilities>`
- `<external systems controlled elsewhere>`

## Upstream Dependencies

Systems this repo depends on:

- `<service/library/platform>`
  - purpose: `<why it is needed>`
  - contract location: `<doc or repo path>`
  - failure impact: `<what breaks if unavailable>`

## Downstream Consumers

Systems or teams that depend on this repo:

- `<consumer>`
  - dependency type: `<API|event|artifact|UI embed|shared package>`
  - compatibility concern: `<versioning, schema stability, SLA, etc.>`

## Contracts

Source-of-truth contracts for this repo:

- `<OpenAPI path>`
- `<event schema path>`
- `<protobuf or shared type path>`
- `<external contract doc>`

Rules:
- do not guess contracts
- verify before implementing
- record confirmed usage patterns in `docs/tech.md`

## Data and State

Persistent state owned here:
- `<database>`
- `<cache>`
- `<blob store>`

Important invariants:
- `<invariant 1>`
- `<invariant 2>`

## Environments and Deployment

Deployment environments:
- `<local>`
- `<dev>`
- `<staging>`
- `<production>`

Deployment notes:
- `<pipeline or hosting notes>`
- `<rollout constraints>`
- `<migration sequencing>`

## Operational Risks

Known failure modes or sensitive areas:
- `<external dependency instability>`
- `<migration risk>`
- `<high-volume path>`
- `<security/compliance risk>`

Observability references:
- `<logs>`
- `<dashboards>`
- `<alerts>`

## Adjacent Repositories

Related repositories the agent may need to know about:

- `<repo-name>`
  - relationship: `<upstream|downstream|shared lib|frontend|backend|ops>`
  - why it matters: `<reason>`

## Working Rules For AI Agents

- Prefer local repo facts over assumptions.
- Keep active implementation specs in `.cmd/specs/` within this repo.
- For cross-repo work, document dependencies and rollout order in the active spec.
- If this file is stale or incomplete, call that out explicitly rather than inventing missing architecture facts.

## Maintenance

Update this file when:
- ownership changes
- contracts move
- major dependencies change
- deployment topology changes
- the repo boundary changes
