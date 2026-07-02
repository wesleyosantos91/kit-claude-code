# Prompt: implement-tdd

Implemente com **TDD obrigatório**:
entender requisito → **teste falhando** → confirmar red
(`bash .claude/scripts/quality/test-unit.sh`) → implementação mínima → verde →
refatorar → `bash .claude/scripts/quality/verify-all.sh --fast`.

Bugfix: reproduzir com teste falhando → corrigir → provar → regressão.

Regras: nenhuma linha de produção antes do teste falhando; respeitar
camadas/pacotes (domínio sem Spring/JPA/AWS/Kafka); SOLID obrigatório; não
alterar `pom.xml` com risco (propor `.example`); sem comandos destrutivos; não
deletar arquivos; não reestruturar pacotes sem aprovação.
