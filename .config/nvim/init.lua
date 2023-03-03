-- Set <leader> to ,
-- The leader key has to be set BEFORE any plugins set mappings for <leader> for stuff to work
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require('settings.terminalcolors')    -- ./lua/settings/terminalcolors.lua

-- Packer
require('plugins')                    -- ./lua/plugins/init.lua
require('settings')                   -- ./lua/settings/init.lua
-- require('auto_cmds')                  -- ./lua/auto_cmds.lua (I don't think I use those anymore?)

-- require("settings.completion")        -- autocompletion (old, for comparison with lsp.lua)

-- completion and stuff for neovim lua stuff specifically
require("settings.neodev")            -- keey before lsp!

require("settings.lsp")               -- LSP config and servers
require("settings.null-ls")           -- null-ls config (keep after lsp!)
require("settings.lspsaga")           -- lspsaga config (keep after lsp!)

require('settings.mappings')          -- ./lua/settings/mappings.lua
require('settings.abbreviations')     -- ./lua/settings/abbreviations.lua

-- Select colorscheme her
-- those load ./lua/colorschemes/THEME.lua
-- require('colorschemes.onedarkpro')
-- require('colorschemes.monokai')
-- require('colorschemes.ayu')
-- require('colorschemes.tokyonight')
-- require('colorschemes.catppuccin')
require('colorschemes.gruvbox-nvim')
