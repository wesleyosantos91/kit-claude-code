# Prompt: plan

> Para uso headless (`claude -p "$(cat .claude/harness_engineer/prompts/plan.md)"`)
> ou como base de cenários de avaliação.

Diagnostique e planeje **sem editar código**.

1. Read-only: `bash .claude/scripts/ai/preflight.sh` e
   `bash .claude/scripts/ai/detect-project.sh`.
2. Plano curto: objetivo, requisito, arquivos prováveis por camada, estratégia
   de teste (unit obrigatório; integration se dependência externa; BDD se regra
   de negócio), critério de pronto testável, riscos, rollback.
3. Não implemente; aguarde confirmação.

Regras: `CLAUDE.md`; mudanças pequenas (`references/change-size-guidelines.md`).
