local cmp = require 'cmp'

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
