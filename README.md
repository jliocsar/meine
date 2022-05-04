# Meine :boar:

## My personal config files for ZSH, Vim and such

This repo is a collection of my personal configuration files for ZSH, Vim, Tmux and other useful tools _(a.k.a. 2 lazy 2 sync 'em)_.

### Files :evergreen_tree:

```bash
.
├── zsh
│   ├── zinit_plugins
│   ├── zsh_alias
│   ├── zsh_hooks
│   └── zsh_spaceship
├── vim
│   └── .gitkeep
└── .zsh_custom_config # source this in your `.zshrc` file
```

### Usage :ninja:

#### Dependencies

- [zsh](https://www.zsh.org/)
- [oh my zsh](https://ohmyz.sh/)
- [zinit](https://github.com/zdharma-continuum/zinit)
- [nvm](https://github.com/nvm-sh/nvm/blob/master/README.md)
- [spaceship-prompt](https://github.com/spaceship-prompt/spaceship-prompt)
- [bat](https://github.com/sharkdp/bat)

#### Installing

```bash
git clone git@github.com:jliocsar/meine.git $HOME/.meine
echo 'source ~/.meine/zsh_custom_config' >> $HOME/.zshrc
```

