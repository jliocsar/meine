local set = vim.keymap.set

-- File explorer
set('n', '<leader>fe', '<cmd>Lex<CR>', { desc = 'Open Netrw' })

-- Save/write file
set('n', '<leader>s', '<cmd>w<CR>', { desc = 'Save current file' })

