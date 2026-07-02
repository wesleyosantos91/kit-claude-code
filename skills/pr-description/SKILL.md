---
name: pr-description
description: Gera descrição de Pull Request estruturada a partir dos commits e do diff da branch. Use quando pedirem para criar PR, descrever PR ou preparar PR description.
---

# Skill: PR Description

## Objetivo

Gerar uma descrição de Pull Request clara, agrupada por área funcional,
focada no "por quê" da mudança.

## Quando usar

Ao abrir/atualizar um PR ou quando pedirem a descrição.

## Quando NÃO usar

Para mensagem de um commit individual (use `commit-message`) ou para o gate
de aprovação (use `pre-pr-review`).

## Inputs esperados

- Branch alvo (padrão: diff contra `main`).

## Workflow

1. Analise os commits da branch (`git log main...HEAD --oneline`).
2. Analise os arquivos alterados (`git diff main...HEAD --stat`).
3. Leia os diffs para entender a natureza completa da mudança.
4. Se o PR for grande demais (>500 linhas, >10 arquivos), sugira split antes.
5. Gere a descrição.

## Saída esperada

```markdown
## Summary
<!-- 1-3 frases: O QUE e POR QUÊ -->

## Changes
- **area**: descrição da mudança (agrupado por área, não por arquivo)

## Breaking Changes
<!-- só se houver — o que quebra e como migrar -->

## Test Plan
- [ ] Testes unitários passando
- [ ] Testes de integração passando
- [ ] Testado manualmente: [cenários]

## Notes for Reviewers
<!-- contexto que ajuda na revisão -->
```

Regras: Summary foca no "por quê" (o diff mostra o "o quê"); mesmo idioma do projeto.

## Segurança

- Nunca expor secrets/credenciais na descrição (valores de env, tokens de exemplo reais).
