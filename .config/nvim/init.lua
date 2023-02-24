-- Set <leader> to ,
--" The leader key has to be set BEFORE any mappings <leader> for stuff to work
vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.termguicolors = true

-- Packer
require('plugins')                    -- ./lua/plugins/init.lua
require('settings')                   -- ./lua/settings/init.lua
require('auto_cmds')                  -- ./lua/auto_cmds.lua

-- Some fix for some terminals?
require('settings.terminalcolors')    -- ./lua/settings/terminalcolors.lua

-- Select colorscheme her
-- those load ./lua/colorschemes/THEME.lua
-- require('colorschemes.onedarkpro')
-- require('colorschemes.gruvbox')
-- require('colorschemes.gruvbox-nvim')
-- require('colorschemes.monokai')
-- require('colorschemes.ayu')
-- require('colorschemes.gruvbox_baby')
-- require('colorschemes.tokyonight')
-- require('colorschemes.catppuccin')

-- require("settings.completion")        -- autocompletion
require("settings.neodev")
require("settings.lsp")               -- LSP config and servers
require("settings.null-ls")           -- null-ls config (keep after lsp!)
require("settings.lspsaga")           -- lspsaga config (keep after lsp!)

require('settings.mappings')          -- ./lua/settings/mappings.lua
require('settings.abbreviations')     -- ./lua/settings/abbreviations.lua

require('colorschemes.gruvbox-nvim')
