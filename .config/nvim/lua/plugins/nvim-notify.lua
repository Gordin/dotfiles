local utils = require("utils")
local notify = require("notify")
vim.notify = notify

local setup_notify_colors = function()
  local search = vim.api.nvim_get_hl(0, {name = "Folded"})
  notify.setup({
    background_colour = utils.numberToRRGGBB(search.background),
  })
end

utils.easyAutocmd("NoiceAutocmdGroup", {
  ColorScheme = { callback = setup_notify_colors },
})

vim.keymap.set('n', '<leader><Del>', notify.dismiss, {silent = true, remap = false})
