require'nvim-treesitter.configs'.setup {
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

local utils = require("utils")

local interval_ms = 1000
local last_execution = 0
local function restart_rainbow()
  vim.cmd[[:TSDisable rainbow | TSEnable rainbow]]
end

-- Use a timer that ensures, this is only triggered once every 500ms
function Reset_Rainbow_Timer()
  local now = vim.loop.now()
  if now - last_execution >= interval_ms then
    last_execution = now
    local timer = vim.loop.new_timer()
    if timer == nil then return end

    -- timer:start(interval_ms, 0, vim.schedule_wrap(restart_rainbow))
    restart_rainbow()
  end
end

utils.easyAutocmd("TSRainbow", {
  TextChanged = { pattern = "*", callback = Reset_Rainbow_Timer }
})
