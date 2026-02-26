# Yamada's dotfiles

Personal dotfiles for macOS (zsh + vim). One command to set up a new Mac from scratch.

## Quick Start

```sh
# 1. Clone the repo
git clone https://github.com/bruno-yamada/dotfiles.git ~/projects/github.com/bruno-yamada/dotfiles
cd ~/projects/github.com/bruno-yamada/dotfiles

# 2. Run the installer
chmod +x install.sh
./install.sh

# 3. Add your secrets
cp .private.example .private
# Edit .private and fill in your API keys / tokens

# 4. Restart your terminal
```

## What's included

### Shell config

| File | Description |
|------|-------------|
| `.zshrc` | Main zsh config (oh-my-zsh, PATH, tool init, sources modules) |
| `.bashrc` | Bash config (legacy, still functional) |
| `.aliases` | All shell aliases (git, docker, k8s, terraform, navigation) |
| `.functions` | All shell functions (git, k8s, vault, AWS, tmux, etc) |
| `.tmux.conf` | tmux config (keybindings, panes, plugins, theme, clipboard) |
| `.private` | **Gitignored.** Your secrets, tokens, API keys |
| `.private.example` | Template showing which env vars to set |

### Vim

| File | Description |
|------|-------------|
| `.vimrc` | Vim config with Vundle plugins, FZF, ALE linter, molokai theme |

### Scripts

Utility scripts in `scripts/` are added to `$PATH` automatically:

| Script | Description |
|--------|-------------|
| `zet` / `zetc` | Zettelkasten note creation and commit |
| `epoch-converter` | Unix timestamp <-> date conversion |
| `url-codec` | URL encode/decode |
| `random_password` | Generate random password |
| `csv-to-md` | Convert CSV to markdown table |
| `isosec` / `isodate` | ISO timestamp helpers |
| `aws-env` / `aws-ssm` / `aws-tf-vars` | AWS helper scripts |
| `y` | Quick web search from terminal |
| `pbp` / `pbd` / `pby` | Clipboard buffer helpers |
| `onchange` / `haschanged` / `changed` | File change detection |

### Packages

`Brewfile` contains all Homebrew packages. Key tools:

- **Shell:** fzf, ag (silver searcher), ripgrep, bat, git-delta, icdiff, direnv
- **Version managers:** asdf, pyenv, rbenv, nvm
- **Cloud/Infra:** awscli, terraform, kubectl, helm, kustomize, vault, dive
- **Languages:** go, python, node

## How it works

The installer (`install.sh`) does the following:

1. Installs **Homebrew** (if not present)
2. Installs all packages from **Brewfile**
3. Installs **oh-my-zsh** + plugins (zsh-autosuggestions, zsh-syntax-highlighting) + theme (powerlevel10k)
4. Installs **Vundle** and vim plugins
5. Creates **symlinks** from `$HOME` to the dotfiles in this repo
6. Creates common **directories** (`~/projects/`, `~/bin/`, `~/.kube/`, etc)

Existing files in `$HOME` are backed up before being replaced.

## Adding secrets

All secrets live in `.private` (gitignored). See `.private.example` for the full list of env vars. The file is sourced automatically by both `.zshrc` and `.bashrc`.

## Customizing

- **Add packages:** Edit `Brewfile`, then run `brew bundle --file=Brewfile`
- **Add aliases:** Edit `.aliases`
- **Add functions:** Edit `.functions`
- **Add secrets:** Edit `.private`
- **Add scripts:** Drop executables into `scripts/`
