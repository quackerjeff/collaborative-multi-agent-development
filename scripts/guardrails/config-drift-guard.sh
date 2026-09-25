#!/bin/bash
# Guardrail: Block writes to framework configuration files unless explicitly approved.
# Exit 0 = allow, Exit 2 = block (returns STDERR to LLM)
#
# Protected paths: AGENTS.md, agents/, steering/, skills/, prompts/, scripts/guardrails/
# To allow config writes, set AGENT_ALLOW_CONFIG_WRITES=1.
set -euo pipefail

[ "${AGENT_ALLOW_CONFIG_WRITES:-}" = "1" ] && exit 0

EVENT=$(cat)

# Use realpath to resolve symlinks and normalize path traversal.
_HOOK_EVENT="$EVENT" python3 << 'PYEOF'
import json, sys, os

ROOT = os.getcwd()
PROTECTED = [
    os.path.join(ROOT, "AGENTS.md"),
    os.path.join(ROOT, "agents"),
    os.path.join(ROOT, "steering"),
    os.path.join(ROOT, "skills"),
    os.path.join(ROOT, "prompts"),
    os.path.join(ROOT, "scripts", "guardrails"),
]

try:
    event = json.loads(os.environ['_HOOK_EVENT'])
except (KeyError, json.JSONDecodeError) as e:
    print(f"Guardrail error: failed to parse event: {e}", file=sys.stderr)
    sys.exit(1)

inp = event.get('tool_input', {})
ops = inp.get('ops', [inp])

for op in ops:
    path = op.get('path', '')
    if not path:
        continue
    resolved = os.path.realpath(os.path.expanduser(path))
    for protected in PROTECTED:
        if resolved.startswith(protected + os.sep) or resolved == protected:
            print("BLOCKED: Writing to framework configuration files requires explicit approval.", file=sys.stderr) 
            print(f"File: {resolved}", file=sys.stderr)
            print("Ask the user to approve this change before proceeding.", file=sys.stderr)
            sys.exit(2)

sys.exit(0)
PYEOF

exit $?
