local remap = vim.keymap.set
local SILENT_NORE = { noremap = true, silent = true }
local SILENT_NORE_NOWAIT = { noremap = true, silent = true, nowait = true }

-- Put directory of current file in command line mode
-- Useful when you want to do something in command mode relative to the current file path
-- e.g. To create a new file in the same dir as current file: `:e ,.FILENAME<Enter>`
remap('c', '<leader>.', '<C-R>=expand(\'%:p:h\').\'/\'<cr>', { remap = false })

-- don't select the newline with $ in visual mode. This allows you to use $d in visual mode to expand
-- your selection to the end of the line and delete, without pulling the next line up. Also lets you
-- expand your selection to the end of line and copy without the newline with $y in visual mode
remap('v', '$', '$h', { remap = false })

-- Movement
-- Change tab with <leader>[t]ab H/L
remap('n', '<leader>th', "<CMD>tabprevious<CR>", SILENT_NORE)
remap('n', '<leader>tl', "<CMD>tabnext<CR>",     SILENT_NORE)
-- Change window with <leader>[w]indow [hjkl]
remap('n', '<leader>wh', "<c-w>h",           SILENT_NORE)
remap('n', '<leader>wl', "<c-w>l",           SILENT_NORE)
remap('n', '<leader>wj', "<c-w>j",           SILENT_NORE)
remap('n', '<leader>wk', "<c-w>k",           SILENT_NORE)
-- Change window with <c-[hjkl]> (I don't actually use this...)
-- remap('n', '<c-h>',      "<c-w>h",           SILENT_NORE)
-- remap('n', '<c-l>',      "<c-w>l",           SILENT_NORE)
-- remap('n', '<c-j>',      "<c-w>j",           SILENT_NORE)
-- remap('n', '<c-k>',      "<c-w>k",           SILENT_NORE)

-- Opens current file again in a tab. Better than `:tabe %` because that puts your cursor to line 1,
-- but `:tab split` will keep the cursor position.
remap('n', '<leader>te', '<CMD>tab split<CR>', SILENT_NORE)

-- go down or up 1 visual line on wrapped lines instead of line of file. Check the count to only
-- do this without a count. (It will jump over wrapped lines when you give a count, so it works with
-- relative numbers)
remap('n', 'j',  "v:count == 0 ? 'gj' : 'j'", { noremap = true, silent = true, expr = true })
remap('n', 'k',  "v:count == 0 ? 'gk' : 'k'", { noremap = true, silent = true, expr = true })
remap('n', 'gj', "j",                         SILENT_NORE)
remap('n', 'gk', "k",                         SILENT_NORE)

remap("n",    "<C-e>",  ":TSHighlightCapturesUnderCursor<CR>",   SILENT_NORE)

remap("c", "<leader>pr", "lua vim.pretty_print()<left>")
remap("c", "<leader>re", 'require("").<left><left><left>')

vim.cmd[[
nnoremap <f1> :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
nnoremap <f2> :echo ("hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">")<cr>
nnoremap <f3> :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>
nnoremap <f4> :exec 'syn list '.synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
]]

-- correct Qa/QA to qa in command mode...
remap('c', 'Qa', "qa", { remap = false })
remap('c', 'QA', "qa", { remap = false })

-- [t]oggle [r]elative[n]umber
remap('n', '<leader>trn', '<CMD>set relativenumber!<CR>')

-- [t]oggle [m]ouse selection mode
remap('n', '<leader>tm', '<CMD>lua require("utils").toggleMouseSelection()<CR>')

-- vim-asterisk
-- Allows to search for text in visual mode by pressing *
-- Also makes the cursor stay after pressing *
remap({'x', 'n'}, '*',  '<Plug>(asterisk-z*)<CR>',  SILENT_NORE)
remap({'x', 'n'}, '#',  '<Plug>(asterisk-z#)<CR>',  SILENT_NORE)
remap({'x', 'n'}, 'g*', '<Plug>(asterisk-gz*)<CR>', SILENT_NORE)
remap({'x', 'n'}, 'g#', '<Plug>(asterisk-gz#)<CR>', SILENT_NORE)

-- Telescope
-- remap('n', '<c-p>',   "<CMD>Telescope git_or_yadm_files<CR>",                                  SILENT_NORE)
--remap('n', '<leader>t',  "<CMD>lua require('telescope.builtin').treesitter()<CR>",                SILENT_NORE)
-- live fuzzy text search, matches filename + code (separete filename from code easily with "::" )
remap('n', '<leader>rg', '<cmd>lua require("telescope.builtin").grep_string({ search = "" })<cr>',                SILENT_NORE)
-- live fuzzy code search, but only in code
remap('n', '<leader>rc', '<cmd>lua require("telescope.builtin").grep_string({ search = "", only_sort_text = true  })<cr>', SILENT_NORE)
-- remap('n', '<leader>lg', "<cmd>lua require('telescope.builtin').live_grep()<cr>",                                 SILENT_NORE)
remap('n', '<leader>ya', "<cmd>telescope yadm_files<cr>",                                                         SILENT_NORE)
remap('n', '<leader>*',  "<cmd>lua require('telescope.builtin').grep_string()<cr>",                               SILENT_NORE)
remap('n', '<leader>b',  "<cmd>lua require('telescope.builtin').buffers()<cr>",                                   SILENT_NORE)
remap('n', '<leader>l',  "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",                 SILENT_NORE)
remap('n', '<leader>f',  "<cmd>lua require('plugins.telescope').project_files()<cr>",                             SILENT_NORE)
remap('n', '<c-p>',      "<cmd>lua require('plugins.telescope').project_files()<cr>",                             SILENT_NORE)
remap('n', '<leader>c',  "<cmd>lua require('plugins.telescope').my_git_commits()<cr>",                            SILENT_NORE)
-- remap('n', '<leader>g',  "<cmd>lua require('plugins.telescope').my_git_status()<cr>",                             SILENT_NORE)
remap('n', '<leader>rr',  "<cmd>lua require'telescope'.extensions.repo.list { file_ignore_patterns= { '/%.cache/', '/%.cargo/',                    '/%.local/', '/%.asdf/', '/%.zinit/', '/%.tmux/'}}<cr>", SILENT_NORE)
remap('n', '<leader>h',  "<cmd>lua require'telescope.builtin'.help_tags()<cr>", SILENT_NORE)
remap('n', '<leader>/',  "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find({skip_empty_lines = true})<cr>", SILENT_NORE)
remap('n', '<leader>T',  "<cmd>Telescope<cr>", SILENT_NORE)

-- Yanks current filename. I want exactly what :file shows, so I'm doing it with the file command and not with
-- expand("%")
remap('n', '<leader><c-g>', ':lua vim.fn.setreg("*", string.gmatch(vim.api.nvim_command_output("file"), \'"(.+)"\')())<CR>', SILENT_NORE)

-- lazygit
remap('n', '<leader>lg', "<cmd>LazyGit<cr>",                                 SILENT_NORE)

-- remap('n', '<leader>b', "<CMD>lua require('plugins.telescope').my_git_bcommits()<CR>", {noremap = true, silent = true})
-- remap('n', '<leader>ns', "<CMD>lua require('plugins.telescope').my_note()<CR>", {noremap = true, silent = true})
-- remap('n', '<leader>nn', "<CMD>lua NewNote()<CR>", {noremap = true, silent = false})
-- remap('n', '<leader>n', "<CMD>lua require('plugins.scratches').open_scratch_file_floating()<CR>", {noremap = true, silent = true})
-- remap('n', '<leader>gc', '<CMD>Octo issue create<CR>', {noremap = true, silent = false})
-- remap('n', '<leader>i', '<CMD>Octo issue list<CR>', {noremap = true, silent = false})
-- remap('n', '<leader>ll', "<CMD>lua require('telescope.builtin').grep_string({ search = vim.fn.input('GREP -> ') })<CR>", {noremap = true, silent = true})

-- Alpha
remap('n', '<leader>al', "<CMD>Alpha<CR>",         SILENT_NORE)
remap('n', '<leader>Al', "<CMD>vsp<CR>:Alpha<CR>", SILENT_NORE)
remap('n', '<leader>AL', "<CMD>vsp<CR>:Alpha<CR>", SILENT_NORE)

-- incsearch-fuzzy
-- remap('n', '<leader>/', '<Plug>(incsearch-fuzzy-/)')
-- remap('n', '<leader>?', '<Plug>(incsearch-fuzzy-stay/)')

-- Neoclip
remap('n', '<leader>p', "<CMD>Telescope yank_history<CR> | ",  SILENT_NORE) -- `| ` skips searching

-- vim_current_word
remap('x', '<leader>tw', "<CMD>VimCurrentWordToggle<CR>", {noremap = false, silent = true})

-- nvim-comment
remap('n', '', '<Cmd>set operatorfunc=CommentOperator<CR>g@$', {noremap = true, silent = true})
remap('x', '', ':<C-U>call CommentOperator(visualmode())<CR>', {noremap = true, silent = true})

-- Pressing I/A when in visual block mode allows to add something in front of/after the block in all
-- lines of the block. !!vim will only show the edit to current line until you leave edit mode!!
-- I just put this here as a reminder, because TComment and CoC already have visual mapping that
-- start with i/a
remap('v', 'i', 'I')
remap('v', 'a', 'A')

-- nvim-tree
remap('n', '<leader>tt', '<CMD>NvimTreeToggle<CR>', SILENT_NORE) -- [t]oggle [t]ree
remap('n', '<leader>tf', '<CMD>NvimTreeFindFile<CR>', SILENT_NORE) -- [t]oggle [t]ree
-- remap('n', '<leader>tr', '<CMD>lua require"nvim-tree".open_replacing_current_buffer()<CR>', SILENT_NORE) -- [t]oggle [t]ree

-- vim-expand-region
-- With this you can just press v multiple times from normal mode to get the selection you want
-- Adds extra text objecst to stop extending/shrinking around.
-- No idea what those are any more... :help expand_region has examples
--autocmd VimEnter * call expand_region#custom_text_objects({ 'a]' :1, 'ab' :1, 'aB' :1, 'a<' : 1 })
-- remap('v', 'v',     '<Plug>(expand_region_expand)')
-- remap('v', '-',     '<Plug>(expand_region_shrink)')
-- remap('v', '<c-v>', '<Plug>(expand_region_shrink)')


-- diffs
-- Automatically update/fold the diff after [o]btaining or [p]utting and go to next change
remap('n', 'do', 'do:diffupdate<cr>]c', SILENT_NORE)
remap('n', 'dp', 'dp:diffupdate<cr>]c', SILENT_NORE)

-- Folding
-- Make zO recursively open whatever fold we're in, even if it's partially open.
remap('n', 'zO', 'zczO')
-- Space to toggle folds.
remap({'n', 'v'}, "<Space><Space>", 'za')
-- Easily set foldlevel to get an overview of all attributes of something
-- (Anything above 3 will probably never be used)
for i=0, 9 do
  remap("n", "<leader>z"..i, "<CMD>set foldlevel=".. i .. "<CR>", SILENT_NORE)
end

-- debugging / nvim-dap
remap('n', "<leader>dt", '<CMD>lua require("dapui").toggle()<CR>',          SILENT_NORE)
remap({'n', 'i'}, '<F5>',       '<CMD>lua require"osv".launch({port = 8086})<CR>', SILENT_NORE)
remap({'n', 'i'}, '<F8>',       '<CMD>lua require"dap".toggle_breakpoint()<CR>',   SILENT_NORE)
remap({'n', 'i'}, '<S-F8>',     '<CMD>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',   SILENT_NORE)
remap({'n', 'i'}, '<S-F7>',     '<CMD>lua require"dap".clear_breakpoints()<CR>',   SILENT_NORE)
remap({'n', 'i'}, '<F9>',       '<CMD>lua require"dap".continue()<CR>',            SILENT_NORE)
remap({'n', 'i'}, '<F10>',      '<CMD>lua require"dap".step_over()<CR>',           SILENT_NORE)
remap({'n', 'i'}, '<F11>',      '<CMD>lua require"dap".step_into()<CR>',           SILENT_NORE)
remap({'n', 'i'}, '<S-F11>',    '<CMD>lua require"dap".step_out()<CR>',            SILENT_NORE)
remap({'n', 'i'}, '<F12>',      '<CMD>lua require"dap.ui.widgets".hover()<CR>',    SILENT_NORE)

-- remap('n', '<F6>',       '<CMD>Connect<CR>',            SILENT_NORE)


-- NeoRoot
-- remap('n', '<Leader>.',  function() vim.cmd('NeoRootSwitchMode') end, SILENT_NORE_NOWAIT)
-- remap('n', '<Leader>t.', function() vim.cmd('NeoRootChange') end,     SILENT_NORE_NOWAIT)

-- Surround
-- Change surrounding quotes to different ones by quickly pressing the
-- current quote and the quote type you want to change to
-- mx  -> `x  pust the cursor on the same position after the change
-- Does not work for some reason...
local surround_mappings = {"'`", "`'", '`"', '"`', [['"]], [["']], '"/', "'/", '`/',
                           '([', '[(', '[{', '({', '{(', '{[', [[':]], '":'}
for _, mapping in ipairs(surround_mappings) do
  -- The lua version doesn't work for some reason
  -- remap('n', mapping, 'mxcs' .. mapping ..'`x')
  vim.cmd([[nmap ]] .. mapping .. [[ mxcs]] .. mapping .. [[`x]])
end

local group = vim.api.nvim_create_augroup("Mappings", {})
vim.api.nvim_clear_autocmds({ group = group })

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "Help",
  command = 'noremap <CR> K',
})

-- Make q close the quickfix/command/search history window (That thing when you hit q: or q/)
vim.api.nvim_create_autocmd("CmdwinEnter", {
  group = group,
  pattern = "*",
  callback = function ()
    remap('n', 'q', '<c-c><c-c>', { buffer = true})
  end
})

vim.api.nvim_create_autocmd({"BufWinEnter", "BufEnter"}, {
  group = group,
  pattern = "quickfix",
  callback = function ()
    remap('n', 'q', '<CMD>q<CR>', { buffer = true})
  end
})

-- Makes Enter jump to stuff under cursor when looking at help files
local filetype_mapping = function(file_type, mode , lhs, rhs)
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = file_type,
    callback = function ()
      remap(mode, lhs, rhs, { buffer = true})
    end
  })
end

filetype_mapping("help", 'n', '<CR>', 'K')
filetype_mapping("help", 'n', 'q', '<CMD>q<CR>')
