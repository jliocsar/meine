local HOME = vim.fn.expand '$HOME'

return {
	'rktjmp/lush.nvim',
	priority = 1000,
	{ dir = HOME .. '/.config/nvim', lazy = true },
}
