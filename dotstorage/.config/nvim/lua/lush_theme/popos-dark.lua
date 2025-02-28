local lush = require 'lush'
local hsl = lush.hsl

-- lush() will parse the spec and
-- return a table containing all color information.
-- We return it for use in other files.
return lush(function()
  return {
    -- Define Vim's Normal highlight group.
    -- You can provide values with hsl/hsluv or anything that responds to `tostring`
    -- but be aware if you don't "wrap" your color in a hsl/hsluv call you
    -- wont have chainable access to the color "operators" (darken, etc).
    Normal { bg = 'NONE', fg = hsl '#A3CFF5' },

    -- Make whitespace slightly darker than normal.
    -- you must define Normal before deriving from it.
    Whitespace { fg = Normal.fg.darken(40) },

    -- Make comments look the same as whitespace, but with italic text
    Comment { fg = '#666666', gui = 'italic' },

    -- Clear all highlighting for CursorLine
    CursorLine {},
  }
end)
