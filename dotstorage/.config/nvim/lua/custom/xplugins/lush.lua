local HOME = vim.fn.expand '$HOME'

return {
  'rktjmp/lush.nvim',
  { dir = HOME .. '/.config/nvim', lazy = true },
}
