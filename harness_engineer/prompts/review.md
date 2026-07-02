# Prompt: review

Revise o diff atual; não implemente. Avalie: arquitetura e pacotes
(`skills/java-quality-gate/config/package-organization.md`); SOLID e riscos de
design; testes (unit, regressão de bugfix, integration quando há dependência
externa); thresholds de cobertura/mutação se configurados; segurança (sem
secrets/destrutivo). Se seguro: `bash .claude/scripts/quality/verify-all.sh --fast`.

Saída: lista priorizada com `arquivo:linha`, severidade pela matriz
(`references/review-severity-matrix.md`) e evidência (`references/evidence-rules.md`).
