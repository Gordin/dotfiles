require('illuminate').configure({
  -- delay: delay in milliseconds
  delay = 100,
  -- filetype_overrides: filetype specific overrides.
  -- The keys are strings to represent the filetype while the values are tables that
  -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
  filetype_overrides = {},
  -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
  filetypes_denylist = {
    'dirvish',
    'fugitive',
  },
  -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
  -- See `:help mode()` for possible values
  modes_denylist = {},
  -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
  -- See `:help mode()` for possible values
  modes_allowlist = {},
  under_cursor = false,
})

-- override Color for word highlight after colorscheme is loaded
local group = vim.api.nvim_create_augroup("IlluminateHighlights", {})
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  pattern = "*",
  callback = function ()
    -- vim.api.nvim_set_hl(0, 'IlluminatedWordText',  { underline = true, bg = "#1B3C31" })
    vim.api.nvim_set_hl(0, 'IlluminatedWordText',  { underline = true, italic = true })
    vim.api.nvim_set_hl(0, 'IlluminatedWordRead',  { link = "IlluminatedWordText"   })
    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = "IlluminatedWordText"   })
  end
})
