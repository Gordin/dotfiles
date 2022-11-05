local utils = require('utils')

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
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
