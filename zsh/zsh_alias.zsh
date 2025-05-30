## git
alias g='lazygit'
alias gsl='git switch -'

ginit() {
    g init
    ga .
    gb -M main
    gcmsg 'source files'
    gr add origin git@github.com:jliocsar/$1.git
    gp -u origin main
}

bak() {
	cp $1 $1.bak
}

here() {
	local IFS=' '
	echo "$*" >> "$HOME/.here"
}

## zsh
alias j='jump'
alias szh='source $HOME/.zshrc'

## neovim
alias nvim:cfg="nvim ~/.config/nvim"

## apt
alias update='sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'

## npm/yarn/bun
alias ys='yarn start'
alias yb='yarn build'
alias yd='yarn dev'
alias ya='yarn add'
alias yt='yarn test'
alias yad='yarn add -D'
alias yaw='yarn add -W'
alias yawd='yarn add -WD'
alias nr='npm run'
alias ni='npm install'
alias nid='npm install --save-dev'
alias b='bun'
alias ba='bun add'
alias bd='bun dev'
alias bi='bun install'
alias bu='bun upgrade'
alias bs='bun start'
alias br='bun run'
alias brb='bun run --bun'

## docker
alias dc='docker-compose'
alias dcup='docker-compose up'

# bash
alias t='tree -i -L 1'
alias notes="nvim $HOME/.timov"
# alias notes="EDITOR=nvim glow -a $HOME/.timov"

# meine
alias __assert_meine="if [[ ! -d $HOME/.meine ]]; then echo '~/.meine not found'; return 1; fi"
alias meine="__assert_meine && $HOME/.meine/meine.pl"
alias morning="__assert_meine && $HOME/.meine/morning.pl"

# i3wm related
if [[ $DESKTOP_SESSION == "i3" ]]; then
    alias volume="alsamixer"
    alias volume:up="amixer -D pulse sset Master 10%+"
    alias volume:down="amixer -D pulse sset Master 10%-"
    alias brightness="brightnessctl"
    alias brightness:inc="sudo brightnessctl set +20%"
    alias brightness:dec="sudo brightnessctl set 20%-"
    alias brightness:full="sudo brightnessctl set 100%"
    alias brightness:dim="sudo brightnessctl set 50%"
    alias keyboard:us="setxkbmap us"
    alias keyboard:br="setxkbmap br"
    alias getclass="xprop | grep WM_CLASS | awk '{ print \$4 }'"
fi
