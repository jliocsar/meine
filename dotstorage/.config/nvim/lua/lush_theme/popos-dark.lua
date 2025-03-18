local lush = require 'lush'
local hsl = lush.hsl

-- Run Borderline command to change border colors and styles
vim.cmd [[Borderline single]]

-- lush() will parse the spec and
-- return a table containing all color information.
-- We return it for use in other files.
return lush(function()
  return {
    Normal { bg = 'NONE', fg = hsl '#cccccc' },
    -- Whitespace { fg = Normal.fg.darken(40) },
    CursorLine { bg = hsl '#333333' },
    -- Constant { fg = hsl '#7dbea9', bold = true },
    Constant { fg = hsl '#7dbef9', bold = true },
    Comment { fg = hsl '#999999' },
    Function { fg = hsl '#65c1d8', bold = true },
    Keyword { fg = hsl '#e65959', bold = true, italic = true },
    String { fg = hsl '#7fc954' },
    Special { fg = hsl '#A0A0A0' },
    Type { fg = hsl '#8cdad3' },

    Cursor { gui = styles.inverse },
    Identifier { fg = hsl '#d7ba7d' },

    StatusLine { bg = 'NONE', fg = hsl '#A0A0A0' },

    -- Oil settings
    OilDir { fg = hsl '#8cdad3' },

    -- Express_line settings
    ElVisual { fg = hsl '#d7ba7d' },
    ElVisualLine { bg = hsl '#e6da59', fg = hsl '#111111' },
    ElNormal { fg = hsl '#65c1d8' },
    -- ElInsert { bg = hsl '#7fc954', fg = hsl '#111111' },
    ElCommand { bg = hsl '#e69d59', fg = hsl '#111111' },

    -- Telescope Settings
    TelescopeMatching { fg = hsl '#FFFFFF' },
    TelescopeSelection { bg = hsl '#333333', fg = hsl '#FFFFFF' },
    TelescopeResultsNormal { fg = hsl '#A0A0A0' },
    TelescopePromptBorder { fg = hsl '#999999' },
    TelescopeResultsBorder { fg = hsl '#999999' },
    TelescopePreviewBorder { fg = hsl '#999999' },

    -- Treesitter Settings
    TreesitterContext { bg = hsl '#292929' },
    TreesitterContextBottom { bg = hsl '#292929' },

    -- Change floating window border and background
    NormalFloat { bg = 'NONE' },
    Pmenu { bg = 'NONE' },
    FloatBorder { fg = hsl '#999999' },

    -- Flash Settings
    FlashBackdrop {},

    -- Fidget notifications
    FidgetTask { bg = 'NONE' },
  }
end)
