if &compatible
  set nocompatible
endif
syntax on

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
set scrolloff=8                     " Keep X lines around cursor visible when scrolling up/down
set showmatch                       " Highlight matching (){}[] etc. pairs
" enable true colors support if available
if exists('+termguicolors')
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
set cursorline                      " Highlight the line where the cursor is
set mousehide                       " Hide the mouse cursor while typing (works only in gvim?)

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
" and hiding everything you don't want to copy like line numbers, diff signs, line end markers,
" etc. It also toggles "paste" mode, which let's you paste stuff into vim witout it messing up the
" formatting
" (Note that this does not save the current values yet, this has to match the rest of the config...)
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

" [T]oggle [M]ouse mode
nnoremap <leader>tm :silent call ToggleMouseSelection()<CR>
" Map right mouse button to toggle mouse selection.
noremap <RightMouse> <esc>:call ToggleMouseSelection()<CR>

" ### "Mouse selection Mode" end ###

" diffs
" Add filler lines in diffs and open diffsplit to the left
set diffopt=filler,vertical
" Automatically update/fold the diff after [o]btaining or [p]utting and go to next change
nnoremap do do:diffupdate<cr>]c
nnoremap dp dp:diffupdate<cr>]c

" Special settings for gruvbox scheme
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_invert_selection='0'

set hidden                        " Allow to switch files without having saved
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

set mouse=nvi                      " Enable mouse controls
                                   " nvi means mouse is hadled by vime only whene in [n]ormal,
                                   " [v]isual and [i]nsert mode.
                                   " This allows the mouse to act like it normally would in a
                                   " Terminal when you are in `:` Command mode or if a
                                   " Command output window is open

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=10
set splitbelow                      " open vertical splits below current buffer
set splitright                      " open horizontal splits right of current buffer

" don't select the newline with $ in visual mode. This allows you to use $d in visual mode to expand
" your selection to the end of the line and delete, without pulling the next line up. Also lets you
" expand your selection to the end of line and copy without the newline with $y
vnoremap $ $h

" Indentation settings
set tabstop=4 softtabstop=4         " Show tabs as 4 spaces and make 4 spaces == <tab> for commands
set shiftwidth=4                    " Use 4 spaces when changing indentation
set smarttab                        " Makes <tab> insert `shiftwidth` amount of spaces
set expandtab                       " Put multiple spaces instead of <TAB>s
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
set noswapfile                      " Don't create swap files
set backup                          " Enable backups ...
set backupdir=~/.config/nvim/tmp/backup//   " set directory for backups
set history=10000                   " 10000 is the max history size...
if has('nvim')
  set shada=!,'100,<50,s10,h          " Some new vim 8+ session/history thing?
endif
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
nnoremap <silent><expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent><expr> k v:count == 0 ? 'gk' : 'k'
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

" Opens current file in tab. Better than `:tabe %` because that puts your cursor to line 1,
" but `:tab split` will keep the cursor position.
nnoremap <leader>te :tab split<CR>

" Folding
set foldlevelstart=1
set foldnestmax=5
set foldmethod=indent               " Fold automatically based on indentation level
" :help foldopen !
set foldopen=block,jump,mark,percent,quickfix,search,tag,undo
" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
" Easily set foldlevel to get an overview of all attributes of something
" (Anything above 3 will probably never be used)
nnoremap <leader>z1 :set foldlevel=1<CR>
nnoremap <leader>z2 :set foldlevel=2<CR>
nnoremap <leader>z3 :set foldlevel=3<CR>
nnoremap <leader>z4 :set foldlevel=4<CR>
nnoremap <leader>z5 :set foldlevel=5<CR>
nnoremap <leader>z6 :set foldlevel=6<CR>
nnoremap <leader>z7 :set foldlevel=7<CR>
nnoremap <leader>z8 :set foldlevel=8<CR>
nnoremap <leader>z9 :set foldlevel=9<CR>
nnoremap <leader>z0 :set foldlevel=0<CR>

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
autocmd BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} set filetype=markdown

