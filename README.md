# Kit Claude Code — Template Base

Repositório boilerplate com a infraestrutura de agente (Claude Code) para ser
reutilizada em múltiplos projetos via **git submodule** montado no caminho `.claude/`.

> **Conceito-chave:** a raiz deste repositório **é** o conteúdo da pasta `.claude/`
> do projeto hospedeiro. Ao rodar `git submodule add <url> .claude`, tudo daqui
> (skills/, hooks/, etc.) aparece como `.claude/skills/`, `.claude/hooks/`, etc.

## Estrutura

```text
.claude/                      # ← este repositório, montado como submodule
├── CLAUDE.md                 # System Prompt do orquestrador (carregado automaticamente)
├── harness.yaml              # Manifesto central do harness (gates, workflow, safety)
├── skills/                   # Habilidades invocáveis pelo agente
│   ├── analise-de-codigo/
│   ├── commit-message/       # Conventional Commits
│   ├── java-quality-gate/    # Gates Java + configs (checkstyle, spotless, pom...)
│   ├── java-spring-patterns/ # Padrões Spring Boot de produção
│   ├── pr-description/       # Descrição estruturada de PR
│   ├── pre-pr-review/        # Gate GO/NO-GO antes de abrir PR
│   └── terraform-module/     # Boas práticas de módulos Terraform
├── hooks/                    # Scripts de ciclo de vida
│   ├── pre_tool_use.py       # Bloqueia comandos perigosos antes da execução
│   ├── prevent_secret_leak.py# Bloqueia escrita de secrets (Write/Edit)
│   └── post_edit_format.py   # Formata arquivos após edições
├── agents/                   # Subagentes especializados para delegação
│   ├── code-reviewer.md
│   ├── security-reviewer.md  # Revisão de segurança defensiva (read-only)
│   ├── performance-reliability-reviewer.md
│   └── tech-writer.md        # Documentação, ADRs, diagramas C4
├── commands/                 # Slash commands: /pre-pr, /review, /security-check, /quality, /adr
├── scripts/                  # Scripts executáveis do harness
│   ├── lib/common.sh         # Helpers (detecção de build tool, logging, raízes)
│   ├── quality/              # Gates: verify-all, checkstyle, jacoco, pit, archunit...
│   └── ai/                   # preflight (secrets+estado) e detect-project
├── references/               # Governança compartilhada pelos revisores
│   ├── review-severity-matrix.md
│   ├── evidence-rules.md
│   ├── agent-selection-matrix.md
│   ├── change-size-guidelines.md
│   ├── quality-gate-policy.md
│   └── agent-finding-template.md
├── devcontainer/             # Ambiente padronizado (Java 25 + runtimes dos MCPs)
│   ├── devcontainer.example.json
│   └── install-tools.sh
├── permissions/              # Escopos de acesso e limites
│   └── settings.json
├── mcp/                      # Servidores MCP (AWS, Terraform, Spring)
│   ├── README.md
│   ├── mcp.example.json      # Copiar para a raiz do hospedeiro como .mcp.json
│   └── servers/              # Wrappers com versão pinada de cada servidor
└── harness_engineer/         # Testes, validação de prompts e benchmarks
    ├── README.md
    ├── run_eval.py           # Roda cenários contra o Claude Code headless
    ├── validate_assets.py    # Lint estrutural de skills/ e agents/
    ├── prompts/              # Prompts operacionais (plan, review, quality, debug, tdd)
    ├── scenarios/            # Cenários de avaliação/regressão (YAML)
    └── results/              # Relatórios: quality-summary, benchmarks (gitignored)
```

## Manual do Git Submodule

### a) Iniciar este repositório e subir para o GitHub

```bash
# Na pasta deste template (git init já feito se você usou o boilerplate)
git add .
git commit -m "feat: estrutura inicial do template Claude Code"

# Crie o repositório no GitHub (via UI ou gh CLI) e conecte:
gh repo create SEU_USUARIO/kit-claude-code --public --source=. --push
# — ou manualmente:
git remote add origin https://github.com/SEU_USUARIO/kit-claude-code.git
git branch -M main
git push -u origin main
```

### b) Adicionar como submodule em um projeto novo

```bash
cd /caminho/do/seu-projeto
git submodule add https://github.com/SEU_USUARIO/kit-claude-code.git .claude
git commit -m "chore: adiciona template Claude Code como submodule em .claude/"
```

Quem clonar o projeto depois precisa inicializar o submodule:

```bash
git clone --recurse-submodules https://github.com/SEU_USUARIO/seu-projeto.git
# ou, se já clonou sem a flag:
git submodule update --init --recursive
```

### c) Puxar atualizações quando o template evoluir

Publique a mudança no repositório base (`git push` aqui), depois em **cada projeto**:

```bash
git submodule update --remote --merge
git add .claude
git commit -m "chore: atualiza template Claude Code"
```

> `--remote` busca o último commit do branch rastreado (main) em vez do commit
> pinado; `--merge` mescla com eventuais ajustes locais dentro de `.claude/`.
> O `git add .claude` + commit é necessário porque o projeto hospedeiro pina o
> submodule em um commit específico — atualizar o ponteiro também é um commit.

Para atualizar todos os projetos de uma vez, num diretório que contém vários deles:

```bash
for d in */; do (cd "$d" && git submodule update --remote --merge 2>/dev/null); done
```

## Integração com o Claude Code (importante)

O Claude Code descobre configurações por convenção de caminho. Duas pastas deste
template já caem na convenção nativa quando montadas em `.claude/`; duas precisam
de um passo de ativação no projeto hospedeiro:

