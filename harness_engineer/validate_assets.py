#!/usr/bin/env python3
"""Valida a estrutura das skills e subagentes do template.

Checa frontmatter obrigatório e seções mínimas para que os arquivos sejam
descobertos corretamente pelo Claude Code e sigam o padrão do template.

Uso:
    python harness_engineer/validate_assets.py

Sem dependências externas. Exit code 0 = tudo válido; 1 = falhas encontradas.
Rode antes de commitar mudanças em skills/ ou agents/ (serve como pre-commit).
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

SKILL_REQUIRED_SECTIONS = [
    "Objetivo",
    "Quando usar",
    "Quando NÃO usar",
    "Inputs esperados",
    ("Workflow", "Passos"),  # qualquer um dos dois satisfaz
    "Saída esperada",
]
SECURITY_NOTE_RE = re.compile(r"destrutiv|nunca|somente leitura|secrets", re.IGNORECASE)


def parse_frontmatter(text: str) -> dict[str, str] | None:
    if not text.startswith("---"):
        return None
    match = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not match:
        return None
    fields: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if ":" in line and not line.startswith((" ", "\t", "#")):
            key, _, value = line.partition(":")
            fields[key.strip()] = value.strip()
    return fields


def check_file(path: Path, required_keys: list[str],
               required_sections: list[str | tuple[str, ...]]) -> list[str]:
    errors: list[str] = []
    text = path.read_text(encoding="utf-8")

    frontmatter = parse_frontmatter(text)
    if frontmatter is None:
        errors.append("sem frontmatter YAML (--- ... ---)")
    else:
        for key in required_keys:
            if not frontmatter.get(key):
                errors.append(f"frontmatter sem campo obrigatório '{key}'")

    for section in required_sections:
        options = section if isinstance(section, tuple) else (section,)
        if not any(re.search(rf"^##\s+{re.escape(opt)}", text, re.MULTILINE)
                   for opt in options):
            errors.append(f"falta seção '## {' | '.join(options)}'")

    if not SECURITY_NOTE_RE.search(text):
        errors.append("(aviso) sem nota de segurança/restrição explícita")

    return errors


def main() -> int:
    fail_count = 0
    checked = 0

    skills = sorted((REPO_ROOT / "skills").glob("*/SKILL.md"))
    subagents = sorted((REPO_ROOT / "agents").glob("*.md"))

    print("=== Validando skills ===")
    for path in skills:
        checked += 1
        errors = check_file(path, ["name", "description"], SKILL_REQUIRED_SECTIONS)
        hard_errors = [e for e in errors if not e.startswith("(aviso)")]
        status = "OK  " if not hard_errors else "FAIL"
        print(f"[{status}] {path.relative_to(REPO_ROOT)}")
        for error in errors:
            print(f"       - {error}")
        fail_count += len(hard_errors)

    print("\n=== Validando subagentes ===")
    for path in subagents:
        checked += 1
        errors = check_file(path, ["name", "description"], [])
        hard_errors = [e for e in errors if not e.startswith("(aviso)")]
        status = "OK  " if not hard_errors else "FAIL"
        print(f"[{status}] {path.relative_to(REPO_ROOT)}")
        for error in errors:
            print(f"       - {error}")
        fail_count += len(hard_errors)

    print(f"\n{checked} arquivo(s) verificados, {fail_count} erro(s).")
    return 1 if fail_count else 0


if __name__ == "__main__":
    sys.exit(main())
