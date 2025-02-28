local lush = require 'lush'
local theme = require 'lush_theme.popos-dark'

-- Change some plugins' colors
local error = '#e65959'
local warn = '#e69d59'
local primary = '#8cdad3'

-- Telescope colors
vim.api.nvim_set_hl(0, 'TelescopeMatching', { fg = '#FFFFFF' })
vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = '#333333', fg = '#FFFFFF' })
vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { fg = '#A0A0A0' })
vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = '#999999' })
vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = '#999999' })
vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = '#999999' })

lush(theme)
