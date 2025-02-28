return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require 'lspconfig'

    -- lspconfig.prettier.setup {}
    lspconfig.eslint.setup {
		autoFixOnSave = true
	}
    lspconfig.ts_ls.setup {}
    lspconfig.lua_ls.setup {}
  end,
  dependencies = {
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        -- 'hrsh7th/cmp-buffer',
        --"zbirenbaum/copilot.lua",
        --"zbirenbaum/copilot-cmp",
      },
      config = function()
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
          mapping = {
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
      end,
    },
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      'folke/lazydev.nvim',
      ft = 'lua',
      dependencies = { 'justinsgithub/wezterm-types' },
      opts = {
        library = {
          -- Or relative, which means they will be resolved from the plugin dir.
          'lazy.nvim',
          -- always load the LazyVim library
          'LazyVim',
          -- Only load the lazyvim library when the `LazyVim` global is found
          { path = 'LazyVim', words = { 'LazyVim' } },
          -- Load the wezterm types when the `wezterm` module is required
          -- Needs `justinsgithub/wezterm-types` to be installed
          { path = 'wezterm-types', mods = { 'wezterm' } },
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
        -- always enable unless `vim.g.lazydev_enabled = false`
        -- This is the default
        -- disable when a .luarc.json file is found
        enabled = function(root_dir)
          return not vim.uv.fs_stat(root_dir .. '/.luarc.json')
        end,
      },
    },
  },
}
