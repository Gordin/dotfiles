vim.api.nvim_set_hl(0, 'Nothing', { fg="#1D2021", bg="#1D2021"})
require("ibl").setup {
  exclude = {
    buftypes = {'terminal', 'nofile'},
    filetypes = {'help', 'noice', 'startify', 'alpha', 'dashboard', 'packer', 'neogitstatus', 'NvimTree', 'mason.nvim'},
  },
  -- Setting char empty and enabling show_current_context makes it so only your current context 
  -- has indent line
  indent = {
    -- char = {' ', '▎'},
    -- tab_char = { "a", "b", "c" },
    highlight = 'Nothing'
  },
  whitespace = {
    highlight = 'Nothing',
    remove_blankline_trail = false
  },
  scope = {
    enabled = true,
    show_start = true
  },
  -- context_char_blankline = '│',
  -- use_treesitter = true,
  -- show_trailing_blankline_indent = true,
  -- disable_with_nolist = true,
}


local utils = require("utils")

-- Don't link to anything with background here, it will color all spaces...
utils.easyAutocmd("IndentBlankLineSpaceColor", {
  ColorScheme = {
    callback = utils.link_highlight_group {
      IblIndent          = 'DiagnosticSignOk',
      IblWhitespace = 'DiagnosticSignOk',
      -- IblScope = 'DiagnosticSignOk'
    }
  }
})
