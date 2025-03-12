local conform = require 'conform'

conform.setup {
  formatters = {},
  formatters_by_ft = {
    html = { 'prettierd' },
    lua = { 'stylua' },
    typescript = { 'prettierd' },
    typescriptreact = { 'prettierd' },
    javascript = { 'prettierd' },
    javascriptreact = { 'prettierd' },
    perl = { 'perl' },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
}
