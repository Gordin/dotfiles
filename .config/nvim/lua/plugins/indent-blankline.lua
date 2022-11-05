require("indent_blankline").setup {
  buftype_exclude = {'terminal', 'nofile'},
  filetype_exclude = {'help', 'noice', 'startify', 'alpha', 'dashboard', 'packer', 'neogitstatus', 'NvimTree', 'mason.nvim'},
  char = ' ',
  -- char = '▏',
  -- char = '▕',
  show_current_context = true,
  show_current_context_start = true,  -- underline first line
  use_treesitter = true,
  show_trailing_blankline_indent = false,
  char_blankline = ' ',
  char_list = {' ', '▏', '▏', '▏', '▏', '▏', '▏', '▏'}
  -- char_list = {' ', '|', '¦', '┆', '┊'}
  -- char_list_blankline = {'_', '|', '¦', '┆', '┊'}
}
