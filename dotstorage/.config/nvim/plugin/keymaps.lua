local set = vim.keymap.set

-- File explorer
set('n', '<leader>fe', '<cmd>Rex<CR>', { desc = 'Open Netrw' })
set('n', '<leader>se', '<cmd>Lex!<CR>', { desc = 'Open Netrw as a side explorer' })

-- Save/write file
set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save current file' })
