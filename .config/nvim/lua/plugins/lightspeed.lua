require'lightspeed'.setup{}

local remap = vim.keymap.set
-- lightspeed -- jump anywhere by typing s + 1 or 2 letters of where you want to go + shown letter
remap('n', 's', '<Plug>Lightspeed_omni_s', {noremap = false })
remap('n', 'S', '<Plug>Lightspeed_omni_s', {noremap = false })
