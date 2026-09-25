# Flywheel: Agent Configuration Improvement Loop

Analyze recent sessions to identify patterns where the user had to correct, redirect, or steer the agent — then propose configuration changes to prevent recurrence.

## Process

### Phase 1: Session Analysis

1. **Identify the best correction-evidence source available from the active agent harness.** Prefer structured correction logs, turn indexes, and session/event logs when the harness exposes them. Do not assume a particular harness or filesystem layout.
2. If structured correction signals are available, start with those to identify which sessions are worth deep-diving into. Otherwise, inspect recent session or conversation history directly for user corrections, redirects, repeated instructions, cancellations, and tool failures.
3. Cross-reference available turn/session context to determine what the agent did immediately before each correction. Use timestamps, working-directory metadata, session identifiers, or equivalent harness-provided metadata when available.
4. Read the full conversation context for sessions containing likely correction events (or up to 10 recent sessions when no pre-filtered correction evidence is available).
5. Identify **correction events** — user messages that indicate the agent did something wrong or suboptimal:
   - Explicit corrections: "no, I meant...", "that's wrong", "don't do that", "try again but..."
   - Redirections: "instead, do...", "I said X not Y", "stop", "cancel that"
   - Repeated instructions: user restating something they already said
   - Frustration signals: user simplifying their request after a failed attempt
   - Cancelled turns (`end_reason: "Cancelled"`) followed by a rephrased request
   - Tool failures that required user intervention to resolve
   - Agent making assumptions the user had to correct
6. For each correction event, extract:
   - What the agent did wrong (the assistant message before the correction)
   - What the user wanted instead (the correction message)
   - The underlying principle (what general rule would have prevented this)
   - Which agent was running (`agent_name` from session metadata)

### Phase 2: Pattern Recognition

1. Group correction events by theme (e.g., "output too verbose", "wrong tool choice", "ignored constraint", "hallucinated API")
2. Filter out one-off mistakes — focus on patterns that appear across 2+ sessions or represent a class of error
3. For each pattern, determine if it's:
   - A **steering** issue (general behavioral rule that applies to all agents)
   - A **skill** gap (domain-specific knowledge the agent is missing)
   - An **agent** config issue (specific agent needs different instructions or constraints)

### Phase 3: Cross-Reference Existing Configuration

1. Read all steering docs in the repository: `steering/*.md`
2. Read all skill docs in the repository: `skills/*/SKILL.md`
3. Read all agent prompts in the repository: `agents/*.md`
4. For each identified pattern, check:
   - Is there already a rule that covers this? → If yes, is it too weak or ambiguous?
   - Is there a gap — no rule exists for this class of error?
   - Is an existing rule being ignored? → May need stronger language or a different placement

### Phase 4: Propose Changes

Present findings as a structured report saved to `docs/flywheel-report.md`:

```markdown
# Flywheel Report — YYYY-MM-DD

## Sessions Analyzed
- [session title] (date) — N correction events found
- ...

## Patterns Identified

### Pattern 1: [descriptive name]
**Frequency**: N occurrences across M sessions
**Examples**:
- Session [title]: user said "..." after agent did "..."
- Session [title]: user said "..." after agent did "..."
**Root cause**: [why the agent behaved this way]
**Existing coverage**: [which config file addresses this, if any — or "none"]

**Proposed fix**:
- **Type**: steering | skill | agent-config
- **Target**: [file path — new or existing]
- **Change**: [update existing rule | add new rule | add new skill | modify agent prompt]
- **Draft content**:
  > [the actual content to add or modify]
```

### Phase 5: Interactive Review

After presenting the report:
1. Walk through each proposed change with the user
2. For each proposal, ask: **approve, modify, or skip?**
3. For approved changes:
   - If updating an existing file: show the diff and apply
   - If creating a new file: create it with proper frontmatter/format
   - If `scripts/guardrails/config-drift-guard.sh` is enforced by a wrapper or CI, use the documented approval bypass before writing policy files.
4. For modified changes: incorporate feedback and re-present
5. Summarize all changes made at the end

## Codex Evidence Adapter

When running under Codex with the provided flywheel guardrail helpers, use the following evidence sources. Other harnesses should use their equivalent structured telemetry or conversation/session history as described in Phase 1.

### Corrections Log (preferred Codex starting point)

The `flywheel-correction.sh` helper writes filtered correction-signal prompts to `~/.codex/flywheel-corrections.jsonl`:

```json
{"ts": "2026-04-02T19:16:54Z", "cwd": "/path/to/project", "signals": ["explicit_correction", "redirect"], "prompt": "No, use uv instead of pip", "prompt_len": 26}
```

Each entry represents a user prompt that matched at least one correction pattern. The `signals` array tells you what kind of correction:
- `explicit_correction` — "no, I meant", "that's wrong", "don't do X"
- `redirect` — "instead", "cancel that", "try again", "start over"
- `repeat` — "I already said", "again, but", "why did..."
- `quality` — "too verbose", "you forgot", "you missed"
- `tool_redirect` — "use X instead", "don't use Y"
- `terse` — prompt shorter than 60 characters (often a one-word correction)
- `short_question` — terse prompt ending in "?"

When this Codex helper is installed and producing data, this log is the preferred starting point for finding correction events.

### Turn Index Log (for context)

The `flywheel-log.sh` helper writes a lightweight turn index to `~/.codex/flywheel-log.jsonl`:

```json
{"ts": "2026-04-02T19:16:54Z", "cwd": "/path/to/project", "len": 1234, "head": "first 200 chars...", "tail": "last 200 chars..."}
```

Use this to find what the agent said immediately before a correction — match by timestamp + cwd to the correction entry, then look at the entry just before it in the turn index.

### Full Session Data

Codex stores session data under `~/.codex/sessions/`. Exact filenames may vary by runtime version, but the useful pattern is the same:

- a metadata file with session identifiers, timestamps, and summary fields
- a `.jsonl` event log with user prompts, assistant responses, and tool activity

Key metadata fields for correction detection:
- `end_reason: "Cancelled"` — user interrupted the agent mid-turn
- `end_reason: "UserTurnEnd"` — normal turn completion
- `total_request_count` and `number_of_cycles` — high values may indicate the agent was struggling

## Rules

- Never fabricate correction events — only report what's actually in the session logs
- Be conservative: only propose changes for clear, repeated patterns — not every minor hiccup
- Respect the existing config hierarchy: steering for universal rules, skills for domain knowledge, agent prompts for agent-specific behavior
- New steering docs must include `inclusion: always` frontmatter
- New skill docs must include `name` and `description` frontmatter
- Proposed changes should be minimal and targeted — don't rewrite entire files
- If a pattern is already covered by an existing rule, propose strengthening the language rather than adding a duplicate
- Quote the actual user messages as evidence — don't paraphrase
