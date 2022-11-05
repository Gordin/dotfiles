require("noice").setup({
  cmdline = {
    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    opts = {
      buf_options = { filetype = "vim" },
      win_options = {
        winhighlight = {
          FloatBorder = "Question"
        }
      }
  }, -- enable syntax highlighting in the cmdline
    icons = {
      ["/"] = { icon = " ", hl_group = "red",firstc = false },
      ["?"] = { icon = " ", hl_group = "red", firstc = false },
      [":"] = { icon = "|> ", hl_group = "red", firstc = false },
    },
    format = {
      cmdline     = { pattern = "^:",              icon = "",   lang = "vim" },
      search_down = { pattern = "^/",              icon = " ", lang = "regex",  kind = "search" },
      search_up   = { pattern = "^%?",             icon = " ", lang = "regex",  kind = "search" },
      filter      = { pattern = "^:%s*!",          icon = "$",   lang = "bash" },
      lua         = { pattern = "^:%s*lua%s+",     icon = "",   lang = "lua" },
      help        = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      input       = {},                            -- Used by input()
    }
  },
  lsp = {
    progress = {
      enabled = true
    }
  },
  views = {

    cmdline_popup = {
      size = {
        height = "auto",
        width = "90%",
      },
      position = {
        row = "90%",
        col = "50%",
      },
      border = {
        style = "double",
      },
      win_options = {
        winblend = 5,
        winhighlight = {
          Normal = "Normal",
        },
      },
    },
  },
  popupmenu = {
    enabled = true,
    backend = "nui"
  },
  routes = {
    {
      filter = { event = "msg_show", min_height = 20 },
      view = "vsplit",
      opts = { enter = true },
    },
  },
})
