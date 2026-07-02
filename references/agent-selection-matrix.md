# Matriz de seleção de agentes

O orquestrador usa esta matriz. Acione o **mínimo viável** — nunca todos por padrão.

| Demanda | Agentes / skills |
|---|---|
| Bug simples | corrigir direto com teste de regressão (skill `analise-de-codigo` se precisar de diagnóstico) |
| Mudança de domínio/feature | plano curto → implementação → `code-reviewer` |
| Mudança de API | `code-reviewer` (atenção a breaking changes) + `pre-pr-review` |
| Mudança sensível (auth, credenciais, entrada de usuário) | `security-reviewer` |
| Risco de carga/performance | `performance-reliability-reviewer` |
| Pré-PR | skill `pre-pr-review` (orquestra testes + secrets + `code-reviewer`) |
| Qualidade Java | skill `java-quality-gate` (`verify-all.sh`) |
| Documentação / ADR | `tech-writer` |
| Pesquisa ampla no codebase | agente de exploração read-only |

Princípios:

- Não acionar todos por padrão; preservar headroom de contexto.
- Consolidar conflitos entre achados priorizando as regras deste harness
  (`review-severity-matrix.md`, `evidence-rules.md`).
