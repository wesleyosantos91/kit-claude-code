# Harness Engineer

Ambiente de testes e avaliação do agente: validação de prompts, cenários de
regressão e benchmarks. Nada aqui é carregado pelo Claude Code em runtime —
é ferramenta de engenharia para evoluir o template com segurança.

## Estrutura

| Caminho | Propósito |
|---|---|
| `scenarios/` | Cenários de avaliação em YAML (entrada + critérios de sucesso) |
| `run_eval.py` | Executa os cenários contra o Claude Code em modo headless |
| `validate_assets.py` | Valida frontmatter e seções obrigatórias de `skills/` e `agents/` |
| `results/` | Saída dos benchmarks (gitignored) |

## Validação estrutural (rode antes de commitar)

```bash
python harness_engineer/validate_assets.py
```

Falha (exit 1) se alguma skill/subagente estiver sem frontmatter `name`/`description`
ou sem as seções obrigatórias (Objetivo, Quando usar, Quando NÃO usar, Inputs
esperados, Workflow/Passos, Saída esperada).

## Como rodar uma avaliação

```bash
# Requer o Claude Code CLI instalado e autenticado
python harness_engineer/run_eval.py --scenarios harness_engineer/scenarios/
```

O runner usa `claude -p "<prompt>" --output-format json` (modo headless) para
cada cenário e verifica os critérios (`expect_contains`, `expect_exit_code`).

## Quando adicionar um cenário

- Sempre que alterar o `CLAUDE.md` (mudança de comportamento do orquestrador).
- Sempre que um subagente ou skill produzir um resultado errado em produção —
  transforme o caso em cenário de regressão antes de corrigir.
