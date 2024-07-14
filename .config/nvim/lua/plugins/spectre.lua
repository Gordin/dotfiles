require('spectre').setup({
  open_cmd = 'vnew',
  lnum_for_results = true, -- show line number for search/replace results
  -- line_sep_start = '┌-----------------------------------------',
  -- result_padding = '¦  ',
  -- line_sep       = '└-----------------------------------------',
  line_sep_start = '',
  result_padding = ' ',
  line_sep       = '',
  highlight = {
    ui = "String",
    search = "DiffChange",
    replace = "DiffDelete"
  },
})

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})
