#!/usr/bin/env bash
# Fallback de arquitetura via grep/find: isola o domínio e valida regras de
# adapter sem exigir ArchUnit. Falha (exit 1) em violações. Idempotente.
# Padrão de pacotes: skills/java-quality-gate/config/package-organization.md
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"
detect_base_package

SRC="$REPO_ROOT/src/main/java"
violations=0

DOMAIN_DIR="$(find "$SRC" -type d -name domain 2>/dev/null | head -1 || true)"
WEB_DIR="$(find "$SRC" -type d -name web 2>/dev/null | head -1 || true)"
MSG_DIR="$(find "$SRC" -type d -name message 2>/dev/null | head -1 || true)"

# check_forbidden <dir> <label> <import-regex>
check_forbidden() {
  local dir="$1" label="$2" re="$3"
  [ -n "$dir" ] && [ -d "$dir" ] || return 0
  local hits
  hits="$(grep -rnE "^import\s+($re)" "$dir" 2>/dev/null || true)"
  if [ -n "$hits" ]; then
    err "VIOLAÇÃO [$label]:"
    echo "$hits" | sed "s#$REPO_ROOT/##"
    violations=$((violations+1))
  else
    ok "[$label] OK"
  fi
}

section "Regras de arquitetura (fallback grep/find)"
if [ -z "$DOMAIN_DIR" ] && [ -z "$WEB_DIR" ] && [ -z "$MSG_DIR" ]; then
  warn "Pacotes domain/web/message ainda não existem (projeto inicial)."
  warn "Regras serão aplicadas assim que a estrutura for criada. Nada a validar agora."
  exit 0
fi

# domain não depende de frameworks/tecnologia.
check_forbidden "$DOMAIN_DIR" "domain !-> Spring"        'org\.springframework\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> JPA(jakarta)"  'jakarta\.persistence\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> JPA(javax)"    'javax\.persistence\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> AWS SDK v2"    'software\.amazon\.awssdk\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> AWS SDK v1"    'com\.amazonaws\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> Kafka"         'org\.apache\.kafka\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> Spring AWS"    'io\.awspring\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> Spring Web"    'org\.springframework\.web\..*'
check_forbidden "$DOMAIN_DIR" "domain !-> Spring Data"   'org\.springframework\.data\..*'

# web / message não acessam a persistência JPA diretamente.
check_forbidden "$WEB_DIR" "web !-> infra.persistence.jpa" "${BASE_PACKAGE//./\\.}\\.infrastructure\\.persistence\\.jpa\\..*"
check_forbidden "$MSG_DIR" "message !-> infra.persistence.jpa" "${BASE_PACKAGE//./\\.}\\.infrastructure\\.persistence\\.jpa\\..*"

echo
if [ "$violations" -gt 0 ]; then
  err "package-rules: $violations violação(ões) de arquitetura."
  exit 1
fi
ok "package-rules: nenhuma violação."
