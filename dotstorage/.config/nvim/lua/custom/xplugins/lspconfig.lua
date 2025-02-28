return {
  'neovim/nvim-lspconfig',
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
