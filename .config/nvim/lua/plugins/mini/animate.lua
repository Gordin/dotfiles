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
local utils = require('utils')
utils.easyAutocmd("MiniAnimateColor", {
  ColorScheme = { callback = utils.link_highlight_group{ MiniAnimateCursor = 'IncSearch' } }
})
