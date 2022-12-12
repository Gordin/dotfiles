local remap = vim.keymap.set
local diagnostics = vim.diagnostic
local lsp = vim.lsp.buf

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    -- null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.jq,
    null_ls.builtins.formatting.lua_format
    -- require("null-ls").builtins.completion.spell,
  }
})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "sumneko_lua", "vimls" },
  automatic_installation = true
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
remap("n", "<leader>di", diagnostics.open_float, opts)
remap("n", "<leader>dp", diagnostics.goto_prev,  opts)
remap("n", "<c-j>",      diagnostics.goto_next,  opts)
remap("n", "<leader>dn", diagnostics.goto_next,  opts)
remap("n", "<leader>dq", diagnostics.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  local telescope = require("telescope.builtin")
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  remap("n", "gD",         lsp.declaration,                bufopts)
  remap("n", "gd",         telescope.lsp_definitions,      bufopts)
  remap("n", "gv",         function () telescope.lsp_definitions{jump_type= "vsplit"} end,      bufopts)
  remap("n", "gt",         function () telescope.lsp_definitions{jump_type= "tab"} end,      bufopts)
  remap("n", "K",          lsp.hover,                      bufopts)
  remap("n", "gi",         telescope.lsp_implementations,  bufopts)
  remap("n", "<C-k>",      lsp.signature_help,             bufopts)
  remap("n", "<leader>k",  lsp.signature_help,             bufopts)
  remap("n", "<leader>wa", lsp.add_workspace_folder,       bufopts)
  remap("n", "<leader>wr", lsp.remove_workspace_folder,    bufopts)
  remap("n", "<leader>D",  telescope.lsp_type_definitions, bufopts)
  remap("n", "<leader>rn", lsp.rename,                     bufopts)
  remap("n", "<leader>ca", lsp.code_action,                bufopts)
  remap("n", "gr",         telescope.lsp_references,       bufopts)
  remap("n", "<leader>fmt",
    function() lsp.format({ async = true }) end, bufopts)
  remap("n", "<leader>wl", function()
    print(vim.inspect(lsp.list_workspace_folders()))
  end, bufopts)
end

require("neodev").setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities()
})
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  settings = { ["rust-analyzer"] = {} },
  capabilities = capabilities
})
lspconfig.vimls.setup({
  on_attach = on_attach,
  capabilities = capabilities
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities
})

lspconfig.solargraph.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings= {
  settings = {
    solargraph = {
      diagnostics = true
    }
  }
  }
}

lspconfig.marksman.setup({
  on_attach = on_attach,
  capabilities = capabilities
})


local json_capabilities = vim.lsp.protocol.make_client_capabilities()
json_capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.jsonls
    .setup({ on_attach = on_attach, capabilities = json_capabilities })

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
table.insert(runtime_path, os.getenv("HOME") .. '/.config/nvim/lua/?.lua')
table.insert(runtime_path, os.getenv("HOME") .. '/.config/nvim/lua/?/?.lua')

lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      -- completion settings just to disable Text suggestions
      completion = {
        callSnippet = "Replace",
        workspaceWord = true,
        showWord = "Enable"
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        path = runtime_path
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" }
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        maxPreload = 5000,
        preloadFileSize = 50000,
        userThirdParty = "/home/gordin/.local/share/nvim/site/pack/packer/start"
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false }
    }
  }
})
