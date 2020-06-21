if &compatible
  set nocompatible
endif
syntax on

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
set noshowmode                      " Hide the mode text as airline already shows this
set showcmd                         " Show partially entered commands in the statusline
set shortmess+=c                    " Don't show autocompletion stuff in statusbar.
set background=dark                 " Use dark background for color schemes
set laststatus=2                    " Always show the statusline
set ruler                           " Show the line and column number of the cursor position,
set cursorline                      " Highlight the line with the cursor
set mousehide                       " Hide the mouse cursor while typing (works only in gvim?)

" Listchars
set list                        " enable listchars
set listchars=""                " Reset the listchars
set listchars=tab:»\            " a tab should display as "»"
set listchars+=trail:…          " show trailing spaces as "…"
" set listchars+=eol:¬            " show line break
set listchars+=extends:>        " The character to show in the last column when wrap is off and the
                                " line continues beyond the right of the screen
set listchars+=precedes:<       " The character to show in the first column when wrap is off and the
                                " line continues beyond the left of the screen

" Special settings for gruvbox scheme
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_invert_selection='0'

" Functional stuff
set hidden                          " Allow to switch files without having saved
set clipboard^=unnamed,unnamedplus  " Use system clipboard as default register
set mouse=a                         " Enable mouse controls
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=30
set splitbelow                      " open vertical splits below current buffer
set splitright                      " open horizontal splits right of current buffer
" don't select the newline with $ in visual mode (to $d in visual without deleting the newline)
vnoremap $ $h

" Indentation settings
set tabstop=4 softtabstop=4         " Show tabs as 4 spaces and make 4 spaces == <tab> for commands
set shiftwidth=4                    " Use 4 spaces when changing indentation
set smarttab                        " Makes <tab> insert `shiftwidth` amount of spaces
set expandtab                       " Put multiple spaces instead of <TAB>s
set autoindent                      " copy indent from current line when starting a new line
set smartindent                     " be more context-aware than `autoindent`
set nojoinspaces                    " Prevents inserting two spaces after punctuation on a join (J)
set matchpairs+=<:>                 " Adds <> to list of bracket pairs

" Vim Menu autocompletion
set wildmenu            " Completion for :Ex mode. Show list instead of just completing
set wildmode=full,full  " Command <Tab> completion, Show all matches, cycle through with <tab>
set wildchar=<tab>      " Make sure Tab starts wildmode
set wildignorecase      " ignore case in wildmode
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

" Resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

" Line numbers
set number                          " Show line numbers
set relativenumber                  " Line numbers relative to current line instead of absolute
" toggle [r]elative[n]umber
nmap <leader>rn :set relativenumber!<CR>

" Line wrapping
set nowrap                          " Don't wrap lines when the go off screen
set textwidth=100                   " Automatically wrap lines after column 100
set wrapmargin=100                  " fallback for when textwidth is 0?
set colorcolumn=100                 " Highlight colomn 100
" highlight ColorColumn ctermbg=0 guibg=lightgrey " Set color for column 100

" Backup/History
set noswapfile                      " Don't create swap files
set backup                          " Enable backups ...
set backupdir=~/.config/nvim/tmp/backup//   " set directory for backups
set history=10000                   " 10000 is the max history size...
set shada=!,'100,<50,s10,h          " Some new vim 8+ session/history thing?
if has('persistent_undo')           " Most vims should have this...
  set undofile                      " Save undo history to file
  set undodir=~/.config/nvim/undodir//   " Set directory for undo history
  set undolevels=100000             " Maximum number of undos
  set undoreload=100000             " Save complete files for undo on reload if it has less lines
endif

" Searching
set hlsearch                        " Highlight searches
set ignorecase                      " search case insensitive
set smartcase                       " search case sensitive again when you use capital letters
set incsearch                       " Show search results while typing
set gdefault                        " substitutions have the g (all matches) flag by default.
                                    " (Add g after s/// to turn off)
" Turn off search result highlights when you go to insert mode toggle it back on afterwards
autocmd InsertEnter * :setlocal nohlsearch
autocmd InsertLeave * :setlocal hlsearch
" Toggle :[hl]search with <leader>hl
nmap <silent> <leader>hl :set invhlsearch<CR>
" Paste current search
nmap <leader>p/ "/p

