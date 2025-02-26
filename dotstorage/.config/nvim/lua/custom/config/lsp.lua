local lspconfig = require 'lspconfig'
local mason = require 'mason'

-- Setup Mason as the LSP manager
mason.setup()

-- Setup the LSPs that are used 
lspconfig.ts_ls.setup {}
lspconfig.lua_ls.setup {}
