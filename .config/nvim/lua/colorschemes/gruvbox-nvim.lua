vim.o.background = "dark" -- or "light" for light mode
-- setup must be called before loading the colorscheme
-- Default options:
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

vim.cmd([[
hi rainbowcol1 guifg=#8ec07c
hi rainbowcol2 guifg=#fe8019
hi rainbowcol3 guifg=#458588
hi rainbowcol4 guifg=#fabd2f
hi rainbowcol4 guifg=#fb4934
hi rainbowcol5 guifg=#689d6a
hi rainbowcol6 guifg=#d5c4a1
]])



vim.cmd("colorscheme gruvbox")
