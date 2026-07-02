#!/usr/bin/env python3
"""Runner de avaliação: executa cenários YAML contra o Claude Code headless.

Uso:
    python harness_engineer/run_eval.py --scenarios harness_engineer/scenarios/

Requisitos: Python 3.10+, PyYAML (pip install pyyaml), Claude Code CLI no PATH.
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

import yaml


@dataclass
class Result:
    name: str
    passed: bool
    failures: list[str] = field(default_factory=list)


def run_scenario(scenario_path: Path) -> Result:
    spec = yaml.safe_load(scenario_path.read_text(encoding="utf-8"))
    name = spec.get("name", scenario_path.stem)
    expectations = spec.get("expectations", {})
    failures: list[str] = []

    with tempfile.TemporaryDirectory(prefix="claude-eval-") as workdir:
        for rel_path, content in (spec.get("setup", {}).get("files", {}) or {}).items():
            target = Path(workdir) / rel_path
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content, encoding="utf-8")

        proc = subprocess.run(
            ["claude", "-p", spec["prompt"], "--output-format", "json"],
            cwd=workdir,
            capture_output=True,
            text=True,
            timeout=spec.get("timeout_seconds", 300),
        )

    try:
        output_text = json.loads(proc.stdout).get("result", proc.stdout)
    except json.JSONDecodeError:
        output_text = proc.stdout

    expected_exit = expectations.get("expect_exit_code")
    if expected_exit is not None and proc.returncode != expected_exit:
        failures.append(f"exit code {proc.returncode}, esperado {expected_exit}")

    for needle in expectations.get("expect_contains", []) or []:
        if needle not in output_text:
            failures.append(f"saída não contém: {needle!r}")

    for needle in expectations.get("expect_not_contains", []) or []:
        if needle in output_text:
            failures.append(f"saída contém (proibido): {needle!r}")

    return Result(name=name, passed=not failures, failures=failures)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--scenarios", type=Path, required=True,
                        help="Diretório com cenários .yaml")
    args = parser.parse_args()

    scenario_files = sorted(args.scenarios.glob("*.yaml"))
    if not scenario_files:
        print(f"Nenhum cenário encontrado em {args.scenarios}", file=sys.stderr)
        return 1

    results = [run_scenario(path) for path in scenario_files]

    print("\n=== Resultado da Avaliação ===")
    for result in results:
        status = "PASS" if result.passed else "FAIL"
        print(f"[{status}] {result.name}")
        for failure in result.failures:
            print(f"       - {failure}")

    failed = sum(1 for r in results if not r.passed)
    print(f"\n{len(results) - failed}/{len(results)} cenários passaram")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
