# Guardrail Scripts

These scripts provide optional policy enforcement and logging helpers for this repository.

Treat them as standalone utilities that can be integrated with the active agent harness or development workflow:

- call them from a harness wrapper or hook mechanism
- wire them into git hooks
- run them from CI before accepting generated changes

Codex does not read a repo-local hook manifest here, so Codex users can call these scripts from a local wrapper around `codex`.

## Event Format

Most scripts intentionally use a JSON-on-stdin contract so they can be called from harness wrappers, hook mechanisms, or CI without much glue.

Typical payloads:

```json
{"cwd":"/path/to/repo","prompt":"user text"}
{"cwd":"/path/to/repo","assistant_response":"assistant text"}
{"tool_input":{"command":"terraform destroy"}}
{"tool_input":{"ops":[{"path":"package.json","content":"..."}]}}
```

`validate-environment.sh` is the exception: it can be run directly with no payload.

The flywheel scripts are optional Codex logging helpers. They currently write Codex-specific telemetry under `~/.codex/`; other harnesses may provide their own equivalent evidence sources for the flywheel workflow.
