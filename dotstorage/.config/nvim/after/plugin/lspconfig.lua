local lspconfig = require 'lspconfig'

lspconfig.eslint.setup {
  autoFixOnSave = true,
}
lspconfig.ts_ls.setup {}
lspconfig.lua_ls.setup {}
lspconfig.tailwindcss.setup {}
lspconfig.htmx.setup {}
lspconfig.perlnavigator.setup {}
