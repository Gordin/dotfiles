local M = {}

M.change_ruby_color = function(color)
  -- local ruby_color = "#701516"
  color = color or "#fb4934"

  local ruby_icons = {
    "DevIconGemspec",
    "DevIconRakefile",
    "DevIconRake",
    "DevIconErb",
    "DevIconRb",
    "DevIconConfigRu",
    "DevIconGemfile",
    "DevIconBrewfile"
  }

  for _, group in ipairs(ruby_icons) do
    vim.api.nvim_set_hl(0, group, { foreground = color })
  end
end

M.change_ruby_color('#fb4934')

return M
