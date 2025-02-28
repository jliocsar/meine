return {
  'olimorris/onedarkpro.nvim',
  config = function()
    local onedarkpro = require 'onedarkpro'

    onedarkpro.setup {
      colors = {
        red = '#cccccc',
        green = '#7fc954',
        blue = '#65c1d8',
        purple = '#e65959',
        orange = '#e69d59',
      },
      options = {
        transparency = true,
      },
    }

    vim.cmd.colorscheme 'onedark'
  end,
}
