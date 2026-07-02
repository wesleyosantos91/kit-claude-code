# Matriz de severidade de review

Use para classificar achados de forma consistente em **todas** as revisões
(`code-reviewer`, `security-reviewer`, `analise-de-codigo`, `pre-pr-review`).

| Severidade | Critério | Ação |
|---|---|---|
| **CRÍTICO** | Quebra build/segurança/dados; secret exposto; breaking change de API sem versionamento; viola isolamento do domínio | **Bloqueia** (NO-GO) |
| **ALTO** | Gap de cobertura em regra de negócio; bugfix sem teste de regressão; risco de resiliência relevante (sem timeout/retry em chamada externa) | Corrigir antes do merge |
| **MÉDIO** | Legibilidade, duplicação, idiomatismo da linguagem, observabilidade incompleta | Corrigir ou registrar como follow-up |
| **BAIXO** | Estilo, nomenclatura, melhorias opcionais | Opcional |

Regras:

- Separe sempre **críticos** (bloqueiam) de **melhorias** (não bloqueiam).
- Nunca infle severidade para chamar atenção, nem rebaixe para "passar".
- Todo achado segue as [regras de evidência](evidence-rules.md).
