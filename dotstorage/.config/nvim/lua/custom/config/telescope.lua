local telescope = require 'telescope'

local data = assert(vim.fn.stdpath 'data') --[[@as string]]

telescope.setup {
  defaults = {},
  extensions = {
    wrap_results = true,
    fzf = {},
    history = {
      path = vim.fs.joinpath(data, 'telescope_history.sqlite3'),
      limit = 100,
    },
  },
}