" Movement
" Change to tab with <leader>[T]ab H/L
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>tl :tabnext<CR>
" go down or up 1 visual line on wrapped lines instead of line of file. Check the count to only
" do this without a count. (It will jump over wrapped lines when you give a count)
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap gj j
nnoremap gk k
set virtualedit=block               " Allows to select beyond end of lines in block selection mode

" Make q close the quickfix/command/search history window (That thing when you hit q: or q/)
autocmd! CmdwinEnter * nnoremap <buffer> q <c-c><c-c>
autocmd! BufWinEnter quickfix nnoremap <silent> <buffer> q :q<cr>

" Jump to last known cursor position when opening a file (unless it's a commit message file)
autocmd BufReadPost * call s:SetCursorPosition()
function! s:SetCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

" Folding
set foldlevelstart=99
set foldnestmax=5
set foldmethod=indent               " Fold automatically based on indentation level
" :help foldopen !
set foldopen=block,jump,mark,percent,quickfix,search,tag,undo
" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Abbreviations
iabbrev :ldis: ಠ_ಠ
iabbrev :shrug: ¯\_(ツ)_/¯
iabbrev :flip: (╯°□°)╯︵ ┻━┻
iabbrev :aflip: (ﾉಥ益ಥ）ﾉ ┻━┻
iabbrev :patience: ┬─┬ ノ(゜-゜ノ)
iabbrev :zwnj: ‌
iabbrev :check: ✓


" Automatically reload vim settings on save
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" Make sure all markdown files have the correct filetype set
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} set filetype=markdown

