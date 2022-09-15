if &compatible
  set nocompatible
endif
syntax on

" let g:node_client_debug = 1
" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']
" let $NVIM_COC_LOG_LEVEL = 'debug'

" Set <leader> to ,
" The leader key has to be set BEFORE mapping anything to <leader> for the which-key plugin to work
let mapleader = ","
let maplocalleader = ","

" Use python from special virtual environments just for vim (if it's there)
if filereadable(expand('~/.config/pyenv/versions/neovim2/bin/python'))
  let g:python_host_prog = '~/.config/pyenv/versions/neovim2/bin/python'
endif
if filereadable(expand('~/.config/pyenv/versions/neovim3/bin/python'))
  let g:python3_host_prog = '~/.config/pyenv/versions/neovim3/bin/python'
endif

" Use custom lua interpreter (neovim doesn't need it)
if !has('nvim') && filereadable(expand('~/.config/lib/liblua.so'))
  set luadll=~/.config/lib/liblua.so
endif

" This changes the shape of the cursor depending on the current mode.
" Insert Mode will be a line, normal mode will be a block.
" Different config is needed for gvim, neovim and vim.
if has("gui_running") || has("nvim")
  " Controls cursor blinking and shapes for gvim and neovim
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
        \,a:blinkwait900-blinkoff200-blinkon500-Cursor/lCursor
        \,sm:block-blinkwait500-blinkoff200-blinkon500
else
  " Taken and adapted from https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
  " This probably does not work on all terminals, but it works on "Windows Terminal", so I assume
  " it will work in most cases. I removed the `redraw!` from the example  because that made my
  " terminal flash each time I entered/left INSERT mode.
  augroup cursorshape
    autocmd!
    autocmd VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"'
    autocmd InsertEnter,InsertChange *
          \ if v:insertmode == 'i' |
          \   silent execute '!echo -ne "\e[5 q"' |
          \ elseif v:insertmode == 'r' |
          \   silent execute '!echo -ne "\e[3 q"' |
          \ endif
    autocmd VimLeave * silent execute '!echo -ne "\e[ q"'
  augroup end
endif

" Visual stuff
set visualbell                      " Blink when errors happen instead of making a sound
set vb t_vb=                        " Also disable the blinking, I don't want any bell...
set scrolloff=20                    " Keep X lines around cursor visible when scrolling up/down
set showmatch                       " Highlight matching (){}[] etc. pairs
" enable true colors support if available
if exists('+termguicolors')
  " setting some special escape sequences for terminals. No idea what they do ¯\_(ツ)_/¯
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set cmdheight=1                     " Make line below statusbar always 1 line high
set noshowmode                      " Hide the mode text as airline already shows this
set showcmd                         " Show partially entered commands in the statusline
set shortmess+=c                    " Don't show autocompletion stuff in statusbar.
set laststatus=2                    " Always show the statusline
set ruler                           " Show the line and column number of the cursor position,
set cursorline                      " Highlight the line with the cursor
set mousehide                       " Hide the mouse cursor while typing (works only in gvim?)
set nolazyredraw

" Listchars
set list                        " enable listchars
set listchars=""                " Reset the listchars
set listchars=tab:»\            " a tab should display as "»"
set listchars+=trail:…          " show trailing spaces as "…"
set listchars+=eol:¬            " show line breaks as "¬"
set listchars+=extends:>        " The character to show in the last column when wrap is off and the
                                " line continues beyond the right of the screen
set listchars+=precedes:<       " The character to show in the first column when wrap is off and
                                " the line continues beyond the left of the screen
set conceallevel=2              " Enable "conceal". Poor mans WYSIWYG. Does something different for
                                " different languages. For example in Markdown, can show
                                " "*ABC*" as just "ABC", but actually with a bold font or in python
                                " "\lambda" can be shown as "λ" (with the right plugins)


" ### "Mouse selection Mode" start ###

" (Should probably extract this as a plugin... )
" These function let you select and copy stuff from terminal vim, by disabling vims mouse mappings,
" and hiding everything you don't want to copy, like line numbers, diff signs, line end markers,
" etc. It also toggles "paste" mode, which let's you paste stuff into vim witout it messing up the
" formatting due to auto-formatting
" (Sidenote: Should not be needed if you have set up yanking to the system clipboard, but it's
" nice to have when this doesn't work if you are working through SSH/tmux/screen, or whatever else
" would need a properly setup X-Forwarding to reach your system clipboard)
let g:mouse_select = 0
fun! EnableMouseSelection()
  let g:mouse_select = 1
  set nolist
  set nonumber
  set norelativenumber
  set mouse=
  set signcolumn=no
  set conceallevel=0
  set paste
endf

fun! DisableMouseSelection()
  let g:mouse_select = 0
  set list
  set number
  set relativenumber
  set mouse=nvi
  set signcolumn=auto
  set conceallevel=2
  set nopaste
endf

fun! ToggleMouseSelection()
    if g:mouse_select
        call DisableMouseSelection()
    else
        call EnableMouseSelection()
    endif
endf

" [T]oggle [M]ouse Selection mode in Terminal on/off
nnoremap <leader>tm :silent call ToggleMouseSelection()<CR>
" Map right mouse button to toggle mouse selection.
" (Can only turn mouse mode off, because with mouse mode off, right click isn't recognized...)
noremap <silent> <RightMouse> <esc>:call ToggleMouseSelection()<CR>

" ### "Mouse selection Mode" end ###

" diffs
" Add filler lines in diffs and open diffsplit to the left
set diffopt=filler,vertical,closeoff
" Automatically update/fold the diff after [o]btaining or [p]utting and go to next change
nnoremap do do:diffupdate<cr>]c
nnoremap dp dp:diffupdate<cr>]c

" Special settings for gruvbox scheme
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_invert_selection='0'

set hidden                        " Allow to switch files without having saved
set mouse=nvi                     " Enable mouse controls
                                  " nvi means mouse is hadled by vim only whene in [n]ormal,
                                  " [v]isual and [i]nsert mode.
                                  " This allows the mouse to act like it normally would in a
                                  " Terminal when you are in `:` Command mode or if a
                                  " Command output window is open

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delay when doing stuff...
set updatetime=10
set splitbelow                      " open vertical splits below current buffer
set splitright                      " open horizontal splits right of current buffer

