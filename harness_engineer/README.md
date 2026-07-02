# Harness Engineer

Ambiente de engenharia do harness: validação de prompts, cenários de regressão,
benchmark do agente e relatórios. Nada aqui é carregado automaticamente pelo
Claude Code em runtime — é ferramenta para evoluir e medir o template com
segurança. O manifesto central do harness é o `harness.yaml` na raiz do template.

## Estrutura

| Caminho | Propósito |
|---|---|
| `prompts/` | Prompts operacionais (plan, review, quality, debug, implement-tdd) para uso headless/CI e como base de cenários |
| `scenarios/` | Cenários de avaliação em YAML (entrada + critérios de sucesso) |
| `run_eval.py` | Executa os cenários contra o Claude Code em modo headless |
| `validate_assets.py` | Valida frontmatter e seções obrigatórias de `skills/` e `agents/` |
| `results/` | Relatórios gerados (quality-summary, benchmarks) — gitignored |

Scripts de runtime relacionados (fora daqui, em `scripts/`):

- `scripts/ai/preflight.sh` — estado do repo + varredura de secrets + resumo do projeto (rodar antes de tarefas grandes).
- `scripts/ai/detect-project.sh` — detecção de build tool, framework, gates presentes.
- `scripts/quality/verify-all.sh` — orquestrador dos quality gates (`--fast`/`--full`).

## Validação estrutural (rode antes de commitar)

```bash
python harness_engineer/validate_assets.py
```

Falha (exit 1) se alguma skill/subagente estiver sem frontmatter `name`/`description`
ou sem as seções obrigatórias (Objetivo, Quando usar, Quando NÃO usar, Inputs
esperados, Workflow/Passos, Saída esperada).

## Avaliação comportamental (headless)

```bash
# Requer o Claude Code CLI autenticado; cada cenário gasta uma chamada
python harness_engineer/run_eval.py --scenarios harness_engineer/scenarios/
```

O runner roda `claude -p "<prompt>" --output-format json` por cenário e checa
`expect_contains` / `expect_not_contains` / `expect_exit_code`.

Cenários atuais: revisão detecta segredo hardcoded (`exemplo_revisao`),
orquestrador delega ao agente certo (`delegacao_correta`), skill de commit gera
Conventional Commits (`commit_conventional`).

## Quando adicionar um cenário

- Sempre que alterar o `CLAUDE.md` (mudança de comportamento do orquestrador).
- Sempre que um subagente ou skill produzir um resultado errado em uso real —
  transforme o caso em cenário de regressão antes de corrigir.

## Uso dos prompts em CI

```bash
claude -p "$(cat .claude/harness_engineer/prompts/review.md)" --output-format json
```
