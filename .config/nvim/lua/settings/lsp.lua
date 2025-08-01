local remap = vim.keymap.set
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
-- vim.lsp.set_log_level("debug")
-- Reserve space for diagnostic icons
vim.opt.signcolumn = 'yes'
vim.opt.completeopt = {'menu','menuone','preview','noselect'}

local lsp = require('lsp-zero')
-- lsp.preset('recommended')

-- lsp.ensure_installed({
  -- -- Replace these with whatever servers you want to install
  -- 'ts_ls',
  -- 'eslint',
  -- 'vimls',
  -- 'lua_ls'
-- })

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

local cmp = require('cmp')

local types = require('cmp.types')
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-n>'] = {
      i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
    ['<C-p>'] = {
      i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
})

local lspkind = require('lspkind')
cmp.setup({
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
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
    { name = 'path',     priority = 8 },
    { name = 'buffer',   keyword_length = 3 },
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  -- documentation = {
  --   max_height = 15,
  --   max_width = 60,
  --   border = 'rounded',
  --   col_offset = 0,
  --   side_padding = 1,
  --   winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
  --   zindex = 1001
  -- }
})

-- lsp.defaults.cmp_mappings({
--     ['<C-n>'] = {
--       i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
--     },
--     ['<C-p>'] = {
--       i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
--     },
--   -- ['<C-Space>'] = cmp.mapping.complete(),
--   -- ['<C-e>'] = cmp.mapping.abort(),
--   -- ['<leader>k'] = lspbuf.signature_help,
--   -- ['<leader>ca'] = lspbuf.code_action,
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

-- Skip eslint server, because eslint-lsp has some bug...
-- lsp.skip_server_setup({'eslint', 'ts_ls', 'solargraph'})
-- lsp.skip_server_setup({'eslint', 'ts_ls', 'shellcheck'})
-- lsp.skip_server_setup({'shellcheck'})

-- Pass arguments to a language server
-- lsp.configure('ts_ls', {
--   settings = {
--     completions = {
--       completeFunctionCalls = true
--     }
--   }
-- })

-- lsp.configure('solargraph', {
--   cmd = {'solargraph', 'stdio'},
--   settings = {
--     solargraph = {
--       autoformat       = false,
--       checkGemVersion  = true,
--       completion       = true,
--       definitions      = true,
--       diagnostics      = true,
--       folding          = true,
--       formatting       = true,
--       hover            = true,
--       logLevel         = "warn",
--       references       = true,
--       rename           = true,
--       symbols          = true,
--       useBundler       = true,
--     }
--   },
--   init_options = { formatting = true },
--   filetypes = { 'ruby' },
-- }
-- )
-- Configure lua language server for neovim
-- lsp.nvim_workspace()



local on_attach = function(client, bufnr)
  local bufopts = {buffer = bufnr, remap = false, silent = true}
  local telescope = require("telescope.builtin")
  local lspbuf = vim.lsp.buf

  -- remap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', bufopts)
  -- remap("n", "gD",         lspbuf.declaration,                bufopts)
  -- remap("n", "gd",         telescope.lsp_definitions,      bufopts)
  remap("n", "gv",         function () telescope.lsp_definitions{jump_type= "vsplit"} end,      bufopts)
  remap("n", "gt",         function () telescope.lsp_definitions{jump_type= "tab"} end,      bufopts)
  -- remap("n", "K",          lspbuf.hover,                      bufopts)
  remap("n", "gi",         function () telescope.lsp_implementations{jump_type= "vsplit"} end,  bufopts)
  -- remap("n", "<C-k>",      lspbuf.signature_help,             bufopts)
  remap("n", "<leader>k",  lspbuf.signature_help,          bufopts)
  remap("n", "<leader>wa", lspbuf.add_workspace_folder,    bufopts)
  remap("n", "<leader>wr", lspbuf.remove_workspace_folder, bufopts)
  remap("n", "<leader>d",  telescope.lsp_type_definitions, bufopts)
  -- remap("n", "<leader>rn", lspbuf.rename,                  bufopts)
  -- remap("n", "<leader>ca", lspbuf.code_action,             bufopts)
  remap("n", "gr",         telescope.lsp_references,       bufopts)
  remap("n", "<leader>fmt",
    function() lspbuf.format({ async = true }) end, bufopts)
  remap("n", "<leader>wl", function()
    print(vim.inspect(lspbuf.list_workspace_folders()))
  end, bufopts)
end

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

-- require("typescript").setup({
--     disable_commands = false, -- prevent the plugin from creating Vim commands
--     debug = false, -- enable debug logging for commands
--     go_to_source_definition = {
--         fallback = true, -- fall back to standard LSP definition on failure
--     },
--     server = { -- pass options to lspconfig's setup method
--         on_attach = on_attach
--     },
-- })

-- lsp.setup_nvim_cmp({
--   mapping = cmp_mappings,
--   formatting = {
--     -- changing the order of fields so the icon is the first
--     fields = {'abbr', 'kind'},
--     -- fields = {'menu', 'abbr', 'kind'},
--     format = lspkind.cmp_format({
--       mode = 'symbol_text', -- show only symbol annotations
--       maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
--       ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
--
--       -- The function below will be called before any actual modifications from lspkind
--       -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
--       -- before = function (entry, vim_item)
--       --   -- ...
--       --   return vim_item
--       -- end
--     })
--   },
--   sources = {
--     { name = 'luasnip', option = { show_autosnippets = true }, priority = 9 },
--     -- For luasnip users.
--     { name = 'nvim_lua', priority = 8 },
--     { name = 'nvim_lsp', priority = 8 },
--     { name = 'path',     priority = 8 },
--     { name = 'buffer',   keyword_length = 3 },
--   },
--   documentation = {
--     max_height = 15,
--     max_width = 60,
--     border = 'rounded',
--     col_offset = 0,
--     side_padding = 1,
--     winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
--     zindex = 1001
--   }
-- })

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  ensure_installed = {'lua_ls', 'rust_analyzer'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})
require("luasnip.loaders.from_vscode").lazy_load()
lsp.setup()


-- Mappings.
local diagnostics = vim.diagnostic
diagnostics.config({
  virtual_text = true,
})

local function goto_next()
  diagnostics.jump{diagnostic= diagnostics.get_next()}
end

local function goto_prev()
  diagnostics.jump{diagnostic= diagnostics.get_prev()}
end

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
remap("n", "<leader>di", diagnostics.open_float, opts)
remap("n", "<leader>dp", goto_prev,  opts)
remap("n", "<c-j>",      goto_next,  opts)
remap("n", "<leader>dn", goto_next,  opts)
remap("n", "<leader>dq", diagnostics.setloclist, opts)

require("plugins.lsp_signature")
