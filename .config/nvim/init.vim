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

packadd minpac

if !exists('*minpac#init')
  " minpac is not available.

  " Settings for plugin-less environment.
else
  " minpac is available.
  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " Find stuff
  " call minpac#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  call minpac#add('junegunn/fzf.vim')

  " Stuff that shows information
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('mbbill/undotree')

  " Language stuff
  call minpac#add('sheerun/vim-polyglot')

  " Autocompletion
  "call minpac#add('neoclide/coc.nvim', { 'do': function('InstallCoc') })
  call minpac#add('ycm-core/YouCompleteMe')

  " Colorschemes
  call minpac#add('morhetz/gruvbox')
  call minpac#add('phanviet/vim-monokai-pro')
  call minpac#add('vim-airline/vim-airline')
  call minpac#add('flazz/vim-colorschemes')

  " Plugin settings here.
endif

let g:gruvbox_contrast_dark = 'hard'
" if exists('+termguicolors')
" 	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" 	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" endif
let g:gruvbox_invert_selection='0'
set background=dark
colorscheme gruvbox
