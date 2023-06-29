autoload -U add-zsh-hook

# nvm hook
# load-nvmrc() {
#   if [[ -f .nvmrc && -r .nvmrc ]]; then
#     nvm use
#   elif [[ $(nvm version) != $(nvm version default)  ]]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

# change git icon hook
change-spaceship-git-icon() {
  local symbol=""
  if git remote -v 2>/dev/null | grep -q "bitbucket"; then
    symbol="󰂨"
  fi
  export SPACESHIP_GIT_SYMBOL="$symbol "
  export SPACESHIP_GIT_BRANCH_PREFIX="$SPACESHIP_GIT_SYMBOL "
}
add-zsh-hook chpwd change-spaceship-git-icon
change-spaceship-git-icon
