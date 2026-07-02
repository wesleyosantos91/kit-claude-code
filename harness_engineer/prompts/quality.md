# Prompt: quality

Modos: `fast` → `verify-all.sh --fast`; `full` → `verify-all.sh --full`;
`coverage` → `jacoco.sh`; `mutation` → `mutation-test.sh`; `arch` → `archunit.sh`
(scripts em `.claude/scripts/quality/`).

Depois, mostre `.claude/harness_engineer/results/quality-summary.md`. Não esconda
falhas: explique causa e correção. Gate ausente = ausente (não falha); aponte
`skills/java-quality-gate/config/pom-quality-plugins.example.xml` para habilitar.
