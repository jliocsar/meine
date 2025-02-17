local builtin = require 'telescope.builtin'
local telescope = require 'telescope'

local data = assert(vim.fn.stdpath "data") --[[@as string]]
local set = vim.keymap.set

telescope.setup {
	defaults = {},
	extensions = {
		wrap_results = true,
		fzf = {},
		history = {
			path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
			limit = 100,
		},
	},
}

set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

