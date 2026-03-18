#!/usr/bin/env bash
set -euo pipefail

# Install Starship binary if missing

if command -v starship >/dev/null 2>&1; then
    echo "starship: already installed ($(starship --version))"
else
    echo "starship: installing..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "${HOME}/.local/bin"
    echo "starship: installed to $(which starship)"
fi

echo "starship: done"
