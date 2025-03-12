local set = vim.keymap.set

-- ## Motions
-- Basic movement keybinds, these make navigating splits easy for me
set('n', '<c-j>', '<c-w><c-j>')
set('n', '<c-k>', '<c-w><c-k>')
set('n', '<c-l>', '<c-w><c-l>')
set('n', '<c-h>', '<c-w><c-h>')

-- ## Buffers
-- Save/write/exit buffer
set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save current buffer' })
set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Exit current buffer' })

-- ## Diagnostics/LSP
-- Shows all errors in the current buffer
set('n', '<leader>le', vim.diagnostic.setloclist, { noremap = true })
-- Open floating window with the cursor error
set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
-- Rename the symbol
set('n', '<leader>r', vim.lsp.buf.rename, { noremap = true, silent = true })
-- Shows the hints from types etc
set('n', '<space>tt', function()
  vim.lsp.inlay_hint.enable(
    not vim.lsp.inlay_hint.is_enabled { bufnr = 0 },
    { bufnr = 0 }
  )
end)
