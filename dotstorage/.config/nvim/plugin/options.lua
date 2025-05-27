local opt = vim.opt

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
opt.shortmess = opt.shortmess + { c = true }

opt.inccommand = 'split'

opt.smartcase = true
opt.ignorecase = true

opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = 'yes'
opt.swapfile = false

-- TODO: Check better way to do this
vim.cmd [[
  augroup NoAutoComment
    autocmd!
    autocmd FileType * setlocal formatoptions-=o
  augroup END
]]
opt.formatoptions:remove 'o'

opt.shada = { "'10", '<0', 's10', 'h' }

opt.wrap = true
opt.linebreak = true

opt.tabstop = 2
opt.shiftwidth = 2

opt.more = false

opt.foldmethod = 'manual'

opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'
opt.statusline = ''

opt.undofile = true

-- Always copy to system clipboard
-- idk why but i like this
opt.clipboard = 'unnamedplus'
