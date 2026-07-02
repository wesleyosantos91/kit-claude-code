---
name: pre-pr-review
description: Checklist técnico final antes de abrir ou atualizar um PR, com veredito GO/NO-GO. Use quando o usuário disser "revise antes do PR", "posso abrir o PR?" ou "checklist de PR".
---

# Skill: Pre-PR Review

## Objetivo

Consolidar um veredito **GO / NO-GO** antes de abrir ou atualizar um Pull Request,
verificando diff, testes, secrets e qualidade em uma única passada.

## Quando usar

Antes de abrir ou atualizar um PR, como último gate da branch.

## Quando NÃO usar

Durante o loop de desenvolvimento — para análise pontual de código use a skill
`analise-de-codigo`; para revisão de segurança profunda, o subagente `security-reviewer`.

## Inputs esperados

- Branch/diff alvo (padrão: diff da branch atual contra `main`).

## Workflow

1. **Diff:** `git diff main...HEAD --stat` — confira se o escopo bate com a intenção
   do PR (arquivos inesperados = achado).
2. **Testes:** rode o comando de testes do projeto (ver `CLAUDE.md`, seção
   "Contexto do Projeto Hospedeiro"). Falha = NO-GO automático.
3. **Secrets:** varra o diff por credenciais (`git diff main...HEAD | grep -iE
   'password|token|secret|api[_-]?key|BEGIN.*PRIVATE'`). Achado = NO-GO automático.
4. **Revisão:** delegue o diff ao subagente `code-reviewer`.
5. **Consolidação:** monte o relatório GO/NO-GO por item.

## Saída esperada

```markdown
## Pre-PR Review — <branch>

| Item | Status | Observação |
|---|---|---|
| Escopo do diff | ✅/❌ | |
| Testes | ✅/❌ | |
| Secrets | ✅/❌ | |
| Code review | ✅/⚠️/❌ | |

**Veredito: GO | NO-GO** — <justificativa em 1 frase>
```

## Segurança

- Nunca rodar comandos destrutivos (rm -rf, git reset --hard, terraform apply,
  kubectl delete).
- Nunca expor o valor de secrets encontrados — apenas `arquivo:linha` mascarado.
