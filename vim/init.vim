lua<<EOF
  local MEINE_VIM_LUA_PATH = os.getenv('HOME') .. '/.meine/vim/lua'

  function import(path)
    return dofile(MEINE_VIM_LUA_PATH .. '/' .. path .. '.lua')
  end

  import('init')
EOF
