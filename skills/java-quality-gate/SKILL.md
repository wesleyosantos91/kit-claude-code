---
name: java-quality-gate
description: Executa e interpreta os quality gates de projetos Java (Spotless, Checkstyle, JaCoCo, PIT mutation testing, ArchUnit). Use antes de fechar tarefa/PR em projetos Java/Spring, ou quando o usuário pedir "rode os gates", "verifique a qualidade".
---

# Skill: Java Quality Gate

## Objetivo

Executar os quality gates da stack Java, interpretar as falhas e produzir um
veredito GO/NO-GO de qualidade — sem nunca relaxar thresholds para "passar".

## Quando usar

Antes de fechar tarefa/PR em projetos Java; ao validar a qualidade de uma mudança.

## Quando NÃO usar

Quando só precisa rodar testes unitários (rode `./mvnw test` direto) ou quando o
projeto não é Java. Para o gate final completo de PR, combine com `pre-pr-review`.

## Inputs esperados

- Branch/diff alvo.
- Escopo (módulo/classe) quando aplicável — PIT em projeto grande é lento;
  restrinja com `-DtargetClasses`.

## Workflow

1. Detecte o build tool (`mvnw` ou `gradlew`) e quais gates o projeto tem
   configurados (procure os plugins no `pom.xml`/`build.gradle`).
2. Rode os gates presentes, do mais barato ao mais caro:

```bash
./mvnw spotless:check                              # formatação
./mvnw checkstyle:check                            # estilo/convenções
./mvnw verify                                      # testes + JaCoCo (+ ArchUnit se for teste)
./mvnw org.pitest:pitest-maven:mutationCoverage    # mutation testing (mais lento)
```

3. Classifique cada resultado: **falha real** (bloqueia) × **gate ausente**
   (reportar, não é falha) × **melhoria** (sugestão).
4. Consolide o resumo com GO/NO-GO.

## Saída esperada

```markdown
## Quality Gates — <branch>

| Gate | Status | Detalhe |
|---|---|---|
| Spotless | ✅/❌/– | |
| Checkstyle | ✅/❌/– | |
| Testes + JaCoCo | ✅/❌/– | cobertura X% (threshold Y%) |
| PIT | ✅/❌/– | mutation score X% |
| ArchUnit | ✅/❌/– | |

**Veredito: GO | NO-GO** (– = gate não configurado no projeto)
```

## Critérios de qualidade

- **Nunca relaxar thresholds** (cobertura/mutation) para o build passar.
- Gate ausente ≠ falha — reporte e sugira adotar os configs de `config/` desta skill.
- Não esconder falhas: sempre reporte causa + correção sugerida.

## Segurança

- Nunca rodar comandos destrutivos (rm -rf, git reset --hard).
- Nunca expor secrets/.env/credenciais nos logs dos gates.

## Recursos incluídos (`config/`)

Configs prontos para adotar em projetos que ainda não têm os gates:

- `pom-quality-plugins.example.xml` — bloco de plugins Maven (Spotless, Checkstyle,
  JaCoCo, PIT) para colar no `pom.xml`.
- `checkstyle/checkstyle-java25.xml` + `suppressions.xml`.
- `spotless/eclipse-java-formatter.xml` + `spotless-java25.md`.
- `pitest/pitest-rules.md` — política de mutation testing.
- `archunit/architecture-rules.md` — regras de arquitetura sugeridas.
- `package-organization.md` — padrão de organização de pacotes (hexagonal:
  web/message/application/domain/infrastructure/core). Ao criar classes novas
  em projetos Java, siga esta convenção; nunca reestruture pacotes existentes
  sem aprovação.
