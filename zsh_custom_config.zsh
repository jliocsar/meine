MEINE_ROOT=$(dirname $0)/zsh

function meine_require() {
  source $MEINE_ROOT/$1
}

meine_require zsh_alias.zsh
meine_require zsh_hooks.zsh
meine_require zinit_plugins.zsh
