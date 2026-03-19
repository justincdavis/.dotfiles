#!/usr/bin/env bash
set -euo pipefail

# Install a Nerd Font (required for starship powerline icons)

FONT_NAME="${1:-JetBrainsMono}"
FONT_DIR="${HOME}/.local/share/fonts"

if fc-list | grep -qi "JetBrainsMono Nerd Font" 2>/dev/null; then
    echo "nerd-font: ${FONT_NAME} already installed"
    exit 0
fi

echo "nerd-font: downloading ${FONT_NAME}..."
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL -o "${TMP_DIR}/${FONT_NAME}.tar.xz" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.tar.xz"

echo "nerd-font: installing to ${FONT_DIR}..."
mkdir -p "$FONT_DIR"
tar -xf "${TMP_DIR}/${FONT_NAME}.tar.xz" -C "$FONT_DIR"

echo "nerd-font: rebuilding font cache..."
fc-cache -f "$FONT_DIR"

echo "nerd-font: ${FONT_NAME} installed"
echo "nerd-font: set your terminal font to '${FONT_NAME} Nerd Font' to see icons"
