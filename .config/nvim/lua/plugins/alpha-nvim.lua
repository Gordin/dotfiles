local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local path_ok, path = pcall(require, "plenary.path")
if not path_ok then
  return
end

local startify = require("alpha.themes.startify")
local dashboard = require("alpha.themes.dashboard")
local nvim_web_devicons = require "nvim-web-devicons"
local cdir = vim.fn.getcwd()

local function get_extension(fn)
  local match = fn:match("^.+(%..+)$")
  local ext = ""
  if match ~= nil then
    ext = match:sub(2)
  end
  return ext
end

local function footer()
  local plugin_count = require("lazy").stats().count
  local plugin_updates = require("lazy.status").updates() or '0'
  local date = os.date("%d-%m-%Y")
  local time = os.date("%H:%M:%S")
  return "[ " .. plugin_count .. " plugins - " .. plugin_updates .. " updates available] [ " .. date .. "] [ " .. time .. "]"
end

local function icon(fn)
  local nwd = require("nvim-web-devicons")
  local ext = get_extension(fn)
  return nwd.get_icon(fn, ext, { default = true })
end

local function file_button(fn, sc, short_fn)
  short_fn = short_fn or fn
  local ico_txt
  local fb_hl = {}

  local ico, hl = icon(fn)
  local hl_option_type = type(nvim_web_devicons.highlight)
  if hl_option_type == "boolean" then
    if hl and nvim_web_devicons.highlight then
      table.insert(fb_hl, { hl, 0, 1 })
    end
  end
  if hl_option_type == "string" then
    table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
  end
  ico_txt = ico .. "  "

  local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. " <CR>")
  local fn_start = short_fn:match(".*/")
  if fn_start ~= nil then
    table.insert(fb_hl, { "Type", #ico_txt - 2, #fn_start + #ico_txt - 2 })
  end
  file_button_el.opts.hl = fb_hl
  return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
  ignore = function(pathh, ext)
    return (string.find(pathh, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
  end,
}

--- @param start number
--- @param cwd string optional
--- @param items_number number optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
  opts = opts or mru_opts
  items_number = items_number or 9

  local oldfiles = {}
  for _, v in pairs(vim.v.oldfiles) do
    if #oldfiles == items_number then
      break
    end
    local cwd_cond
    if not cwd then
      cwd_cond = true
    else
      cwd_cond = vim.startswith(v, cwd)
    end
    local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
    if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
      oldfiles[#oldfiles + 1] = v
    end
  end

  local special_shortcuts = {}
  local target_width = 50

  local tbl = {}
  for i, fn in ipairs(oldfiles) do
    local short_fn
    if cwd then
      short_fn = vim.fn.fnamemodify(fn, ":.")
    else
      short_fn = vim.fn.fnamemodify(fn, ":~")
    end

    if(#short_fn > target_width) then
      short_fn = path.new(short_fn):shorten(1, {-2, -1})
      if(#short_fn > target_width) then
        short_fn = path.new(short_fn):shorten(1, {-1})
      end
    end

    local shortcut = ""
    if i <= #special_shortcuts then
      shortcut = special_shortcuts[i]
    else
      shortcut = tostring(i + start - 1 - #special_shortcuts)
    end

    local file_button_el = file_button(fn, " " .. shortcut, short_fn)
    tbl[i] = file_button_el
  end
  return {
    type = "group",
    val = tbl,
    opts = {},
  }
end

local logo = {
  [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
  [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
  [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
  [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
  [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
  [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
}

local section_header = {
  type = "text",
  val = logo,
  opts = {
    hl = "Operator",
    shrink_margin = false,
    position = "left",
  }
}

local section_mru = {
  type = "group",
  val = {
    {
      type = "text",
      val = "Recent files",
      opts = {
        hl = "Constant",
        shrink_margin = false,
        position = "left",
      },
    },
    { type = "padding", val = 1 },
    {
      type = "group",
      val = function()
        return { mru(1, cdir, 9) }
      end,
      opts = { shrink_margin = false },
    },
  }
}

local buttons = {
  type = "group",
  position = "left",
  val = {
    { type = "text", val = "Quick links", opts = { hl = "Constant", position = "left" } },
    { type = "padding", val = 1, opts = { position = "left" } },
    -- startify.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    startify.button("z", "  zshrc", ":e ~/.zshrc<CR>"),
    startify.button("v", "  vimrc", ":e $MYVIMRC<CR>"),
    startify.button("t", "  tmux config", ":e ~/.config/tmux/tmux.conf<CR>"),
    startify.button("g", "  git config", ":e ~/.gitconfig<CR>"),
    startify.button("s", "  ssh config", ":e ~/.ssh/config<CR>"),
    startify.button("i", "  i3 config", ":e ~/.config/i3/config<CR>"),
    startify.button("y", "  yadm bootstrap script", ":e $HOME/.config/yadm/bootstrap<CR>"),
    startify.button("o", "  old vim config", ":e $HOME/.config/nvim_old/oldconfig.vim<CR>"),
    -- startify.button("g", "  Edit config", ""),
    startify.button("p", "  plugins", ":e ~/.config/nvim/lua/plugins.lua<CR>"),
    startify.button("P", "  plugin dir", ":e ~/.local/share/nvim/site/pack/packer/<CR>"),
    startify.button("l", "  lazygit", ":LazyGit<CR>"),
    startify.button("c", "  lazygit config", ":LazyGitConfig<CR>"),

    -- startify.button("o", "ﭯ  Recently opened files", ":Telescope oldfiles<CR>"),
    -- startify.button("f", "  Find file", ":lua require('plugins.telescope').project_files()<CR>"),
    -- startify.button("p", "  Find project", ":Telescope repo list<CR>"),
    -- startify.button("r", "  Find word", ":lua require('telescope.builtin').live_grep()<CR>"),
    -- startify.button("g", "  Find modified file", ":lua require('plugins.telescope').my_git_status()<CR>"),
    -- startify.button("m", "  Show mark", ":Telescope marks"),
    -- startify.button("t", "  Show todo", ":TodoTelescope<CR>"),
    startify.button("u", "  Sync plugins", ":PackerSync<CR>"),
    startify.button("h", "  Neovim Check health", ":checkhealth<CR>"),
    startify.button("q", "  Quit", "<Cmd>qa<CR>")
  },
}

local section_footer = {
  type = "group",
  val = {
    { type = "text", val = footer(), opts = { hl = "Constant", position = "left" } },
  }
}

local opts = {
  layout = {
    { type = "padding", val = 1 },
    section_header,
    { type = "padding", val = 2 },
    startify.section.top_buttons,
    { type = "padding", val = 1 },
    startify.section.mru_cwd,
    -- section_mru,
    -- { type = "padding", val = 1 },
    startify.section.mru,
    { type = "padding", val = 1 },
    buttons,
    { type = "padding", val = 1 },
    section_footer,
  },
  opts = {
    margin = 5,
  },
}

alpha.setup(opts)
-- alpha.setup(startify.config)
