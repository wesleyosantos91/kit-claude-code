#!/usr/bin/env bash
# Roda Checkstyle quando configurado. Fallback: valida que a config existe e
# avisa que o plugin está ausente (sem falha injusta).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool

CONFIG="$QUALITY_CONFIG_DIR/checkstyle/checkstyle-java25.xml"

case "$BUILD_TOOL" in
  maven)
    if maven_has 'maven-checkstyle-plugin'; then run_build -q checkstyle:check; ok "Checkstyle OK"
    else
      warn "maven-checkstyle-plugin ausente no pom.xml."
      [ -f "$CONFIG" ] && info "Config pronta: $CONFIG (copie para o projeto e habilite o plugin)." || err "Config Checkstyle ausente!"
    fi ;;
  gradle)
    if gradle_has 'checkstyle'; then run_build checkstyleMain checkstyleTest; ok "Checkstyle OK"
    else warn "Plugin checkstyle ausente no Gradle. Config: $CONFIG"; fi ;;
  *) warn "Build tool não detectado." ;;
esac
