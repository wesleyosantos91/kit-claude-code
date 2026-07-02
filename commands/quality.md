---
description: Executa e interpreta os quality gates Java (Spotless, Checkstyle, JaCoCo, PIT, ArchUnit).
---

# /quality

Execute a skill `java-quality-gate` via orquestrador de gates:

```bash
bash .claude/scripts/quality/verify-all.sh --fast   # (--full antes de PR)
```

Leia o resumo em `.claude/harness_engineer/results/quality-summary.md` e
consolide o veredito **GO/NO-GO**.

Regras: nunca relaxar thresholds para passar; gate ausente ≠ falha (reporte e
sugira adotar os configs de `skills/java-quality-gate/config/`).

## Contexto adicional
$ARGUMENTS
