return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mxsdev/nvim-dap-vscode-js",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
      }
    },
    keys = {
      -- normal mode is default
      { "<leader>db", function() require 'dap'.toggle_breakpoint() end },
      { "<leader>dc", function() require 'dap'.continue() end },
      { "<leader>dC", function() require 'dap'.run_to_cursor() end },
      { "<leader>dt", function() require 'dap'.terminate() end },
      { "<F5>",     function() require 'dap'.step_over() end },
      { "<F6>",     function() require 'dap'.step_into() end },
      { "<F7>",     function() require 'dap'.step_out() end },
    },
    config = function()
      -- git clone https://github.com/microsoft/vscode-js-debug ~/.DAP/vscode-js-debug --depth=1
      -- cd ~/.DAP/vscode-js-debug
      -- npm install --legacy-peer-deps
      -- npm run compile

      require('dap-vscode-js').setup({
        node_path = 'ts-node',
        debugger_path = os.getenv('HOME') .. '/.DAP/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })
      require("dap").configurations = {
        typescript = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
            outFiles = { "${workspaceFolder}/dist/**/*.js" },
            runtimeExecutable = "ts-node",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = {
                "${workspaceFolder}/dist/**/*.js",
                "${workspaceFolder}/**",
                "!**/node_modules/**",
            },
          }
        }
      }

      -- for i, ext in ipairs(exts) do
      --   require("dap").configurations[ext] = {
      --     {
      --       type = 'pwa-node',
      --       request = 'launch',
      --       name = 'Launch Current File (pwa-node)',
      --       cwd = vim.fn.getcwd(),
      --       args = { '${file}' },
      --       sourceMaps = true,
      --       protocol = 'inspector',
      --     },
      --     {
      --       type = 'pwa-node',
      --       request = 'launch',
      --       name = 'Launch Current File (pwa-node with ts-node)',
      --       cwd = vim.fn.getcwd(),
      --       runtimeArgs = { '--loader', 'ts-node/esm' },
      --       runtimeExecutable = 'node',
      --       args = { '${file}' },
      --       sourceMaps = true,
      --       protocol = 'inspector',
      --       skipFiles = { '<node_internals>/**', 'node_modules/**' },
      --       resolveSourceMapLocations = {
      --         "${workspaceFolder}/**",
      --         "!**/node_modules/**",
      --       },
      --     },
      --     {
      --       type = 'pwa-node',
      --       request = 'launch',
      --       name = 'Launch Current File (pwa-node with deno)',
      --       cwd = vim.fn.getcwd(),
      --       runtimeArgs = { 'run', '--inspect-brk', '--allow-all', '${file}' },
      --       runtimeExecutable = 'deno',
      --       attachSimplePort = 9229,
      --     },
      --     {
      --       type = 'pwa-node',
      --       request = 'launch',
      --       name = 'Launch Test Current File (pwa-node with jest)',
      --       cwd = vim.fn.getcwd(),
      --       runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
      --       runtimeExecutable = 'node',
      --       args = { '${file}', '--coverage', 'false'},
      --       rootPath = '${workspaceFolder}',
      --       sourceMaps = true,
      --       console = 'integratedTerminal',
      --       internalConsoleOptions = 'neverOpen',
      --       skipFiles = { '<node_internals>/**', 'node_modules/**' },
      --     },
      --     {
      --       type = 'pwa-node',
      --       request = 'launch',
      --       name = 'Launch Test Current File (pwa-node with vitest)',
      --       cwd = vim.fn.getcwd(),
      --       program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
      --       args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
      --       autoAttachChildProcesses = true,
      --       smartStep = true,
      --       console = 'integratedTerminal',
      --       skipFiles = { '<node_internals>/**', 'node_modules/**' },
      --     },
      --     {
      --       type = 'pwa-node',
      --       request = 'launch',
      --       name = 'Launch Test Current File (pwa-node with deno)',
      --       cwd = vim.fn.getcwd(),
      --       runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
      --       runtimeExecutable = 'deno',
      --       attachSimplePort = 9229,
      --     },
      --     {
      --       type = 'pwa-chrome',
      --       request = 'attach',
      --       name = 'Attach Program (pwa-chrome = { port: 9222 })',
      --       program = '${file}',
      --       cwd = vim.fn.getcwd(),
      --       sourceMaps = true,
      --       port = 9222,
      --       webRoot = '${workspaceFolder}',
      --     },
      --     {
      --       type = 'node2',
      --       request = 'attach',
      --       name = 'Attach Program (Node2)',
      --       processId = require('dap.utils').pick_process,
      --     },
      --     {
      --       type = 'node2',
      --       request = 'attach',
      --       name = 'Attach Program (Node2 with ts-node)',
      --       cwd = vim.fn.getcwd(),
      --       sourceMaps = true,
      --       skipFiles = { '<node_internals>/**' },
      --       port = 9229,
      --     },
      --     {
      --       type = 'pwa-node',
      --       request = 'attach',
      --       name = 'Attach Program (pwa-node)',
      --       cwd = vim.fn.getcwd(),
      --       processId = require('dap.utils').pick_process,
      --       skipFiles = { '<node_internals>/**' },
      --     },
      --   }
      -- end
      --
      -- for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
      --   require("dap").configurations[language] = {
      --     -- attach to a node process that has been started with
      --     -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
      --     -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
      --     {
      --       -- use nvim-dap-vscode-js's pwa-node debug adapter
      --       type = "pwa-node",
      --       -- attach to an already running node process with --inspect flag
      --       -- default port: 9222
      --       request = "attach",
      --       -- allows us to pick the process using a picker
      --       processId = require 'dap.utils'.pick_process,
      --       -- name of the debug action you have to select for this config
      --       name = "Attach debugger to existing `node --inspect` process",
      --       -- for compiled languages like TypeScript or Svelte.js
      --       sourceMaps = true,
      --       -- resolve source maps in nested locations while ignoring node_modules
      --       resolveSourceMapLocations = {
      --         "${workspaceFolder}/**",
      --         "!**/node_modules/**" },
      --       -- path to src in vite based projects (and most other projects as well)
      --       cwd = "${workspaceFolder}/src",
      --       -- we don't want to debug code inside node_modules, so skip it!
      --       skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
      --     },
      --     {
      --       type = "pwa-chrome",
      --       name = "Launch Chrome to debug client",
      --       request = "launch",
      --       url = "http://localhost:5173",
      --       sourceMaps = true,
      --       protocol = "inspector",
      --       port = 9222,
      --       webRoot = "${workspaceFolder}/src",
      --       -- skip files from vite's hmr
      --       skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
      --     },
      --     -- only if language is javascript, offer this debug action
      --     language == "javascript" and {
      --       -- use nvim-dap-vscode-js's pwa-node debug adapter
      --       type = "pwa-node",
      --       -- launch a new process to attach the debugger to
      --       request = "launch",
      --       -- name of the debug action you have to select for this config
      --       name = "Launch file in new node process",
      --       -- launch current file
      --       program = "${file}",
      --       cwd = "${workspaceFolder}",
      --     } or nil,
      --   }
      -- end
      --
      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
      end
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
    end
  }
}
