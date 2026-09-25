# How To Review A GitHub PR With This Framework

Use this guide from inside the repository that owns the pull request you need to review. The PR can be in GitHub; the local agent session should run in the target project checkout.

This process is intentionally step-gated. Do not move to the next step until the current step has completed and the human reviewer says to continue.

## Review Model

This framework treats pull request review as a spec-backed gate:

- `architect` frames the review and keeps the spec current.
- `reviewer` checks correctness, maintainability, spec compliance, tests, and regression risk.
- `security-reviewer` checks security risks separately when the PR touches trust boundaries, auth, data, infrastructure, secrets, or dependencies.
- `qa-engineer` validates behavior separately when the PR changes user-facing or operator-facing behavior.

General code review is not a substitute for security review or QA validation.

## Step 1: Orient The Target Repo Session

Prompt the agent session inside the target repository:

```text
We need to review GitHub PR <PR URL or number> using the repo's AGENTS.md framework.

Do not start reviewing yet. First, orient yourself:
1. Read AGENTS.md.
2. Read SYSTEM_CONTEXT.md if present.
3. Read the mandatory steering docs referenced by AGENTS.md.
4. Identify whether there is an active spec in .cmd/specs/currentspec.md.
5. Check the current git branch and clean/dirty worktree status.
6. Report what framework instructions apply before taking any review action.
```

Expected result:

- The session summarizes repo-specific instructions.
- The session says whether an active spec already exists.
- The session reports branch and worktree state.
- The session does not inspect or judge the PR yet.

Stop here until Step 1 is confirmed complete.

## Step 2: Resolve The PR Context

Prompt:

```text
Step 2: Resolve the GitHub PR context.

Use the PR URL/number I provide: <PR URL or number>.

Gather:
1. PR title, author, base branch, head branch, and current state.
2. PR description/body.
3. List of changed files.
4. Commit list.
5. Existing review status: requested reviewers, approvals, requested changes, unresolved comments if available.
6. CI/check status summary.

Do not perform code review yet. Do not modify files. Report whether the local checkout is on the PR branch, base branch, or some other branch, and whether we need to fetch/switch before reviewing.
```

Expected result:

- The exact PR is known.
- The local checkout relationship to the PR branch is known.
- CI status is green, red, pending, or unknown.
- No findings are produced yet.

Stop here until Step 2 is confirmed complete.

## Step 3: Create Or Resume The Review Spec

Prompt:

```text
Step 3: Create or resume the review spec for this PR.

If an active spec already exists and clearly corresponds to this PR, reuse it.

If no matching active spec exists, create a lightweight review spec:

.cmd/specs/YYYY-MM-DD-pr-<number>-review/spec.md
.cmd/specs/YYYY-MM-DD-pr-<number>-review/tasks.md
.cmd/specs/YYYY-MM-DD-pr-<number>-review/review.md
.cmd/specs/YYYY-MM-DD-pr-<number>-review/security-review.md
.cmd/specs/YYYY-MM-DD-pr-<number>-review/qa.md
.cmd/specs/YYYY-MM-DD-pr-<number>-review/decisions.md

Then write the slug to:

.cmd/specs/currentspec.md

The spec.md should include:
- PR title and URL
- base branch and head branch
- PR goal from the description
- changed file summary
- stated acceptance criteria, if any
- initial risks or unknowns
- whether security review appears required
- whether QA validation appears required

The tasks.md should include ordered groups:
1. PR context and local checkout alignment
2. General code review
3. Security review, only if applicable
4. QA validation, only if applicable
5. Final documentation/review summary

Do not review the code yet. Only create or resume the spec and task plan.
```

Expected result:

- `.cmd/specs/currentspec.md` points to the PR review spec.
- `spec.md` describes the PR and review scope.
- `tasks.md` has review, QA, and security gates as needed.
- No code-review findings are produced yet.

Stop here until Step 3 is confirmed complete.

## Step 4: Align Local Checkout

Prompt:

```text
Step 4: Align the local checkout for review.

Read .cmd/specs/currentspec.md, then read the active spec and tasks.

Confirm:
1. Current branch.
2. Whether the PR head branch is available locally.
3. Whether the worktree is clean.
4. Whether switching branches would overwrite or conflict with local changes.

If safe, fetch the PR branch and check it out locally.

If the PR comes from the same repo, prefer checking out the PR head branch.

If the PR comes from a fork, fetch the PR ref into a local review branch, for example:
git fetch origin pull/<PR_NUMBER>/head:review/pr-<PR_NUMBER>
git switch review/pr-<PR_NUMBER>

After checkout, report:
- branch now checked out
- latest commit SHA
- whether it matches the PR head SHA
- worktree status

Do not review the code yet.
```