" don't select the newline with $ in visual mode. This allows you to use $d in visual mode to expand
" your selection to the end of the line and delete, without pulling the next line up. Also lets you
" expand your selection to the end of line and copy without the newline with $y in visual mode
vnoremap $ $h
" enter [v]isual [b]lock mode (If you don't like ctrl+v...)
nnoremap <leader>vb <c-q>
" Pressing I/A when in visual block mode allows to add something in front of/after the block in all
" lines of the block. !!vim will only show the edit to current line until you leave edit mode!!
" I just put this here as a reminder, because TComment and CoC already have visual mapping that
" start with i/a
" vnoremap i I
" vnoremap a A

" Indentation settings
set tabstop=2 softtabstop=2         " Show tabs as 2 spaces and make 2 spaces == <tab> for commands
set shiftwidth=2                    " Use 2 spaces when changing indentation
set expandtab                       " Put multiple spaces instead of <TAB>s
set smarttab                        " Makes <tab> insert `shiftwidth` amount of spaces
set autoindent                      " copy indent from current line when starting a new line
set smartindent                     " be more context-aware than `autoindent`
set matchpairs+=<:>                 " Adds <> to list of bracket pairs you can jump between with %
set nojoinspaces                    " Put (max) 1 space between words when joining 2 lines with `J`
" Keep cursor at the same position when joining lines with J
nnoremap J mzJ`z

" Vim Menu autocompletion
set wildmenu            " Completion for : mode. Show list instead of just completing
set wildmode=full,full  " Command <Tab> completion, Show all matches, cycle through with <tab>
set wildchar=<tab>      " Make sure Tab starts wildmode
set wildignorecase      " ignore case in wildmode
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Ignore typical Linux/MacOSX files we don't care about
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Ignore typical Windows files we don't care about

" Resize splits when the window is resized
autocmd VimResized * exe "normal! \<c-w>="

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
set swapfile                              " create swap files to recover from crashes
set directory=~/.config/nvim/tmp/swap//   " set directory for swap files
set backup                                " Enable backups ...
set backupdir=~/.config/nvim/tmp/backup// " set directory for backups
set history=10000                         " 10000 is the max history size...
if has('nvim')
  set shada=!,'100,<50,s10,h              " Some new vim 8+ session/history thing?
endif
if has('persistent_undo')                 " Most vims should have this...
  set undofile                            " Save undo history to file
  set undodir=~/.config/nvim/undodir//    " Set directory for undo history
  set undolevels=100000                   " Maximum number of undos
  set undoreload=100000                   " Save complete files for undo on reload if it has less lines
endif

" Searching
set hlsearch   " Highlight searches
set ignorecase " Search case insensitive
set smartcase  " Switch to case sensitive again when you use capital letters
set incsearch  " Highlight search results while typing
set gdefault   " substitutions have the g (replace all matches on a line) flag by default.
               " (Add g after s/// to turn off)
set wrapscan   " Makes searches loop around to the beginning of file after the last result

autocmd! BufWinEnter * set wrapscan " Something keeps resetting this -_-

" Turn off search result highlights when you go to insert mode toggle it back on afterwards
autocmd InsertEnter * :setlocal nohlsearch
autocmd InsertLeave * :setlocal hlsearch

" Clear the current search register with // to remove highlighting
" (For me setting nohlsearch doesn't work, because I toggle it on when Leaving Insert mode)
nmap <silent> // :let @/ = ""<CR>
" Toggle :[t]oggle [hl]search with <leader>thl
nmap <silent> <leader>t/ :set invhlsearch<CR>
" Paste current search
nmap <leader>p/ "/p

" Copies current file path (relative to repo) into default register
nmap <silent>y% :call yoink#manualYank(@%)<CR>

" Movement
" Change tab with <leader>[t]ab H/L
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>tl :tabnext<CR>
" Change window with <leader>[w]indow [hjkl]
nnoremap <leader>wh <c-w>h
nnoremap <leader>wl <c-w>l
nnoremap <leader>wj <c-w>j
nnoremap <leader>wk <c-w>k
" go down or up 1 visual line on wrapped lines instead of line of file. Check the count to only
" do this without a count. (It will jump over wrapped lines when you give a count, so it works with
" relative numbers)
nnoremap <silent><expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent><expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <silent> gj j
nnoremap <silent> gk k
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

" Opens current file again in a tab. Better than `:tabe %` because that puts your cursor to line 1,
" but `:tab split` will keep the cursor position.
nnoremap <leader>te :tab split<CR>

" Folding
set foldlevelstart=1                " Files will be folded to the first level on opening
set foldnestmax=5                   " Maximum fold level
set foldmethod=indent               " Fold automatically based on indentation level
" sets the actions that will open a fold when performed on a fold. See :help foldopen !
set foldopen=block,jump,mark,percent,quickfix,search,tag,undo
" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
" Easily set foldlevel to get an overview of all attributes of something
" (Anything above 3 will probably never be used)
nnoremap <leader>z0 :set foldlevel=0<CR>
nnoremap <leader>z1 :set foldlevel=1<CR>
nnoremap <leader>z2 :set foldlevel=2<CR>
nnoremap <leader>z3 :set foldlevel=3<CR>
nnoremap <leader>z4 :set foldlevel=4<CR>
nnoremap <leader>z5 :set foldlevel=5<CR>
nnoremap <leader>z6 :set foldlevel=6<CR>
nnoremap <leader>z7 :set foldlevel=7<CR>
nnoremap <leader>z8 :set foldlevel=8<CR>
nnoremap <leader>z9 :set foldlevel=9<CR>

" Abbreviations (left side will be replaced automatically when typed in insert mode)
iabbrev :ldis: ಠ_ಠ
iabbrev :shrug: ¯\_(ツ)_/¯
iabbrev :flip: (╯°□°)╯︵ ┻━┻
iabbrev :aflip: (ﾉಥ益ಥ）ﾉ ┻━┻
iabbrev :patience: ┬─┬ ノ(゜-゜ノ)
iabbrev :zwnj: ‌
iabbrev :check: ✓


" Automatically reload vim settings on save
" SOME PLUGINS DON'T LIKE TO BE LOADED MULTIPLE TIMES, IF YOU ARE PLAYING AROUND WITH THE CONFIG
" AND STUFF DOESN'T SEEM TO WORK, TRY RESTARTING VIM INSTEAD!
" Mostly a problem with highlighting/color/other visual stuff plugins though
" autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" Make sure all markdown (and txt) files are treated as markdown
" autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} set filetype=markdown

" Treat JSON files like JSON instead of JavaScript (Not sure if still needed, too lazy to test)
autocmd BufNewFile,BufRead *.json set ft=json

" Disable Ex mode
nnoremap Q <Nop>

" Store plugins in custom directory
" Add Plugins between plug#begin and plug#end
" :PlugUpgrade to update Plug, :PlugUpdate/Install/Clean to handle plugins
silent! if plug#begin('~/.config/nvim/plugged')
  " ### Startify start ###
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
  " Edit common config files quickly by just opening vim and pressing <leader>X
  let g:startify_commands = [
    \  {',z': ['Edit zshrc',                 'e $HOME/.zshrc']}
    \, {',v': ['Edit vimrc',                 'e $MYVIMRC']}
    \, {',t': ['Edit tmux config',           'e $HOME/.config/tmux/tmux.conf']}
    \, {',g': ['Edit git config',            'e $HOME/.gitconfig']}
    \, {',s': ['Edit ssh config',            'e $HOME/.ssh/config']}
    \, {',i': ['Edit i3 config',             'e $HOME/.config/i3/config']}
    \, {',b': ['Edit yadm bootstrap script', 'e $HOME/.config/yadm/bootstrap']}
    \, {',l': ['Edit lazygit config',        'LazyGitConfig']}
    \, {'lg': ['Open lazygit',               'LazyGit']}
    \ ]
  let g:startify_update_oldfiles     = 1    " Update most recently used files on the fly
  let g:startify_change_to_vcs_root  = 1    " cd into root of repository if possible
  let g:startify_change_to_dir       = 1    " When opening a file or bookmark, change directory
  let g:startify_fortune_use_unicode = 1    " Use unicode symbors instead of just ASCII
  " Open Startify with ,st in current buffer or in a split with Shift
  nnoremap <silent> <leader>St :vsp<cr>:Startify<cr>
  nnoremap <silent> <leader>ST :vsp<cr>:Startify<cr>
  nnoremap <silent> <leader>st :Startify<cr>

  " ### Startify end ###

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " ### vim-fetch start ###
  " Makes `vim x:10` or `:e x:10` open file `x` and jump to line 10
  " (Useful for copypasting files paths from stacktraces or searches
  Plug 'kopischke/vim-fetch'
  " ### vim-fetch end ###

  " ### vim-help start ###
  " adds maps to Vim help files
  " jump to ... option: o/O ,link: s/S, anchor: t/T
  " jump to selected: <enter>/<backspace>
  Plug 'dahu/vim-help'
  " ### vim-help end ###

  " ### DidYouMean start ###
  " When you open a new file but a file with a similar name exists Vim will ask to open that one
  " Useful for when you open vim with vim ABC<TAB><Enter>, but the tab completion only partly
  " completed the file name.
  Plug 'EinfachToll/DidYouMean'
  let g:dym_use_fzf = 1
  " ### DidYouMean end ###

  " ### auto_mkdir start ###
  " Automatically create folders that don't exist when saving a new file
  Plug 'DataWraith/auto_mkdir'
  " ### auto_mkdir end ###

  " ### incsearch start ###
  " Highlight ALL matching searches while typing (For regexes)
  Plug 'haya14busa/incsearch.vim'
  let g:incsearch#auto_nohlsearch = 0           " Don't disable hlsearch after searching
  let g:incsearch#consistent_n_direction = 1    " n is always the next match down, even for ?
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
  " ### incsearch end ###

  " ### incsearch-fuzzy start ###
  " Makes searching fuzzy with <leader>/
  Plug 'haya14busa/incsearch-fuzzy.vim'
  map <leader>/  <Plug>(incsearch-fuzzy-/)
  map <leader>?  <Plug>(incsearch-fuzzy-?)
  map <leader>g/ <Plug>(incsearch-fuzzy-stay)
  " ### incsearch-fuzzy start ###

  " ### vim-search-pulse start ###
  " Pulses search results when you jump to them. Useful for very dense code
  Plug 'iamFIREcracker/vim-search-pulse'
  let g:vim_search_pulse_mode = 'pattern'
  let g:vim_search_pulse_duration = 100

  if has("gui_running") || has("nvim")
    let g:vim_search_pulse_color_list = ["#99ffff", "#ff99ff", "#99ffff", "#ff99ff"]
  else
    let g:vim_search_pulse_color_list = [226, 201, 226, 201, 226]
  endif
  " Disable default mappings becaus we want to combine Pulse with vim-asterisk and incsearch
  let g:vim_search_pulse_disable_auto_mappings = 1
  " This is a fork. Original (seems inactive) (Fork added the Pulse command):
  " Plug 'inside/vim-search-pulse'

  " Integrate incsearch plugin with Pulse
  map n <Plug>(incsearch-nohl-n)<Plug>Pulse
  map N <Plug>(incsearch-nohl-N)<Plug>Pulse
  autocmd! User IncSearchExecute
  autocmd  User IncSearchExecute :call search_pulse#Pulse()

  " Alternative to vim-search-pulse
  " Plug 'danilamihailov/beacon.nvim'

  " ### vim-search-pulse end ###

  " ### vim-asterisk start ###
  Plug 'haya14busa/vim-asterisk'
  " Allows to search for text in visual mode by pressing *
  " Also has a command that makes the cursor stay after pressing *
  " Map * to stay in place after * and make the search pulse with vim-search-pulse
  map *  <Plug>(asterisk-z*)<Plug>Pulse
  map #  <Plug>(asterisk-z#)<Plug>Pulse
  map g* <Plug>(asterisk-gz*)<Plug>Pulse
  map g# <Plug>(asterisk-gz#)<Plug>Pulse
  " ### vim-asterisk end ###

  " ### vim-expend-region start ###
  " Expand/Shrink current selection around text objects
  " Default is +/_, I added v for expand and <c-v>/- for shrink
  " With this you can just press v multiple times from normal mode to get the selection you want
  Plug 'landock/vim-expand-region'
  " Adds extra text objecst to stop extending/shrinking around.
  " No idea what those are any more... :help expand_region has examples
  autocmd VimEnter * call expand_region#custom_text_objects({ 'a]' :1, 'ab' :1, 'aB' :1, 'a<' : 1 })
  vmap v     <Plug>(expand_region_expand)
  vmap -     <Plug>(expand_region_shrink)
  vmap <c-v> <Plug>(expand_region_shrink)
  " This is a fork. Original is this, but hasn't been updated since 2013:
  " Plug 'terryma/vim-expand-region'
  " ### vim-expend-region end ###

  " ### Highlighter start ###
  " Allows to highlight word under cursor or visual selection
  "
  " Adds a highlight to the current word/selection
  let HiSet   = '<leader>hl'
  " Adds a highlight to the current word/selection that goes away when you move the cursor
  let HiErase = '<leader>he'
  " Clears all highlight
  let HiClear = '<leader>hc'
  " Does some searching stuff, I don't need it.
  let HiFind  = '<leader>h/'
  Plug 'azabiong/vim-highlighter'
  " ### Highlighter end ###

  " ### current_word end ###
  " Plugin that automatically highlight the word and all other occurences of the word under cursor.
  " Style can be controlled whith the variables CurrentWord and CurrentWordTwins at the end of this
  " file (becase colorscheme needs to be loadid first)
  Plug 'dominikduda/vim_current_word'
  " Twins of word under cursor:
  let g:vim_current_word#highlight_twins = 1
  " The word under cursor:
  let g:vim_current_word#highlight_current_word = 1
  let g:vim_current_word#highlight_delay = 100
  nmap <leader>tw :VimCurrentWordToggle<CR>
  " ### current_word end ###

  " ### vimspector start ###
  " I never really tested this, should be a nice alternative to using VSCode/Chromium as debugger
  Plug 'puremourning/vimspector'
  let g:vimspector_base_dir='/home/aguth/.config/nvim/plugged/vimspector'
  let g:vimspector_enable_mappings = 'HUMAN'
  " ### vimspector end ###

  " ### fzf start ###
  " Find stuff
  " Next line installs fzf for your user (for use outside of vim). This may give an error on updates
  " if you already have it installed a different way. Will still work though.
  Plug 'junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'}
  Plug 'junegunn/fzf.vim'
  " Fuzzy search in code in current file
  nnoremap <leader>fl :Lines<cr>
  " Fuzzy search filenames in project
  nnoremap <expr> <leader>ff (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
  nnoremap <expr> <c-p>      (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
  nnoremap <leader>bu :Buffers<cr>
  " Fuzzy search in code in project
  nnoremap <leader>fc :norm <leader>rg<cr>
  nnoremap <leader>rg :Rg<cr>
  " ### fzf end ###

  " This is commented out because for some reason this does not match fuzzy any more -_-
  " The default :Rg command matches filenames AND Code, this redefined version only matches code
  " This is just copied from the fzf help section `fzf-vim-example-advanced-ripgrep-integration`
  " I have no idea why this one doesn't match the filenames, but it doesn't...
  " function! RipgrepFzf(query, fullscreen)
  "   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  "   let initial_command = printf(command_fmt, shellescape(a:query))
  "   let reload_command = printf(command_fmt, '{q}')
  "   let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  "   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  " endfunction
  " command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

  " Doesn't work yet
  " function! NoJSFiles(query, fullscreen)
  "   let command_fmt = 'fd --type f --exclude *.js --exclude .* || true'
  "   let initial_command = printf(command_fmt, shellescape(a:query))
  "   let spec = {'options': ['--phony', '--query', a:query, '--bind']}
  "   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  " endfunction
  " command! -bang Files call NoJSFiles(<q-args>, <bang>0)

  " ### easy-align start ###

  " Allows to interactively align code on = || && etc. to make variable definitions look more clean
  " This can do A LOT of stuff, but I only use it by selecting stuff in visual mode, activate this,
  " press the character I want to align to, play around with hjkl until I have the alignment I want.
  " (Enter changes the alignment of the right side, you have to press the aligned character again
  " to confirm the alignment)
  "
  " Plug 'junegunn/vim-easy-align'
  " I forked this and added hjkl as alternatives for arrow keys. Development seems dead
  " Pull Request here: https://github.com/junegunn/vim-easy-align/pull/138/files
  " Edit: changed it to the repo of some other guy that used my fork...
  Plug 'njhoffman/vim-easy-align'
  " Start interactive EasyAlign in visual mode (e.g. vipga) [g]o [a]lign
  xmap ga <Plug>(EasyAlign)
  " Easier mapping to remember this plugin because = indents and <leader>= aligns
  xmap <leader>= <Plug>(LiveEasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip) [g]o [a]lign (motion)
  nmap ga <Plug>(EasyAlign)

  " ### easy-align end ###

  " ### vim-recover start ###
  " Shows a diff with recovery files by pressing c
  Plug 'chrisbra/Recover.vim'
  nnoremap <leader>fr :FinishRecovery<CR>
  " ### vim-recover end ###

  " ### Sneak start ###

  " I replaced this with "Hop". this is still nice if you prever to press 2 chars instead of 1

  " Press s and two keys to jump to the next occurence of those 2 characters together
  " Like f/t, but for two characters...
  " If there are more than one possible places, will show a character you need to press to go there
  " with this config.
  " (USE THIS, THIS IS FASTER THAN ANYTHING ELSE FOR MOVING AROUND IN ONE SCREEN!)
  " Plug 'justinmk/vim-sneak'
  " let g:sneak#s_next     = 1 " Press s/S again to jump through all targets"
  " let g:sneak#label      = 1 " Put labels on possible jump target after activating
  " let g:sneak#use_ic_scs = 1 " Make sneak follow ignorecase and smartcase setting

  " ### Sneak end ###

  Plug 'jparise/vim-graphql'

  " Syntax file for jsonc (json with comments...)
  Plug 'kevinoid/vim-jsonc'
  augroup jsonc
    autocmd!
    " set filetype of the coc config file to jsonc. Comments show up as errors otherwise
    autocmd BufEnter */coc-settings.json set ft=jsonc
  augroup end

  Plug 'ekalinin/Dockerfile.vim'

  " ### git stuff start ###

  " Adds Commands :Gdiff X to diff with other branches or add stuff to staging area in vimsplit
  " Also has :Gblame and other stuff. Can browse through everything in a git repo
  Plug 'tpope/vim-fugitive'
  " [g]it: Go to [n]ext/[p]revious change in current file (maps ]c and [c itself, but I don't like
  " it)
  nmap <leader>gn ]c
  nmap <leader>gp [c
  " Gblame tells you to use :Git blame instead, but I like Gblame -_-
  command! Gblame Git blame
  " Rhubarb extends fugitive with some stuff when `hub` in installed (Github Client)
  Plug 'tpope/vim-rhubarb'

  " ### git stuff end ###

  Plug 'nvim-lua/plenary.nvim'

  " ### lazygit start ###
  "
  Plug 'kdheepak/lazygit.nvim'

  let g:lazygit_floating_window_winblend = 10 " transparency of floating window
  let g:lazygit_floating_window_scaling_factor = 0.95 " scaling factor for floating window
  let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
  let g:it_floating_window_use_plenary = 1 " use plenary.nvim to manage floating window if available
  let g:lazygit_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed
  nmap <leader>lg :LazyGit<CR>

  if has('nvim') && executable('nvr')
    let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  endif
  " ### lazygit end ###

  " ### Signify start ###

  " Show changed lines in files under version control next to the line numbers
  if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif
  if !exists("g:signify_vcs_cmds")
    let g:signify_vcs_cmds= {}
  endif
  " let g:signify_vcs_cmds['git'] = 'git diff --no-color --no-ext-diff -U0 -- %f | sed "/^ /d"'
  let g:signify_vcs_cmds['yadm'] = 'yadm diff --no-color --no-ext-diff -U1 -- %f'
  let g:signify_sign_show_count = 1
  let g:signify_number_highlight = 0
  let g:signify_line_highlight = 0

  " show or undo current hunk (changed lines)
  " [G]it [d]iff / [G]it [u]ndo
  noremap <leader>Gd :SignifyHunkDiff<CR>
  noremap <leader>Gu :SignifyHunkUndo<CR>

  " Hide signcolumn when there are no changes or Errors to be shown
  set signcolumn=auto

  " ### Signify end ###

  " ### Abolish end ###
  " Does a lot of word-conversion stuff
  " Has mappings to convert between snake/camel/mixed/dash etc. cases
  " Mappings: crs (snake_case), crm (MixedCase), crc (camelCase), cr- (dash-case), cr. (dot.case)
  Plug 'tpope/vim-abolish'
  " ### Abolish end ###

  " ### Undotree start ###

  " Adds Undotree commands to show vim undo history like a git history
  " Lets you go back to provious versions of a file by selecting and pressing enter.
  " Useful when you pressed undo to copy stuff, but accidentally changed stuff, so you can't redo
  " anymore to get back. This let's you get back to where you want easily.
  Plug 'mbbill/undotree'
  let g:undotree_WindowLayout=2
  let g:undotree_SetFocusWhenToggle=1
  " Scroll back in history, while updating the file
  function! g:Undotree_CustomMap()
    nmap <buffer> K <plug>UndotreeNextState
    nmap <buffer> J <plug>UndotreePreviousState
  endfunc
  " Show/Hide Untotree and switch to it with ,ut
  nnoremap <silent> <leader>ut :UndotreeToggle<cr>

  " ### Undotree end ###

  " Detect indentation settings of current files and use them
  Plug 'tpope/vim-sleuth'

  Plug 'phaazon/hop.nvim'


  " Meta-Plugin for multiple programming languages, loaded on demand
  Plug 'sheerun/vim-polyglot'
  let g:polyglot_disabled = []

  Plug 'elixir-editors/vim-elixir'
  Plug 'mhinz/vim-mix-format'
  let g:mix_format_on_save = 1

  " ### Dart stuff start ###
  " (needs some work...)
  Plug 'dart-lang/dart-vim-plugin'
  let g:dart_style_guide = 2
  let g:dart_format_on_save = 0 " Does not work?....
  let dart_html_in_string=v:true
  nmap <leader>fd :!flutter dartfmt %
  " Plug 'natebosch/vim-lsc'
  " Plug 'natebosch/vim-lsc-dart'
  " let g:lsc_auto_map = v:true

  " ### Dart stuff end ###

  " ### CoC start ###
  " I'M TRYING TO MAKE COC WORK TOGETHER WITH YouCompleteMe HERE, YOU ARE PROBABLY BETTER OFF
  " REMOVING ANYTHING RELATED TO YCM FROM THIS CONFIG AND JUST USE COC!
  " You have been warned...

  " Autocompletion with Coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <C-Space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Automatically open signature help when entering insert mode.
  " (Sounds helpful, but it can be kinda annoying, because the help hides other stuff...)
  augroup cocsignaturehelp
    autocmd!
    autocmd InsertEnter *       call CocActionAsync('showSignatureHelp')
  augroup end

  " Show [s]ignature [h]elp again while in insert mode
  inoremap <leader>sh <C-\><C-O>:call CocActionAsync('showSignatureHelp')<cr>

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: There's always complete item selected by default, you may want to enable
  " no select by `"suggest.noselect": true` in your configuration file.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  let g:coc_global_extensions = [
        \  'coc-tsserver'
        \, 'coc-json'
        \, 'coc-marketplace'
        \, 'coc-python'
        \, 'coc-elixir'
        \, 'coc-snippets'
        \, 'coc-rust-analyzer'
        \, 'coc-rls'
        \, 'coc-solargraph'
        \, 'coc-vimlsp'
        \, 'coc-flutter'
        \, 'coc-flutter-tools'
        \]
  " Use K to show documentation in preview window.
  " (Only needed in neovim, in vim this is always shown for stuff under the cursor)
  nnoremap <silent> K :call ShowDocumentation()<CR>

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Use <C-l> for trigger snippet expand.
  imap <C-l> <Plug>(coc-snippets-expand)

  " Use <C-j> for select text for visual placeholder of snippet.
  vmap <C-j> <Plug>(coc-snippets-select)

  " Use <C-j> for jump to next placeholder, it's default of coc.nvim
  let g:coc_snippet_next = '<c-j>'

  " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
  let g:coc_snippet_prev = '<c-k>'

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction

  " nnoremap <esc> :call coc#util#float_hide()<CR>
  " nmap <esc> <Plug>(coc-float-hide)
  " nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
  " nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
  " nnoremap <leader><esc> :call popup_clear()<CR>:call coc#util#float_hide()<CR>:call coc#util#close_floats()<CR>
  " nnoremap <leader><esc> :call coc#config('suggest.floatEnable', "false")<cr>

  " autocmd User CocOpenFloat call coc#util#close_floats()


  " GoTo code navigation.
  " Setup Mappings to use
  nmap <Plug>(coc-definition-vsplit) :call CocAction('jumpDefinition', 'vsplit')<CR>
  nmap <Plug>(coc-definition-tabe) :call CocAction('jumpDefinition', 'tabe')<CR>
  nmap <Plug>(coc-definition-edit) :call CocAction('jumpDefinition', 'edit')<CR>
  " Use the mappings
  " [g]o to definition of current word in [v]split
  nmap <silent> gv <Plug>(coc-definition-vsplit)
  " [g]o to definition of current word in new [t]ab
  nmap <silent> gt <Plug>(coc-definition-tabe)
  " [g]o to [d]efinition of current word (in the current window)
  nmap <silent> gd <Plug>(coc-definition-edit)
  " [g]o to [t]ype definition of current word (in the current window (I guess?))
  nmap <silent> gy <Plug>(coc-type-definition)
  " [g]o to [i]mplementation of current word (in the current window)
  nmap <silent> gi <Plug>(coc-implementation)
  " [g]o to [r]eferences of current word (shows window to select which one)
  nmap <silent> gr <Plug>(coc-references)

  " Select `inside` and `around` function
  " In visual mode, lets you press af/if to expand the selection to the whole function you are in
  " either the whole thing with af or just the code inside with if
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)

  " Refactoring stuff.
  " [r]e[n]ame word under cursor. If available will use a language server and rename occurences in
  " the whole repository
  nmap <leader>rn <Plug>(coc-rename)
  " Show inspectEdit view. (For checking renamings for coc-rename)
  nmap <leader>ie :CocCommand workspace.inspectEdit<CR>
  " Bring up a small menu for [c]de [a]ctions. Can do stuff like add missing imports from other files
  nmap <leader>ca <Plug>(coc-codeaction)
  " Same thing for codelens actions I guess, whatever those are... ¯\_(ツ)_/¯
  nmap <leader>cl <Plug>(coc-codelens-action)
  " Like rename, but with more options?
  nmap <leader>rf <Plug>(coc-refactor)

  " Formatting selected code. (Needs a properly configured language server for current language)
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  " Go through automatic completion suggestions with TAB
  let g:coc_snippet_next = '<tab>'

  " ### CoC end ###

  Plug 'SirVer/ultisnips'
  let g:UltiSnipsExpandTrigger="<c-`>"
  Plug 'honza/vim-snippets'
  " let g:UltiSnipsExpandTrigger       = "<c-l>"
  " let g:UltiSnipsJumpForwardTrigger  = "<tab>"
  " let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
  " let g:UltiSnipsListSnippets        = "<leader><tab>"
  " let g:UltiSnipsListSnippets        = ""
  " inoremap <leader><tab> <esc>:Snippets<CR>
  " Open :UltiSnipsEdit in a vsplit
  " let g:UltiSnipsEditSplit           = "vertical"
  " let g:ycm_use_ultisnips_completer  = 1

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
  " mx  -> `x  pust the cursor on the same position after the change
  " lazyredraw -> nolazyredraw stops the cursor from flickering
  " <silent> disables showing the lazyredraw settings change in the statusline
  nmap <silent> '` :set lazyredraw<CR>mxcs'``x:set nolazyredraw<CR>
  nmap <silent> `' :set lazyredraw<CR>mxcs`'`x:set nolazyredraw<CR>
  nmap <silent> `" :set lazyredraw<CR>mxcs`"`x:set nolazyredraw<CR>
  nmap <silent> "` :set lazyredraw<CR>mxcs"``x:set nolazyredraw<CR>
  nmap <silent> '" :set lazyredraw<CR>mxcs'"`x:set nolazyredraw<CR>
  nmap <silent> "' :set lazyredraw<CR>mxcs"'`x:set nolazyredraw<CR>
  nmap <silent> "/ :set lazyredraw<CR>mxcs"/`x:set nolazyredraw<CR>
  nmap <silent> '/ :set lazyredraw<CR>mxcs'/`x:set nolazyredraw<CR>
  nmap <silent> `/ :set lazyredraw<CR>mxcs`/`x:set nolazyredraw<CR>
  nmap <silent> /" :set lazyredraw<CR>mxcs/"`x:set nolazyredraw<CR>
  nmap <silent> /' :set lazyredraw<CR>mxcs/'`x:set nolazyredraw<CR>
  nmap <silent> /` :set lazyredraw<CR>mxcs/``x:set nolazyredraw<CR>

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

  augroup python_settings
    autocmd!
    autocmd FileType python setlocal shiftwidth=4
    autocmd FileType python setlocal softtabstop=4
    autocmd FileType python setlocal expandtab
    autocmd FileType python setlocal tabstop=4
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

  " Lets you cycle through previous yanked things after pasting
  Plug 'bfredl/nvim-miniyank'
  map p <Plug>(miniyank-autoput)
  map P <Plug>(miniyank-autoPut)
  nmap <CR> <Plug>(miniyank-cycle)
  nmap <BS> <Plug>(miniyank-cycleback)

  " Syntax definitions for i3 config files
  Plug 'mboughaba/i3config.vim'
  aug i3config_ft_detection
      au!
      autocmd BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
      autocmd BufNewFile,BufRead ~/.config/sway/config set filetype=i3config
  aug end

  " Replace every occurence of your current search with content of your clipboard
  vmap <leader>s/ :s//*/<cr>
  nmap <leader>s/ :%s//*/<cr>

  let g:ale_disable_lsp = 0
  let g:ale_set_balloons = 1
  " Set to 1 to open another buffer with error information when there is any
  let g:ale_cursor_detail = 0
  " Show errors in virtualtext (neovim only)
  let g:ale_virtualtext_cursor = 1
  " Automatically Lint/Syntax Check everything asynchronously
  Plug 'dense-analysis/ale'
  let g:airline#extensions#ale#enabled = 1
  " Cycle through errors
  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
  " Configure how errors/warnings are shown in the sidebar
  let g:ale_sign_error           = ' ⚠'
  highlight ALEWarning ctermbg=Yellow
  let g:ale_sign_warning         = ' ⚠'
  highlight ALEError ctermbg=Red
  " Configure how errors/warnings are shown in the statusbar
  let g:ale_echo_msg_error_str   = 'Error'
  let g:ale_echo_msg_warning_str = 'Warning'
  let g:ale_echo_msg_format      = '%severity%: %s [%linter% - %code%]'
  " Check when getting back to normal made
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_delay           = 200
  let g:ale_fixers = {
        \ 'javascript': [ 'standard', 'eslint', ],
        \ 'typescript': [ 'tsserver', 'tslint' ],
        \ 'python': [ 'trim_whitespace', 'autopep8' ]
        \ }
  let g:ale_linters= {
        \ 'javascript': [ 'standard' ],
        \ 'typescript': [ 'tsserver', 'tslint' ],
        \ 'python': ['flake8'],
        \ 'sh': ['shell', 'shellcheck'],
        \ 'zsh': ['shell', 'shellcheck'],
        \ }
        " \ 'python': ['flake8', 'mypy'],
  let g:ale_python_flake8_options = '--ignore=E501'
  let g:ale_completion_tsserver_autoimport = 1
  " let g:ale_completion_enabled = 1
  let g:ale_typescript_tslint_config_path = '.'
  " autocmd BufRead,BufNewFile *.ts vnoremap <leader>v :ALEGoToDefinition -vsplit<cr>
  " autocmd BufRead,BufNewFile *.ts vnoremap <leader>t :ALEGoToDefinition -tab<cr>
  " autocmd BufRead,BufNewFile *.ts vnoremap <c-]>     :ALEGoToDefinition<cr>
  " autocmd BufRead,BufNewFile *.ts nnoremap <leader>v :ALEGoToDefinition -vsplit<cr>
  " autocmd BufRead,BufNewFile *.ts nnoremap <leader>t :ALEGoToDefinition -tab<cr>
  " autocmd BufRead,BufNewFile *.ts nnoremap <c-]>     :ALEGoToDefinition<cr>

  Plug 'pechorin/any-jump.vim'
  " Disable default keybinds (I kept the default below though)
  let g:any_jump_disable_default_keybindings = 1
  " Allow searching in files not under version control (for newly created files)
  let g:any_jump_disable_vcs_ignore          = 0
  " Any-jump window size & position options
  let g:any_jump_window_width_ratio          = 0.8
  let g:any_jump_window_height_ratio         = 0.8
  let g:any_jump_window_top_offset           = 4
  let g:any_jump_max_search_results          = 20
  let g:any_jump_search_prefered_engine      = 'rg'

  " Set custom ignores for different filetypes
  autocmd filetype * let g:any_jump_ignored_files = ['*.tmp', '*.temp', '*.swp']
  " Ignore definitions/references in JavaScript files while editing TypeScript
  autocmd filetype typescript call add(g:any_jump_ignored_files, '*.js')
  Plug 'delphinus/vim-firestore'

  " Jump to definition under cursor/of selection
  " Also turn colorcolumn off in the result window
  nnoremap <leader>j  :AnyJump<CR>:setlocal colorcolumn=0<CR>
  xnoremap <leader>j  :AnyJumpVisual<CR>:setlocal colorcolumn=0<CR>
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

  " Shows color codes in the color they represent (Only works in neovim)
  Plug 'norcalli/nvim-colorizer.lua'

  " Makes sure vims working directory is always the root of the project you are working on
  Plug 'airblade/vim-rooter'
  " Don't change directory if no project root is found (Default)
  let g:rooter_change_directory_for_non_project_files = ''
  let g:rooter_silent_chdir  = 1        " Don't announce when directory is changed
  let g:rooter_resolve_links = 1        " Follow symlinks
  nnoremap <leader>. :Rooter<CR>
  " Put directory of current file in command line mode
  " Useful when you want to do something in command mode relative to the current file path
  " e.g. To create a new file in the same dir as current file: `:e ,.FILENAME<Enter>`
  cnoremap <leader>. <C-R>=expand('%:p:h').'/'<cr>


  " Automatically close opening parenthesis
  " Plug 'tmsvg/pear-tree'
  " if this is 1, closing Braces will be inserted after leaving insert mode
  " This allows repeating with `.`, but automatic Linters go crazy with this,
  " so disable it...
  let g:pear_tree_repeatable_expand = 0
  " Enable Smart pairs
  let g:pear_tree_smart_openers = 0
  let g:pear_tree_smart_closers = 0
  let g:pear_tree_smart_backspace = 1
  " If enabled, smart pair functions timeout after 60ms:
  let g:pear_tree_timeout = 60

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
  \  '/'     : 'fuzzy search'
  \, '<Tab>' : 'Pick UltiSnips snippet from list'
  \, '?'     : 'fuzzy search backwards'
  \, 'g'     : {'name': 'which_key_ignore'
    \, '/'   : 'fuzzy search, but cursor stays'
    \, 'n'   : '[g]o to [n]ext changed line (according to git)'
    \, 'p'   : '[g]o to [p]revious changed line (according to git)'
    \}
  \, 'f'     : { 'name': '[f]ind Files, search in code (FZF)'
    \, 'f'   : 'find [f]ilenames in project'
    \, 'c'   : 'find [c]ode in project'
    \, 'l'   : 'find [l]ines in project'
    \}
  \, '_'     : {'name': 'TComment Stuff'  }
  \, 'c'     : {'name': '[C]oc or [c]lear [0-9] or [a]ll highlights'
    \, '#'   : '[0-9] Clear highlight of word', '0' : 'which_key_ignore'
    \, '1'   : 'which_key_ignore', '2' : 'which_key_ignore', '3' : 'which_key_ignore'
    \, '4'   : 'which_key_ignore', '5' : 'which_key_ignore', '6' : 'which_key_ignore'
    \, '7'   : 'which_key_ignore', '8' : 'which_key_ignore', '9' : 'which_key_ignore'
    \, 'g'   : [':CocConfig'     ,'[C]oc confi[g]']
    \, 'c'   : [':CocCommand'    ,'[C]oc [C]ommand']
    \, 'a'   : 'Coc Code Actions'
    \, 'e'   : [':CocList extensions'  ,'[C]oc [e]xtensions']
    \, 'm'   : [':CocList marketplace' ,'[C]oc [m]arketplace']
    \, 'o'   : [':CocList outline'     ,'[C]oc [o]utline']
    \, 'n'   : [':CocNext'     ,'[C]oc [N]ext']
    \, 'p'   : [':CocPrev'     ,'[C]oc [P]rev']
    \, 'd'   : [':CocList diagnostics' ,'[C]oc [d]iagnostics']}
  \, 'd'     : 'Show [d]iagnostics for YouCompleteMe'
  \, 'a'     : {'name': '[a]nyJump mappings'
    \, 'b'   : 'Jump [b]ack'
    \, 'i'   : [':ALEInfo' ,'[A]LE [I]nfo']
    \, 'd'   : [':ALEDetail' ,'[A]LE [D]etail']
    \, 'f'   : [':ALEFix'  ,'[A]LE [F]ix']
    \, 'l'   : 'show [l]ast search'
    \}
  \, 'j'     : 'Any[j]ump to word under cursor'
  \, 'p'     : {'name': '[p]aste stuff'
    \, '/'   : 'paste current search [/]'
    \}
  \, 'h'     : { 'name': 'which_key_ignore'
    \, 'l'   : 'toggle h[l]search'
    \}
  \, 'hl'    : [',hl',  'toggle [hl]search']
  \, 'st'    : [',st',  '[St]artify']
  \, 'ST'    : [',ST',  '[ST]artify in a vsplit']
  \, 'S'     : {'name': 'which_key_ignore'
    \, 't'   : 'Open [St]artify in a split'
    \, 'T'   : 'Open [ST]artify in a split'
    \}
  \, 's'     : { 'name': '[s]ubstitute'
    \, 't'   : 'Open S[t]artify in current buffer'
    \, 'w'   : '[s]ubstitute [w]ord under cursor in motion'
    \, '/'   : '[s]ubstitute current search [/] with last yanked text'
    \}
  \, 'r'     : {'name': 'which_key_ignore'
    \, 'g'   : 'Search in code with r[g]'
    \}
  \, 'rg'    : [',rg', 'Search in code with [rg]']
  \, 'u'     : {'name': 'which_key_ignore'}
  \, 'ut'    : [',ut', '[u]ndo[t]ree']
  \, 't'     : { "name" : "[t]abs, [t]oggle + [t]rim"
    \, 'rn'  : [',trn',  'toggle [r]elative[n]number']
    \, 'h'   : 'previous tab'
    \, 'l'   : 'next tab'
    \, 't'   : 'Toggle Hover Tooltips'
    \, 'rim' : [',trim', 't[rim] all trailing whitespace']
    \, 'r'   : {'name': 'which_key_ignore'}
    \, 'm'   : 'toggle "Mouse selection mode"'
    \ }
  \, 'w'     : { "name" : "[w]indow movement"
    \, 'h'   : 'go left'
    \, 'l'   : 'go right'
    \, 'j'   : 'go down'
    \, 'k'   : 'go up'
    \ }
  \ }

