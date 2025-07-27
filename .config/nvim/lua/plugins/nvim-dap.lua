local dap, dapui = require("dap")

-- require("dap-vscode-js").setup({
--   -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--   -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
--   -- debugger_path = "~/.local/share/nvim/lazy/vscode-js-debug",
--   -- debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
--   -- debugger_path = os.getenv('HOME') .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
--   debugger_cmd = { 'node', os.getenv('HOME') .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js' },
--   -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
--   -- debugger_cmd = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/dist/src/dapDebugServer.js",
--   adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
--   -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
--   -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
--   -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
-- })


vim.fn.sign_define('DapBreakpoint', {text='', texthl='error', linehl='', numhl=''})
-- ADAPTERS
-- dap.adapters.node2 = {
--   type = 'executable',
--   command = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug/dist/src/dapDebugServer.js",
--   -- args = {os.getenv('HOME') .. '/.zinit/plugins/microsoft---vscode-node-debug2.git/out/src/nodeDebug.js'},
--   -- args =  { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
--   args = {},
-- }
-- dap.adapters.node2 = {
--   type = 'executable',
--   command = 'node-debug2-adapter',
--   -- args = {os.getenv('HOME') .. '/.zinit/plugins/microsoft---vscode-node-debug2.git/out/src/nodeDebug.js'},
--   -- args =  { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
--   args = {},
-- }
--
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

dap.adapters.python = {
  type = "executable",
  command = "python",
  args = {
    "-m",
    "debugpy.adapter",
  },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}", -- This configuration will launch the current file if used.
  },
}


dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    -- 💀 Make sure to update this path to point to your installation
    args = { os.getenv('HOME') .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', "${port}"},
  }
}


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

-- for _, language in ipairs({ "typescript", "javascript" }) do
--   require("dap").configurations[language] = {
--     {
--       type = "pwa-node",
--       request = "attach",
--       name = "Attach",
--       trace = true, -- include debugger info
--       rootPath = "${workspaceFolder}",
--       cwd = "${workspaceFolder}",
--       port = 9229,
--       remoteRoot = '/app/functions/',
--       localRoot = "${workspaceFolder}",
--     }
--   }
-- end

for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
  dap.configurations[language] = {
    {
      name = 'Attach to ' .. language .. 'node repl',
      type = 'pwa-node',
      request = 'attach',
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      address = "127.0.0.1",
      port = "9229",
      restart = true,
      remoteRoot = '/app/functions/',
      localRoot = "${workspaceFolder}",
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
      -- remoteDirectoryMapping = {
      --   ["${workspaceFolder}"] = "/app/functions",
      -- },
      -- sourceMapPathOverrides = {
      --   ["${workspaceFolder}"] = "/app/functions",
      --   ["${workspaceFolder}/src/**/*.ts"] = "${workspaceFolder}/lib/**/*.js",
      --   ["*:///app/functions/node_modules/*"] = "${workspaceFolder}/node_modules/*",
      --   ["*:///./~/*"] = "${workspaceFolder}/node_modules/*",
      --   ["*://@?:*/?:*/*"] = "${workspaceFolder}/*",
      --   ["*://?:*/*"] = "${workspaceFolder}/*",
      --   -- ["*:///([a-z]):/(.+)"] = "${workspaceFolder}/$1:/$2",
      --   -- ["${workspaceFolder}/src/**/*.ts"] = "${workspaceFolder}/lib/**/*.js",
      -- },
      outFiles = {"${workspaceFolder}/**/*.js"},
      rootPath = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    }
  }
end

vim.api.nvim_create_user_command('Connect', function ()
  -- dap.attach({ type = 'server', host = '127.0.0.1', port = 9229 }, dap.configurations.typescript[1], {})
  dap.attach({ type = 'server', host = '127.0.0.1', port = 9229 }, dap.configurations.typescript[1], {})
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
