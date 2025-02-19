local configs = require "nvim-treesitter.configs"

configs.setup {
	ensure_installed = { "lua", "javascript" },
	highlight = { enable = true },
	indent = { enable = true },
	sync_install = true,
}

