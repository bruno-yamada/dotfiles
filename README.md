# Yamada's dotfiles

## Installation

1. Backup your current `.bashrc`
1. Clone this repo
1. Create an a link to the `~/.bashrc`
```sh
# cd into the cloned repository
ln -s $PWD/.bashrc ~/.bashrc
```

## Add private stuff to `.private`

`.private` is .gitignored and should be used to store **personal, hidden or secure** settings, aliases, exports, and such.
