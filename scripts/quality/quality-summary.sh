#!/usr/bin/env bash
# Produz o resumo consolidado de qualidade. Agregação read-only; nunca falha o
# build. Saída: harness_engineer/results/quality-summary.md (dentro do template)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_build_tool; detect_java_version; detect_framework; detect_base_package

OUT="$TEMPLATE_ROOT/harness_engineer/results/quality-summary.md"
mkdir -p "$(dirname "$OUT")"

present() { if eval "$1"; then echo "configured"; else echo "ABSENT"; fi; }

CS="$(present 'maven_has maven-checkstyle-plugin || gradle_has checkstyle')"
SP="$(present 'maven_has spotless-maven-plugin || gradle_has spotless')"
JA="$(present 'maven_has jacoco-maven-plugin || gradle_has jacoco')"
PI="$(present 'maven_has pitest || gradle_has pitest')"
AU="$(present 'maven_has archunit || gradle_has archunit')"
IT="$([ -n "$(find src/test -type f \( -name "*IT.java" -o -name "*IntegrationTest.java" \) 2>/dev/null | head -1)" ] && echo "present" || echo "none")"
BDD="$([ -d src/test/resources/features ] || maven_has 'cucumber|jbehave' && echo "present" || echo "none")"

{
  echo "# Quality summary"
  echo
  echo "| campo | valor |"
  echo "|---|---|"
  echo "| date | $(now_utc) |"
  echo "| branch | $(git_branch) |"
  echo "| commit | $(git_commit) |"
  echo "| build tool | ${BUILD_TOOL} |"
  echo "| java | ${JAVA_VERSION_CONFIGURED} |"
  echo "| framework | ${FRAMEWORK} |"
  echo "| base package | ${BASE_PACKAGE} |"
  echo
  echo "## Gates (configuração)"
  echo
  echo "| gate | estado |"
  echo "|---|---|"
  echo "| Spotless (format) | ${SP} |"
  echo "| Checkstyle | ${CS} |"
  echo "| Unit tests | $([ -d src/test/java ] && echo present || echo none) |"
  echo "| Integration tests | ${IT} |"
  echo "| BDD | ${BDD} |"
  echo "| JaCoCo (>=90%) | ${JA} |"
  echo "| PIT mutation (>=90%) | ${PI} |"
  echo "| ArchUnit | ${AU} (fallback: package-rules.sh) |"
  echo
  echo "## Próximos passos sugeridos"
  [ "$SP" = "ABSENT" ] && echo "- Habilitar Spotless (skills/java-quality-gate/config/spotless/)"
  [ "$CS" = "ABSENT" ] && echo "- Habilitar Checkstyle (skills/java-quality-gate/config/checkstyle/)"
  [ "$JA" = "ABSENT" ] && echo "- Habilitar JaCoCo com threshold 90%"
  [ "$PI" = "ABSENT" ] && echo "- Habilitar PIT com score 90% (skills/java-quality-gate/config/pitest/)"
  [ "$AU" = "ABSENT" ] && echo "- Habilitar ArchUnit (skills/java-quality-gate/config/archunit/) — enquanto isso, package-rules.sh cobre o essencial"
  echo "- Plugins de build prontos: skills/java-quality-gate/config/pom-quality-plugins.example.xml (opt-in)"
} > "$OUT"

cat "$OUT"
echo
ok "quality summary: $OUT"
