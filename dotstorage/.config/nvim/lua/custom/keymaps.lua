local set = vim.keymap.set

-- Basic movement keybinds, these make navigating splits easy for me
set('n', '<c-j>', '<c-w><c-j>')
set('n', '<c-k>', '<c-w><c-k>')
set('n', '<c-l>', '<c-w><c-l>')
set('n', '<c-h>', '<c-w><c-h>')

set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Execute the current file' })

-- Save/write/exit buffer
set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save current buffer' })
set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Exit current buffer' })

set('n', '<space>tt', function()
  vim.lsp.inlay_hint.enable(
    not vim.lsp.inlay_hint.is_enabled { bufnr = 0 },
    { bufnr = 0 }
  )
end)
