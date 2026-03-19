#!/usr/bin/env bash
set -euo pipefail

CONFIG="${HOME}/.config/starship.toml"
PALETTES=(pastel ocean sunset forest cyberpunk monochrome dracula nord gruvbox tokyo-night berry lava)

usage() {
    cat <<EOF
Usage: starship_palette.sh <palette>

Set the active starship color scheme.

Available palettes:
  pastel        Soft rainbow pastels
  ocean         Deep sea to shore blues
  sunset        Warm dusk sky gradient
  forest        Woodland earth tones
  cyberpunk     Neon city nights
  monochrome    Clean grayscale
  dracula       Classic dark theme
  nord          Arctic frost
  gruvbox       Retro earthy tones
  tokyo-night   Neon city vibes
  berry         Deep purples and magentas
  lava          Volcanic heat gradient

Current: $(sed -n 's/^palette = "\(.*\)"/\1/p' "$CONFIG" 2>/dev/null || echo "unknown")
EOF
    exit 0
}

[[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]] && usage

PALETTE="$1"

# Validate palette name
VALID=false
for p in "${PALETTES[@]}"; do
    [[ "$p" == "$PALETTE" ]] && VALID=true && break
done

if ! $VALID; then
    echo "ERROR: unknown palette '$PALETTE'"
    echo "Run with --help to see available palettes"
    exit 1
fi

sed -i "s/^palette = \".*\"/palette = \"$PALETTE\"/" "$CONFIG"
echo "Starship palette set to '$PALETTE'"
echo "Restart your shell or open a new tab to see the change"
