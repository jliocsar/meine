return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require 'nvim-treesitter.configs'

    configs.setup {
      ensure_installed = { 'lua', 'javascript', 'typescript', 'perl' },
      highlight = { enable = true },
      indent = { enable = true },
      sync_install = true,
    }
  end,
}
