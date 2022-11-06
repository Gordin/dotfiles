-- Twins of word under cursor:
vim.cmd[[let g:vim_current_word#highlight_twins = 1]]
-- The word under cursor:
vim.cmd[[let g:vim_current_word#highlight_current_word = 1]]
vim.cmd[[let g:vim_current_word#highlight_delay = 100]]
--autocmd BufAdd NERD_tree_*,your_buffer_name.rb,*.js :let b:vim_current_word_disabled_in_this_buffer = 1

-- vim.cmd[[hi CurrentWord  gui=underline,bold,italic cterm=underline,bold,italic]]
-- vim.cmd[[hi CurrentWord guifg=#XXXXXX guibg=#XXXXXX gui=underline,bold,italic ctermfg=XXX ctermbg=XXX cterm=underline,bold,italic]]

vim.cmd[[
hi CurrentWord guifg=NONE guibg=#4C4745 gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
hi CurrentWordTwins guifg=NONE guibg=#4C4745 gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
]]

local toggle  = ":let b:vim_current_word_disabled_in_this_buffer = "
local cmd_off = toggle .. "1"
local cmd_on  = toggle .. "0"


local group = vim.api.nvim_create_augroup("AlphaGroup", {})
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "NERD_tree_*",
  command = cmd_off,
})

-- Disable on the startscreen (alpha-nvim)
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "AlphaReady",
  command = cmd_off .. " | autocmd BufUnload <buffer> " .. cmd_on,
})