" Treat JSON files like JavaScript (do I really need this? 0.o)
au BufNewFile,BufRead *.json set ft=json

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
  " let g:comfortable_motion_scroll_down_key = "j"
  " let g:comfortable_motion_scroll_up_key = "k"
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
  function! SaveCursor()
    set lazyredraw
    let g:winview = winsaveview()
  endfunction
  function! LoadCursor()
    call winrestview(g:winview)
    set nolazyredraw
  endfunction
  function! VimSearchPulseMappings()
    nmap <silent> * :call SaveCursor()<CR><Plug>(incsearch-nohl-*):call LoadCursor()<cr><Plug>Pulse
    nmap <silent> # :call SaveCursor()<CR><Plug>(incsearch-nohl-#):call LoadCursor()<cr><Plug>Pulse
    nmap <silent> g* :call SaveCursor()<CR><Plug>(incsearch-nohl-g*):call LoadCursor()<cr><Plug>Pulse
    nmap <silent> g# :call SaveCursor()<CR><Plug>(incsearch-nohl-g#):call LoadCursor()<cr><Plug>Pulse
  endfunction
  au VimEnter * call VimSearchPulseMappings()

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
  function! TempKeywords()
    call DeclareTempKeyword('1', 'bold', 'lightyellow', 'Black')
    call DeclareTempKeyword('2', 'bold', 'green', 'Black')
    call DeclareTempKeyword('3', 'bold', 'lightgreen', 'Black')
    call DeclareTempKeyword('4', 'bold', 'brown', 'Black')
    call DeclareTempKeyword('5', 'bold', 'lightmagenta', 'Black')
    call DeclareTempKeyword('6', 'bold', 'lightcyan', 'Black')
    call DeclareTempKeyword('7', 'bold', 'White', 'DarkRed')
    call DeclareTempKeyword('8', 'bold', 'White', 'DarkGreen')
    call DeclareTempKeyword('9', 'bold', 'White', 'DarkBlue')
    call DeclareTempKeyword('0', 'bold', 'White', 'DarkMagenta')
  endfunction
  au VimEnter * call TempKeywords()

  " Find stuff
  " I install fzf outside of vim anyway so I don't need the next line
  " Plug 'junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'}
  Plug 'junegunn/fzf.vim'

  " Press s and two keys to jump to the next occurence of those 2 characters together
  " Like f/t, but for two characters...
  Plug 'justinmk/vim-sneak'
  let g:sneak#s_next = 1

  " Adds Commands :Gdiff X to diff with other branches or add stuff to staging area in vimsplit
  " Also has :Gblame and other stuff. Adds Modification markers to the line numbers
  Plug 'tpope/vim-fugitive'

  " Adds Undotree commands to show vim undo history like a git history
  Plug 'mbbill/undotree'
  let g:undotree_WindowLayout=2
  let g:undotree_SetFocusWhenToggle=1
  function g:Undotree_CustomMap()
    nmap <buffer> K <plug>UndotreeNextState
    nmap <buffer> J <plug>UndotreePreviousState
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

  " Colors the current line number background in the mode indicator color
  Plug 'ntpeters/vim-airline-colornum'

  " Surround text or remove surrounding characters
  Plug 'tpope/vim-surround'

  " Make some plugin functions repeatable with .
  Plug 'tpope/vim-repeat'

  " Ruby stuff
  Plug 'thoughtbot/vim-rspec'
  Plug 'tpope/vim-rails'
  Plug 'vim-ruby/vim-ruby'
  Plug 'joonty/vdebug'
  augroup ruby_settings
    autocmd!
    autocmd Filetype ruby setlocal iskeyword+=? iskeyword+=!
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal expandtab
    autocmd FileType ruby setlocal tabstop=2
  augroup end

  augroup vim settings
    autocmd!
    autocmd FileType vim setlocal shiftwidth=2
    autocmd FileType vim setlocal softtabstop=2
    autocmd FileType vim setlocal expandtab
    autocmd FileType vim setlocal tabstop=2
  augroup end

  " Better file tree viewer than default vim
  Plug 'scrooloose/nerdtree'
  let NERDTreeShowHidden=1
  let NERDTreeHighlightCursorline=1

  " Icons for different filetypes in NerdTree
  Plug 'ryanoasis/vim-webdevicons'

  " Yoink let's you cycle through clipboard after pasting
  Plug 'svermeulen/vim-yoink'
  nmap <c-n> <plug>(YoinkPostPasteSwapBack)
  nmap <c-p> <plug>(YoinkPostPasteSwapForward)

  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)

  let g:yoinkMaxItems=20
  let g:yoinkIncludeDeleteOperations=1  " Includes entries from `d` in the history
  let g:yoinkSavePersistently=1         " Save history when you close vim. Needs the `shada` stuff

  " Syntax definitions for i3 config files
  Plug 'mboughaba/i3config.vim'
  aug i3config_ft_detection
      au!
      au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
      au BufNewFile,BufRead ~/.config/sway/config set filetype=i3config
  aug end

  Plug 'svermeulen/vim-subversive'
  " make vim-yoink work when you paste in visual mode
  xmap s <plug>(SubversiveSubstitute)plug
  xmap p <plug>(SubversiveSubstitute)
  xmap P <plug>(SubversiveSubstitute)

  " Substitute current word inside next Motion with something
  nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

  " Replace every occurence of your current search with content of your clipboard
  vmap <leader>s/ :s//*/<CR>

  " Automatically Lint/Syntax Check everything asynchronously
  Plug 'dense-analysis/ale'
  let g:airline#extensions#ale#enabled = 1
  " Cycle through errors
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
  " Configure how errors/warnings are shown in the sidebar
  let g:ale_sign_error = 'E>'
  let g:ale_sign_warning = 'W>'
  " Configure how errors/warnings are shown in the statusbar
  let g:ale_echo_msg_error_str = 'Error'
  let g:ale_echo_msg_warning_str = 'Warning'
  let g:ale_echo_msg_format = '%severity%: %s [%linter%]'
  " Check when getting back to normal made
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_delay = 200
  " Typescript config for ALE
  let g:ale_fixers = { 'javascript': [ 'standard', 'eslint', ], 'typescript': [ 'tsserver', 'tslint' ] }
  let g:ale_linters= { 'javascript': [ 'standard' ], 'typescript': [ 'tsserver', 'tslint' ],}
  let g:ale_completion_tsserver_autoimport = 1
  let g:ale_typescript_tslint_config_path = '.'
  au BufRead,BufNewFile *.ts vnoremap <leader>v :ALEGoToDefinition -vsplit<cr>
  au BufRead,BufNewFile *.ts vnoremap <leader>t :ALEGoToDefinition -tab<cr>
  au BufRead,BufNewFile *.ts vnoremap <c-]> :ALEGoToDefinition<cr>
  au BufRead,BufNewFile *.ts nnoremap <leader>v :ALEGoToDefinition -vsplit<cr>
  au BufRead,BufNewFile *.ts nnoremap <leader>t :ALEGoToDefinition -tab<cr>
  au BufRead,BufNewFile *.ts nnoremap <c-]> :ALEGoToDefinition<cr>

  " Comment stuff with gc or <c-/>
  Plug 'tomtom/tcomment_vim'
  " tComment has a lot of mappings that use another key after pressing <c-/>. The next 2 lines
  " effectively overwrite all those mappings with just <c-/> => toggle comments
  " (If this is not done, vim will wait for a second after pressing <c-/> to see if you wanted to
  " use one of the other commands that follow after <c-/>)
  " Also, <c-/> does not work in most Terminals for reasons. <c-_> is <c-/>...
  autocmd FileType * vnoremap <nowait> <silent> <buffer> <c-_> :TCommentBlock<cr>
  autocmd FileType * nnoremap <nowait> <silent> <buffer> <c-_> :TComment<cr>

  " Gives nested prentheses different colors
  Plug 'junegunn/rainbow_parentheses.vim'
  let g:rainbow#max_level = 16
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}'], ['<', '>']]
  autocmd FileType * RainbowParentheses

  " Shows color codes in the color they represent
  if has('nvim')
    Plug 'norcalli/nvim-colorizer.lua'
  endif

  " Makes sure vims working directory is always the root of the project you are working on
  Plug 'airblade/vim-rooter'
  " Don't change directory if no project root is found (Default)
  let g:rooter_change_directory_for_non_project_files = ''
  let g:rooter_silent_chdir = 1         " Don't announce when directory is changed
  let g:rooter_resolve_links = 1        " Follow symlinks

  " Automatically close opening parenthesis
  Plug 'jiangmiao/auto-pairs'
  let g:AutoPairsFlyMode = 1
  " Cancel what AutoPairs did and revert to what you actually typed
  let g:AutoPairsShortcutBackInsert = '<M-b>'
  " [S]urround things after typing an opening \( => Alt-s
  let g:AutoPairsShortcutFastWrap = '<M-s>'

  " Shows a list of all mapped keys after pressing <leader> and waiting
  Plug 'liuchengxu/vim-which-key'

  " Initialize plugin system
  call plug#end()
