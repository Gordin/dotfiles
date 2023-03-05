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

M.return_to_last_cursor_position = function()
  local ft = vim.bo.filetype
  if string.find(ft, "commit") then return end
  if string.find(ft, "svn") then return end

  local last_pos = vim.fn.line("'\"")
  if last_pos > 0 and last_pos <= vim.fn.line("$") then
    vim.cmd[[ exe "normal! g`\"" ]]
    vim.cmd[[ normal! zz ]]
    -- The lua version below always go to to first column of a line
    -- vim.api.nvim_win_set_cursor(0, {last_pos, 0})
  end

  -- This doesn't belong here, but something is overwriting this, so let's set this for every buffer...
  -- Continue comments on next line, when pressing <CR>, but not with o/O (and a lot of other settings...)
  vim.opt.formatoptions = "rc/n1jp"
end

M.mergeBintoA = function(tableA, tableB)
  for key, value in pairs(tableB) do
    tableA[key] = value
  end
  return tableA
end

M.easyAutocmd = function(unique_group_name, opts)
  local group = vim.api.nvim_create_augroup(unique_group_name, {})
  vim.api.nvim_clear_autocmds({ group = group })

  for event, options in pairs(opts) do
    local real_opts = M.mergeBintoA({ group = group  }, options)
    if not (real_opts["pattern"] or real_opts["buffer"]) then
      real_opts["pattern"] = '*'
    end
    vim.api.nvim_create_autocmd(event, real_opts)
  end
end

M.link_highlight_group = function(group_mapping)
  return function ()
    for group, group_to_link_to in pairs(group_mapping) do
      vim.api.nvim_set_hl(0, group, { link = group_to_link_to })
    end
  end
end

return M
