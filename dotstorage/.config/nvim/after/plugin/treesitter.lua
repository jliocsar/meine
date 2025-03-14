local configs = require 'nvim-treesitter.configs'
local context = require 'treesitter-context'

context.setup {}
configs.setup {
  ensure_installed = { 'lua', 'javascript', 'typescript', 'perl', 'tsx', 'rust' },
  highlight = { enable = true },
  indent = { enable = true },
  sync_install = true,
}
