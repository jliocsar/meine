## git
alias glog='git log --abbrev-commit --first-parent --oneline'
alias gdiff='function __gdf() { git diff --name-only --diff-filter=d $1^ | xargs bat --diff }; __gdf'
alias gdh='gdiff HEAD'
alias gsl='git switch -'

## zsh
alias j='jump'
alias szh='source $HOME/.zshrc'

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
alias vim="nvim"
alias t='tree -i -L 1'
alias cat='bat'

# meine
alias dotfiles="$HOME/.meine/dotfiles.pl"
alias meine:sync="$HOME/.meine/dotfiles.pl sync \
&& cd $HOME/.meine \
&& git add . \
&& git commit -m 'sync' \
&& git push \
&& cd -"

# i3wm related
if [[ $DESKTOP_SESSION == "i3" ]]; then
    alias volume="alsamixer"
    alias volume:up="amixer -D pulse sset Master 5%+"
    alias volume:down="amixer -D pulse sset Master 5%-"
    alias brightness="brightnessctl"
    alias brightness:inc="sudo brightnessctl set +20%"
    alias brightness:dec="sudo brightnessctl set 20%-"
    alias keyboard:us="setxkbmap us"
    alias keyboard:br="setxkbmap br"
fi
