local lush = require 'lush'
local hsl = lush.hsl

-- lush() will parse the spec and
-- return a table containing all color information.
-- We return it for use in other files.
return lush(function()
  return {
    Normal { bg = 'NONE', fg = hsl '#cccccc' },
    -- Whitespace { fg = Normal.fg.darken(40) },
    CursorLine { bg = hsl '#333333' },
    Constant { fg = hsl '#7dbea9', bold = true },
    Comment { fg = hsl '#999999' },
    Function { fg = hsl '#65c1d8', bold = true },
    Keyword { fg = hsl '#e65959', bold = true, italic = true },
    String { fg = hsl '#7fc954' },
    Special { fg = hsl '#A0A0A0' },
    Type { fg = hsl '#8cdad3' },

    Cursor { gui = styles.inverse },
    Identifier { fg = hsl '#d7ba7d' },

    StatusLine { bg = 'NONE', fg = hsl '#A0A0A0' },

    -- Telescope Settings
    TelescopeMatching { fg = hsl '#FFFFFF' },
    TelescopeSelection { bg = hsl '#333333', fg = hsl '#FFFFFF' },
    TelescopeResultsNormal { fg = hsl '#A0A0A0' },
    TelescopePromptBorder { fg = hsl '#999999' },
    TelescopeResultsBorder { fg = hsl '#999999' },
    TelescopePreviewBorder { fg = hsl '#999999' },
  }
end)
