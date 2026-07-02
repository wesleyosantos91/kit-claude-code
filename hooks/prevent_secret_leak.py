#!/usr/bin/env python3
"""Hook PreToolUse: bloqueia escrita de conteúdo contendo secrets.

Registre em .claude/settings.json do projeto hospedeiro:

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "python .claude/hooks/prevent_secret_leak.py" }
        ]
      }
    ]
  }

Protocolo: recebe o payload da chamada de ferramenta via stdin (JSON).
Exit code 0 = permite; exit code 2 = bloqueia (stderr é mostrado ao agente).
Nunca imprime o valor do secret — apenas o tipo detectado.
"""
import json
import re
import sys

SECRET_PATTERNS = [
    (r"AKIA[0-9A-Z]{16}", "AWS Access Key ID"),
    (r"aws_secret_access_key\s*[:=]", "AWS Secret Access Key"),
    (r"-----BEGIN [A-Z ]*PRIVATE KEY-----", "chave privada PEM"),
    (r"""password\s*[:=]\s*["'][^"']{6,}["']""", "senha hardcoded"),
    (r"""token\s*[:=]\s*["'][A-Za-z0-9_\-]{16,}["']""", "token hardcoded"),
    (r"sk-(live|proj|ant)-[A-Za-z0-9_\-]{10,}", "API key (formato sk-*)"),
    (r"ghp_[A-Za-z0-9]{36}", "GitHub personal access token"),
]


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    tool_input = payload.get("tool_input", {})
    content = tool_input.get("content", "") or tool_input.get("new_string", "")
    if not content:
        return 0

    for pattern, label in SECRET_PATTERNS:
        if re.search(pattern, content, re.IGNORECASE):
            file_path = tool_input.get("file_path", "<desconhecido>")
            print(
                f"[hook prevent_secret_leak] BLOQUEADO: possível '{label}' "
                f"no conteúdo destinado a {file_path}. "
                "Use variável de ambiente ou secret manager em vez de hardcode.",
                file=sys.stderr,
            )
            return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
