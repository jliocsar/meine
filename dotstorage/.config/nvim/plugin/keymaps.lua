local builtin = require 'telescope.builtin'

local set = vim.keymap.set

-- File explorer
set('n', '<leader>fe', '<cmd>Rex<CR>', { desc = 'Open Netrw' })
set('n', '<leader>se', '<cmd>Lex!<CR>', { desc = 'Open Netrw as a side explorer' })

-- Save/write file
set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save current file' })

-- Telescope
set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
