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

## npm/yarn
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

# bash
if command -v tree &> /dev/null; then
  alias ls='tree -L 1'
fi

if command -v bat &> /dev/null; then 
  alias cat='bat'
fi
