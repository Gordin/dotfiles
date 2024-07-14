local utils = require("utils")
local notify = require("notify")
vim.notify = notify

local setup_notify_colors = function()
  local search = vim.api.nvim_get_hl(0, {name = "Folded"})
  notify.setup(
  {
    -- background_colour = "NotifyBackground",
    background_colour = utils.numberToRRGGBB(search.background),
    fps = 10,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = ""
    },
    level = 2,
    minimum_width = 50,
    render = "default",
    stages = "fade_in_slide_out",
    time_formats = {
      notification = "%T",
      notification_history = "%FT%T"
    },
    timeout = 5000,
    top_down = true
  })
end

utils.easyAutocmd("NoiceAutocmdGroup", {
  ColorScheme = { callback = setup_notify_colors },
})

vim.keymap.set('n', '<leader><Del>', notify.dismiss, {silent = true, remap = false})