" Trim trailing whitespace
nnoremap <silent> <leader>trim  :%s/\s\+$//<cr>:let @/=''<CR>

" Spellchecking
set spelllang=de_20,en          " German and English spellchecking
set nospell                     " disable spellchecking on startup

" Sometimes using 16bit colors in vim will reset the themes set by base16.
" This function checks if base16 is used, and activates the base16 theme again.
function! s:RestoreBase16()
  if !empty($BASE16_THEME) && filereadable($BASE16_SHELL .. "/profile_helper.sh")
    :silent !eval "$("$BASE16_SHELL/profile_helper.sh")"
  endif
endfunction

" This function removes the background color from a given highlight group, so that the background is
" the same as for text. I wrote this specifically for the "NonText" highlight group that is used for
" listchars, because in many colorschemes listchars have a different background and it makes
" everything look bad...
function! s:ResetBackground(group)
  let output = execute('hi ' . a:group)
  " build a command line to execute from the current highlight setting
  let result = 'highlight! ' .. a:group .. matchstr(output, '\( \w\+=\w\+\)\+')
  " remove ctermbg and guibg from the command
  let result = substitute(result, 'ctermbg=\w\+', "", "")
  let result = substitute(result, 'guibg=\w\+', "", "")
  " Execute the line once with the backgrounds set to NONE. If I execute just the second line,
  " for some reason the background colors are still there even though the highlight command should
  " completely overwrite the setting...
  execute(result .. ' ctermbg=NONE guibg=NONE')
  execute(result)

  " Some Highlight groups are linked to other Groups (They inherit settings from a different group)
  " This gets the currently linked group. (This code probably only works for 0 or 1 linked
  " group...)
  let link = get(matchlist(output, '\( links to \(\w\+\)\)\+'), 2, 0)
  " If there is a link, create and run a command that sets the link again, because it was removed
  " by the prevous commands
  if len(link) > 1
    let linkline = 'highlight! link ' .. a:group .. " " .. link
    execute(linkline)
  endif
