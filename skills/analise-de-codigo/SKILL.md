---
name: analise-de-codigo
description: Analisa um arquivo ou diretório e produz um relatório de qualidade (complexidade, duplicação, riscos e sugestões de melhoria). Use quando o usuário pedir "analise", "audite" ou "avalie a qualidade" de código.
---

# Skill: Análise de Código

## Objetivo

Produzir um relatório estruturado de qualidade sobre o alvo indicado
(arquivo, diretório ou diff), sem modificar nenhum arquivo.

## Quando usar

Análise pontual de qualidade durante o desenvolvimento ("analise", "audite",
"avalie a qualidade").

## Quando NÃO usar

Como gate final antes de PR — use a skill `pre-pr-review`, que consolida
testes + secrets + revisão em um veredito GO/NO-GO.

## Inputs esperados

- `alvo` (obrigatório): caminho do arquivo/diretório ou referência de diff.
- `foco` (opcional): `seguranca` | `performance` | `manutenibilidade` (padrão: todos).

## Passos

1. Leia o alvo. Se for um diretório, priorize arquivos com mais linhas alteradas
   recentemente (`git log --stat`) ou os pontos de entrada (main, controllers, index).
2. Avalie cada arquivo nos eixos:
   - **Complexidade:** funções longas (>40 linhas), aninhamento profundo (>3 níveis).
   - **Duplicação:** blocos repetidos que deveriam ser extraídos.
   - **Riscos:** tratamento de erro ausente, entradas não validadas, segredos hardcoded.
3. Classifique cada achado como `CRÍTICO`, `ALTO`, `MÉDIO` ou `BAIXO`.

## Saída esperada

Relatório em Markdown com o formato:

```markdown
## Relatório de Análise — <alvo>

| Severidade | Arquivo:Linha | Achado | Sugestão |
|---|---|---|---|
| CRÍTICO | src/auth.ts:42 | Token hardcoded | Mover para variável de ambiente |

### Resumo
<2–3 frases com a visão geral e a recomendação principal>
```

## Restrições

- **Somente leitura.** Esta skill nunca edita, cria ou deleta arquivos.
- Máximo de 15 achados por relatório — priorize os mais severos.
