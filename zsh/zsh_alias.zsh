## git
alias glog='git log --graph --decorate --stat'
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

## docker
alias dc='docker-compose'
alias dcup='docker-compose up'

# bash
alias vim="nvim"
alias t='tree -L 1'
alias cat='bat'