Expected result:

- The local checkout is on the exact PR code to review.
- The checked-out SHA is confirmed against GitHub's PR head SHA.
- Any local-change risk is surfaced before switching.

Stop here until Step 4 is confirmed complete.

## Step 5: Build The Review Baseline

Prompt:

```text
Step 5: Build the review baseline.

Read .cmd/specs/currentspec.md, then read the active spec and tasks.

Determine the merge base between the PR branch and base branch.

Inspect the diff from merge base to PR head:
- file list
- added/removed lines summary
- changed tests
- changed docs
- changed dependency/config/build files
- changed public APIs, routes, schemas, migrations, permissions, or environment variables

Also inspect relevant surrounding code for the changed areas. Do not rely only on the diff.

Update the active spec or decisions.md if you discover important scope facts that were missing, such as:
- undocumented behavior changes
- new dependencies
- missing acceptance criteria
- security-sensitive surfaces
- QA scenarios that need validation

Do not produce review findings yet unless there is an immediate blocker like "cannot determine base branch" or "PR branch does not match GitHub head".
```

Expected result:

- The PR's actual change surface is understood.
- The spec or decisions file captures missing context.
- Security review and QA scope are confirmed or corrected.

Stop here until Step 5 is confirmed complete.

## Step 6: Run The General Code Review

Prompt:

```text
Step 6: Run the general code review.

Act as the reviewer role from agents/reviewer.md.

Read:
1. .cmd/specs/currentspec.md
2. the active spec.md
3. the active tasks.md
4. decisions.md, if present
5. agents/reviewer.md
6. the PR diff from merge base to PR head
7. relevant surrounding code, not just changed lines
8. relevant tests

Review for:
- spec compliance
- correctness
- edge cases
- error handling
- performance risks
- maintainability
- test coverage
- regression risk

Do not review security issues here except to note that security-reviewer must inspect them separately.

Run the relevant test commands if they are known and reasonably available. If no test command is known, inspect the repo scripts/config and identify the most appropriate verification command.

Write findings to:

.cmd/specs/<active-slug>/review.md

Use this verdict rule:
- FAIL if any Critical or Warning findings exist
- FAIL if relevant tests fail or cannot be run for a blocking reason
- PASS only if zero Criticals, zero Warnings, and relevant tests pass

Do not modify source files.
```

Expected result:

- `review.md` contains Critical, Warning, Suggestion, Tests, and Verdict sections.
- Findings have `file:line` references and concrete remediation.
- The session reports PASS or FAIL.

Stop here until Step 6 is confirmed complete.

## Step 7: Triage A Failed Review

Only run this step if Step 6 verdict is `FAIL`.

Prompt:

```text
Step 7: Triage the failed review.

Read:
1. .cmd/specs/currentspec.md
2. the active review.md
3. the active spec.md
4. the active tasks.md

Summarize the failed review findings into:
- Critical findings
- Warning findings
- Suggestions, clearly marked non-blocking
- Failed or missing verification commands

For each Critical and Warning, identify:
- whether it is definitely actionable
- the smallest likely fix
- which files would need to change
- whether the fix requires author/product clarification
- what test or validation should prove the fix

Then append a new task group to tasks.md:

## Group N: Review fixes
- [ ] Fix <finding summary> | `<relevant files>`
  - **Accept**: <measurable expected result>
  - **Verify**: <specific command>
  - **Constraints**: <any known gotchas>

Do not modify implementation files yet.
Do not mark the fix tasks complete.
```

Expected result:

- There is a clean blocker list.
- `tasks.md` has a fix group for all Critical and Warning findings.
- Suggestions remain optional and non-blocking unless explicitly promoted.

Stop here until Step 7 is confirmed complete.

## Step 8: Choose Local Fixes Or Author Feedback

If the agent should implement fixes locally, prompt:

