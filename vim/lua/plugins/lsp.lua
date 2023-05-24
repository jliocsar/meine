local lsp = require "lspconfig"
local coq = require "coq"

lsp.pyright.setup(coq.lsp_ensure_capabilities())
