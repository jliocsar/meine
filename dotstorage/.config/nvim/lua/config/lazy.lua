-- Setup lazy.nvim
local lazy = require "lazy"

lazy.setup {
    -- Treesitter configs
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require "nvim-treesitter.configs"
            configs.setup {
                ensure_installed = { "lua", "python" },
                sync_install = false,
                highlight = { enabled = true },
                indent = { enabled = true }
            }
        end,
    }
    --
}
