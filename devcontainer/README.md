# Devcontainer

Ambiente de desenvolvimento padronizado com tudo que o template precisa:
Java 25, Node 22 (npx/MCPs), Python 3.12 + uv (MCPs AWS), Docker-in-Docker
(MCP terraform-registry), Terraform e AWS CLI — mais o Claude Code instalado
via `install-tools.sh`.

## Ativação no projeto hospedeiro

O runtime de devcontainer lê `.devcontainer/` na **raiz do projeto**:

```bash
mkdir -p .devcontainer
cp .claude/devcontainer/devcontainer.example.json .devcontainer/devcontainer.json
cp .claude/devcontainer/install-tools.sh .devcontainer/
```

Ajuste `name`, portas e extensões à realidade do projeto. Abra no VS Code
("Reopen in Container") ou no IntelliJ (Gateway).

## Notas

- Os features pinam as versões das linguagens independentemente da imagem base —
  não instale Java/Node/Python via apt no script.
- Maven vem do `./mvnw` do projeto (versão exata, agnóstico de SO).
- O `install-tools.sh` é idempotente: seguro rodar de novo em rebuilds.
