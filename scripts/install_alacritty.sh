#!/usr/bin/env bash
set -euo pipefail

# Install Alacritty terminal emulator

if command -v alacritty &>/dev/null; then
    echo "alacritty: already installed ($(alacritty --version))"
    exit 0
fi

echo "alacritty: installing..."

if command -v apt-get &>/dev/null; then
    sudo add-apt-repository -y ppa:aslatter/ppa
    sudo apt-get update -qq && sudo apt-get install -y -qq alacritty
elif command -v dnf &>/dev/null; then
    sudo dnf install -y alacritty
elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm alacritty
elif command -v brew &>/dev/null; then
    brew install --cask alacritty
else
    echo "ERROR: Could not find a supported package manager"
    exit 1
fi

echo "alacritty: installed ($(alacritty --version))"
