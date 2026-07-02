# Política de quality gates

Fonte: build do projeto + `scripts/quality/`. Orquestrador: `verify-all.sh`.

| Gate | Regra | Bloqueia? |
|---|---|---|
| Spotless | formatação | Sim, se configurado e falhar |
| Checkstyle | estilo | Sim, se configurado e falhar |
| Unit tests | JUnit 5 | Sim |
| Integration | Failsafe `*IT` (quando há dependência externa) | Sim, se houver IT sem runner |
| JaCoCo | line+branch >= 90% | Sim (quando há código mensurável) |
| PIT | mutation score >= 90% | Sim (quando há código mutável) |
| ArchUnit / package-rules | isolamento do domínio | Sim |

Regras:

- **Nunca** baixar thresholds para facilitar o build.
- Gate ausente (plugin não configurado) = reportar como ausente, não falha injusta.
- Não esconder falhas; explicar causa e correção.
