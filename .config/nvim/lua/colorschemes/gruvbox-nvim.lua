vim.o.background = "dark" -- or "light" for light mode
-- setup must be called before loading the colorscheme
local gruvbox = require('gruvbox')
local palette = gruvbox.palette
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "hard", -- can be "hard", "soft" or empty string
  -- I don't like the neutral colors, so make everything the normal colors 
  palette_overrides = {
    neutral_red    = palette.bright_red,
    neutral_green  = palette.bright_green,
    neutral_yellow = palette.bright_yellow,
    neutral_blue   = palette.bright_blue,
    neutral_purple = palette.bright_purple,
    neutral_aqua   = palette.bright_aqua,
    neutral_orange = palette.bright_orange,
  },
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

vim.api.nvim_set_hl(0, 'Nothing', { fg="#1D2021", bg="#1D2021"})
vim.cmd("colorscheme gruvbox")
