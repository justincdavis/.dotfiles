# .dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Install

```bash
git clone https://github.com/justincdavis/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

This will:
1. Install `stow` if not found
2. Install [Starship](https://starship.rs) prompt if not found
3. Install [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) for Starship icons
4. Install [Alacritty](https://alacritty.org/) terminal emulator if not found
5. Back up any existing config files to `~/.dotfiles-backup-<timestamp>/`
6. Symlink all stow packages into `$HOME`
7. Copy `~/.bashrc_local` template if it doesn't exist

### Options

```bash
./install.sh --only deps        # only install dependencies (stow)
./install.sh --only starship    # install starship binary + nerd font only
./install.sh --only alacritty   # install alacritty binary only
./install.sh --only stow        # only create symlinks + bashrc_local template
./install.sh --cuda             # install everything + add CUDA paths to ~/.bashrc_local
```

## Stow packages

Each directory is a stow package that mirrors the home directory structure.

| Package | Contents | Symlinks |
|---------|----------|----------|
| `bash/` | `.bashrc`, `.bash_aliases` | `~/.bashrc`, `~/.bash_aliases` |
| `starship/` | `.config/starship.toml` | `~/.config/starship.toml` |
| `git/` | `.gitconfig` | `~/.gitconfig` |
| `alacritty/` | `.config/alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` |

## Scripts

Helper scripts in `scripts/`:

| Script | Purpose |
|--------|---------|
| `install_starship.sh` | Installs Starship binary to `~/.local/bin` |
| `install_nerd_font.sh` | Installs JetBrainsMono Nerd Font to `~/.local/share/fonts` |
| `install_alacritty.sh` | Installs Alacritty via system package manager |
| `starship_palette.sh` | Switch Starship color palette (run with `--help` for options) |

### Starship palettes

The Starship config includes multiple built-in color palettes. Switch with:

```bash
./scripts/starship_palette.sh <palette>
```

Available: `pastel`, `ocean`, `sunset`, `forest`, `cyberpunk`, `monochrome`, `dracula`, `nord`, `gruvbox`, `tokyo-night`, `berry`, `lava`

## Machine-specific config

`~/.bashrc_local` is **copied** from `templates/bashrc_local` on first install — it is not symlinked. Edit it freely for machine-specific paths (CUDA, NVM, Bun, etc.). It won't be overwritten on re-runs.

The `--cuda` flag appends CUDA path setup to `~/.bashrc_local` automatically.

## Adding a new stow package

1. Create a directory named after the package (e.g. `vim/`)
2. Mirror the home directory structure inside it (e.g. `vim/.vimrc`)
3. Add the package name to the `PACKAGES` array in `install.sh`
4. Add the config files to the backup list in `install.sh`
5. Run `./install.sh --only stow`