endif

" Set <leader> to ,
let mapleader = ","
let maplocalleader = ","
" Make sure the leader key in the next line stays the same as your leader!
call which_key#register(',', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>
" nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
" Help Menu for my leader mappings
let g:which_key_map = {
            \'/' : 'fuzzy search' ,
            \'?' : 'fuzzy search backwards' ,
            \'g' : {'name': 'which_key_ignore'}, 'g/' : 'fuzzy search, cursor stays' ,
            \'_' : {'name': 'TComment Stuff'},
            \'c' : {'name': 'which_key_ignore'},
            \'ca' : 'Clear all highlights',
            \'c0-9' : 'Clear highlight 0-9',
            \'p' : {'name': 'which_key_ignore'}, 'p/' : 'paste current search',
            \'r' : {'name': 'which_key_ignore'}, 'rn' : 'toogle relativenumber',
            \0 : 'which_key_ignore', 1 : 'which_key_ignore', 2 : 'which_key_ignore',
            \3 : 'which_key_ignore', 4 : 'which_key_ignore', 5 : 'which_key_ignore',
            \6 : 'which_key_ignore', 7 : 'which_key_ignore', 8 : 'which_key_ignore',
            \9 : 'which_key_ignore', '0-9' : 'highlight word under cursor',
            \'h' : {'name': 'which_key_ignore'}, 'hl' : 'toggle hlsearch',
            \'s' : {'name': 'which_key_ignore'}, 'ss' : 'substitute word under cursor in motion',
            \'u' : {'name': 'which_key_ignore'}, 'ut' : '[u]ndo[t]ree',
            \'t' : { "name" : "Tabs + trim",
                \'h': 'previous tab',
                \'l': 'next tab',
                \'rim': 't[rim] all trailing whitespace',
                \'r': {'name': 'which_key_ignore'}
                \}
            \}

if has('nvim')
  lua require'colorizer'.setup()
endif

" Trim trailing whitespace
nnoremap <silent> <leader>trim  :%s/\s\+$//<cr>:let @/=''<CR>

" Spellchecking
set spelllang=de_20,en          " German and English spellchecking
set nospell                     " disable spellchecking on startup

" Colorschemes have to be after Plugins because they aren't there before loading plugins...
" silent! colorscheme gruvbox
silent! colorscheme monokain        " Sets Colorscheme. silent! suppresses the warning when you
                                    " start vim the first time and the scheme isn't installed yet.
