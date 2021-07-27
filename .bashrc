# Add `~/bin` to the `$PATH`

# If not running interactively, don't do anything
case $- in
    *i*) ;; # interactive
      *) return;;
esac

export GITUSER="bruno-yamada"
export DOTFILES="$HOME/projects/github.com/bruno-yamada/dotfiles"
export SCRIPTS="$DOTFILES/scripts"

export EDITOR="vim"
export LANG=en_US.UTF-8
export LC_ALL="en_US.UTF-8"

################################################################################
# PATH
################################################################################
pathappend() {
  declare arg
  for arg in "$@"; do
    test -d "${arg}" || continue
    PATH=${PATH//:${arg}:/:}
    PATH=${PATH/#${arg}:/}
    PATH=${PATH/%:${arg}/}
    export PATH="${PATH:+"${PATH}:"}${arg}"
  done
}

pathprepend() {
  for ARG in "$@"; do
    test -d "${ARG}" || continue
    PATH=${PATH//:${ARG}:/:}
    PATH=${PATH/#${ARG}:/}
    PATH=${PATH/%:${ARG}/}
    export PATH="${ARG}${PATH:+":${PATH}"}"
  done
}

# remember last arg will be first in path
pathprepend \
  $SCRIPTS

pathappend \
  $HOME/bin \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/local/go/bin

################################################################################
# Load dotfiles
################################################################################
# * ~/.path can be used to extend `$PATH`.
# * ~/.private can be used for other settings you don’t want to commit.
for file in $DOTFILES/.{path,bash_prompt,exports,aliases,functions,private}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

################################################################################
# shopt - shell options
################################################################################
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;
# Autocorrect typos in path names when using `cd`
shopt -s cdspell;
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# expand aliases on shell scripts (not on POSIX, but bash-specific feature)
shopt -s expand_aliases

################################################################################
# History
################################################################################
export HISTFILE="$HOME/.history"
# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE

################################################################################
# Misc
################################################################################

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

git_branch() {
  # maybe try to improve the performance by making less calls to git
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ -n "$BRANCH" ]; then
    HAS_CHANGES=$(git ls-files -o 2> /dev/null)
    IS_BEHIND=$(git status 2> /dev/null | grep 'Your branch.*behind')
    IS_AHEAD=$(git status 2> /dev/null | grep 'Your branch.*ahead')
    if [ -n "$HAS_CHANGES" ]; then
      BRANCH="$BRANCH*"
    fi
    if [ -n "$IS_BEHIND" ]; then
      BRANCH="$BRANCH↓"
    fi
    if [ -n "$IS_AHEAD" ]; then
      BRANCH="$BRANCH↑"
    fi
    BRANCH="($BRANCH)"
  fi
  echo $BRANCH
}

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(git_branch)\$ '
    PS1='\[\033[01;34m\]\w\[\033[00m\]$(git_branch)\$ '
else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='\W\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

########
# FZF customizations, affects Ctrl+T, Ctrl+R, vim Ctrl+P, etc
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# replace default fzf command
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -f -g ""'

# replace default Ctrl-T command from fzf keybindings (faster)
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

