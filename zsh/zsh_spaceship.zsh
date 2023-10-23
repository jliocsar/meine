SPACESHIP_PROMPT_ORDER=(
  time               # Time stamps section
  user               # Username section
  dir                # Current directory section
  host               # Hostname section
  hg                 # Mercurial section (hg_branch  + hg_status)
  node		           # Node section
  venv		           # Virtual env section
  git                # Git section (git_branch + git_status)
  exec_time          # Execution time
  line_sep           # Line break
  jobs               # Background jobs indicator
  exit_code          # Exit code section
  char               # Prompt character
)
SPACESHIP_USER_SHOW=never
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL=""
# SPACESHIP_CHAR_SYMBOL=";"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_NODE_SYMBOL="󰎙  "
# SPACESHIP_PROMPT_SUFFIXES_SHOW=false
SPACESHIP_PROMPT_PREFIXES_SHOW=false
SPACESHIP_PROMPT_SEPARATE_LINE=true
SPACESHIP_DIR_TRUNC_REPO=true
SPACESHIP_DIR_LOCK_SYMBOL="  "
SPACESHIP_GIT_SYMBOL=" "
SPACESHIP_GIT_BRANCH_PREFIX="$SPACESHIP_GIT_SYMBOL "
SPACESHIP_GIT_STATUS_RENAMED=" 󰙏 "
SPACESHIP_GIT_STATUS_MODIFIED=" 󰈿 "
SPACESHIP_GIT_STATUS_DELETED="  "
SPACESHIP_GIT_STATUS_UNMERGED="  "
SPACESHIP_GIT_STATUS_STASHED="  "
SPACESHIP_GIT_STATUS_SUFFIX=""
SPACESHIP_GIT_STATUS_PREFIX=" "
