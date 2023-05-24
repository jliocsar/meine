local Plug = vim.fn['plug#']

-- Plugged
vim.call 'plug#begin'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug('nvim-telescope/telescope.nvim', { tag = '0.1.1' })
Plug('ms-jpq/coq_nvim', { branch = 'coq' })
vim.call 'plug#end'

-- Will import the file based on the filename inside `plugins/{filename}.lua`
local plugins = { 'lsp', 'nvim-tree' }

for pluginCount = 1, #plugins do
  import('plugins/' .. plugins[pluginCount])
end
