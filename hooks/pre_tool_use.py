#!/usr/bin/env python3
"""Hook PreToolUse: bloqueia comandos perigosos antes da execução.

Registre em .claude/settings.json do projeto hospedeiro:

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "python .claude/hooks/pre_tool_use.py" }
        ]
      }
    ]
  }

Protocolo: recebe o payload da chamada de ferramenta via stdin (JSON).
Exit code 0 = permite; exit code 2 = bloqueia (stderr é mostrado ao agente).
"""
import json
import re
import sys

BLOCKED_PATTERNS = [
    (r"\brm\s+-rf\s+[/~]", "rm -rf em caminho raiz/home"),
    (r"\bgit\s+push\s+.*--force\b", "git push --force"),
    (r"\bgit\s+reset\s+--hard\b", "git reset --hard"),
    (r"\bDROP\s+(TABLE|DATABASE)\b", "SQL destrutivo"),
    (r"chmod\s+777", "chmod 777"),
]


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0  # payload ilegível: não bloqueia, apenas ignora

    command = payload.get("tool_input", {}).get("command", "")
    if not command:
        return 0

    for pattern, label in BLOCKED_PATTERNS:
        if re.search(pattern, command, re.IGNORECASE):
            print(
                f"[hook pre_tool_use] BLOQUEADO: '{label}' detectado no comando. "
                "Peça aprovação explícita ao usuário.",
                file=sys.stderr,
            )
            return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
