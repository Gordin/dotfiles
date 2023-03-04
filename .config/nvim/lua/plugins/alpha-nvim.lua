local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  return
end

local startify = require("alpha.themes.startify")

local function footer()
  local plugin_count = require("lazy").stats().count
  local plugin_updates = require("lazy.status").updates() or ''
  if string.len(plugin_updates) > 0 then
    plugin_updates = " - " .. plugin_updates .. " updates available"
  end
  local date = os.date("%d-%m-%Y")
  local time = os.date("%H:%M:%S")
  return "[ " .. plugin_count .. " plugins" .. plugin_updates .. "] [ " .. date .. "] [ " .. time .. "]"
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

local button = startify.button

local buttons = {
  type = "group",
  position = "left",
  val = {
    { type = "text", val = "Quick links", opts = { hl = "Constant", position = "left" } },
    { type = "padding", val = 1, opts = { position = "left" } },
    -- button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    button("z", "  zshrc", ":e ~/.zshrc<CR>"),
    button("v", "  vimrc", ":e $MYVIMRC<CR>"),
    button("t", "  tmux config", ":e ~/.config/tmux/tmux.conf<CR>"),
    button("g", "  git config", ":e ~/.gitconfig<CR>"),
    button("s", "  ssh config", ":e ~/.ssh/config<CR>"),
    button("i", "  i3 config", ":e ~/.config/i3/config<CR>"),
    button("y", "  yadm bootstrap script", ":e $HOME/.config/yadm/bootstrap<CR>"),
    button("o", "  old vim config", ":e $HOME/.config/nvim_old/oldconfig.vim<CR>"),
    -- button("g", "  Edit config", ""),
    button("p", "  plugins", ":e ~/.config/nvim/lua/plugins.lua<CR>"),
    button("P", "  plugin dir", ":e ~/.local/share/nvim/site/pack/packer/<CR>"),
    button("l", "  lazygit", ":LazyGit<CR>"),
    button("c", "  lazygit config", ":LazyGitConfig<CR>"),

    -- button("o", "ﭯ  Recently opened files", ":Telescope oldfiles<CR>"),
    -- button("f", "  Find file", ":lua require('plugins.telescope').project_files()<CR>"),
    -- button("p", "  Find project", ":Telescope repo list<CR>"),
    -- button("r", "  Find word", ":lua require('telescope.builtin').live_grep()<CR>"),
    -- button("g", "  Find modified file", ":lua require('plugins.telescope').my_git_status()<CR>"),
    -- button("m", "  Show mark", ":Telescope marks"),
    -- button("t", "  Show todo", ":TodoTelescope<CR>"),
    button("u", "  Sync plugins", ":Lazy sync<CR>"),
    button("h", "  Neovim Check health", ":checkhealth<CR>"),
    button("q", "  Quit", "<Cmd>qa<CR>")
  },
}

local section_footer = {
  type = "group",
  val = {
    { type = "text", val = footer, opts = { hl = "Constant", position = "left" } },
  }
}

alpha.setup({
  layout = {
    { type = "padding", val = 1 },
    section_header,
    { type = "padding", val = 2 },
    startify.section.top_buttons,
    { type = "padding", val = 1 },
    startify.section.mru_cwd,
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
})
-- alpha.setup(startify.config)