endfunction

" nnoremap <f9> :call <SID>ResetBackground("NonText")<CR>
augroup colorschemes
  autocmd!
  autocmd ColorScheme * call s:ResetBackground("NonText")
  autocmd ColorScheme * call s:RestoreBase16()
augroup END

lua << EOF
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = "all",

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing (for "all")
    -- ignore_install = { "javascript" },

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- list of language that will be disabled
      -- disable = { "c", "rust" },

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
EOF

" Use treesitter for folding. (Actually, don't, I like folding by indentation more...)
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" Hop config
lua << EOF
require'hop'.setup()
-- [n]ormal mode mappings. Press fX / FX to highlight all X to jump to one.
-- vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
-- vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})
-- [o]visual??? mode mappings. Press fX / FX to jump to the next X.
vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false, inclusive_jump = true })<cr>", {})
vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false, inclusive_jump = true })<cr>", {})
-- normal and visual mapping mode mappings. Press tX / TX to highlight all X to jump to one.
vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>", {})
vim.api.nvim_set_keymap('n', 'S', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = false })<cr>", {})
EOF

" Colorschemes have to be after Plugins because they aren't there before loading plugins...
set background=dark                 " Use dark background for color schemes
silent! colorscheme gruvbox
" silent! color Atelier_CaveLight