| Componente | Convenção nativa do Claude Code | Ação no projeto hospedeiro |
|---|---|---|
| `skills/` | `.claude/skills/<nome>/SKILL.md` | ✅ Nenhuma — funciona direto |
| `agents/` | `.claude/agents/*.md` | ✅ Nenhuma — funciona direto |
| `commands/` | `.claude/commands/*.md` | ✅ Nenhuma — slash commands aparecem direto |
| `devcontainer/` | `.devcontainer/` na **raiz do projeto** | Copiar: `cp .claude/devcontainer/devcontainer.example.json .devcontainer/devcontainer.json` (+ `install-tools.sh`) |
| `permissions/settings.json` | `.claude/settings.json` | Mesclar o conteúdo no `.claude/settings.json` — como `.claude/` é o submodule, crie o settings do projeto em `.claude/settings.local.json` (gitignored pelo Claude Code) para não sujar o submodule |
| `hooks/` | Registrados via `settings.json` → chave `hooks` | Registrar os comandos conforme o cabeçalho de cada script |
| `mcp/` | `.mcp.json` na **raiz do projeto** | `cp .claude/mcp/mcp.example.json .mcp.json` e remover servidores não usados (ver `mcp/README.md`) |
| `CLAUDE.md` | `.claude/CLAUDE.md` | ✅ Nenhuma — carregado automaticamente. Em versões antigas do Claude Code, adicione `@.claude/CLAUDE.md` ao `CLAUDE.md` da raiz do projeto |

## Ferramentas opcionais

Instalação **por máquina/projeto** (não são dependências do template — nada aqui quebra sem elas):

| Ferramenta | O que faz | Instalação | Observações |
|---|---|---|---|
| [OpenSpec](https://github.com/Fission-AI/OpenSpec) | Spec-driven development: você e o agente acordam a especificação **antes** do código; artefatos versionados por mudança (proposta → specs → design → tarefas) | `npm install -g @fission-ai/openspec@latest`, depois `openspec init` no projeto hospedeiro (Node ≥ 20.19) | Adiciona os slash commands `/opsx:explore`, `/opsx:propose`, `/opsx:apply`, `/opsx:archive` ao Claude Code. Encaixa com o gate `pre-pr-review`: spec validada antes do GO |
| [RTK](https://github.com/rtk-ai/rtk) | Proxy CLI que comprime a saída de comandos (git, testes, docker) antes de chegar ao contexto — 60–90% de economia de tokens | `brew install rtk` ou script do repo; depois `rtk init -g` e reinicie o Claude Code | Instaladores oficiais são Linux/macOS; no Windows, valide via Git Bash/cargo antes de adotar |
| [Caveman](https://github.com/juliusbrussee/caveman) | Skill que comprime o estilo das respostas do agente (~65% menos tokens de saída) | Script do repo (Node ≥ 18) | **Conflita com a seção "Estilo de Resposta" do CLAUDE.md** (respostas claras em pt-BR vs. fragmentos telegráficos) — se adotar, ajuste o CLAUDE.md |
| [ccusage](https://github.com/ryoppippi/ccusage) | Relatório de consumo de tokens/custo do Claude Code a partir dos logs locais (por dia, projeto, modelo) | `npx ccusage@latest` (não precisa instalar) | Comece por aqui: não dá para otimizar custo sem medir. Rode semanalmente e compare antes/depois de adotar RTK etc. |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Varredura de secrets no repositório e no histórico git | `scoop install gitleaks` (Windows) ou binário das releases | Defesa em profundidade: o hook `prevent_secret_leak.py` bloqueia na escrita; gitleaks pega o que passou (pre-commit/CI) |
| [Repomix](https://github.com/yamadashy/repomix) | Empacota o repositório num único arquivo otimizado para contexto de IA | `npx repomix` (não precisa instalar) | Útil para gerar "context packs" de onboarding ou analisar um repo inteiro de uma vez |
| [Serena MCP](https://github.com/oraios/serena) | Navegação semântica de código via LSP (ir à definição, referências, símbolos) em vez de grep/leitura de arquivos inteiros | `uvx --from git+https://github.com/oraios/serena serena start-mcp-server` (registrar como MCP) | Maior ganho em codebases Java grandes: o agente lê símbolos, não arquivos — menos tokens e mais precisão. Adote por projeto, não globalmente |

> Leia os scripts de instalação (`curl \| bash`) antes de executá-los.

## Base de conhecimento opcional

Se você mantém um repositório de guias de boas práticas (AWS, DDD, design
patterns, K8s...), dê esse conhecimento ao agente **sem inflar este template**
adicionando-o como segundo submodule nos projetos que quiserem:

```bash
git submodule add <url-do-repo-de-guias> docs/guides
```

E aponte os diretórios relevantes da stack no `CLAUDE.md` da raiz do projeto:

```markdown
Ao tomar decisões de arquitetura AWS, consulte docs/guides/aws/.
Ao modelar domínio, consulte docs/guides/ddd/.
```

> Referencie diretórios específicos, não a biblioteca inteira — o agente deve
> ler guias sob demanda, não carregá-los todos no contexto.

## Versionamento

Use tags semânticas neste repositório (`v1.0.0`, `v1.1.0`...). Para pinar um
projeto em uma versão específica em vez de seguir `main`:

```bash
cd .claude && git checkout v1.0.0 && cd ..
git add .claude && git commit -m "chore: pina template Claude Code em v1.0.0"
```
