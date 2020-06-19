if &compatible
  set nocompatible
endif
syntax on

set guicursor=
set showmatch
set relativenumber
set hlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.config/vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=30

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set colorcolumn=100
highlight ColorColumn ctermbg=0 guibg=lightgrey


" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')
  Plug 'mhinz/vim-startify'

  " Find stuff
  " call minpac#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  Plug 'junegunn/fzf.vim'

  " Stuff that shows information
  Plug 'tpope/vim-fugitive'
  Plug 'mbbill/undotree'

  " Language stuff
  Plug 'sheerun/vim-polyglot'

  " Autocompletion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --ts-completer --rust-completer' }

  " Colorschemes
  Plug 'morhetz/gruvbox'
  Plug 'phanviet/vim-monokai-pro'
  Plug 'flazz/vim-colorschemes'

  " Statusbar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()

let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1

let g:gruvbox_contrast_dark = 'medium'
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'
set background=dark
set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
silent! colorscheme ayu
" silent! colorscheme gruvbox
