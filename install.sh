#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# Usage
# =============================================================================

usage() {
    cat <<EOF
Usage: install.sh [options]

Options:
  --only <name>   Run only the named step (stow, starship, deps)
  --cuda          Add CUDA paths to ~/.bashrc_local
  -h, --help      Show this help

Examples:
  install.sh                    # install everything
  install.sh --cuda             # install everything + CUDA paths
  install.sh --only starship    # install only starship
  install.sh --only stow        # only stow symlinks
EOF
    exit 1
}

# =============================================================================
# Parse args
# =============================================================================

ONLY=""
CUDA=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --only)
            [[ $# -lt 2 ]] && { echo "ERROR: --only requires a name"; usage; }
            ONLY="$2"; shift ;;
        --cuda) CUDA=true ;;
        -h|--help) usage ;;
        *) echo "ERROR: Unknown argument: $1"; usage ;;
    esac
    shift
done

should_run() {
    [[ -z "$ONLY" || "$ONLY" == "$1" ]]
}

# =============================================================================
# Install dependencies
# =============================================================================

if should_run "deps"; then
    echo ""
    echo "=== Dependencies ==="

    if command -v stow &>/dev/null; then
        echo "stow: already installed"
    else
        echo "stow: installing..."
        if command -v apt-get &>/dev/null; then
            sudo apt-get update -qq && sudo apt-get install -y -qq stow
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y stow
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm stow
        elif command -v brew &>/dev/null; then
            brew install stow
        else
            echo "ERROR: Could not find a package manager to install stow"
            exit 1
        fi
        echo "stow: installed"
    fi
fi

# =============================================================================
# Starship
# =============================================================================

if should_run "starship"; then
    echo ""
    echo "=== Starship ==="
    bash "$DOTFILES_DIR/scripts/install_starship.sh"
    bash "$DOTFILES_DIR/scripts/install_nerd_font.sh"
fi

# =============================================================================
# Alacritty
# =============================================================================

if should_run "alacritty"; then
    echo ""
    echo "=== Alacritty ==="
    bash "$DOTFILES_DIR/scripts/install_alacritty.sh"
fi

# =============================================================================
# Stow packages
# =============================================================================

if should_run "stow"; then
    echo ""
    echo "=== Stow symlinks ==="

    # Back up existing files before stow replaces them
    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    NEEDS_BACKUP=false
    for f in .bashrc .bash_aliases .gitconfig .config/starship.toml .config/alacritty/alacritty.toml; do
        if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
            NEEDS_BACKUP=true
            break
        fi
    done
    if $NEEDS_BACKUP; then
        mkdir -p "$BACKUP_DIR"
        for f in .bashrc .bash_aliases .gitconfig .config/starship.toml .config/alacritty/alacritty.toml; do
            if [ -f "$HOME/$f" ] && [ ! -L "$HOME/$f" ]; then
                mkdir -p "$BACKUP_DIR/$(dirname "$f")"
                cp "$HOME/$f" "$BACKUP_DIR/$f"
                echo "  backed up: ~/$f -> $BACKUP_DIR/$f"
            fi
        done
    fi

    PACKAGES=(bash starship git alacritty)

    for pkg in "${PACKAGES[@]}"; do
        if [ ! -d "$DOTFILES_DIR/$pkg" ]; then
            echo "  $pkg: package dir not found, skipping"
            continue
        fi

        # Adopt existing files so stow doesn't conflict, then restow
        echo "  $pkg: stowing..."
        stow -d "$DOTFILES_DIR" -t "$HOME" --adopt "$pkg"
        # Restow to ensure dotfiles repo version wins
        # (adopt pulls existing files into repo, restow overwrites with repo version)
        git -C "$DOTFILES_DIR" checkout -- "$pkg/"
        stow -d "$DOTFILES_DIR" -t "$HOME" -R "$pkg"
        echo "  $pkg: done"
    done
fi

# =============================================================================
# Copy template files (not stowed — user edits per machine)
# =============================================================================

if should_run "stow"; then
    if [ ! -f "$HOME/.bashrc_local" ]; then
        cp "$DOTFILES_DIR/templates/bashrc_local" "$HOME/.bashrc_local"
        echo "  Created ~/.bashrc_local from template — edit for this machine"
    else
        echo "  ~/.bashrc_local already exists, skipping"
    fi
fi

# =============================================================================
# CUDA (optional)
# =============================================================================

if $CUDA; then
    BASHRC_LOCAL="$HOME/.bashrc_local"
    CUDA_BLOCK='# --- CUDA ---
if [ -d /usr/local/cuda ]; then
    export CUDA_HOME=/usr/local/cuda
    export PATH="${CUDA_HOME}/bin:${PATH}"
    export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
fi'

    if grep -qF "CUDA_HOME" "$BASHRC_LOCAL" 2>/dev/null; then
        echo "  cuda: already in ~/.bashrc_local, skipping"
    else
        printf '\n%s\n' "$CUDA_BLOCK" >> "$BASHRC_LOCAL"
        echo "  cuda: added CUDA paths to ~/.bashrc_local"
    fi
fi

# =============================================================================
# Done
# =============================================================================

echo ""
echo "Done. Restart your shell or run: source ~/.bashrc"
if $NEEDS_BACKUP 2>/dev/null; then
    echo "  Backups saved to: $BACKUP_DIR"
fi
