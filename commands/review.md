---
description: Revisão de código do diff atual (correção, segurança, contratos, testes).
---

# /review

Delegue ao subagente `code-reviewer` a revisão do diff indicado (padrão:
mudanças não commitadas; senão, a branch atual contra `main`).

Exija veredito **APROVADO | APROVADO COM RESSALVAS | MUDANÇAS NECESSÁRIAS**,
com cada achado citando `arquivo:linha`, severidade da matriz e sugestão
acionável.

## Contexto adicional
$ARGUMENTS
