return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	priority = 1000,
	dependencies = {
		'nvim-treesitter/nvim-treesitter-context',
	},
}