" Treat JSON files like JavaScript (do I really need this? 0.o)
autocmd BufNewFile,BufRead *.json set ft=json

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
    \, {',i': ['Edit i3 config',             'e $HOME/.config/i3/config']}
    \, {',b': ['Edit yadm bootstrap script', 'e $HOME/.config/yadm/bootstrap']}
    \ ]
  let g:startify_update_oldfiles     = 1    " Update most recently used files on the fly
  let g:startify_change_to_vcs_root  = 0    " cd into root of repository if possible
  let g:startify_change_to_dir       = 1    " When opening a file or bookmark, change directory
  let g:startify_fortune_use_unicode = 1    " Use unicode symbors instead of just ASCII
  " Open Startify with ,st in current buffer or in a split with Shift
  nnoremap <silent> <leader>St :vsp<cr>:Startify<cr>
  nnoremap <silent> <leader>ST :vsp<cr>:Startify<cr>
  nnoremap <silent> <leader>st :Startify<cr>

  " Makes `vim x:10` or `:e x:10` open file `x` and jump to line 10
  " (Useful for copypasting files from stacktraces or searches
  Plug 'kopischke/vim-fetch'

  " Smooth scrolling for vim
  " Plug 'yuttie/comfortable-motion.vim'
  " Make scrolling control the cursor. (Default is just scrolling the viewport)
  " let g:comfortable_motion_scroll_down_key = "j"
  " let g:comfortable_motion_scroll_up_key = "k"
  " Configure scrolling physics
  let g:comfortable_motion_friction = 100.0
  let g:comfortable_motion_air_drag = 5.0
  let g:comfortable_motion_interval = 1000 / 60 " 60 fps scrolling
  " Smooth scrolling with mousewheel
  " noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(50)<CR>
  " noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-50)<CR>

  " adds maps to Vim help files
  " jump to ... option: o/O ,link: s/S, anchor: t/T
  " jump to selected: <enter>/<backspace>
  Plug 'dahu/vim-help'

  " When you open a new file but a file with a similar name exists Vim will ask to open that one
  Plug 'EinfachToll/DidYouMean'
  let g:dym_use_fzf = 1

  " Automatically create folders that don't exist when saving a new file
  Plug 'DataWraith/auto_mkdir'

  " Highlight ALL matching searches while typing (For regexes)
  Plug 'haya14busa/incsearch.vim'
  let g:incsearch#auto_nohlsearch = 0
  let g:incsearch#consistent_n_direction = 1
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)

  " Fuzzy search with <leader>SEARCH-KEY
  Plug 'haya14busa/incsearch-fuzzy.vim'
  map <leader>/  <Plug>(incsearch-fuzzy-/)
  map <leader>?  <Plug>(incsearch-fuzzy-?)
  map <leader>g/ <Plug>(incsearch-fuzzy-stay)

  " Pulses search results when you jump to them. Useful for very dense code
  Plug 'iamFIREcracker/vim-search-pulse'
  let g:vim_search_pulse_mode = 'pattern'
  let g:vim_search_pulse_duration = 300
  " Disable default mappings becaus we want to combine Pulse with vim-asterisk and incsearch
  let g:vim_search_pulse_disable_auto_mappings = 1
  " This is a fork. Original (seems inactive):
  " Plug 'inside/vim-search-pulse'

  " Integrate incsearch plugin with Pulse
  map n <Plug>(incsearch-nohl-n)<Plug>Pulse
  map N <Plug>(incsearch-nohl-N)<Plug>Pulse
  autocmd! User IncSearchExecute
  autocmd  User IncSearchExecute :call search_pulse#Pulse()

  " Alternative to vim-search-pulse
  " Plug 'danilamihailov/beacon.nvim'

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
  " (Turned off now)
  let g:asterisk#keeppos = 0

  " Expand/Shrink current selection around text objects
  " Default is +/_, I added v for expand and <c-v>/- for shrink
  " With this you can just press v multiple times from normal mode to get the selection you want
  Plug 'landock/vim-expand-region'
  " Adds extra text objecst to stop extending/shrinking around. No idea what those are any more...
  autocmd VimEnter * call expand_region#custom_text_objects({ 'a]' :1, 'ab' :1, 'aB' :1, 'a<' : 1 })
  vmap v     <Plug>(expand_region_expand)
  vmap -     <Plug>(expand_region_shrink)
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
  autocmd VimEnter * call TempKeywords()


  " Find stuff
  " I install fzf outside of vim anyway so I don't need the next line
  " Plug 'junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'}
  Plug 'junegunn/fzf.vim'
  Plug '~/.fzf'
  " Addon to search in the quickfix window
  Plug 'fszymanski/fzf-quickfix', {'on': 'Quickfix'}
  " Fuzy search in code in current file
  nnoremap <leader>fl :Lines<cr>
  " Fuzzy search filenames in project
  nnoremap <leader>ff :Files<cr>
  nnoremap <c-p>      :Files<cr>
  nnoremap <leader>bu :Buffers<cr>
  " Fuzzy search in code in project
  nnoremap <leader>fc :norm <leader>rg<cr>
  nnoremap <leader>rg :Rg<cr>
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


  " Allows to interactively align code (like on : as in the lines above)
  " Plug 'junegunn/vim-easy-align'
  " I forked this and added hjkl as alternatives for arrow keys
  " Pull Request here: https://github.com/junegunn/vim-easy-align/pull/138/files
  Plug 'Gordin/vim-easy-align', { 'branch': 'real_main' }
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Additional mapping to remember this plugin because = indents
  xmap <leader>= <Plug>(LiveEasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)

  " Press s and two keys to jump to the next occurence of those 2 characters together
  " Like f/t, but for two characters...
  Plug 'justinmk/vim-sneak'
  let g:sneak#s_next     = 1 " Press s/S again to jump through all targets"
  let g:sneak#label      = 1 " Put labels on possible jump target after activating
  let g:sneak#use_ic_scs = 1 " Make sneak follow ignorecase and smartcase setting

  " Syntax fire for jsonc (json as config files with comments)
  Plug 'kevinoid/vim-jsonc'
  augroup jsonc
    autocmd!
    " set filetype of the coc config file to jsonc. Comments show up as errors otherwise
    autocmd BufEnter */coc-settings.json set ft=jsonc
  augroup end


  " Adds Commands :Gdiff X to diff with other branches or add stuff to staging area in vimsplit
  " Also has :Gblame and other stuff. Can browse through everything in a git repo
  Plug 'tpope/vim-fugitive'
  " [g]it: Go to [n]ext/[p]revious change in current file
  nmap <leader>gn ]c
  nmap <leader>gp [c
  " Rhubarb extends fugitive with some stuff when `hub` in installed (Github Client)
  Plug 'tpope/vim-rhubarb'

  " Show changed lines in files under version control next to the line numbers
  if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif
  if !exists("g:signify_vcs_cmds")
    let g:signify_vcs_cmds= {}
  endif
  let g:signify_vcs_cmds['git'] = 'git diff --no-color --no-ext-diff -U0 -- %f | sed "/^ /d"'
  let g:signify_vcs_cmds['yadm'] = 'yadm diff --no-color --no-ext-diff -U1 -- %f'
  let g:signify_sign_show_count = 1

  " Only show signcolumn when there are changes or Errors to be shown
  set signcolumn=auto

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
  let g:polyglot_disabled = []

  Plug 'dart-lang/dart-vim-plugin'
  let g:dart_style_guide = 2
  let g:dart_format_on_save = 0 " Does not work....
  let dart_html_in_string=v:true
  nmap <leader>fd :!flutter dartfmt %
  " Plug 'natebosch/vim-lsc'
  " Plug 'natebosch/vim-lsc-dart'
  " let g:lsc_auto_map = v:true

  " Autocompletion with Coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Use <c-space> to trigger completion.
  " if has('nvim')
  "   inoremap <silent><expr> <c-space> coc#refresh()
  " else
  "   inoremap <silent><expr> <c-@> coc#refresh()
  " endif

  " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
  " position. Coc only does snippet and additional edit on confirm.
  " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
  " if exists('*complete_info')
  "   inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  " else
  "   inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  " endif
  let g:coc_global_extensions = [
              \  'coc-tsserver'
              \, 'coc-json'
              \, 'coc-marketplace'
              \, 'coc-python'
              \, 'coc-snippets'
              \, 'coc-ultisnips'
              \, 'coc-rust-analyzer'
              \, 'coc-rls'
              \, 'coc-vimlsp'
              \]
  " Use K to show documentation in preview window.
  " (Only needed in neovim, in vim this is always shown for stuff under the cursor)
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " nnoremap <esc> :call coc#util#float_hide()<CR>
  " nmap <esc> <Plug>(coc-float-hide)
  " nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
  " nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
  " nnoremap <leader><esc> :call popup_clear()<CR>:call coc#util#float_hide()<CR>:call coc#util#close_floats()<CR>
  " nnoremap <leader><esc> :call coc#config('suggest.floatEnable', "false")<cr>

  " autocmd User CocOpenFloat call coc#util#close_floats()

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Disable/enable completion based on languages (others are handled by YouCompleteMe)
  augroup coc
    autocmd!
    autocmd BufEnter *          call coc#config('suggest.autoTrigger', "always")
    autocmd BufEnter *          call CocMappings()
    autocmd filetype *          let b:coc_suggest_disable=0

    autocmd filetype python     let b:coc_suggest_disable=1
    autocmd BufEnter *.py       call coc#config('suggest.autoTrigger', "never")
    autocmd BufEnter *.py       call YcmMappings()

    autocmd filetype rust       let b:coc_suggest_disable=1
    autocmd BufEnter *.rs       call coc#config('suggest.autoTrigger', "never")
    autocmd BufEnter *.rs       call YcmMappings()

    autocmd filetype typescript let b:coc_suggest_disable=1
    autocmd BufEnter *.ts       call coc#config('suggest.autoTrigger', "trigger")
    autocmd BufEnter *.ts       call YcmMappings()
  augroup end

  " inoremap <silent><expr> <CR>
  "             \ UltiSnips#ExpandableExact() ? "<C-R>=UltiSnips#ExpandSnippet()<CR>":
  "             \ "\<CR>"
  inoremap <silent><expr> <TAB>
              \ pumvisible() ? "\<c-n>":
              \ "\<TAB>"
  inoremap <silent><expr> <S-TAB>
              \ pumvisible() ? "\<c-p>":
              \ "\<S-TAB>"

  " GoTo code navigation.
  nmap <Plug>(coc-definition-vsplit) :call CocAction('jumpDefinition', 'vsplit')<CR>
  nmap <Plug>(coc-definition-tabe) :call CocAction('jumpDefinition', 'tabe')<CR>
  nmap <Plug>(coc-definition-edit) :call CocAction('jumpDefinition', 'edit')<CR>
  nmap <silent> gv <Plug>(coc-definition-vsplit)
  nmap <silent> gt <Plug>(coc-definition-tabe)
  nmap <silent> gd <Plug>(coc-definition-edit)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Select `inside` and `around` function
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)

  " Refactoring stuff.
  nmap <leader>rn <Plug>(coc-rename)
  nmap <leader>coa <Plug>(coc-codeaction)
  nmap <leader>cl <Plug>(coc-codelens-action)
  nmap <leader>rf <Plug>(coc-refactor)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  fun! YcmMappings()
  endfunction

  fun! CocMappings()
  endfunction

  let g:coc_snippet_next = '<tab>'

  " YCM is nice for python, TypeScript and some other languages. You can also try coc
  Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --ts-completer --rust-completer' }
  " Change selection from list away from <Tab> so ultisnips can use it
  let g:ycm_key_list_select_completion                = ['<TAB>', '<Down>']
  let g:ycm_key_list_previous_completion              = ['<S-TAB>', '<Up>']
  let g:ycm_key_invoke_completion                     = '<C-Space>'
  let g:ycm_autoclose_preview_window_after_insertion  = 1
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_auto_hover                                = 'CursorHold'
  nmap <silent> <leader>tt <esc>:call HoverToggle()<CR><plug>(YCMHover)
  " nmap <esc> <plug>(YCMHover)
  " This toggles YCMs hover tooltips with context help
  " I'm overriding the b:ycm_hover variable because g:ycm_auto_hover seems to be read only when
  " a file is (re)loaded.
  function! HoverToggle()
    if g:ycm_auto_hover == 'CursorHold'
      let g:ycm_auto_hover = ''
      let b:ycm_hover      = { 'command': '',       'syntax': '' }
      echo "Turned Hover Tooltips Off"
    else
      let g:ycm_auto_hover = 'CursorHold'
      let b:ycm_hover      = { 'command': 'GetDoc', 'syntax': &filetype }
      echo "Turned Hover Tooltips On"
    endif
  endfunction

  " Turn off ycm on plugin specific buffers
  let g:ycm_filetype_blacklist = {
              \ 'any-jump': 1,     'fzf': 1, 'tagbar': 1,    'notes': 1,  'markdown': 1,
              \    'netrw': 1,   'unite': 1,   'text': 1,  'vimwiki': 1,    'pandoc': 1,
              \  'infolog': 1, 'leaderf': 1,   'mail': 1, 'startify': 1, 'gitcommit': 1
              \}
  " Turn off ycm for specific programming languages (to use coc instead)
  " let g:ycm_filetype_blacklist['typescript'] = 1
  " let g:ycm_filetype_blacklist['python'] = 1
  let g:ycm_filetype_blacklist['firestore'] = 1
  let g:ycm_filetype_blacklist['ruby'] = 1
  let g:ycm_filetype_blacklist['vim'] = 1
  let g:ycm_filetype_blacklist['json'] = 1
  let g:ycm_filetype_blacklist['jsonc'] = 1
  let g:ycm_filetype_blacklist['sh'] = 1
  let g:ycm_filetype_blacklist['zsh'] = 1
  let g:ycm_filetype_blacklist['dart'] = 1
  let g:ycm_filetype_blacklist['i3config'] = 1

  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  let g:UltiSnipsExpandTrigger       = "<c-l>"
  let g:UltiSnipsJumpForwardTrigger  = "<tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
  " let g:UltiSnipsListSnippets        = "<leader><tab>"
  let g:UltiSnipsListSnippets        = ""
  inoremap <leader><tab> <esc>:Snippets<CR>
  " Open :UltiSnipsEdit in a vsplit
  let g:UltiSnipsEditSplit           = "vertical"
  let g:ycm_use_ultisnips_completer  = 1

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
  if has('nvim')
    let g:yoinkSavePersistently=1       " Save history when you close vim. Needs the `shada` stuff
  endif

  " Syntax definitions for i3 config files
  Plug 'mboughaba/i3config.vim'
  aug i3config_ft_detection
      au!
      autocmd BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
      autocmd BufNewFile,BufRead ~/.config/sway/config set filetype=i3config
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

  let g:ale_disable_lsp = 1
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
  let g:ale_sign_error           = 'E>'
  let g:ale_sign_warning         = 'W>'
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
        \ 'python': ['flake8', 'mypy'],
        \ 'sh': ['shell', 'shellcheck'],
        \ 'zsh': ['shell', 'shellcheck'],
        \ }
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
  Plug 'tmsvg/pear-tree'
  " if this is 1, closing Braces will be inserted after leaving insert mode
  " This allows repeating with `.`, but automatic Linters go crazy with this,
  " so disable it...
  let g:pear_tree_repeatable_expand = 0
  " Enable Smart pairs
  let g:pear_tree_smart_openers = 1
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
  \  '#'     : '[0-9] highlight word under cursor', '0' : 'which_key_ignore'
  \, '1'     : 'which_key_ignore', '2' : 'which_key_ignore', '3' : 'which_key_ignore'
  \, '4'     : 'which_key_ignore', '5' : 'which_key_ignore', '6' : 'which_key_ignore'
  \, '7'     : 'which_key_ignore', '8' : 'which_key_ignore', '9' : 'which_key_ignore'
  \, '/'     : 'fuzzy search'
  \, '<Tab>' : 'Pick UltiSnips snippet from list'
  \, '?'     : 'fuzzy search backwards'
  \, 'g/'    : [',g/', 'fuzzy search, cursor stays'], 'g' : {'name': 'which_key_ignore'}
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
    \, 'c'   : [':CocConfig'     ,'[C]oc [C]onfig']
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

" Colorschemes have to be after Plugins because they aren't there before loading plugins...
set background=dark                 " Use dark background for color schemes
silent! colorscheme gruvbox
" silent! color Atelier_CaveLight

" silent! colorscheme getafe
" silent! colorscheme ayu
" silent! colorscheme monokain        " Sets Colorscheme. silent! suppresses the warning when you
                                    " start vim the first time and the scheme isn't installed yet.
