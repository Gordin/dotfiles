local dap, dapui = require("dap")

require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
  debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- adapters = { 'pwa-node', 'node-terminal' }, -- which adapters to register in nvim-dap
})


vim.fn.sign_define('DapBreakpoint', {text='', texthl='error', linehl='', numhl=''})
-- ADAPTERS
dap.adapters.node2 = {
  type = 'executable',
  command = 'node-debug2-adapter',
  -- args = {os.getenv('HOME') .. '/.zinit/plugins/microsoft---vscode-node-debug2.git/out/src/nodeDebug.js'},
  -- args =  { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  args = {},
}
-- dap.configurations.javascript = {
--   {
--     name = 'Launch',
--     type = 'node2',
--     request = 'launch',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     console = 'integratedTerminal',
--   },
--   {
--     -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--     name = 'Attach to process',
--     type = 'node2',
--     request = 'attach',
--     restart = true,
--     -- port = 9229
--     processId = require'dap.utils'.pick_process,
--   },
-- }
dap.adapters.ruby = {
  type = 'executable';
  command = 'bundle';
  args = {'exec', 'readapt', 'stdio'};
}

dap.configurations.ruby = {
  {
    type = 'ruby';
    request = 'launch';
    name = 'Rails';
    program = 'bundle';
    programArgs = {'exec', 'rails', 's'};
    useBundler = true;
  },
}

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end
-- dap.configurations.typescript = {
--   {
--     name = 'Debug firebase repl',
--     type = 'node2',
--     request = 'attach',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     port = 9229,
--     remoteDirectoryMapping = {
--       ["${workspaceFolder}"] = "/app/functions",
--     },
--     sourceMapPathOverrides = {
-- 			["${workspaceFolder}/src/**/*.ts"] = "${workspaceFolder}/lib/**/*.js",
--       ["*:///app/functions/node_modules/*"] = "${workspaceFolder}/node_modules/*",
--       ["*:///./~/*"] = "${workspaceFolder}/node_modules/*",
--       ["*://@?:*/?:*/*"] = "${workspaceFolder}/*",
--       ["*://?:*/*"] = "${workspaceFolder}/*",
--       ["*:///([a-z]):/(.+)"] = "${workspaceFolder}/$1:/$2",
-- 		},
--     outFiles = {"${workspaceFolder}/lib/**/*.js"},
--   }
-- }

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      name = 'Debug ' .. language .. 'node repl',
      type = 'pwa-node',
      request = 'attach',
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      port = 9229,
      remoteRoot = '/app/functions/',
      localRoot = "${workspaceFolder}",
      -- remoteDirectoryMapping = {
      --   ["${workspaceFolder}"] = "/app/functions",
      -- },
      sourceMapPathOverrides = {
        ["${workspaceFolder}"] = "/app/functions",
        ["${workspaceFolder}/src/**/*.ts"] = "${workspaceFolder}/lib/**/*.js",
        ["*:///app/functions/node_modules/*"] = "${workspaceFolder}/node_modules/*",
        ["*:///./~/*"] = "${workspaceFolder}/node_modules/*",
        ["*://@?:*/?:*/*"] = "${workspaceFolder}/*",
        ["*://?:*/*"] = "${workspaceFolder}/*",
        -- ["*:///([a-z]):/(.+)"] = "${workspaceFolder}/$1:/$2",
        -- ["${workspaceFolder}/src/**/*.ts"] = "${workspaceFolder}/lib/**/*.js",
      },
      outFiles = {"${workspaceFolder}/**/*.js"},
    }
  }
end

vim.api.nvim_create_user_command('Connect', function ()
  dap.attach({ type = 'server', host = 'localhost', port = 9229 }, dap.configurations.typescript[1], {})
end, {})

-- dap.configurations.javascript = {
--   {
--     name = 'Launch',
--     type = 'node2',
--     request = 'launch',
--     program = '${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     console = 'integratedTerminal',
--   },
--   {
--     -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--     name = 'Attach to process',
--     type = 'node2',
--     request = 'attach',
--     processId = require'dap.utils'.pick_process,
--   },
-- }
