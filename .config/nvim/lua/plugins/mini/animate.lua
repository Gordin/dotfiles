local animate = require('mini.animate')
animate.setup({
  cursor = {
    timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
  },
  scroll = {
    timing = animate.gen_timing.linear({ duration = 25, unit = 'total' }),
  }
})

-- Make the animated cursor the same color as visual mode selections
-- Autocommand, because colorschemes can reset this
local group = vim.api.nvim_create_augroup("MiniAnimateColor", {})
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  pattern = "*",
  callback = function ()
    vim.api.nvim_set_hl(0, 'MiniAnimateCursor', { link = "IncSearch" })
  end
})

