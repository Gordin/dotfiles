if &compatible
  set nocompatible
endif
syntax on

" Set <leader> to ,
let mapleader = ","
let maplocalleader = ","

" Controls cursor blinking and shapes. (blink timing has problems in some terminals)
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
            \,a:blinkwait900-blinkoff200-blinkon500-Cursor/lCursor
            \,sm:block-blinkwait500-blinkoff200-blinkon500

" Visual stuff
set noerrorbells                    " no blinking or noises...
set scrolloff=8                     " Keep X lines around cursor visible when scrolling
set showmatch                       " Highlight matching (){}[] etc. pairs
set termguicolors                   " enable true colors support
set cmdheight=1                     " Make line below statusbar always 1 line high
set shortmess+=c                    " Don't show autocompletion stuff in statusbar.
set background=dark                 " Use dark background for color schemes

" Special settings for gruvbox scheme
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_invert_selection='0'

" Functional stuff
set hidden                          " Allow to switch files without having saved
set clipboard=unnamed               " Use system clipboard as default register
set mouse=a                         " Enable mouse controls
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=30

" Indentation settings
set tabstop=4 softtabstop=4         " Show tabs as 4 spaces and make 4 spaces == <tab> for commands
set shiftwidth=4                    " Use 4 spaces when changing indentation
set smarttab                        " Makes <tab> insert `shiftwidth` amount of spaces
set expandtab                       " Put multiple spaces instead of <TAB>s
set autoindent                      " copy indent from current line when starting a new line
set smartindent                     " be more context-aware than `autoindent`

" Line numbers
set number                          " Show line numbers
set relativenumber                  " Line numbers relative to current line instead of absolute

" Line wrapping
set nowrap                          " Don't wrap lines when the go off screen
set textwidth=100                   " Automatically wrap lines after column 100
set wrapmargin=100                  " fallback for when textwidth is 0?
set colorcolumn=100                 " Highlight colomn 100
" highlight ColorColumn ctermbg=0 guibg=lightgrey " Set color for column 100

" Backup/History
set noswapfile                      " Don't create swap files
set nobackup                        " Don't create backups of files
set undodir=~/.config/vim/undodir   " Set directory for undo history
set undofile                        " Keep undo history when exiting vim
set shada=!,'100,<50,s10,h          " Some new vim 8+ session/history thing?

" Searching
set hlsearch                        " Highlight searches
set ignorecase                      " search case insensitive
set smartcase                       " search case sensitive again when you use capital letters
set incsearch                       " Show search results while typing

" Automatically reload vim settings on save
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" Disable Ex mode
nnoremap Q <Nop>

