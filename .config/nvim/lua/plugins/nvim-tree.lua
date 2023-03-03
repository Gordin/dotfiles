require("nvim-tree").setup({
  view = {
    float = {
      enable = true,
      open_win_config = {
        relative = "editor",
        border = "rounded",
        width = 60,
        height = 60,
      },
    },
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
})
