local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

require('neoclip').setup({
  enable_persistent_history = true,
  continuous_sync = true,
  default_register = {'"', '+', '*'},
  keys = {
    telescope = {
      i = {
        select = {'<space>', 'y'},
        paste = '<cr>',
        paste_behind = '<c-k>',
        replay = '<c-q>',  -- replay a macro
        delete = '<c-d>',  -- delete an entry
        custom = {},
      },
      n = {
        select = {'<space>', 'y'},
        paste = '<cr>',
        --- It is possible to map to more than one key.
        -- paste = { 'p', '<c-p>' },
        paste_behind = 'P',
        replay = 'q',
        delete = 'd',
        custom = {},
      },
    },
  },
  filter = function(data)
    return not all(data.event.regcontents, is_whitespace) -- don't store whitespace yanks
  end,
})
