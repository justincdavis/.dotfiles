#!/usr/bin/env bash
set -euo pipefail

# ── 1. Install Starship if missing ───────────────────────────────────────────

if command -v starship >/dev/null 2>&1; then
    echo "starship: already installed ($(starship --version))"
else
    echo "starship: installing..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "${HOME}/.local/bin"
    echo "starship: installed to $(which starship)"
fi

# ── 2. Write default starship.toml if missing ────────────────────────────────

STARSHIP_CONFIG="${HOME}/.config/starship.toml"
mkdir -p "$(dirname "$STARSHIP_CONFIG")"

if [ -f "$STARSHIP_CONFIG" ]; then
    echo "starship: config already exists at $STARSHIP_CONFIG, skipping"
else
    cat > "$STARSHIP_CONFIG" <<'EOF'
# Starship prompt config
# https://starship.rs/config/

format = """
$directory\
$git_branch\
$git_status\
$python\
$nodejs\
$rust\
$golang\
$docker_context\
$cmd_duration\
$line_break\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
format = "[$symbol$branch]($style) "

[git_status]
format = '([$all_status$ahead_behind]($style) )'

[cmd_duration]
min_time = 2_000
format = "[$duration]($style) "

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
EOF
    echo "starship: wrote default config to $STARSHIP_CONFIG"
fi

echo "starship: done"
