# Meine :boar:

## My personal config files for ZSH and such

This repo is a collection of my personal configuration files for ZSH and other useful tools _(a.k.a. 2 lazy 2 sync 'em)_.

### Usage :ninja:

#### Installing

Simply run the `install` script:

```bash
./install.pl
```

### Requirements/Recommendations

- [warp](https://www.warp.dev/)
- [i3wm](https://i3wm.org/)
- [zsh](https://www.zsh.org/)
- [oh-my-zsh](https://ohmyz.sh/)
- [zinit](https://github.com/zdharma-continuum/zinit)
- [bat](https://github.com/sharkdp/bat)
- [difftastic](https://github.com/Wilfred/difftastic)
- [yazi](https://github.com/sxyazi/yazi)
- [glow](https://github.com/charmbracelet/glow)
- [http](https://github.com/httpie/cli)
- [fzf](https://github.com/junegunn/fzf)
- [harlequin](https://github.com/tconbeer/harlequin)
- [lazygit](https://github.com/jesseduffield/lazygit)

#### Useful External Libs

- [luvit](https://luvit.io/install.html)

#### For i3wm

- [blueman](https://github.com/blueman-project/blueman)
- [feh](https://github.com/derf/feh)
- [fastcompmgr](https://github.com/tycho-kirchner/fastcompmgr)
  - alternatively, [picom](https://github.com/yshui/picom) with [flashfocus](https://github.com/fennerm/flashfocus)

### Development

#### nvim configs

1. If you want to change the `nvim` config file via VSCode, make sure that the path in `workspace.library` inside the `.luarc.json` file is the same as the `$VIMRUNTIME` inside `nvim`

### To-do

- [ ] centralize colors variables somewhere
- [ ] make a generic thing for the zsh_custom_config replace (from sed)
- [ ] finish rofi theme
