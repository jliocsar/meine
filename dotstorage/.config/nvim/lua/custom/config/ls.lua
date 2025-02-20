local lspconfig = require "lspconfig"
local mason = require "mason"

mason.setup()

lspconfig.ts_ls.setup {}
lspconfig.lua_ls.setup {}
