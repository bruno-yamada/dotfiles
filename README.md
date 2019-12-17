# Yamada's dotfiles

## Installation

1. Clone this repo to you `home` directory:

```sh
cd ~ && git clone https://github.com/bruno-yamada/dotfiles.git
```

2. Backup your current `.bashrc` with something like:

```sh
cd ~ && cp .bashrc .bashrc-backup
```

3. Change your `.bashrc` to the following:
```
[ -n "$PS1" ] && source ~/dotfiles/.bashrc;
```

## Add private stuff to `.private`

`.private` is .gitignored and should be used to store **personal, hidden or secure** settings, aliases, exports, and such.