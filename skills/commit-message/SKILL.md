---
name: commit-message
description: Gera mensagem de commit seguindo Conventional Commits. Use quando pedirem para commitar, criar mensagem de commit ou preparar commit.
---

# Skill: Commit Message (Conventional Commits)

## Objetivo

Gerar mensagens de commit consistentes no padrão Conventional Commits,
uma mudança lógica por commit.

## Quando usar

Ao commitar ou quando pedirem uma mensagem de commit.

## Quando NÃO usar

Para descrever o PR inteiro — use a skill `pr-description`.

## Inputs esperados

- Mudanças staged (`git diff --cached`) ou o diff completo.

## Workflow

1. Analise as mudanças staged (`git diff --cached`) ou todas (`git diff`).
2. Identifique a natureza da mudança e escolha o `type`.
3. Se houver mudanças independentes misturadas, sugira commits separados.
4. Gere a mensagem no formato abaixo.

## Formato

```
<type>(<scope>): <description>

[body opcional — explique o "por quê", não o "o quê"]

[footer opcional — BREAKING CHANGE, referências]
```

Types: `feat` | `fix` | `refactor` | `docs` | `test` | `chore` | `perf` | `style`

Regras:

- `description` no imperativo, lowercase, sem ponto final, máximo 72 caracteres.
- `scope` opcional — use quando clarifica (`feat(auth):`, `fix(orders):`).
- `body` só quando o "por quê" não é óbvio.
- `BREAKING CHANGE:` no footer quando aplicável.

## Saída esperada

```
feat(orders): add pagination to list orders endpoint

refactor(auth): extract token validation to dedicated service

Previously scattered across three controllers. Centralizing
reduces duplication and makes rotation easier.
```

## Segurança

- Nunca incluir secrets/tokens no corpo da mensagem.
- Nunca commitar sem que o usuário tenha pedido; nunca usar `--no-verify`.
