#!/usr/bin/env bash
# Aplica formatação via Spotless quando configurado; senão avisa (sem falha).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

case "$BUILD_TOOL" in
  maven)
    if maven_has 'spotless-maven-plugin'; then run_build -q spotless:apply; ok "Spotless apply concluído"
    else warn "Spotless não configurado no pom.xml. Veja $QUALITY_CONFIG_DIR/spotless/spotless-java25.md para habilitar."; fi ;;
  gradle)
    if gradle_has 'spotless'; then run_build spotlessApply; ok "spotlessApply concluído"
    else warn "Spotless não configurado no Gradle. Veja $QUALITY_CONFIG_DIR/spotless/spotless-java25.md."; fi ;;
  *) warn "Build tool não detectado; nada a formatar." ;;
esac
