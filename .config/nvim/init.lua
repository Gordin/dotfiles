-- Impatient
local impatient_ok, impatient = pcall(require, "impatient")
if impatient_ok then impatient.enable_profile() end

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
require('colorschemes.gruvbox-nvim')
-- require('colorschemes.ayu')
-- require('colorschemes.gruvbox_baby')
-- require('colorschemes.tokyonight')
-- require('colorschemes.catppuccin')

-- require("settings.completion")        -- autocompletion
require("settings.lsp")               -- LSP config and servers
require("settings.null-ls")           -- null-ls config (keep after lsp!)

require('settings.mappings')          -- ./lua/settings/mappings.lua
require('settings.abbreviations')     -- ./lua/settings/abbreviations.lua
