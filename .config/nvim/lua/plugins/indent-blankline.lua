require("indent_blankline").setup {
  buftype_exclude = {'terminal', 'nofile'},
  filetype_exclude = {'help', 'noice', 'startify', 'alpha', 'dashboard', 'packer', 'neogitstatus', 'NvimTree', 'mason.nvim'},
  -- Setting char empty and enabling show_current_context makes it so only your current context 
  -- has indent line
  char = ' ',
  show_current_context = true,
  show_current_context_start = true,  -- underline first line
  context_char_blankline = '│',
  use_treesitter = true,
  show_trailing_blankline_indent = true,
  disable_with_nolist = true,
}

local utils = require("utils")

utils.easyAutocmd("IndentBlankLineSpaceColor", {
  ColorScheme = {
    callback = function ()
      -- Don't link to anything with background here, it will color all spaces...
      utils.link_highlight_group('IndentBlanklineSpaceChar',          'DiagnosticSignOk')
      utils.link_highlight_group('IndentBlanklineSpaceCharBlankline', 'DiagnosticSignOk')
    end
  }
})
