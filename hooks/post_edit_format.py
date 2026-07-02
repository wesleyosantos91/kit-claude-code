#!/usr/bin/env python3
"""Hook PostToolUse: roda o formatador do projeto após edições de arquivo.

Registre em .claude/settings.json do projeto hospedeiro:

  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "python .claude/hooks/post_edit_format.py" }
        ]
      }
    ]
  }

Adapte FORMATTERS à stack do projeto hospedeiro.
"""
import json
import subprocess
import sys
from pathlib import Path

FORMATTERS = {
    ".py": ["python", "-m", "black", "--quiet"],
    ".js": ["npx", "--no-install", "prettier", "--write"],
    ".ts": ["npx", "--no-install", "prettier", "--write"],
    ".json": ["npx", "--no-install", "prettier", "--write"],
    ".java": [],  # ex.: ["google-java-format", "-i"]
}


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    file_path = payload.get("tool_input", {}).get("file_path", "")
    if not file_path:
        return 0

    cmd = FORMATTERS.get(Path(file_path).suffix)
    if not cmd:
        return 0

    try:
        subprocess.run([*cmd, file_path], check=False, timeout=30)
    except (OSError, subprocess.TimeoutExpired):
        pass  # formatador ausente não deve quebrar o fluxo do agente

    return 0


if __name__ == "__main__":
    sys.exit(main())
