local ok, dap = pcall(require, "dap")
if not ok then return end
local okdapui, dapui = pcall(require, "dapui")
if not okdapui then return end

vim.keymap.set("n", "<leader>ds", dap.continue)
vim.keymap.set("n", "<leader>do", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>dn", dap.step_out)
vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dr", dap.repl.open)


require("nvim-dap-virtual-text").setup({})
dapui.setup({
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
})

vim.keymap.set("n", "<leader>tr", function()
  require('nvim-tree.view').close()
  dapui.open({})
end
)

vim.keymap.set("n", "<leader>de", function(e, o)
  dapui.eval(e, o)
  dapui.eval(e, o)
end
)

dap.listeners.after.event_initialized["dapui_config"] = function()
  require('nvim-tree.view').close()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  require('nvim-tree.view').open()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  require('nvim-tree.view').open()
  dapui.close({})
end
-- local dapui = require("dapui")
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open({})
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close({})
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close({})
-- end

-- https://code.visualstudio.com/docs/nodejs/nodejs-debugging#_launch-configuration-attributes
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.api.nvim_command("au FileType dap-repl lua require('dap.ext.autocompl').attach()")

-- dap.listeners.before["event_loadedSource"]["entropitor"] = function(--[[ _session, _body ]])
-- ignore
-- end

local load_launchjs = function()
  require("dap.ext.vscode").load_launchjs()
end
if not pcall(load_launchjs) then
  vim.notify("Failed to parse launch.json", "warn")
end

require("dap-vscode-js").setup({
  log_file_level = vim.log.levels.TRACE,
  adapters = {
    "pwa-node",
    "pwa-chrome",
    "pwa-msedge",
    "node-terminal",
    "pwa-extensionHost",
  }, -- which adapters to register in nvim-dap
})

local HOME = os.getenv "HOME"
local DEBUGGER_LOCATION = HOME .. "/.local/share/nvim/vscode-chrome-debug"

-- set console for pure typescript program (e.g. cli program).
dap.defaults.fallback.external_terminal = {
  command = "/usr/bin/alacritty",
  args = { "-e" },
}
dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
dap.defaults.fallback.focus_terminal = true
dap.set_log_level("INFO")

local debugger_location = os.getenv("HOME") .. "/Software/vscode-node-debug2"

dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { DEBUGGER_LOCATION .. "/out/src/chromeDebug.js" },
}
dap.adapters.node = {
  type = "executable",
  command = "node",
  args = { debugger_location .. "/out/src/nodeDebug.js" },
}

for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
  dap.configurations[language] = {
    {
      name = "ts-node (Node2 with ts-node)",
      type = "node",
      request = "launch",
      cwd = vim.loop.cwd(),
      runtimeArgs = { "-r", "ts-node/register" },
      runtimeExecutable = "node",
      args = { "--inspect", "${file}" },
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
  }
end
