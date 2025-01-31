MEINE_ROOT=$(dirname $0)
MEINE_ZSH_ROOT=$MEINE_ROOT/zsh

function meine_require() {
  source $MEINE_ZSH_ROOT/$1
}

meine_require zsh_alias.zsh
meine_require zsh_hooks.zsh
meine_require zinit_plugins.zsh

$MEINE_ROOT/morning.pl --sh
