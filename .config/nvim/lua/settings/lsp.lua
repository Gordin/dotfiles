local remap = vim.keymap.set
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase

-- Reserve space for diagnostic icons
vim.opt.signcolumn = 'yes'

local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  -- Replace these with whatever servers you want to install
  'tsserver',
  'eslint',
  'sumneko_lua',
  'vimls'
})

-- local cmp = require('cmp')
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--   -- ['<C-Space>'] = cmp.mapping.complete(),
--   -- ['<C-e>'] = cmp.mapping.abort(),
--   ['<leader>k'] = lspbuf.signature_help,
--   ['<leader>ca'] = lspbuf.code_action,
-- })

-- -- disable completion with tab
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil
--
-- -- disable confirm with Enter key
-- cmp_mappings['<CR>'] = nil

-- lsp.setup_nvim_cmp({
--   mapping = cmp_mappings
-- })

-- Pass arguments to a language server
lsp.configure('tsserver', {
  on_attach = function(client, bufnr)
    print('hello tsserver')
  end,
  settings = {
    completions = {
      completeFunctionCalls = true
    }
  }
})

-- Configure lua language server for neovim
lsp.nvim_workspace()

lsp.on_attach(function(client, bufnr)
  local bufopts = {buffer = bufnr, remap = false, silent = true}
  local telescope = require("telescope.builtin")
  local lspbuf = vim.lsp.buf

  -- remap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', bufopts)
  -- remap("n", "gD",         lspbuf.declaration,                bufopts)
  -- remap("n", "gd",         telescope.lsp_definitions,      bufopts)
  remap("n", "gv",         function () telescope.lsp_definitions{jump_type= "vsplit"} end,      bufopts)
  remap("n", "gt",         function () telescope.lsp_definitions{jump_type= "tab"} end,      bufopts)
  -- remap("n", "K",          lspbuf.hover,                      bufopts)
  -- remap("n", "gi",         telescope.lsp_implementations,  bufopts)
  -- remap("n", "<C-k>",      lspbuf.signature_help,             bufopts)
  remap("n", "<leader>k",  lspbuf.signature_help,          bufopts)
  remap("n", "<leader>wa", lspbuf.add_workspace_folder,    bufopts)
  remap("n", "<leader>wr", lspbuf.remove_workspace_folder, bufopts)
  remap("n", "<leader>D",  telescope.lsp_type_definitions, bufopts)
  remap("n", "<leader>rn", lspbuf.rename,                  bufopts)
  remap("n", "<leader>ca", lspbuf.code_action,             bufopts)
  remap("n", "gr",         telescope.lsp_references,       bufopts)
  remap("n", "<leader>fmt",
    function() lspbuf.format({ async = true }) end, bufopts)
  remap("n", "<leader>wl", function()
    print(vim.inspect(lspbuf.list_workspace_folders()))
  end, bufopts)
end)

local lspkind = require('lspkind')
lsp.setup_nvim_cmp({
  formatting = {
    -- changing the order of fields so the icon is the first
    fields = {'abbr', 'kind'},
    -- fields = {'menu', 'abbr', 'kind'},
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      -- before = function (entry, vim_item)
      --   -- ...
      --   return vim_item
      -- end
    })
  },
  sources = {
    { name = 'luasnip', option = { show_autosnippets = true }, priority = 9 },
    -- For luasnip users.
    { name = 'nvim_lua', priority = 8 },
    { name = 'nvim_lsp', priority = 8 },
    { name = 'path', priority = 8 },
    {name = 'buffer', keyword_length = 3},
  },
  documentation = {
    max_height = 15,
    max_width = 60,
    border = 'rounded',
    col_offset = 0,
    side_padding = 1,
    winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
    zindex = 1001
  }
})

lsp.setup()


-- Mappings.
local diagnostics = vim.diagnostic
diagnostics.config({
  virtual_text = true,
})

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
remap("n", "<leader>di", diagnostics.open_float, opts)
remap("n", "<leader>dp", diagnostics.goto_prev,  opts)
remap("n", "<c-j>",      diagnostics.goto_next,  opts)
remap("n", "<leader>dn", diagnostics.goto_next,  opts)
remap("n", "<leader>dq", diagnostics.setloclist, opts)
