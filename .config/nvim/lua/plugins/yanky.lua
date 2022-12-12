require("yanky").setup({
  ring = {
    history_length = 100,
    storage = "sqlite",
    sync_with_numbered_registers = true,
    cancel_event = "update",
  },
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
})


vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "yn", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "yp", "<Plug>(YankyCycleBackward)")
vim.keymap.set("n", "<c-N>", "<Plug>(YankyCycleBackward)")
