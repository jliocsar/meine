local lspconfig = require("lspconfig")

-- Config. for STALKER Anomaly development
local lua_ls_config = vim.g.neovide
		and {
			files = {
				".*%.script",
			},
			settings = {
				files = {
					associations = {
						["*.script"] = "lua",
					},
				},
				Lua = {
					diagnostics = {
						disable = { "lowercase-global" },
					},
					runtime = {
						version = "Lua 5.1",
						plugin = [[C:\Users\sickhowl\Documents\Scripts\anomalydefs\plugin.lua]],
					},
					workspace = {
						ignoreSubmodules = false,
						library = {
							[[C:\Users\sickhowl\Documents\Scripts\anomalydefs\library]],
							[[C:\Abnormally_Cold\tools\_unpacked\scripts]],
						},
					},
				},
			},
		}
	or {}

lspconfig.lua_ls.setup(lua_ls_config)
lspconfig.eslint.setup({})
lspconfig.html.setup({})
lspconfig.ts_ls.setup({})
lspconfig.tailwindcss.setup({})
-- lspconfig.htmx.setup {}
lspconfig.perlnavigator.setup({})
lspconfig.intelephense.setup({})

-- Rust specific shit
lspconfig.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {},
	},
})
