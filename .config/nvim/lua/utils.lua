local M = {}
local nvim_exec = function (src, output)
  output = output or false
  return vim.api.nvim_exec(src, output)
end
local fn = vim.fn
local substitute = fn['substitute']
local matchstr   = fn['matchstr']
local matchlist  = fn['matchlist']

M.rB = function (groupName)
  local output = nvim_exec('hi! ' .. groupName, true)
  if string.len(output) == 0 then
    -- vim.pretty_print(groupName)
    return
  end
  local settings = matchstr(output, "\\( \\w\\+=\\w\\+\\)\\+")
  local command = 'highlight! ' .. groupName .. settings -- .. matchstr(output, '\( \w\+=\w\+\)\+')
  command = substitute(command, 'ctermbg=\\w\\+', "", "")
  command = substitute(command, 'guibg=\\w\\+', "", "")
  -- group['background'] = nil
  -- vim.api.nvim_set_hl(0, groupName, group)
  -- local newStuff = execute('matchstr(' .. groupName .. [[, '\( \w\+=\w\+\)\+')]])
  -- vim.pretty_print(command)
  local clear_command = command .. ' ctermbg=NONE guibg=NONE'
  -- vim.pretty_print(clear_command)
  nvim_exec(clear_command)
  -- vim.pretty_print(command)
  nvim_exec(command)

  -- Some Highlight groups are linked to other Groups (They inherit settings from a different group)
  -- This gets the currently linked group. (This code probably only works for 0 or 1 linked
  -- group...)
  local matches = matchlist(output, '\\( links to \\(\\w\\+\\)\\)\\+')
  local link = matches[3]
  -- If there is a link, create and run a command that sets the link again, because it was removed
  -- by the prevous commands
  if link and string.len(link) > 1 then
    nvim_exec('highlight! link ' .. groupName .. " " .. link)
  end
end

M.enableMouseSelection = function()
  M.mouse_select = true
  vim.opt.list = false
  vim.opt.number = false
  vim.opt.numberwidth = 1
  vim.opt.relativenumber = false
  vim.opt.mouse= ""
  vim.opt.signcolumn='no'
  vim.opt.conceallevel=0
  vim.opt.paste = true
end

M.disableMouseSelection = function()
  M.mouse_select = false
  vim.opt.list = true
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.opt.numberwidth = 4
  vim.opt.mouse= "nvi"
  vim.opt.signcolumn='auto'
  vim.opt.conceallevel=2
  vim.opt.paste = false
end

M.toggleMouseSelection = function ()
  if M.mouse_select then
    M.disableMouseSelection()
  else
    M.enableMouseSelection()
  end
end

return M
