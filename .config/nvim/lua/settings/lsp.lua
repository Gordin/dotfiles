local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua, null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.jq, null_ls.builtins.formatting.lua_format
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
vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev,  opts)
vim.keymap.set("n", "<c-j>",      vim.diagnostic.goto_next,  opts)
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next,  opts)
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
    bufopts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>fmt",
    function() vim.lsp.buf.format({ async = true }) end, bufopts)
end

require("neodev").setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150
}
local lspconfig = require("lspconfig")
lspconfig.jedi_language_server.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
})
lspconfig.pyright.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
})
lspconfig.tsserver.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
})
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  settings = { ["rust-analyzer"] = {} },
  capabilities = capabilities
})
lspconfig.vimls.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
})

lspconfig.solargraph.setup{
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities
}

lspconfig.marksman.setup({
  on_attach = on_attach,
  flags = lsp_flags,
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
  flags = lsp_flags,
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
