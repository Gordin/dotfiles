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
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set colorcolumn=100
highlight ColorColumn ctermbg=0 guibg=lightgrey

call plugpac#begin()
  " minpac is available.
  Pack 'k-takata/minpac', {'type': 'opt'}

  Pack 'kristijanhusak/vim-packager', { 'type': 'opt' }

  " Find stuff
  " call minpac#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  Pack 'junegunn/fzf.vim'

  " Stuff that shows information
  Pack 'tpope/vim-fugitive'
  Pack 'mbbill/undotree'

  " Language stuff
  Pack 'sheerun/vim-polyglot'

  " Autocompletion
  "call minpac#add('neoclide/coc.nvim', { 'do': function('InstallCoc') })
  Pack 'ycm-core/YouCompleteMe', { 'do': {-> system('./install.py --ts-completer')} }

  " Colorschemes
  Pack 'morhetz/gruvbox'
  Pack 'phanviet/vim-monokai-pro'
  Pack 'vim-airline/vim-airline'
  Pack 'flazz/vim-colorschemes'

  " Plugin settings here.
call plugpac#end()

let g:gruvbox_contrast_dark = 'hard'
" if exists('+termguicolors')
" 	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" 	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" endif
let g:gruvbox_invert_selection='0'
set background=dark
silent! colorscheme gruvbox
