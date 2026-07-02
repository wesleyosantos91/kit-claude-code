---
description: Checklist completo antes de abrir PR (GO/NO-GO).
---

# /pre-pr

Execute a skill `pre-pr-review` na branch atual: analise o escopo do diff,
rode os testes do projeto, varra secrets, delegue a revisão ao subagente
`code-reviewer` e consolide o veredito **GO/NO-GO** por item.

Severidade pela matriz `references/review-severity-matrix.md`; achados seguem
`references/evidence-rules.md`.

## Contexto adicional
$ARGUMENTS
