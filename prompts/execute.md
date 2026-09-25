# Execute Current Spec

Read `.cmd/specs/currentspec.md` to resolve the active spec slug.
Read the spec at `.cmd/specs/<slug>/spec.md` and the task list at `.cmd/specs/<slug>/tasks.md`.

Execute all incomplete task groups in order. For each group:

1. **Classify each task by owner** before executing:
   - Research / API verification → execute yourself (Architect) using your tools
   - UI design → delegate to `ui-designer`
   - Implementation → delegate to `coder` subagent
   - Infrastructure / deploy → delegate to `ops` subagent
   - Review gate → delegate to `reviewer` subagent (then `security-reviewer`)
   - QA gate → delegate to `qa-engineer`
   - Documentation → delegate to `docs` subagent
2. Execute your tasks first — subagent tasks may depend on research output (e.g., `docs/tech.md`)
3. If subagents are available, delegate implementation tasks in parallel where no dependencies exist
4. Verify all tasks are marked `[x]` before proceeding to the next group
5. Run the mandatory review and security-review gates, plus any QA gate required by the spec and `steering/quality-engineering.md` — do not skip applicable gates
6. If review fails, create fix tasks and re-run

Continue until all groups are complete and all reviews pass.
