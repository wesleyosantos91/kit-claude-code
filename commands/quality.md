---
description: Executa e interpreta os quality gates Java (Spotless, Checkstyle, JaCoCo, PIT, ArchUnit).
---

# /quality

Execute a skill `java-quality-gate`: detecte os gates configurados no projeto,
rode-os do mais barato ao mais caro e consolide o resumo com veredito
**GO/NO-GO**.

Regras: nunca relaxar thresholds para passar; gate ausente ≠ falha (reporte e
sugira adotar os configs de `skills/java-quality-gate/config/`).

## Contexto adicional
$ARGUMENTS