" silent! colorscheme getafe
" silent! colorscheme ayu
" silent! colorscheme monokain        " Sets Colorscheme. silent! suppresses the warning when you
                                    " start vim the first time and the scheme isn't installed yet.

" Something is setting my terminal colors, but my terminal colors work fine...
silent! unlet g:terminal_color_0
silent! unlet g:terminal_color_1
silent! unlet g:terminal_color_2
silent! unlet g:terminal_color_3
silent! unlet g:terminal_color_4
silent! unlet g:terminal_color_5
silent! unlet g:terminal_color_6
silent! unlet g:terminal_color_7
silent! unlet g:terminal_color_8
silent! unlet g:terminal_color_9
silent! unlet g:terminal_color_10
silent! unlet g:terminal_color_11
silent! unlet g:terminal_color_12
silent! unlet g:terminal_color_13
silent! unlet g:terminal_color_14
silent! unlet g:terminal_color_15

" This is here for the 'vim_current_word' plugin, this has to be done after loading a colorscheme
hi CurrentWord guifg=NONE guibg=#4C4745 gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
hi CurrentWordTwins guifg=NONE guibg=#4C4745 gui=underline ctermfg=NONE ctermbg=NONE cterm=underline

if !has('clipboard')
  echo 'VIM IS NOT COMPILED WITH +cliboard!'
else
  set clipboard=unnamed             " Use system clipboard as default register
  " If xsel is available, use it instead of xclip (default) because vim-yoink has a bug with xclip
  if executable('xsel')
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
  endif
endif

