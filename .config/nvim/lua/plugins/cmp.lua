local get_servers = require('mason-lspconfig').get_installed_servers

local cmp = require'cmp'

local types = require('cmp.types')
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-n>'] = {
      i = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
    ['<C-p>'] = {
      i = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
    },
  -- ['<C-Space>'] = cmp.mapping.complete(),
  -- ['<C-e>'] = cmp.mapping.abort(),
  -- ['<leader>k'] = lspbuf.signature_help,
  -- ['<leader>ca'] = lspbuf.code_action,
})

local lspkind = require('lspkind')
cmp.setup({
  mapping = cmp_mappings,
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
    documentation = {
      max_height = 15,
      max_width = 60,
      border = 'rounded',
      col_offset = 0,
      side_padding = 1,
      winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
      zindex = 1001
    }
  }
})
