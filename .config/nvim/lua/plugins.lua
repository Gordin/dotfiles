local execute = vim.api.nvim_command
local fn = vim.fn

-- disable netrw as soon as possible
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "plugins.lua",
  command = "source <afile> | PackerCompile",
})

require('packer').init({display = {auto_clean = false}})

return require('packer').startup(function(use)
  -- Sets path of config to be ./lua/config_file/NAME.lua
  local config_file = function(name)
    return string.format("require'plugins.%s'", name)
  end

  -- Packer can manage itself as an optional plugin
  use { 'wbthomason/packer.nvim' }

  -- Git
  use { 'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}, config = config_file"gitsigns" }
  use { 'kdheepak/lazygit.nvim', config = config_file'lazygit' }
  -- use { 'rhysd/committia.vim' }

  -- Registers & clipboard
  use { 'AckslD/nvim-neoclip.lua', requires = {'kkharji/sqlite.lua', module = 'sqlite'}, config = config_file"neoclip" }

  -- Move & Search & replace
  -- use { 'nacro90/numb.nvim', config = config_file"numb" }
  -- use { 'dyng/ctrlsf.vim', config = config_file"ctrlsf" }
  -- use { 'kevinhwang91/nvim-hlslens', config = config_file"hlslens" }
  -- use { 'ggandor/lightspeed.nvim', config = config_file"lightspeed" } -- go anywhere with 2-4 keypresses mapping: s/S
  use { 'phaazon/hop.nvim', config = config_file'hop' }
  -- use { 'karb94/neoscroll.nvim',   config = config_file"neoscroll" }
  use { 'dstein64/nvim-scrollview' }
  -- use { 'chaoren/vim-wordmotion' }
  -- use { 'fedepujol/move.nvim' } -- move linkes or blocks of text around
  use { 'haya14busa/incsearch.vim' }
  use { 'haya14busa/incsearch-fuzzy.vim' }
  use { 'haya14busa/vim-asterisk' }

  -- Treesitter
  use { 'David-Kunz/markid' } -- ?
  use { 'nvim-treesitter/nvim-treesitter',     run = ':TSUpdate', config = config_file"treesitter" }
  use { 'nvim-treesitter/playground' }
  use { 'p00f/nvim-ts-rainbow' }
  use { 'lukas-reineke/indent-blankline.nvim', config = config_file"indent-blankline" }
  use { 'JoosepAlviste/nvim-ts-context-commentstring' } -- TODO
  use { 'lewis6991/nvim-treesitter-context' } -- TODO
  use { "SmiteshP/nvim-navic",                 requires = "neovim/nvim-lspconfig" }

  -- LSP & Completion
  use { "williamboman/mason.nvim" }   -- Installs languag servers
  use { "williamboman/mason-lspconfig.nvim" } -- makes mason works with nvim-lspconfig
  use { "neovim/nvim-lspconfig" }     -- Provides defaults for configs for different lsp-servers
  -- cmp-stuff adds sources for autocompletions
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { 'hrsh7th/cmp-calc' }
  use { "hrsh7th/cmp-cmdline" }
  use { "hrsh7th/nvim-cmp"}
  use { 'ray-x/cmp-treesitter' }
  use { 'lukas-reineke/cmp-rg' }
  use { "onsails/lspkind-nvim" }      -- adds icons (or other stuff) to autocompletions
  use { "folke/neodev.nvim" }         -- completion for neovim stuff in lua
  -- use { "tzachar/cmp-tabnine", { run = "./install.sh" } }
  -- use { "nvim-lua/lsp_extensions.nvim" }
  -- use { "glepnir/lspsaga.nvim" }
  -- use { "simrat39/symbols-outline.nvim" }
  use { "L3MON4D3/LuaSnip" }
  use { "saadparwaiz1/cmp_luasnip" }
  use { 'quangnguyen30192/cmp-nvim-tags' }
  use { 'rafamadriz/friendly-snippets' }
  use { 'windwp/nvim-autopairs', config = config_file"nvim-autopairs" } -- auto-close pairs (){}
  use { 'windwp/nvim-ts-autotag', config = config_file"nvim-ts-autotag", after = "nvim-treesitter" }
  use { 'andymass/vim-matchup' }      -- makes % work on more things
  use { "jose-elias-alvarez/null-ls.nvim" }


  -- Syntax
  use { 'chrisbra/csv.vim' }
  use { 'zdharma-continuum/zinit-vim-syntax' }

  -- Formatting
  --use { 'junegunn/vim-easy-align' }
  use { 'njhoffman/vim-easy-align' }
  -- Plug 'junegunn/vim-easy-align'
  -- I forked this and added hjkl as alternatives for arrow keys. Development seems dead
  -- Pull Request here: https://github.com/junegunn/vim-easy-align/pull/138/files
  -- Edit: changed it to the repo of some other guy that used my fork...
  use { 'mhartington/formatter.nvim', config = config_file"formatter" }

  -- Statusline
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons' }, config = config_file"lualine" }

  -- Icons
  use { 'kyazdani42/nvim-web-devicons' }
  use { 'ryanoasis/vim-devicons' }

  -- Telescope
  use { 'nvim-lua/popup.nvim' }
  use { 'nvim-lua/plenary.nvim' }
  use { 'nvim-telescope/telescope.nvim', config = config_file"telescope", requires = { {'nvim-lua/plenary.nvim'} } }
  use { 'nvim-telescope/telescope-fzy-native.nvim' }
  use { 'cljoly/telescope-repo.nvim' }
  use { 'nvim-telescope/telescope-dap.nvim' }
  use { "pschmitt/telescope-yadm.nvim", requires = "nvim-telescope/telescope.nvim" }

  -- Comments
  use { "terrortylor/nvim-comment", config = config_file"nvim-comment" }

  -- Tim Pope ✝️
  -- Rails stuff
  use { 'tpope/vim-rails' }
  -- Does a lot of word-conversion stuff
  -- Has mappings to convert between snake/camel/mixed/dash etc. cases
  -- Mappings: crs (snake_case), crm (MixedCase), crc (camelCase), cr- (dash-case), cr. (dot.case)
  use { 'tpope/vim-abolish' }
  -- use { 'tpope/vim-sleuth' } -- breaks completion of noice?
  use { 'tpope/vim-bundler' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-endwise' }
  use { 'tpope/vim-dispatch' }
  use { 'tpope/vim-fugitive' }
  use { 'tpope/vim-surround' }

  use { 'norcalli/nvim-colorizer.lua', config = config_file"colorizer" }
  -- Colorschema
  -- use { 'agrzeslak/gruvbox' }
  -- use { 'gruvbox-community/gruvbox' }
  use { 'sainnhe/gruvbox-material' }
  use { 'luisiacc/gruvbox-baby' }
  use { "ellisonleao/gruvbox.nvim" }
  use { 'Shatur/neovim-ayu'}
  use { 'catppuccin/nvim', as = "catppuccin" }
  use { 'olimorris/onedarkpro.nvim' }
  use { 'folke/tokyonight.nvim' }

    -- Debugger
  use { 'jbyuki/one-small-step-for-vimkind', requires = {"mfussenegger/nvim-dap"} }
  use { 'mfussenegger/nvim-dap',             config = config_file"nvim-dap" }
  use { 'rcarriga/nvim-dap-ui',              requires = {"mfussenegger/nvim-dap"}, config = config_file"nvim-dap-ui" }
  use { 'theHamsta/nvim-dap-virtual-text',   requires = {"mfussenegger/nvim-dap"}, config = config_file"nvim-dap-virtual-text" }

  -- General Plugins
  -- use { 'machakann/vim-sandwich', config = config_file"sandwich" }        -- Set of operators and textobjects to search/select/edit sandwiched texts.
  use { 'rcarriga/nvim-notify', config = config_file"nvim-notify" }       -- A fancy, configurable, notification manager for NeoVim
  use { 'Gordin/noice.nvim', requires = { 'MunifTanjim/nui.nvim' }, config = config_file"noice" }                 -- completely replaces the UI for messages, cmdline and the popupmenu.
  use { 'folke/trouble.nvim' }                                         -- diagnostics, references, telescope results, quickfix and location list
  use { 'goolord/alpha-nvim', config = config_file"alpha-nvim" }          -- greeter like vim-startify / dashboard-nvim
  -- use { 'dstein64/vim-startuptime' }
  -- file explorer
  use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' }, tag = 'nightly', config = config_file"nvim-tree" }

  -- Plugin that automatically highlight the word and all other occurences of the word under cursor.
  -- Style can be controlled whith the variables CurrentWord and CurrentWordTwins at the end of this
  -- file (becase colorscheme needs to be loaded first)
  use { 'dominikduda/vim_current_word', config = config_file"current_word" }

  use { 'lewis6991/impatient.nvim' }


  use { 'kopischke/vim-fetch' } -- " Makes `vim x:10` or `:e x:10` open file `x` and jump to line 10

  -- When you open a new file but a file with a similar name exists Vim will ask to open that one
  use { 'EinfachToll/DidYouMean' }
  -- use { 'airblade/vim-rooter', config = config_file("vim-rooter") }
  -- use { 'nyngwang/NeoRoot.lua', config = config_file("neoroot") }
  use { 'ahmedkhalf/project.nvim', config = config_file("project") }
  use { 'DataWraith/auto_mkdir' }     -- Automatically create folders that don't exist when saving a new file
  use { 'landock/vim-expand-region' } -- Expand/Shrink current selection around text objects
  -- This is a fork. Original is this, but hasn't been updated since 2013:
  -- use {  'terryma/vim-expand-region' }
end)
