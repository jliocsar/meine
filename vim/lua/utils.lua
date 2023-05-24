local Map = {}

function Map.map(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { silent = true })
end

function Map.noremap(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

function Map.exprnoremap(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true, expr = true })
end

-- Useful mode-specific shortcuts
-- nomenclature: "<expr?><mode><nore?>map(lhs, rhs)" where:
--      "expr?" optional expr option
--      "nore?" optional no-remap option
--      modes -> 'n' = NORMAL, 'i' = INSERT, 'x' = 'VISUAL', 'v' = VISUAL + SELECT, 't' = TERMINAL

function Map.nmap(lhs, rhs) Map.map('n', lhs, rhs) end

function Map.xmap(lhs, rhs) Map.map('x', lhs, rhs) end

function Map.nnoremap(lhs, rhs) Map.noremap('n', lhs, rhs) end

function Map.vnoremap(lhs, rhs) Map.noremap('v', lhs, rhs) end

function Map.xnoremap(lhs, rhs) Map.noremap('x', lhs, rhs) end

function Map.inoremap(lhs, rhs) Map.noremap('i', lhs, rhs) end

function Map.tnoremap(lhs, rhs) Map.noremap('t', lhs, rhs) end

function Map.exprnnoremap(lhs, rhs) Map.exprnoremap('n', lhs, rhs) end

function Map.exprinoremap(lhs, rhs) Map.exprnoremap('i', lhs, rhs) end

return Map
