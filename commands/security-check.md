---
description: Revisão de segurança defensiva (secrets, OWASP, authN/authZ) com GO/NO-GO.
---

# /security-check

Delegue ao subagente `security-reviewer` a varredura do diff/módulo indicado
(padrão: branch atual contra `main`).

Escopo: secrets hardcoded, OWASP Top 10, authN/authZ, dependências vulneráveis.
Saída: achados por severidade + veredito **GO/NO-GO** de segurança. Valores de
secrets sempre mascarados.

## Contexto adicional
$ARGUMENTS
