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

-- Sets path of config to be ./lua/config_file/NAME.lua
local config_file = function(name)
  return function()
    require(string.format('plugins.%s', name))
  end
end


local plugins = {
  -- "folke/which-key.nvim",
  -- { "folke/neoconf.nvim", cmd = "Neoconf" },
  -- "folke/neodev.nvim",
  -- Packer can manage itself as an optional plugin
  -- { 'wbthomason/packer.nvim' },

  -- Git
  { 'lewis6991/gitsigns.nvim', dependencies = {'nvim-lua/plenary.nvim'}, config = config_file"gitsigns" },
  { 'kdheepak/lazygit.nvim', config = config_file'lazygit' },
  -- { 'rhysd/committia.vim' }

  -- Registers & clipboard
  { 'AckslD/nvim-neoclip.lua', dependencies = {'kkharji/sqlite.lua', module = 'sqlite'}, config = config_file"neoclip" },
  { "gbprod/yanky.nvim", config = config_file"yanky", dependencies = { "kkharji/sqlite.lua" } },

  -- Move & Search & replace
  -- { 'nacro90/numb.nvim', config = config_file"numb" },
  -- { 'dyng/ctrlsf.vim', config = config_file"ctrlsf" },
  -- { 'kevinhwang91/nvim-hlslens', config = config_file"hlslens" },
  -- { 'ggandor/lightspeed.nvim', config = config_file"lightspeed" } -- go anywhere with 2-4 keypresses mapping: s/S
  { 'phaazon/hop.nvim', config = config_file'hop' },
  -- { 'karb94/neoscroll.nvim',   config = config_file"neoscroll" },
  { 'dstein64/nvim-scrollview' },
  -- { 'chaoren/vim-wordmotion' },
  -- { 'fedepujol/move.nvim' } -- move linkes or blocks of text around
  { 'haya14busa/incsearch.vim' },
  { 'haya14busa/incsearch-fuzzy.vim' },
  { 'haya14busa/vim-asterisk' },
  { 'pechorin/any-jump.vim', config = config_file("any-jump") },

  -- Treesitter
  -- { 'David-Kunz/markid' }, -- ?
  { 'nvim-treesitter/nvim-treesitter',     run = ':TSUpdate', config = config_file"treesitter" },
  { 'nvim-treesitter/playground' },
  -- { 'mrjones2014/nvim-ts-rainbow' },
  { 'lukas-reineke/indent-blankline.nvim', config = config_file"indent-blankline" },
  { 'JoosepAlviste/nvim-ts-context-commentstring' }, -- TODO
  { 'lewis6991/nvim-treesitter-context' }, -- TODO
  { "SmiteshP/nvim-navic",                 dependencies = "neovim/nvim-lspconfig" },

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

  -- { "nvim-lua/lsp_extensions.nvim" },
  -- { "simrat39/symbols-outline.nvim" },

  -- { 'quangnguyen30192/cmp-nvim-tags' },

  { 'windwp/nvim-autopairs', config = config_file"nvim-autopairs" }, -- auto-close pairs (){}
  { 'windwp/nvim-ts-autotag', config = config_file"nvim-ts-autotag", after = "nvim-treesitter" },
  { 'andymass/vim-matchup' },      -- makes % work on more things


  -- Syntax
  { 'chrisbra/csv.vim' },
  { 'zdharma-continuum/zinit-vim-syntax' },

  -- Formatting
  --{ 'junegunn/vim-easy-align' },
  { 'njhoffman/vim-easy-align' },
  -- Plug 'junegunn/vim-easy-align'
  -- I forked this and added hjkl as alternatives for arrow keys. Development seems dead
  -- Pull Request here: https://github.com/junegunn/vim-easy-align/pull/138/files
  -- Edit: changed it to the repo of some other guy that used my fork...
  { 'mhartington/formatter.nvim', config = config_file"formatter" },

  -- Statusline
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, config = config_file"lualine" },

  -- Statuscolumn
  {
    "luukvbaal/statuscol.nvim",
    config = function() require("statuscol").setup{setopt = true} end
  },

  -- Icons
  { 'nvim-tree/nvim-web-devicons', config = config_file('nvim_web-devicons') },
  { 'ryanoasis/vim-devicons' },

  -- Telescope
  { 'nvim-lua/popup.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim', config = config_file"telescope", dependencies = { {'nvim-lua/plenary.nvim'} } },
  { "natecraddock/telescope-zf-native.nvim" },
  { 'cljoly/telescope-repo.nvim' },
  { 'nvim-telescope/telescope-dap.nvim' },
  { "pschmitt/telescope-yadm.nvim", dependencies = "nvim-telescope/telescope.nvim" },

  -- Comments
  { "terrortylor/nvim-comment", config = config_file"nvim-comment" },

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
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },

  { 'norcalli/nvim-colorizer.lua', config = config_file"colorizer" },
  -- Colorschema
  -- { 'agrzeslak/gruvbox' },
  -- { 'gruvbox-community/gruvbox' },
  { 'sainnhe/gruvbox-material' },
  { 'luisiacc/gruvbox-baby' },
  { "ellisonleao/gruvbox.nvim" },
  { 'Shatur/neovim-ayu'},
  { 'catppuccin/nvim', as = "catppuccin" },
  { 'olimorris/onedarkpro.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'Cside/vim-monokai' },
  { 'typicode/bg.nvim' }, -- terminal background fix

    -- Debugger
  { 'jbyuki/one-small-step-for-vimkind', dependencies = {"mfussenegger/nvim-dap"} },
  { 'mfussenegger/nvim-dap',             config = config_file"nvim-dap" },
  { 'rcarriga/nvim-dap-ui',              dependencies = {"mfussenegger/nvim-dap"}, config = config_file"nvim-dap-ui" },
  { 'theHamsta/nvim-dap-virtual-text',   dependencies = {"mfussenegger/nvim-dap"}, config = config_file"nvim-dap-virtual-text" },
  { "mxsdev/nvim-dap-vscode-js",         dependencies = {"mfussenegger/nvim-dap"} },

  -- General Plugins
  -- { 'machakann/vim-sandwich', config = config_file"sandwich" },        -- Set of operators and textobjects to search/select/edit sandwiched texts.
  { 'rcarriga/nvim-notify', config = config_file"nvim-notify" },       -- A fancy, configurable, notification manager for NeoVim
  -- { 'folke/noice.nvim', dependencies = { 'MunifTanjim/nui.nvim' },, config = config_file"noice" }                 -- completely replaces the UI for messages, cmdline and the popupmenu.
  { 'folke/trouble.nvim' },                                         -- diagnostics, references, telescope results, quickfix and location list
  { 'goolord/alpha-nvim', config = config_file"alpha-nvim" },          -- greeter like vim-startify / dashboard-nvim
  -- { 'dstein64/vim-startuptime' },
  -- file explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' }, tag = 'nightly', config = config_file"nvim-tree" },

  -- Plugin that automatically highlight the word and all other occurences of the word under cursor.
  -- Style can be controlled whith the variables CurrentWord and CurrentWordTwins at the end of this
  -- file (becase colorscheme needs to be loaded first)
  { 'dominikduda/vim_current_word', config = config_file"current_word" },

  -- Languages
  { 'jose-elias-alvarez/typescript.nvim' },

  { 'kopischke/vim-fetch' }, -- " Makes `vim x:10` or `:e x:10` open file `x` and jump to line 10

  -- When you open a new file but a file with a similar name exists Vim will ask to open that one
  { 'EinfachToll/DidYouMean' },
  -- { 'airblade/vim-rooter', config = config_file("vim-rooter") },
  -- { 'nyngwang/NeoRoot.lua', config = config_file("neoroot") },
  { 'ahmedkhalf/project.nvim', config = config_file("project") },
  { 'DataWraith/auto_mkdir' },     -- Automatically create folders that don't exist when saving a new file
  { 'landock/vim-expand-region' }, -- Expand/Shrink current selection around text objects
  -- This is a fork. Original is this, but hasn't been updated since 2013:
  -- {  'terryma/vim-expand-region' },
}

require("lazy").setup(plugins, {
  checker = {
    enabled = true,
    notify = false
  }
})
