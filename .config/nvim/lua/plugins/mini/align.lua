local align = require('mini.align')
align.setup({
  mappings = {
    start_with_preview = '<leader>=',
  }
})

local remap = vim.keymap.set
remap('x', '<leader>=', '<Cmd>lua MiniAlign.action_visual(true)<CR>', { remap = false })
remap('n', '<leader>=', 'v:lua.MiniAlign.action_normal(v:true)',      { remap = false })
