-- # Context
local set = vim.keymap.set

--[[ Not used
local function fn(f, ...)
  local args = { ... }
  return function(...)
    return f(unpack(args), ...)
  end
end
--]]

-- fuck uuuuu
set('n', 'CapsLock', 'Esc')

-- # Plugins
-- Just for an easy life interacting with these
set('n', '<leader>l', '<cmd>Lazy<CR>', { desc = 'Opens Lazy' }, { noremap = true })
set('n', '<leader>m', '<cmd>Mason<CR>', { desc = 'Opens Mason' }, { noremap = true })

-- ## Spectre
set('n', '<leader>S', function()
  require('spectre').toggle()
end, {
  desc = 'Toggle Spectre',
})
set('n', '<leader>sw', function()
  require('spectre').open_visual { select_word = true }
end, {
  desc = 'Search current word',
})
-- TODO: Move this to a Lua function
set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = 'Search current word',
})
set('n', '<leader>sp', function()
  require('spectre').open_file_search { select_word = true }
end, {
  desc = 'Search on current file',
})

-- # Motions
-- ## Basic movement keybinds, these make navigating splits easy for me
set('n', '<c-j>', '<c-w><c-j>')
set('n', '<c-k>', '<c-w><c-k>')
set('n', '<c-l>', '<c-w><c-l>')
set('n', '<c-h>', '<c-w><c-h>')

-- # Buffers
-- ## Save/write/exit buffer
set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save current buffer' })
set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Exit current buffer' })
-- ## Cycle between opened buffers
--    These shouldn't really be a thing here but I like having not to hit : and confirm the command so idk
--    Skill issue I guess
set('n', '<leader>bn', '<cmd>bn<CR>', { desc = 'Next buffer' })
set('n', '<leader>bp', '<cmd>bp<CR>', { desc = 'Previous buffer' })
set('n', '<leader>bd', '<cmd>bd<CR>', { desc = 'Deletes the current buffer' })

-- ## Clear highlights
set('n', '<leader>ch', '<cmd>noh<CR>', { desc = 'Clear highlights' })

-- ## Shows all errors in the current buffer
set('n', '<leader>le', vim.diagnostic.setloclist, { noremap = true })
-- ## Open floating window with the cursor error
set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
-- ## Rename the symbol
set('n', '<leader>r', vim.lsp.buf.rename, { noremap = true, silent = true })
-- ## Shows the hints from types etc
set('n', '<space>tt', function()
  vim.lsp.inlay_hint.enable(
    not vim.lsp.inlay_hint.is_enabled { bufnr = 0 },
    { bufnr = 0 }
  )
end)
