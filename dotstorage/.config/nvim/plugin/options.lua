local opt = vim.opt

opt.inccommand = 'split'

opt.smartcase = true
opt.ignorecase = true

opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = 'yes'
opt.swapfile = false

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
