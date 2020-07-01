if &compatible
  set nocompatible
endif
syntax on

" Set <leader> to ,
" The leader key has to be set BEFORE mapping anything to <leader> for the which-key plugin to work
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
set listchars+=precedes:<       " The character to show in the first column when wrap is off and
                                " the line continues beyond the left of the screen

" diffs
" Add filler lines in diffs and open diffsplit to the left
set diffopt=filler,vertical
" Automatically update/fold the diff after [o]btaining or [p]utting and go to next change
nnoremap do do:diffupdate<cr>]c
nnoremap dp dp:diffupdate<cr>]c

" Special settings for gruvbox scheme
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_invert_selection='0'

" Functional stuff
set hidden                          " Allow to switch files without having saved
set clipboard+=unnamed              " Use system clipboard as default register
" Override clipboard manager because xclip is the default and has bug with yoink
let g:clipboard = {
      \   'name': 'xsel_override',
      \   'copy': {
      \      '+': 'xsel --input --clipboard',
      \      '*': 'xsel --input --primary',
      \    },
      \   'paste': {
      \      '+': 'xsel --output --clipboard',
      \      '*': 'xsel --output --primary',
      \   },
      \   'cache_enabled': 1,
      \ }
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
set matchpairs+=<:>                 " Adds <> to list of bracket pairs
set nojoinspaces                    " Put (max) 1 space between words when joining 2 lines with `J`
" Keep cursor at the same position when joining lines
nnoremap J mzJ`z

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
" [t]oggle [r]elative[n]umber
nmap <leader>trn :set relativenumber!<CR>

" Line wrapping
set wrap                            " Don't wrap lines when are too long for the screen
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
" Change tab with <leader>[T]ab H/L
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>tl :tabnext<CR>
" Change window with <leader>[w]indow [hjkl]
nnoremap <leader>wh <c-w>h
nnoremap <leader>wl <c-w>l
nnoremap <leader>wj <c-w>j
nnoremap <leader>wk <c-w>k
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


" Put directory of current file in command line mode
" Useful for editing files that are not in a repository
cnoremap <leader>. <C-R>=expand('%:p:h').'/'<cr>

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
  " returns all modified files of the current git repo
  " `2>/dev/null` makes the command fail quietly, so that when we are not
  " in a git repo, the list will be empty
  function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
  endfunction

  " same as above, but show untracked files, honouring .gitignore
  function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
  endfunction

  let g:startify_lists = [
    \  { 'type': 'files',                    'header': ['   MRU'            ] }
    \, { 'type': 'dir',                      'header': ['   MRU '. getcwd() ] }
    \, { 'type': 'sessions',                 'header': ['   Sessions'       ] }
    \, { 'type': function('s:gitModified'),  'header': ['   git modified'   ] }
    \, { 'type': 'commands',                 'header': ['   Commands'       ] }
    \ ]
  " \, { 'type': function('s:gitUntracked'), 'header': ['   git untracked'  ] }
  " \, { 'type': 'bookmarks',                'header': ['   Bookmarks'      ] }
  " I don't use bookmarks because they don't support a description for the file
  let g:startify_bookmarks = []
  " Edit common config files quickly by opening vim and pressing <leader>X
  let g:startify_commands = [
    \  {',z': ['Edit zshrc',                 'e $HOME/.zshrc']}
    \, {',v': ['Edit vimrc',                 'e $MYVIMRC']}
    \, {',g': ['Edit git config',            'e $HOME/.gitconfig']}
    \, {',s': ['Edit ssh config',            'e $HOME/.ssh/config']}
    \, {',b': ['Edit yadm bootstrap script', 'e $HOME/.config/yadm/bootstrap']}
    \ ]
  let g:startify_update_oldfiles = 1        " Update most recently used files on the fly
  let g:startify_change_to_vcs_root = 0     " cd into root of repository if possible
  let g:startify_change_to_dir = 1          " When opening a file or bookmark, change directory
  let g:startify_fortune_use_unicode = 1    " Use unicode symbors instead of just ASCII
  " Open Startify with ,st in current buffer or in a split with Shift
  nnoremap <silent> <leader>St :vsp<cr>:Startify<cr>
  nnoremap <silent> <leader>ST :vsp<cr>:Startify<cr>
  nnoremap <silent> <leader>st :Startify<cr>

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
  map <leader>/ <Plug>(incsearch-fuzzy-/)
  map <leader>? <Plug>(incsearch-fuzzy-?)
  map <leader>g/ <Plug>(incsearch-fuzzy-stay)
  " noremap <silent> n n<Plug>Pulse
  " noremap <silent> N N<Plug>Pulse

  " Pulses search results when you jump to them. Useful for very dense code
  Plug 'iamFIREcracker/vim-search-pulse'
  let g:vim_search_pulse_mode = 'pattern'
  let g:vim_search_pulse_duration = 50
  " Disable default mappings becaus we want to combine them with vim-asterisk
  let g:vim_search_pulse_disable_auto_mappings = 1
  " This is a fork. Original (seems inactive):
  " Plug 'inside/vim-search-pulse'

  Plug 'haya14busa/vim-asterisk'
  " Allows to search for selected text with *
  " Also has a commend that makes the cursor stay after pressing *
  " Map * to stay in place after * and make the search pulse with vim-search-pulse
  map *  <Plug>(asterisk-z*)<Plug>Pulse
  map #  <Plug>(asterisk-z#)<Plug>Pulse
  map g* <Plug>(asterisk-gz*)<Plug>Pulse
  map g# <Plug>(asterisk-gz#)<Plug>Pulse
  " Makes the cursor stay in the same position inside the match while iterating over matches.
  " Useful for quick refactorings whene you need to replace part of a word:
  " Example Usage: *cwTYPE-REPLACEMENT<esc>n.n.n.n.n.n.n.
  let g:asterisk#keeppos = 1

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
  Plug 'BlueCatMe/TempKeyword'
  let TempKeywordCmdPrefix = "<leader>"
  function! TempKeywords()
    call DeclareTempKeyword('1', 'bold', 'LightYellow', 'Black')
    call DeclareTempKeyword('2', 'bold', 'Green', 'Black')
    call DeclareTempKeyword('3', 'bold', 'LightGreen', 'Black')
    call DeclareTempKeyword('4', 'bold', 'Brown', 'Black')
    call DeclareTempKeyword('5', 'bold', 'LightMagenta', 'Black')
    call DeclareTempKeyword('6', 'bold', 'LightCyan', 'Black')
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
  Plug '~/.fzf'
  nnoremap <leader>fl :Lines<cr>
  nnoremap <leader>ff :Files<cr>
  nnoremap <c-p>      :Files<cr>
  nnoremap <leader>fc :norm <leader>rg<cr>
  nnoremap <leader>rg :Rg<cr>

  " Allows to interactively align code (like on : as in the lines above)
  " Plug 'junegunn/vim-easy-align'
  " I forked this and added hjkl as alternatives for arrow keys
  " Pull Request here: https://github.com/junegunn/vim-easy-align/pull/138/files
  Plug 'Gordin/vim-easy-align', { 'branch': 'main' }
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Additional mapping to remember this plugin because = indents
  xmap <leader>= <Plug>(LiveEasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)

  " Press s and two keys to jump to the next occurence of those 2 characters together
  " Like f/t, but for two characters...
  Plug 'justinmk/vim-sneak'
  let g:sneak#s_next = 1

  " Adds Commands :Gdiff X to diff with other branches or add stuff to staging area in vimsplit
  " Also has :Gblame and other stuff. Can browse through everything in a git repo
  Plug 'tpope/vim-fugitive'

  " Show changed lines in files under version control next to the line numbers
  if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif

  " Adds Undotree commands to show vim undo history like a git history
  Plug 'mbbill/undotree'
  let g:undotree_WindowLayout=2
  let g:undotree_SetFocusWhenToggle=1
  " Scroll back in history, while updating the file
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
  " Change selection from list away from <Tab> so ultisnips can use it
  let g:ycm_key_list_select_completion = ['<Down>']
  let g:ycm_key_list_previous_completion = ['<Up>']
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_autoclose_preview_window_after_completion = 1

  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  let g:UltiSnipsExpandTrigger = "<tab>"
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
  let g:UltiSnipsListSnippets = "<leader><tab>"
  " Open :UltiSnipsEdit in a vsplit
  let g:UltiSnipsEditSplit="vertical"


  " Colorschemes
  Plug 'morhetz/gruvbox'
  Plug 'flazz/vim-colorschemes'
  Plug 'chriskempson/base16-vim'

  " Statusbar
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  " let g:airline_theme='base16_monokai'
  let g:airline_theme='powerlineish'


  " Use fancy icons in the statusbar. Needs a font with icons (Anything from "NerdFonts.com" works)
  let g:airline_powerline_fonts = 1

  " Colors the current line number background in the mode indicator color
  Plug 'ntpeters/vim-airline-colornum'

  " Surround text or remove surrounding characters
  Plug 'tpope/vim-surround'
  " Change surrounding quotes to different ones by quickly pressing the
  " current quote and the quote type you want to change to
  nmap '` cs'`
  nmap `' cs`'
  nmap `" cs`"
  nmap "` cs"`
  nmap '" cs'"
  nmap "' cs"'

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
  nmap <c-h> <plug>(YoinkPostPasteSwapBack)
  nmap <c-l> <plug>(YoinkPostPasteSwapForward)

  nmap p <plug>(YoinkPaste_p)
  nmap P <plug>(YoinkPaste_P)

  nmap y <plug>(YoinkYankPreserveCursorPosition)
  xmap y <plug>(YoinkYankPreserveCursorPosition)

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
  nmap <leader>sw <plug>(SubversiveSubstituteWordRange)

  " Replace every occurence of your current search with content of your clipboard
  vmap <leader>s/ :s//*/<cr>
  nmap <leader>s/ :%s//*/<cr>

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

  Plug 'pechorin/any-jump.vim'
  " Disable default keybinds (I kept the default below though)
  let g:any_jump_disable_default_keybindings = 1
  " Allow searching in files not under version control (for newly created files)
  let g:any_jump_disable_vcs_ignore = 0
  " Any-jump window size & position options
  let g:any_jump_window_width_ratio  = 0.8
  let g:any_jump_window_height_ratio = 0.8
  let g:any_jump_window_top_offset   = 4
  let g:any_jump_max_search_results = 20
  let g:any_jump_search_prefered_engine = 'rg'

  " Set custom ignores for different filetypes
  au filetype * let g:any_jump_ignored_files = ['*.tmp', '*.temp', '*.swp']
  " Ignore definitions/references in JavaScript files while editing TypeScript
  au filetype typescript call add(g:any_jump_ignored_files, '*.js')

  " Jump to definition under cursor/of selection
  " Also turn colorcolumn off in the result window
  nnoremap <leader>j :AnyJump<CR>:setlocal colorcolumn=0<CR>
  xnoremap <leader>j :AnyJumpVisual<CR>:setlocal colorcolumn=0<CR>
  " Normal mode: open previous opened file (after jump)
  nnoremap <leader>ab :AnyJumpBack<CR>
  " Normal mode: open last closed search window again
  nnoremap <leader>al :AnyJumpLastResults<CR>

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
  let g:AutoPairsFlyMode = 0
  " Cancel what AutoPairs did and revert to what you actually typed
  let g:AutoPairsShortcutBackInsert = '<M-b>'
  " [S]urround things after typing an opening \( => Alt-s
  let g:AutoPairsShortcutFastWrap = '<M-s>'

  " Shows a list of all mapped keys after pressing <leader> and waiting
  Plug 'liuchengxu/vim-which-key'

  " Initialize plugin system
  call plug#end()
endif

" Make sure the leader key in the next line stays the same as your leader!
call which_key#register(',', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey ','<CR>
" nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
" Help Menu for my leader mappings
let g:which_key_map = {
  \  '/'  : 'fuzzy search'
  \, '?'  : 'fuzzy search backwards'
  \, 'g/' : [',g/', 'fuzzy search, cursor stays'], 'g' : {'name': 'which_key_ignore'}
  \, 'f'  : { 'name': '[f]ind Files, search in code'
    \, 'f' : 'find [f]ilenames in project'
    \, 'c' : 'find [c]ode in project'
    \, 'l' : 'find [l]ines in project'
    \}
  \, '_'  : {'name': 'TComment Stuff'  }
  \, 'c'  : {'name': '[c]lear [0-9] or [a]ll highlights'}
  \, 'p' : {'name': '[p]aste stuff'
    \, '/' : 'paste current search [/]'
    \}
  \, '#'  : '[0-9] highlight word under cursor', '0' : 'which_key_ignore'
  \, '1'  : 'which_key_ignore', '2' : 'which_key_ignore', '3' : 'which_key_ignore'
  \, '4'  : 'which_key_ignore', '5' : 'which_key_ignore', '6' : 'which_key_ignore'
  \, '7'  : 'which_key_ignore', '8' : 'which_key_ignore', '9' : 'which_key_ignore'
  \, 'h'  : { 'name': 'which_key_ignore'
    \, 'l' : 'toggle h[l]search'
    \}
  \, 'hl' : [',hl',  'toggle [hl]search']
  \, 'st' : [':Startify<cr>',  '[St]artify']
  \, 'S'  : { 'name': '[St]artify in a split'
    \, 't' : 'Open [St]artify in a split'
    \, 'T' : 'Open [St]artify in a split'
    \}
  \, 's'  : { 'name': '[s]ubstitute'
    \, 't' : 'Open S[t]artify in current buffer'
    \, 'w' : '[s]ubstitute [w]ord under cursor in motion'
    \, '/' : '[s]ubstitute current search [/] with last yanked text'
    \}
  \, 'r'  : {'name': 'which_key_ignore'
    \, 'g' : 'Search in code with r[g]'
    \}
  \, 'rg' : [',rg', 'Search in code with [rg]']
  \, 'u'  : {'name': 'which_key_ignore'}
  \, 'ut' : [',ut', '[u]ndo[t]ree']
  \, 't'  : { "name" : "[t]abs, [t]oggle + [t]rim"
    \, 'rn' : [',trn',  'toggle [r]elative[n]number']
    \, 'h'  : 'previous tab'
    \, 'l'  : 'next tab'
    \, 'rim': [',trim', 't[rim] all trailing whitespace']
    \, 'r'  : {'name': 'which_key_ignore'}
    \ }
  \ }

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
silent! colorscheme gruvbox
" silent! colorscheme monokain        " Sets Colorscheme. silent! suppresses the warning when you
                                    " start vim the first time and the scheme isn't installed yet.
