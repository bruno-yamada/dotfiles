#!/usr/bin/env bash
set -euo pipefail

# Yamada's dotfiles installer
# Usage: ./install.sh
#
# This script:
#   1. Installs Homebrew (if missing)
#   2. Installs packages from Brewfile
#   3. Installs fzf shell integration (key bindings + completion)
#   4. Installs oh-my-zsh + plugins + theme
#   5. Installs Vundle (vim plugin manager)
#   6. Creates symlinks for dotfiles
#   7. Creates common directory structure
#
# Safe to run multiple times - existing files are backed up, not overwritten.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

# Files to symlink: source (relative to DOTFILES_DIR) -> target (in $HOME)
SYMLINKS=(
  ".zshrc"
  ".vimrc"
  ".bashrc"
  ".aliases"
  ".functions"
)

################################################################################
# Helpers
################################################################################

info()  { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[WARN]\033[0m  %s\n" "$1"; }
err()   { printf "\033[1;31m[ERROR]\033[0m %s\n" "$1"; }

backup_and_link() {
  local src="$1"
  local dst="$2"

  # If destination exists and is not already the correct symlink
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      ok "Already linked: $dst -> $src"
      return
    fi
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    warn "Backed up existing $dst to $BACKUP_DIR/"
  fi

  ln -s "$src" "$dst"
  ok "Linked: $dst -> $src"
}

################################################################################
# 1. Homebrew
################################################################################

install_homebrew() {
  if command -v brew &>/dev/null; then
    ok "Homebrew already installed"
  else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for the rest of this script (Apple Silicon)
    if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    ok "Homebrew installed"
  fi
}

################################################################################
# 2. Brew packages
################################################################################

install_brew_packages() {
  if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    info "Installing Homebrew packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock
    ok "Brew packages installed"
  else
    warn "No Brewfile found, skipping"
  fi
}

################################################################################
# 3. FZF shell integration
################################################################################

install_fzf_integration() {
  local fzf_install="$(brew --prefix)/opt/fzf/install"
  if [ -f "$fzf_install" ]; then
    info "Installing fzf shell integration..."
    "$fzf_install" --key-bindings --completion --no-update-rc --no-bash --no-fish
    ok "fzf shell integration installed"
  else
    warn "fzf not found, skipping shell integration"
  fi
}

################################################################################
# 4. Oh-My-Zsh + plugins + theme
################################################################################

clone_or_pull() {
  # Usage: clone_or_pull <repo_url> <target_dir> <label> [--depth=1]
  local repo="$1"
  local dir="$2"
  local label="$3"
  local depth_flag="${4:-}"

  if [ -d "$dir" ]; then
    info "Updating $label..."
    git -C "$dir" pull --quiet 2>/dev/null || warn "Could not update $label (offline?)"
    ok "$label up to date"
  else
    info "Installing $label..."
    git clone $depth_flag "$repo" "$dir"
    ok "$label installed"
  fi
}

install_oh_my_zsh() {
  local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ -d "$HOME/.oh-my-zsh" ]; then
    info "Updating oh-my-zsh..."
    git -C "$HOME/.oh-my-zsh" pull --quiet 2>/dev/null || warn "Could not update oh-my-zsh (offline?)"
    ok "oh-my-zsh up to date"
  else
    info "Installing oh-my-zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "oh-my-zsh installed"
  fi

  clone_or_pull \
    "https://github.com/romkatv/powerlevel10k.git" \
    "$ZSH_CUSTOM/themes/powerlevel10k" \
    "powerlevel10k" \
    "--depth=1"

  clone_or_pull \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
    "zsh-autosuggestions"

  clone_or_pull \
    "https://github.com/zsh-users/zsh-syntax-highlighting" \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
    "zsh-syntax-highlighting"
}

################################################################################
# 5. Vundle (vim plugin manager)
################################################################################

install_vundle() {
  clone_or_pull \
    "https://github.com/VundleVim/Vundle.vim.git" \
    "$HOME/.vim/bundle/Vundle.vim" \
    "Vundle"

  info "Installing/updating vim plugins..."
  vim +PluginInstall! +qall 2>/dev/null
  ok "Vim plugins up to date"
}

################################################################################
# 6. Symlinks
################################################################################

create_symlinks() {
  info "Creating symlinks..."
  for file in "${SYMLINKS[@]}"; do
    backup_and_link "$DOTFILES_DIR/$file" "$HOME/$file"
  done
}

################################################################################
# 7. Directory structure
################################################################################

create_directories() {
  info "Creating directory structure..."
  local dirs=(
    "$HOME/projects/github.com/bruno-yamada"
    "$HOME/bin"
    "$HOME/.kube"
    "$HOME/.terraform.d/plugin-cache"
  )
  for dir in "${dirs[@]}"; do
    mkdir -p "$dir"
  done
  ok "Directories created"
}

################################################################################
# 8. Reminders
################################################################################

print_post_install() {
  echo ""
  echo "============================================================"
  echo "  Installation complete!"
  echo "============================================================"
  echo ""
  echo "  Next steps:"
  echo ""
  echo "  1. If you have a .p10k.zsh config, copy it to ~/.p10k.zsh"
  echo ""
  echo "  2. Restart your terminal or run:"
  echo "     source ~/.zshrc"
  echo ""
  echo "  3. Run 'p10k configure' if you want to reconfigure your prompt"
  echo ""
  if [ -d "$BACKUP_DIR" ]; then
    echo "  Backed up files are in: $BACKUP_DIR"
    echo ""
  fi
  echo "============================================================"
}

################################################################################
# Main
################################################################################

main() {
  echo ""
  echo "============================================================"
  echo "  Yamada's dotfiles installer"
  echo "============================================================"
  echo "  DOTFILES: $DOTFILES_DIR"
  echo "============================================================"
  echo ""

  install_homebrew
  install_brew_packages
  install_fzf_integration
  install_oh_my_zsh
  install_vundle
  create_symlinks
  create_directories
  print_post_install
}

main "$@"
