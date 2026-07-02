#!/usr/bin/env bash
# Roda testes de integração quando existem. Maven: Failsafe (*IT/*IntegrationTest).
# Gradle: task integrationTest. Avisa quando não configurado, mas FALHA se
# existem arquivos de teste de integração que não podem ser executados.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

IT_FILES="$(find src/test -type f \( -name '*IT.java' -o -name '*IntegrationTest.java' \) 2>/dev/null || true)"

case "$BUILD_TOOL" in
  maven)
    if maven_has 'maven-failsafe-plugin'; then
      run_build -q verify -DskipUnitTests=true; ok "Integration tests (Failsafe) concluídos"
    elif [ -n "$IT_FILES" ]; then
      err "Existem testes de integração mas o maven-failsafe-plugin NÃO está configurado:"
      echo "$IT_FILES" | sed "s#$REPO_ROOT/##"
      err "Configure o Failsafe para executá-los."
      exit 1
    else
      warn "Sem testes de integração e sem Failsafe configurado — nada a rodar."
    fi ;;
  gradle)
    if gradle_has 'integrationTest|integration-test'; then run_build integrationTest; ok "integrationTest concluído"
    elif [ -n "$IT_FILES" ]; then err "Há testes *IT/*IntegrationTest sem task integrationTest configurada."; exit 1
    else warn "Sem testes de integração configurados no Gradle."; fi ;;
  *) warn "Build tool não detectado." ;;
esac
