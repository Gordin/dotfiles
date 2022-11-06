local utils = require('utils')


local group = vim.api.nvim_create_augroup("ColorschemeStuff", {})
vim.api.nvim_clear_autocmds({ group = group })
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  group = group,
  pattern = "*",
  callback = function ()
    local groups = {
      "NoiceCmdlinePopupBorderHelp",
      "NoiceCmdlinePopupBorder",
      "NoicePopupBorder",
      "NoiceCmdlinePopupBorderSearch",
      "NoiceSplitBorder",
      "NoicePopupmenuBorder",
      "NoiceCmdlinePopupBorderFilter",
      "NoiceConfirmBorder",
      "NoiceCmdlinePopupBorderInput",
      "NoiceCmdlinePopupBorderCmdline",
      "NoiceCmdlinePopupBorderLua",
      "VertSplit",
      "NonText",
      "FloatBorder"
    }
    -- for _, group in ipairs(groups) do
    --   -- utils.rB(group)
    -- end
    -- vim.pretty_print("xxx")
  end
})
