-- vim settings
local let = vim.g
local utils = require('utils')

-- Use python from virtualenv just for neovim
if vim.fn.filereadable('~/.config/pyenv/versions/neovim3/bin/python') then
  let.python3_host_prog = '~/.config/pyenv/versions/neovim3/bin/python'
end

-- Controls cursor blinking and shapes for gvim and neovim
vim.opt.guicursor="n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait900-blinkoff200-blinkon500-Cursor/lCursor,sm:block-blinkwait500-blinkoff200-blinkon500"

vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = false -- Line numbers relative to current line instead of absolute
vim.opt.cursorline = true      -- highlights current line
vim.opt.lazyredraw = false
vim.opt.conceallevel=2          -- Enable "conceal". Poor mans WYSIWYG. Does something different for
                                -- different languages. For example in Markdown, can show
                                -- "*ABC*" as just "ABC", but actually with a bold font or in python
                                -- "\lambda" can be shown as "λ" (with the right plugins)


vim.opt.errorbells = false

vim.opt.tabstop     = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth  = 2
vim.opt.smarttab    = true
vim.opt.expandtab   = true
vim.opt.autoindent  = true
vim.opt.matchpairs:append("<:>") -- Adds <> to list of bracket pairs you can jump between with %



vim.opt.smartindent = true

vim.opt.wrap        = true
vim.opt.textwidth   = 110   -- Automatically wrap lines after column 110
vim.opt.colorcolumn = "110" -- Show line in column 110

vim.opt.history    = 10000     -- 10000 is the max history size...
vim.opt.swapfile   = true
vim.opt.directory  = utils.home() .. '/.config/nvim/tmp/swap//'
vim.opt.backup     = true
vim.opt.backupdir  = utils.home() .. '/.config/nvim/tmp/backup//'
vim.opt.undodir    = utils.home() .. "/.config/nvim/undodir//"
vim.opt.undofile   = true
vim.opt.undolevels = 100000 -- Maximum number of undos
vim.opt.undoreload = 100000 -- Save complete files for undo on reload if it has less lines

-- Searching
vim.opt.hlsearch   = true -- Highlight searches
vim.opt.incsearch  = true -- Highlight search results while typing
vim.opt.ignorecase = true -- Search case insensitive
vim.opt.smartcase  = true -- Switch to case sensitive again when you use capital letters
vim.opt.gdefault   = true -- substitutions have the g (replace all matches on a line) flag by default.
                          -- (Add g after s/// to turn off)
vim.opt.wrapscan   = true -- Makes searches loop around to the beginning of file after the last result

-- Turn off search result highlights when you go to insert mode toggle it back on afterwards
utils.easyAutocmd("AutoHLSearch", {
  InsertEnter = { command = ":setlocal nohlsearch" },
  InsertLeave = { command = ":setlocal hlsearch"   }
})

vim.opt.termguicolors = true

vim.opt.scrolloff  = 15
vim.opt.signcolumn = "auto"
vim.opt.isfname:append("@-@")

-- Spellchecking
vim.opt.spelllang:prepend('de_20')
vim.opt.spell = false

-- Movement
vim.opt.virtualedit = 'block'  -- Allows to select beyond end of lines in block selection mode

-- Give more space for displaying messages.
vim.opt.cmdheight = 0

-- Folding
local folds = 5
vim.opt.foldnestmax=folds     -- Maximum fold level
vim.opt.foldlevelstart=folds  -- Files will not be folded on opening
vim.opt.foldmethod='indent'   -- Fold automatically based on indentation level
-- sets the actions that will open a fold when performed on a fold. See :help foldopen !
vim.opt.foldopen={'block','jump','mark','percent','quickfix','search','tag','undo'}


-- Use treesitter for folding. (Actually, don't, I like folding by indentation more...)
-- vim.opt.foldmethod='expr'
-- vim.opt.foldexpr='nvim_treesitter#foldexpr()'

-- Listchars
vim.opt.listchars = {
  -- space = '_',   -- Show spaces as _
  tab = '» ',    -- a tab should display as "»"
  trail='…',     -- show trailing spaces as "…"
  eol='¬',       -- show line breaks as "¬"
  extends = "#", -- The character to show in the last column when wrap is off and the
                 -- line continues beyond the right of the screen
  precedes = '<' -- The character to show in the first column when wrap is off and
                 -- the line continues beyond the left of the screen
}
vim.opt.list = true

-- diffs
-- Add filler lines in diffs and open diffsplit to the left
vim.opt.diffopt={'filler', 'vertical', 'closeoff'}

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")


-- Open split to the right/below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Make vim use the system clipboard for copy&pasting
vim.opt.clipboard = "unnamed"

vim.cmd[[
  let g:clipboard = {
    \   'name': 'myClipboard',
    \   'copy': {
    \      '+': ['xsel', '--nodetach', '-i', '-b'],
    \      '*': ['xsel', '--nodetach', '-i', '-p'],
    \    },
    \   'paste': {
    \      '+': ['xsel', '-o', '-b'],
    \      '*': ['xsel', '-o', '-p'],
    \   },
    \   'cache_enabled': 1,
    \ }
]]

utils.easyAutocmd("RestoreLastCursorPositionAfterOpeningFile", {
  BufReadPost = { callback = utils.return_to_last_cursor_position, }
})

utils.easyAutocmd("YankGroup", {
  TextYankPost = { callback =  vim.highlight.on_yank }
})
