local g = vim.g

-- ## Netrw configs

-- set list style type to tree
-- g.netrw_liststyle = 3

-- hide gitignored files in the list
-- TODO: How to convert this to the Lua format
-- g.netrw_list_hide = 'netrw_gitignore#Hide()'

-- hides the title banner
g.netrw_banner = 0

-- toggles files preview
g.netrw_preview = 1
-- g.netrw_liststyle = 3
g.netrw_winsize = 28

-- some stuff to make netrw feel like a true IDE file explorer
g.netrw_browse_split = 0
g.netrw_keepdir = 0
