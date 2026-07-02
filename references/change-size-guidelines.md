# Diretrizes de tamanho de mudança

Mudanças menores = review melhor, menos risco, diffs auditáveis.

| Tamanho | Linhas (aprox.) | Recomendação |
|---|---|---|
| Pequena | < 150 | Ideal |
| Média | 150–400 | Aceitável; revisar com atenção |
| Grande | > 400 | Quebrar em partes; justificar se não for possível |

- Uma mudança = um objetivo coeso.
- Se a descrição precisa de "e" três vezes, são três mudanças.
- A skill `pr-description` sugere split automático acima de 500 linhas/10 arquivos.
