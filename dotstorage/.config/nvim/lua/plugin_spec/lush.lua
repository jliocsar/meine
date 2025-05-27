local HOME = vim.fn.expand("$HOME")
local config = {
	"rktjmp/lush.nvim",
	priority = 1000,
}

if not vim.g.neovide then
	table.insert(config, {
		dir = HOME .. "/.config/nvim",
		lazy = true,
	})
end

return config
