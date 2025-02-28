local conform = require 'conform'

conform.setup {
  formatters = {},
  formatters_by_ft = {
    lua = { 'stylua' },
    typescript = { 'prettierd', 'prettier' },
    javascript = { 'prettierd', 'prettier' },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
}
