#!/usr/bin/env bash
# Detecta a forma do projeto: build tool, Java, framework, base package e qual
# tooling de qualidade/teste está presente. Read-only. Idempotente.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

detect_build_tool
detect_java_version
detect_framework
detect_base_package

has() { # has <label> <true|false>
  if [ "$2" = "true" ]; then ok "$1: yes"; else warn "$1: no"; fi
}

section "Project"
info "build tool        : ${BUILD_TOOL}  (${BUILD_CMD:-n/a})"
info "java configured   : ${JAVA_VERSION_CONFIGURED}"
info "framework         : ${FRAMEWORK}"
info "base package      : ${BASE_PACKAGE}"
info "src/main/java     : $([ -d src/main/java ] && echo yes || echo no)"
info "src/test/java     : $([ -d src/test/java ] && echo yes || echo no)"

section "Wrappers / build files"
has "mvnw"               "$([ -f mvnw ] && echo true || echo false)"
has "gradlew"            "$([ -f gradlew ] && echo true || echo false)"
has "pom.xml"            "$([ -f pom.xml ] && echo true || echo false)"
has "build.gradle(.kts)" "$([ -f build.gradle ] || [ -f build.gradle.kts ] && echo true || echo false)"

section "Tests"
has "unit tests"        "$([ -n "$(find src/test -type f \( -name '*Test.java' -o -name '*Tests.java' \) 2>/dev/null | head -1)" ] && echo true || echo false)"
has "integration tests" "$([ -n "$(find src/test -type f \( -name '*IT.java' -o -name '*IntegrationTest.java' \) 2>/dev/null | head -1)" ] && echo true || echo false)"
has "BDD (features/)"   "$([ -d src/test/resources/features ] || maven_has 'cucumber|jbehave' || gradle_has 'cucumber|jbehave|spock' && echo true || echo false)"

section "Quality plugins (in build file)"
has "Checkstyle" "$(maven_has 'maven-checkstyle-plugin' || gradle_has 'checkstyle' && echo true || echo false)"
has "Spotless"   "$(maven_has 'spotless-maven-plugin' || gradle_has 'spotless' && echo true || echo false)"
has "JaCoCo"     "$(maven_has 'jacoco-maven-plugin' || gradle_has 'jacoco' && echo true || echo false)"
has "PIT"        "$(maven_has 'pitest' || gradle_has 'pitest' && echo true || echo false)"
has "ArchUnit"   "$(maven_has 'archunit' || gradle_has 'archunit' || [ -n "$(find src/test -type f -name '*ArchTest*.java' -o -name '*ArchitectureTest*.java' 2>/dev/null | head -1)" ] && echo true || echo false)"

section "Infra / containers"
has "Docker"         "$([ -f Dockerfile ] || [ -f compose.yaml ] || [ -f docker-compose.yml ] && echo true || echo false)"
has "DevContainer"   "$([ -d .devcontainer ] && echo true || echo false)"
has "Testcontainers" "$(maven_has 'testcontainers' || gradle_has 'testcontainers' && echo true || echo false)"

section "Agent files"
has "CLAUDE.md (raiz)"  "$([ -f CLAUDE.md ] && echo true || echo false)"
has ".claude/ (template)" "$([ -d .claude ] && echo true || echo false)"
has ".mcp.json"         "$([ -f .mcp.json ] && echo true || echo false)"

echo
ok "detect-project done"
