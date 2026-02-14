# Yamada's zshrc
# https://github.com/bruno-yamada/dotfiles

# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("$HOME/.oh-my-zsh/custom/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

################################################################################
# Oh-My-Zsh
################################################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ZSH behavior
CASE_SENSITIVE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_AUTO_TITLE="true" # auto-setting terminal title can mess up tmux

# oh-my-zsh overrides
export PAGER="" # behave the same as bash (oh-my-zsh defaults to "less")

plugins=(
  kubectl              # remove later, add alias explicitly instead
  zsh-syntax-highlighting # visual sugar
  zsh-autosuggestions     # really useful
)

source $ZSH/oh-my-zsh.sh

################################################################################
# Core env vars
################################################################################
export GITUSER="bruno-yamada"
export DOTFILES="$HOME/projects/github.com/$GITUSER/dotfiles"
export SCRIPTS="$DOTFILES/scripts"

export EDITOR="vim"
export LANG=en_US.UTF-8
export LC_ALL="en_US.UTF-8"
export CLICOLOR=1

export HISTFILE="$HOME/.history"
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE

# shared plugin cache for terraform inits
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

export PRE_COMMIT_ALLOW_NO_CONFIG=1

################################################################################
# PATH
################################################################################
export PATH="$SCRIPTS:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Homebrew (Apple Silicon)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# asdf version manager
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# krew (kubectl plugin manager)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init -)"

# rbenv
command -v rbenv &>/dev/null && eval "$(rbenv init - --no-rehash zsh)"

# goenv
command -v goenv &>/dev/null && eval "$(goenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"

# go delve debugger workaround (https://github.com/go-delve/delve/issues/852)
export DELVE_DEBUGSERVER_PATH="$HOME/projects/github.com/llvm-project/zz/bin"

################################################################################
# Load dotfiles modules
################################################################################
# .aliases   - shell aliases (git, docker, navigation, etc)
# .functions - shell functions (git, docker, k8s, tmux, etc)
# .private   - secrets, tokens, API keys (gitignored - see .private.example)
for file in "$DOTFILES"/.{aliases,functions,private}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

################################################################################
# FZF
################################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -f -g ""'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

################################################################################
# direnv
################################################################################
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

################################################################################
# Completions
################################################################################
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# kubectl completions (the plugin handles basic completions, this adds full support)
command -v kubectl &>/dev/null && source <(kubectl completion zsh)

# aws completions
complete -C '/usr/local/bin/aws_completer' aws

# gh copilot aliases
command -v gh &>/dev/null && eval "$(gh copilot alias -- zsh)" 2>/dev/null

################################################################################
# Kubernetes
################################################################################
export KUBECONFIG="$HOME/.kube/kubeconfig"

################################################################################
# Powerlevel10k
################################################################################
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