```text
Step 8: Implement the review fixes locally.

Read .cmd/specs/currentspec.md and the active tasks.md.

Implement only the Group N: Review fixes tasks.
Do not address Suggestions unless they are explicitly included as fix tasks.
Do not make unrelated refactors.
Preserve any user or author changes already in the worktree.
Run each task's Verify command.
Mark each fix task [x] only after its verification passes.
If a task cannot be completed safely, mark it [!] and explain the blocker under the task.
```

If feedback should go to the PR author instead, prompt:

```text
Step 8: Prepare PR author feedback.

Read .cmd/specs/currentspec.md and the active review.md.

Draft concise GitHub review feedback grouped by:
- blocking Critical findings
- blocking Warning findings
- optional Suggestions
- test/verification notes

For each blocking item, include:
- file:line
- what is wrong
- why it matters
- the requested change

Do not post the review yet. Prepare the text for me to approve first.
```

Expected result:

- Either local fixes are implemented and verified, or a ready-to-post PR review draft exists.

Stop here until Step 8 is confirmed complete.

## Step 9: Review And Post The Feedback

Run this step when feedback was drafted for the PR author.

Prompt:

```text
Step 9: Prepare to post the PR review.

Show me the drafted PR review feedback exactly as it would be posted.

Classify the GitHub review action as one of:
- COMMENT: non-blocking general feedback only
- REQUEST_CHANGES: at least one Critical or Warning finding blocks merge
- APPROVE: review verdict is PASS and there are no blocking findings

Because review.md verdict is FAIL, default to REQUEST_CHANGES unless I explicitly override.

Do not post anything yet.
Wait for my approval.
```

After approving the exact wording and action, instruct the session to post the review.

Expected result:

- The exact review body is shown before posting.
- The session recommends `REQUEST_CHANGES` for failed reviews.
- Nothing is posted until explicitly approved.

Stop here until Step 9 is confirmed complete.

## Step 10: Record The Review Outcome

Prompt:

```text
Step 10: Record the review outcome.

Read .cmd/specs/currentspec.md, then update the active spec files.

In review.md, append a short "GitHub Review Posted" note with:
- date
- PR URL
- GitHub review action used: COMMENT, REQUEST_CHANGES, or APPROVE
- summary of blocking items posted
- whether local source files were modified: no

In tasks.md:
- mark the general code review task [x] if review.md was completed
- mark the review feedback/posting task [x], if such a task exists
- leave review fix tasks unchecked if the PR author is expected to address them
- add a note that fixes are pending from the PR author

Do not clear .cmd/specs/currentspec.md yet because the PR still has blocking review findings.
```

Expected result:

- The local review spec records what was posted to GitHub.
- The spec remains active for the next review cycle.
- It is clear whether the next step waits for author changes or local fixes.

Stop here until Step 10 is confirmed complete.

## Step 11: Pause For Author Updates

Prompt:

```text
Step 11: Pause the review workflow.

Do not clear .cmd/specs/currentspec.md.
Do not continue to security review, QA, or documentation yet unless I explicitly ask.

The current state is:
- GitHub review was posted.
- Review verdict is FAIL.
- Blocking fixes are pending from the PR author.

Report the exact command or GitHub check I should use later to detect new PR activity, such as:
- gh pr view <PR_NUMBER> --json headRefOid,latestReviews,reviewDecision,comments,commits,statusCheckRollup
- git fetch followed by comparing the previous reviewed SHA to the current PR head SHA

Then stop.
```

Expected result:

- The target session pauses cleanly.
- The active spec remains in place.
- There is a clear way to resume when the PR changes.

## Resuming After Author Updates

When the PR author pushes new commits or responds to review feedback:

1. Re-run Step 2 to refresh GitHub context.
2. Re-run Step 4 to update the local checkout and confirm the reviewed SHA.
3. Re-run Step 5 against the new PR head.
4. Re-run Step 6 as the next review cycle.
5. If the general review passes, run security review and QA when the spec says they apply.
6. When all required gates pass, update final documentation or review summary records and clear `.cmd/specs/currentspec.md`.

## PASS Path

If Step 6 returns `PASS`:

1. Run `security-reviewer` if the spec says security review applies.
2. Run `qa-engineer` if the spec says QA validation applies.
3. Post an `APPROVE` review only after all required gates pass.
4. Record the posted review in `review.md`.
5. Update final review documentation or summary records.
6. Clear `.cmd/specs/currentspec.md` only when the PR review workflow is complete.
