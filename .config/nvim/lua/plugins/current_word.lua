-- Twins of word under cursor:
vim.cmd[[let g:vim_current_word#highlight_twins = 1]]
-- The word under cursor:
vim.cmd[[let g:vim_current_word#highlight_current_word = 1]]
vim.cmd[[let g:vim_current_word#highlight_delay = 100]]
--autocmd BufAdd NERD_tree_*,your_buffer_name.rb,*.js :let b:vim_current_word_disabled_in_this_buffer = 1

-- vim.cmd[[hi CurrentWord  gui=underline,bold,italic cterm=underline,bold,italic]]
-- vim.cmd[[hi CurrentWord guifg=#XXXXXX guibg=#XXXXXX gui=underline,bold,italic ctermfg=XXX ctermbg=XXX cterm=underline,bold,italic]]

-- hi CurrentWord guifg=NONE guibg=#4C4745 gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
vim.cmd[[
hi CurrentWord guifg=NONE guibg=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
hi CurrentWordTwins guifg=NONE guibg=#4C4745 gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
]]

local toggle  = ":let b:vim_current_word_disabled_in_this_buffer = "
local cmd_off = toggle .. "1"
local cmd_on  = toggle .. "0"

local group = vim.api.nvim_create_augroup("CurrentWordGroup", {})
vim.api.nvim_clear_autocmds({ group = group })

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "NERD_tree_*",
  command = cmd_off,
})

-- Disable on the startscreen (alpha-nvim)
local alpha_installed, _ = pcall(require, "alpha")
if alpha_installed then
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "AlphaReady",
    command = cmd_off .. " | autocmd BufUnload <buffer> " .. cmd_on,
  })
end

local function disable_for_nvim_tree()
  local nvim_tree_installed, nvim_tree = pcall(require, "nvim-tree.api")
  if not nvim_tree_installed then
    return
  end

  local Event = nvim_tree.events.Event

  nvim_tree.events.subscribe(Event.TreeOpen, function(_)
    vim.cmd(cmd_off)
  end)

  nvim_tree.events.subscribe(Event.TreeClose, function(_)
    vim.cmd(cmd_on)
  end)
end

disable_for_nvim_tree()
