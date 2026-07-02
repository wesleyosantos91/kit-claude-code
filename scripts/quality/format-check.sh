#!/usr/bin/env bash
# Verifica formatação via Spotless quando configurado; senão avisa (sem falha injusta).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

case "$BUILD_TOOL" in
  maven)
    if maven_has 'spotless-maven-plugin'; then run_build -q spotless:check; ok "Spotless check OK"
    else warn "Spotless não configurado no pom.xml — pulando check (não é falha)."; fi ;;
  gradle)
    if gradle_has 'spotless'; then run_build spotlessCheck; ok "spotlessCheck OK"
    else warn "Spotless não configurado no Gradle — pulando check (não é falha)."; fi ;;
  *) warn "Build tool não detectado; nada a checar." ;;
esac
