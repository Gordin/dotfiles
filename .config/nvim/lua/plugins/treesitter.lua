require'nvim-treesitter.configs'.setup {
  markid = {
    enable = true,
    colors = false
  },
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,          -- false will disable the whole extension
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  matchup = {
    enable = true
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  rainbow = {
    enable = true,
    query = 'rainbow-parens',
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    strategy = require 'ts-rainbow.strategy.local',
  }
}

local group = vim.api.nvim_create_augroup("TSRainbow", {})
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd('InsertLeave',  {
  group=group,
  pattern = "*",
  callback = function ()
    vim.cmd[[:TSDisable rainbow | TSEnable rainbow]]
  end
})
