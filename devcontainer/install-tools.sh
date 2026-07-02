#!/usr/bin/env bash
# postCreateCommand do devcontainer: instala as CLIs que os features não cobrem.
# Java/Node/Python vêm dos features (versões pinadas); Maven vem do ./mvnw do
# projeto. Aqui entram apenas: uv (MCPs Python), Claude Code CLI e extras.
set -euo pipefail

NPM_PREFIX="${NPM_PREFIX:-$HOME/.npm-global}"
mkdir -p "$NPM_PREFIX/bin"
npm config set prefix "$NPM_PREFIX" >/dev/null
export PATH="$NPM_PREFIX/bin:$HOME/.local/bin:$PATH"

if ! grep -q 'devcontainer tool bins' "$HOME/.profile" 2>/dev/null; then
  {
    echo ''
    echo '# devcontainer tool bins'
    echo "export PATH=\"$NPM_PREFIX/bin:\$HOME/.local/bin:\$PATH\""
  } >> "$HOME/.profile"
fi

# uv/uvx — runtime dos MCPs Python (aws-docs, aws-pricing)
if ! command -v uvx >/dev/null 2>&1; then
  echo "Instalando uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Claude Code CLI
if ! command -v claude >/dev/null 2>&1; then
  echo "Instalando Claude Code..."
  npm install --global @anthropic-ai/claude-code
fi

# Opcional: descomente o que o projeto usar
# npm install --global @fission-ai/openspec@latest   # spec-driven development

echo "install-tools: concluído."
claude --version || true
uvx --version || true
