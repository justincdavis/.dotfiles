#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# Block management helpers
# =============================================================================

# Insert or replace a block delimited by BEGIN-AUTO / END-AUTO markers in a file.
# Usage: manage_block <file> <block_name> <content>
manage_block() {
    local file="$1"
    local name="$2"
    local content="$3"
    local begin="# BEGIN-AUTO: ${name}"
    local end="# END-AUTO: ${name}"

    # Ensure the file exists
    touch "$file"

    if grep -qF "$begin" "$file"; then
        # Replace existing block (sed in-place)
        # Delete from BEGIN to END, then insert new content at that position
        local tmp
        tmp=$(mktemp)
        awk -v begin="$begin" -v end="$end" -v content="$content" '
            $0 == begin { print content; skip=1; next }
            $0 == end   { skip=0; next }
            !skip       { print }
        ' "$file" > "$tmp"
        mv "$tmp" "$file"
        echo "  Updated block: ${name} in ${file}"
    else
        # Append new block
        printf '\n%s\n%s\n%s\n' "$begin" "$content" "$end" >> "$file"
        echo "  Added block: ${name} to ${file}"
    fi
}

# =============================================================================
# Usage
# =============================================================================

usage() {
    cat <<EOF
Usage: install.sh [options]

Options:
  --only <name>   Run only the named installer (e.g., starship)
  -h, --help      Show this help

Examples:
  install.sh                    # install everything
  install.sh --only starship    # install only starship
EOF
    exit 1
}

# =============================================================================
# Parse args
# =============================================================================

ONLY=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --only)
            [[ $# -lt 2 ]] && { echo "ERROR: --only requires a name"; usage; }
            ONLY="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "ERROR: Unknown argument: $1"; usage ;;
    esac
    shift
done

# =============================================================================
# Installers
# =============================================================================

should_run() {
    [[ -z "$ONLY" || "$ONLY" == "$1" ]]
}

BASHRC="${HOME}/.bashrc"

# --- Starship ---

if should_run "starship"; then
    echo ""
    echo "=== Starship ==="
    bash "$SCRIPT_DIR/scripts/install_starship.sh"

    STARSHIP_BLOCK='eval "$(starship init bash)"'
    manage_block "$BASHRC" "starship" "$STARSHIP_BLOCK"
fi

# =============================================================================
# Done
# =============================================================================

echo ""
echo "Done."
