# MCP — Servidores de Contexto

Servidores MCP prontos para projetos AWS + Terraform + Spring/Java.

| Servidor | O que dá ao agente | Runtime necessário |
|---|---|---|
| `context7` | Documentação atualizada de qualquer biblioteca/framework (evita API alucinada de versão errada) | Node.js/`npx` |
| `aws-docs` | Documentação oficial AWS pesquisável | `uv`/`uvx` (Python) |
| `aws-pricing-sandbox` | Consulta de preços AWS (perfil `sandbox`) | `uv`/`uvx` + credenciais AWS |
| `terraform-registry` | Docs de providers/módulos do Terraform Registry | Docker |
| `springdocs` | Documentação Spring (Boot, Data, Security...) | Node.js/`npx` |

## Ativação no projeto hospedeiro

O Claude Code lê `.mcp.json` na **raiz do projeto** (não dentro de `.claude/`).
Com o submodule montado em `.claude/`:

```bash
# na raiz do projeto hospedeiro
cp .claude/mcp/mcp.example.json .mcp.json
# edite e remova os servidores que o projeto não usa
```

Verifique com `claude mcp list` dentro do projeto.

## Notas

- Os scripts em `servers/` são wrappers finos (bash) que fixam versão e flags de
  cada servidor — atualize a versão aqui no template e todos os projetos herdam
  via `git submodule update --remote`.
- No Windows, o Claude Code executa `bash` via Git Bash; garanta que ele está no PATH.
- `aws-pricing-sandbox` assume um profile AWS chamado `sandbox` — ajuste o
  `AWS_PROFILE` no `.mcp.json` do projeto se o nome for outro. Nunca aponte para
  um profile com permissões de escrita em produção.