" Store plugins in custom directory
" Add Plugins between plug#begin and plug#end
" :PlugUpgrade to update Plug, :PlugUpdate/Install/Clean to handle plugins
silent! if plug#begin('~/.config/nvim/plugged')
  " Adds a homescreen to vim that shows recently used files when you open vim without a file
  Plug 'mhinz/vim-startify'

  " Makes `vim x:10` or `:e x:10` open file `x` and jump to line 10
  " (Useful for copypasting files from stacktraces or searches
  Plug 'kopischke/vim-fetch'

  " Smooth scrolling for vim
  Plug 'yuttie/comfortable-motion.vim'
  " Make scrolling control the cursor. (Default is just scrolling the viewport)
  let g:comfortable_motion_scroll_down_key = "j"
  let g:comfortable_motion_scroll_up_key = "k"
  " Configure scrolling physics
  let g:comfortable_motion_friction = 200.0
  let g:comfortable_motion_air_drag = 1.0
  let g:comfortable_motion_interval = 1000 / 144 " 144 fps scrolling
  " Smooth scrolling with mousewheel
  noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(50)<CR>
  noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-50)<CR>

  " adds maps to Vim help files
  " jump to ... option: o/O ,link: s/S, anchor: t/T
  " jump to selected: <enter>/<backspace>
  Plug 'dahu/vim-help'

  " When you open a new file but a file with a similar name exists Vim will ask to open that one
  Plug 'EinfachToll/DidYouMean'

  " Automatically create folders that don't exist when saving a new file
  Plug 'DataWraith/auto_mkdir'

  " Highlight ALL matching searches while typing (For regexes)
  Plug 'haya14busa/incsearch.vim'
  let g:incsearch#auto_nohlsearch = 0
  let g:incsearch#consistent_n_direction = 1
  map /  <Plug>(incsearch-forward)\v
  map ?  <Plug>(incsearch-backward)\v
  map g/ <Plug>(incsearch-stay)\v

  " Fuzzy search with <leader>SEARCH-KEY
  " Function copied from README. also matches SOME words when they are misspelled
  Plug 'haya14busa/incsearch-fuzzy.vim'
  function! s:config_fuzzyall(...) abort
      return extend(copy({
                  \   'converters': [
                  \     incsearch#config#fuzzy#converter(),
                  \     incsearch#config#fuzzyspell#converter()
                  \   ],
                  \ }), get(a:, 1, {}))
  endfunction

  noremap <silent><expr> <leader>/  incsearch#go(<SID>config_fuzzyall())
  noremap <silent><expr> <leader>?  incsearch#go(<SID>config_fuzzyall({'command': '?'}))
  noremap <silent><expr> <leader>g/ incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))
  " noremap <silent> n n<Plug>Pulse
  " noremap <silent> N N<Plug>Pulse

  " Pulses search results when you jump to them. Useful for very dense code
  Plug 'iamFIREcracker/vim-search-pulse'
  let g:vim_search_pulse_mode = 'pattern'
  let g:vim_search_pulse_duration = 50
  let g:vim_search_pulse_disable_auto_mappings = 0
  " This is a fork. Original (seems inactive):
  " Plug 'inside/vim-search-pulse'

  " These functions are just because I want the cursor to stay where it is when I press * or #
  " to see if there are matches nearby or if * selected the correct thing I want to search for
  " You can delete them if you like the default behavior
  function! SavePosition()
    set lazyredraw
    let g:winview = winsaveview()
  endfunction
  function! LoadPosition()
    call winrestview(g:winview)
    set nolazyredraw
  endfunction
  function! VimSearchPulseMappings()
    nmap <silent> * :call SavePosition()<CR><Plug>(incsearch-nohl-*):call LoadPosition()<cr><Plug>Pulse
    nmap <silent> # :call SavePosition()<CR><Plug>(incsearch-nohl-#):call LoadPosition()<cr><Plug>Pulse
    nmap <silent> g* :call SavePosition()<CR><Plug>(incsearch-nohl-g*):call LoadPosition()<cr><Plug>Pulse
    nmap <silent> g# :call SavePosition()<CR><Plug>(incsearch-nohl-g#):call LoadPosition()<cr><Plug>Pulse
  endfunction

  " Expand/Shrink current selection around text objects
  " Default is +/_, I added v for expand and <c-v>/- for shrink
  " With this you can just press v multiple times from normal mode to get the selection you want
  Plug 'landock/vim-expand-region'
  " Adds extra text objecst to stop extending/shrinking around. No idea what those are any more...
  au VimEnter * call expand_region#custom_text_objects({ 'a]' :1, 'ab' :1, 'aB' :1, 'a<' : 1 }) ">
  vmap v <Plug>(expand_region_expand)
  vmap - <Plug>(expand_region_shrink)
  vmap <c-v> <Plug>(expand_region_shrink)
  " This is a fork. Original is this, but hasn't been updated since 2013:
  " Plug 'terryma/vim-expand-region'

  " Maps <leader>1-9 to "Highlight word under cursor with color"
  " Useful when you want to see occurences of multiple variables at the same time
  " <leader>ca (c)lears (a)ll highlights, <leader>c1-9 (c)lears color 1-9
  " No idea why I have this in a try/catch...
  Plug 'BlueCatMe/TempKeyword'
  let TempKeywordCmdPrefix = "<leader>"
  try
    au VimEnter * call DeclareTempKeyword('1', 'bold', 'lightyellow', 'Black')
    au VimEnter * call DeclareTempKeyword('2', 'bold', 'green', 'Black')
    au VimEnter * call DeclareTempKeyword('3', 'bold', 'lightgreen', 'Black')
    au VimEnter * call DeclareTempKeyword('4', 'bold', 'brown', 'Black')
    au VimEnter * call DeclareTempKeyword('5', 'bold', 'lightmagenta', 'Black')
    au VimEnter * call DeclareTempKeyword('6', 'bold', 'lightcyan', 'Black')
    au VimEnter * call DeclareTempKeyword('7', 'bold', 'White', 'DarkRed')
    au VimEnter * call DeclareTempKeyword('8', 'bold', 'White', 'DarkGreen')
    au VimEnter * call DeclareTempKeyword('9', 'bold', 'White', 'DarkBlue')
    au VimEnter * call DeclareTempKeyword('0', 'bold', 'White', 'DarkMagenta')
  catch
    " do nothing
  endtry

  " Find stuff
  " I install fzf outside of vim anyway so I don't need the next line
  " Plug 'junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'}
  Plug 'junegunn/fzf.vim'

  " Adds Commands :Gdiff X to diff with other branches or add stuff to staging area in vimsplit
  " Also has :Gblame and other stuff. Adds Modification markers to the line numbers
  Plug 'tpope/vim-fugitive'

  " Adds Undotree commands to show vim undo history like a git history
  Plug 'mbbill/undotree'
  let g:undotree_WindowLayout=2
  let g:undotree_SetFocusWhenToggle=1
  function g:Undotree_CustomMap()
    nmap <buffer> J <plug>UndotreeNextState
    nmap <buffer> K <plug>UndotreePreviousState
  endfunc
  " Show/Hide Untotree and switch to it with ,ut
  nnoremap <silent> <leader>ut :UndotreeToggle<cr>

  " Detect indentation settings of current files and use them
  Plug 'tpope/vim-sleuth'

  " Meta-Plugin for multiple programming languages, loaded on demand
  Plug 'sheerun/vim-polyglot'

  " Autocompletion
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " YCM is nice for python, TypeScript and some other languages. You can also try coc
  Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --ts-completer --rust-completer' }

  " Colorschemes
  Plug 'morhetz/gruvbox'
  Plug 'flazz/vim-colorschemes'

  " Statusbar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme='base16_monokai'
  let g:airline_powerline_fonts = 1

  " Surround text or remove surrounding characters
  Plug 'tpope/vim-surround'

  " Make some plugin functions repeatable with .
  Plug 'tpope/vim-repeat'

  " Yoink let's you cycle through clipboard after pasting
  Plug 'svermeulen/vim-yoink'
  nmap <c-n> <plug>(YoinkPostPasteSwapBack)
  nmap <c-p> <plug>(YoinkPostPasteSwapForward)

  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)

  let g:yoinkMaxItems=20
  let g:yoinkIncludeDeleteOperations=1  " Includes entries from `d` in the history
  let g:yoinkSavePersistently=1         " Save history when you close vim. Needs the `shada` stuff

  Plug 'svermeulen/vim-subversive'
  " s => substitute following motion with yanked text (Also accepts a register)
  nmap s <plug>(SubversiveSubstitute)
  nmap ss <plug>(SubversiveSubstituteLine)
  nmap S <plug>(SubversiveSubstituteToEndOfLine)

  " make vim-yoink work when you paste in visual mode
  xmap s <plug>(SubversiveSubstitute)
  xmap p <plug>(SubversiveSubstitute)
  xmap P <plug>(SubversiveSubstitute)

  " Substitute next motion inside next next Motion with something
  nmap <leader>s <plug>(SubversiveSubstituteRange)
  xmap <leader>s <plug>(SubversiveSubstituteRange)

  " Substitute current word inside next Motion with something
  nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

  " Automatically Lint/Syntax Check everything asynchronously
  Plug 'dense-analysis/ale'
  let g:airline#extensions#ale#enabled = 1
  " Cycle through errors
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)

  " Comment stuff with gc or <c-/>
  Plug 'tomtom/tcomment_vim'
  " tComment has a lot of mappings that use another key after pressing <c-/>. The next 2 lines
  " effectively overwrite all those mappings with just <c-/> => toggle comments
  " (If this is not done, vim will wait for a second after pressing <c-/> to see if you wanted to
  " use one of the other commands that follow after <c-/>)
  " Also, <c-/> does not work in most Terminals for reasons. <c-_> is <c-/>...
  autocmd FileType * vnoremap <nowait> <silent> <buffer> <c-_> :TCommentBlock<cr>
  autocmd FileType * nnoremap <nowait> <silent> <buffer> <c-_> :TComment<cr>

" Initialize plugin system
  call plug#end()
endif

" Call functions that overwrite Plugin mappings here
call VimSearchPulseMappings()

" colorschemes have to be after Plugins because they aren't there before loading plugins...
" silent! colorscheme gruvbox
silent! colorscheme monokain        " Sets colorscheme. silent! suppresses the warning when you
                                    " start vim the first time and the scheme isn't installed yet.
