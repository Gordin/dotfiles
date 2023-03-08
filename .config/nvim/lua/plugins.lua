local fn = vim.fn

-- disable netrw as soon as possible
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Sets path of config to be ./lua/plugins/NAME.lua
local config = function(name)
  return function()
    require(string.format('plugins.%s', name))
  end
end


local plugins = {
  -- "folke/which-key.nvim",
  -- { "folke/neoconf.nvim", cmd = "Neoconf" },

  -- Git
  { 'lewis6991/gitsigns.nvim', dependencies = {'nvim-lua/plenary.nvim'}, config = config"gitsigns" },
  { 'kdheepak/lazygit.nvim', config = config'lazygit' },

  -- Registers & clipboard
  { 'AckslD/nvim-neoclip.lua', dependencies = {'kkharji/sqlite.lua', module = 'sqlite'}, config = config"neoclip" },
  { "gbprod/yanky.nvim", config = config"yanky", dependencies = { "kkharji/sqlite.lua" } },

  -- Move & Search & replace
  { 'ggandor/lightspeed.nvim', config = config"lightspeed" }, -- go anywhere with 2-4 keypresses mapping: s/S
  -- { 'phaazon/hop.nvim', config = config_file'hop' },
  { 'dstein64/nvim-scrollview' }, -- gives neovim a scrollbar
  -- { 'chaoren/vim-wordmotion' },
  -- { 'fedepujol/move.nvim' } -- move lines or blocks of text around
  { 'haya14busa/vim-asterisk' },
  -- zero config jump-to-definition, in case LSP doesn't work (mainly for ruby... -_-)
  { 'pechorin/any-jump.vim', config = config"any-jump" },

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', config = config"treesitter" },
  { 'nvim-treesitter/playground' },
  { 'HiPhish/nvim-ts-rainbow2' },
  { 'lukas-reineke/indent-blankline.nvim', config = config"indent-blankline" },
  { 'JoosepAlviste/nvim-ts-context-commentstring' }, -- TODO
  { 'lewis6991/nvim-treesitter-context' }, -- TODO
  { "SmiteshP/nvim-navic",                 dependencies = "neovim/nvim-lspconfig" },

  -- lsp config is loaded from global init.lua
  {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- null-ls
      {"jay-babu/mason-null-ls.nvim"},
      {"jose-elias-alvarez/null-ls.nvim"},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},

      -- Snippets
      {'L3MON4D3/LuaSnip'},
      -- Snippet Collection (Optional)
      {'rafamadriz/friendly-snippets'},
    }
  },
  {
    "glepnir/lspsaga.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    branch = "main"
  },
  -- LSP & Completion
  -- -- cmp-stuff adds sources for autocompletions
  -- { 'hrsh7th/cmp-calc' }
  -- { "hrsh7th/cmp-cmdline" }
  -- { 'ray-x/cmp-treesitter' }
  -- { 'lukas-reineke/cmp-rg' }
  { "onsails/lspkind-nvim" },      -- adds icons (or other stuff) to autocompletions
  { "folke/neodev.nvim" },         -- completion for neovim stuff in lua

  -- { "simrat39/symbols-outline.nvim" },

  { 'windwp/nvim-autopairs', config = config"nvim-autopairs" }, -- auto-close pairs (){}
  { 'windwp/nvim-ts-autotag', config = config"nvim-ts-autotag", dependencies = { "nvim-treesitter" } },
  { 'andymass/vim-matchup' },                                        -- makes % work on more things

  -- Syntax
  { 'chrisbra/csv.vim' },
  { 'zdharma-continuum/zinit-vim-syntax' },

  -- Formatting
  { 'echasnovski/mini.align',     version = false, config = config"mini.align" },
  { 'echasnovski/mini.animate',   version = false, config = config"mini.animate" },
  { 'echasnovski/mini.ai',        version = false, config = function () require('mini.ai').setup() end },
  { 'mhartington/formatter.nvim', config = config"formatter" },

  -- Statusline
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, config = config"lualine" },

  -- Statuscolumn (Allows stuff like clicking on line numbers for breakpoints)
  { "luukvbaal/statuscol.nvim", config = function() require("statuscol").setup{setopt = true} end },

  -- Icons
  { 'nvim-tree/nvim-web-devicons', config = config'nvim_web-devicons' },
  { 'ryanoasis/vim-devicons' },

  -- Telescope
  { 'nvim-lua/popup.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', config = config"telescope", dependencies = { 'nvim-lua/plenary.nvim' } },
  { "natecraddock/telescope-zf-native.nvim" },
  { 'cljoly/telescope-repo.nvim' },
  { 'nvim-telescope/telescope-dap.nvim' },
  { "pschmitt/telescope-yadm.nvim", dependencies = "nvim-telescope/telescope.nvim" },

  -- Comments
  { "terrortylor/nvim-comment", config = config"nvim-comment" },

  -- Tim Pope ✝️
  -- Rails stuff
  { 'tpope/vim-rails' },
  -- Does a lot of word-conversion stuff
  -- Has mappings to convert between snake/camel/mixed/dash etc. cases
  -- Mappings: crs (snake_case), crm (MixedCase), crc (camelCase), cr- (dash-case), cr. (dot.case)
  { 'tpope/vim-abolish' },
  -- { 'tpope/vim-sleuth' }, -- breaks completion of noice?
  { 'tpope/vim-bundler' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-endwise' },
  { 'tpope/vim-dispatch' },
  { 'tpope/vim-fugitive' }, -- git stuff
  { 'tpope/vim-surround' }, -- mapping to surround stuff with ({[`'"

  -- Show Colors codes and nomes in the actual color
  -- nvim-colorizer is the cool new lua plugin, hexokinase is vimscript, but I like the virtualtext display
  -- { 'NvChad/nvim-colorizer.lua', config = config"colorizer" },
  { "kaymmm/vim-hexokinase",
    init = config"hexokinase", -- init instead of config, because the config has to be set before the plugin
    build = 'make hexokinase',
    branch = 'latex'
  },

  { "laytan/cloak.nvim", config = config"cloak" },

  { "folke/neoconf.nvim", priority = 1000, config = function () require("neoconf").setup({ }) end },

  -- Colorschemes
  "ellisonleao/gruvbox.nvim",
  'Shatur/neovim-ayu',
  { 'catppuccin/nvim', name = "catppuccin" },
  'olimorris/onedarkpro.nvim',
  'folke/tokyonight.nvim',
  'Cside/vim-monokai',
  'typicode/bg.nvim', -- terminal background fix

    -- Debugger
  { 'mfussenegger/nvim-dap',             config = config"nvim-dap" },
  { 'rcarriga/nvim-dap-ui',              dependencies = {"mfussenegger/nvim-dap"}, config = config"nvim-dap-ui"           },
  { 'theHamsta/nvim-dap-virtual-text',   dependencies = {"mfussenegger/nvim-dap"}, config = config"nvim-dap-virtual-text" },
  { 'jbyuki/one-small-step-for-vimkind', dependencies = {"mfussenegger/nvim-dap"}, },
  { "mxsdev/nvim-dap-vscode-js",         dependencies = {"mfussenegger/nvim-dap"}, },

  -- General Plugins
  { 'rcarriga/nvim-notify', config = config"nvim-notify" },       -- A fancy, configurable, notification manager for NeoVim
  -- { 'folke/noice.nvim', dependencies = { 'MunifTanjim/nui.nvim' },, config = config_file"noice" }                 -- completely replaces the UI for messages, cmdline and the popupmenu.
  { 'folke/trouble.nvim' },                                         -- diagnostics, references, telescope results, quickfix and location list
  { 'goolord/alpha-nvim', config = config"alpha-nvim" },          -- greeter like vim-startify / dashboard-nvim
  -- { 'dstein64/vim-startuptime' },
  -- file explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' }, tag = 'nightly', config = config"nvim-tree" },

  -- Plugin that automatically highlight the word and all other occurences of the word under cursor.
  -- Style can be controlled whith the variables CurrentWord and CurrentWordTwins, but AFTER colerscheme loads
  -- { 'dominikduda/vim_current_word', config = config_file"current_word" },
  { 'RRethy/vim-illuminate', config = config"illuminate" },

  -- Languages
  { 'jose-elias-alvarez/typescript.nvim' },

  { 'kopischke/vim-fetch' }, -- " Makes `vim x:10` or `:e x:10` open file `x` and jump to line 10

  -- When you open a new file but a file with a similar name exists Vim will ask to open that one
  { 'EinfachToll/DidYouMean' },
  -- { 'airblade/vim-rooter', config = config"vim-rooter" },
  -- { 'nyngwang/NeoRoot.lua', config = config"neoroot" },
  { 'ahmedkhalf/project.nvim', config = config"project" },
  { 'DataWraith/auto_mkdir' },     -- Automatically create folders that don't exist when saving a new file
  -- { 'landock/vim-expand-region' }, -- Expand/Shrink current selection around text objects
  { 'olambo/vi-viz', config = config"vi-viz" }
  -- This is a fork. Original is this, but hasn't been updated since 2013:
  -- {  'terryma/vim-expand-region' },
}

require("lazy").setup(plugins, {
  checker = {
    enabled = true,
    notify = false
  },
  dev = {
    path = "~/code/nvim_plugins",
    fallback = true
  }
})
