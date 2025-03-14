local cmp = require 'cmp'

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }

cmp.setup {
  sources = {
    {
      name = 'lazydev',
      -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
      group_index = 0,
    },
    { name = 'nvim_lsp' },
    --{ name = 'copilot' },
    --{ name = 'path' },
    --{ name = 'buffer' },
  },
  window = {
    documentation = {
      -- these borders will be overwritten by "borderline", this is just so we can turn them on
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    },
    completion = {
      -- these borders will be overwritten by "borderline", this is just so we can turn them on
      border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
    },
  },
  mapping = {
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-n>'] = cmp.mapping.select_next_item {
      behavior = cmp.SelectBehavior.Insert,
    },
    ['<C-p>'] = cmp.mapping.select_prev_item {
      behavior = cmp.SelectBehavior.Insert,
    },
    ['<C-y>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i', 'c' }
    ),
  },
}
