# Prompt: debug

Analise o erro com contexto mínimo. Preserve o **stack trace relevante** inteiro;
resuma o resto; não vaze secrets. Passos: causa raiz → arquivo/linha → **reproduzir
com teste falhando** → correção mínima → `bash .claude/scripts/quality/test-unit.sh`
→ regressão. Saída: causa raiz + correção + teste. Sem comandos destrutivos.
