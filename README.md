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
3. Back up any existing config files to `~/.dotfiles-backup-<timestamp>/`
4. Symlink all stow packages into `$HOME`
5. Copy `~/.bashrc_local` template if it doesn't exist

### Selective install

```bash
./install.sh --only starship    # install starship binary only
./install.sh --only stow        # only create symlinks
./install.sh --only deps        # only install dependencies (stow)
```

## Stow packages

Each directory is a stow package that mirrors the home directory structure.

| Package | Contents | Symlinks |
|---------|----------|----------|
| `bash/` | `.bashrc`, `.bash_aliases` | `~/.bashrc`, `~/.bash_aliases` |
| `starship/` | `.config/starship.toml` | `~/.config/starship.toml` |
| `git/` | `.gitconfig` | `~/.gitconfig` |

## Machine-specific config

`~/.bashrc_local` is **copied** from `templates/bashrc_local` on first install — it is not symlinked. Edit it freely for machine-specific paths (CUDA, NVM, Bun, etc.). It won't be overwritten on re-runs.

## Adding a new stow package

1. Create a directory named after the package (e.g. `vim/`)
2. Mirror the home directory structure inside it (e.g. `vim/.vimrc`)
3. Add the package name to the `PACKAGES` array in `install.sh`
4. Run `./install.sh --only stow`
