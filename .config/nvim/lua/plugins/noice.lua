require("noice").setup({
  cmdline = {
    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    opts = {
      -- win_options = {
      --   winhighlight = {
      --     FloatBorder = "Question"
      --   }
      -- }
      buf_options = { filetype = "vim" }
    },
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
      substitute  = {
        pattern = "^:%%?s/",
        icon = " ",
        ft = "regex",
        opts = {
          border = {
            text = {
              top = " sub (old/new/) ",
            },
          },
        },
      }
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
        style = "rounded",
      },
      win_options = {
        winblend = 20,
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

local search = vim.api.nvim_get_hl_by_name("Search", true)
vim.api.nvim_set_hl(0, 'TransparentSearch', { fg = search.foreground })

local help = vim.api.nvim_get_hl_by_name("IncSearch", true)
vim.api.nvim_set_hl(0, 'TransparentHelp', { fg = help.foreground })

local cmdGroup = 'DevIconLua'
local noice_cmd_types = {
  CmdLine    = cmdGroup,
  Input      = cmdGroup,
  Lua        = cmdGroup,
  Filter     = cmdGroup,
  Rename     = cmdGroup,
  Substitute = "Define",
  Help       = "TransparentHelp",
  Search     = "TransparentSearch"
}

local noice_hl = vim.api.nvim_create_augroup("NoiceHighlights", {})
vim.api.nvim_clear_autocmds({ group = noice_hl })
vim.api.nvim_create_autocmd("BufEnter", {
  group = noice_hl,
  callback = function()
    for type, hl in pairs(noice_cmd_types) do
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder" .. type, { link = hl })
      vim.api.nvim_set_hl(0, "NoiceCmdlineIcon" .. type, { link = hl })
    end
    vim.api.nvim_set_hl(0, "NoiceConfirmBorder", { link = cmdGroup })
  end,
})
