local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
  return
end

local dapui_ok, dapui = pcall(require, "dapui")
if not dapui_ok then
  return
end

-- signs & highlights (aligned with reference config)
vim.api.nvim_set_hl(0, "DapBreakpoint",           { default = true, link = "DiagnosticSignError" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition",  { default = true, link = "DiagnosticSignWarn" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected",   { default = true, link = "DiagnosticSignError" })
vim.api.nvim_set_hl(0, "DapLogPoint",             { default = true, link = "DiagnosticSignInfo" })
vim.api.nvim_set_hl(0, "DapStopped",              { default = true, link = "DiagnosticSignHint" })

vim.fn.sign_define("DapBreakpoint",          { text = "", texthl = "DapBreakpoint",          linehl = "",          numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "",          numhl = "" })
vim.fn.sign_define("DapBreakpointRejected",  { text = "", texthl = "DapBreakpointRejected",  linehl = "",          numhl = "" })
vim.fn.sign_define("DapLogPoint",            { text = "", texthl = "DapLogPoint",            linehl = "",          numhl = "" })
vim.fn.sign_define("DapStopped",             { text = "", texthl = "DapStopped",             linehl = "CursorLine", numhl = "" })

dapui.setup({})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Ensure Node/JS adapters are available (using Mason installs if present)
local function setup_node_adapters_from_mason()
  local ok_registry, mason_registry = pcall(require, "mason-registry")
  if not ok_registry then
    return
  end

  -- js-debug (pwa-node)
  local ok_js, js_pkg = pcall(mason_registry.get_package, "js-debug-adapter")
  if ok_js and js_pkg:is_installed() then
    local js_path = js_pkg:get_install_path() .. "/js-debug/src/dapDebugServer.js"
    if vim.fn.filereadable(js_path) == 1 then
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_path, "${port}" },
        },
      }
    end
  end

  -- node-debug2 (legacy)
  local ok_node2, node2_pkg = pcall(mason_registry.get_package, "node-debug2-adapter")
  if ok_node2 and node2_pkg:is_installed() then
    local node2_path = node2_pkg:get_install_path() .. "/out/src/nodeDebug.js"
    if vim.fn.filereadable(node2_path) == 1 then
      dap.adapters["node2"] = {
        type = "executable",
        command = "node",
        args = { node2_path },
      }
    end
  end

  -- Create 'node' alias if not set
  if dap.adapters.node == nil then
    dap.adapters.node = dap.adapters["pwa-node"] or dap.adapters["node2"]
  end
end

-- Load VSCode launch.json from current working directory if present
local function load_vscode_launch()
  local ok_vscode, vscode = pcall(require, "dap.ext.vscode")
  if not ok_vscode then
    return
  end

  local launch_path = vim.fn.getcwd() .. "/.vscode/launch.json"
  if vim.fn.filereadable(launch_path) == 1 then
    -- Map VSCode adapter names to Neovim filetypes so configurations are populated
    local type_map = {
      python = { "python" },
    }

    -- When application is n8n (monorepo with packages/cli), also enable Node/TS mapping
    local cwd = vim.fn.getcwd()
    if vim.fn.isdirectory(cwd .. "/packages/cli") == 1 then
      type_map.node = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      type_map["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
    end

    vscode.load_launchjs(launch_path, type_map)
  end
end

-- Auto-load on startup, dir change, and when opening Python files
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd({ "VimEnter" }, {
  group = augroup("dap_load_launch_on_start", { clear = true }),
  callback = function()
    setup_node_adapters_from_mason()
    vim.schedule(load_vscode_launch)
  end,
})

autocmd({ "DirChanged" }, {
  group = augroup("dap_load_launch_on_dirchange", { clear = true }),
  callback = function()
    setup_node_adapters_from_mason()
    vim.schedule(load_vscode_launch)
  end,
})

autocmd({ "FileType" }, {
  pattern = { "python", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  group = augroup("dap_load_launch_on_langs", { clear = true }),
  callback = function()
    setup_node_adapters_from_mason()
    load_vscode_launch()
  end,
})

-- Optional: command to manually reload launch.json
vim.api.nvim_create_user_command("DapLoadLaunch", function()
  load_vscode_launch()
end, {})


-- Default Node/JS/TS configurations (used if launch.json not present)
local dap = require("dap")

local function ensure_table(value)
  return value or {}
end

dap.configurations.javascript = ensure_table(dap.configurations.javascript)
dap.configurations.typescript = ensure_table(dap.configurations.typescript)
dap.configurations["javascriptreact"] = ensure_table(dap.configurations["javascriptreact"])
dap.configurations["typescriptreact"] = ensure_table(dap.configurations["typescriptreact"])

local node_launch_configs = {
  {
    type = "node2",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
    outFiles = { "${workspaceFolder}/**/*.js", "!**/node_modules/**" },
  },
  {
    type = "node2",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

-- Only add defaults if none were loaded from launch.json
if #dap.configurations.javascript == 0 then
  dap.configurations.javascript = node_launch_configs
end
if #dap.configurations.typescript == 0 then
  dap.configurations.typescript = node_launch_configs
end
if #dap.configurations["javascriptreact"] == 0 then
  dap.configurations["javascriptreact"] = node_launch_configs
end
if #dap.configurations["typescriptreact"] == 0 then
  dap.configurations["typescriptreact"] = node_launch_configs
end

-- Adapter aliases so VSCode launch.json entries with type = "node" work
-- Prefer pwa-node if available (js-debug), otherwise fall back to node2
if dap.adapters["pwa-node"] ~= nil and dap.adapters.node == nil then
  dap.adapters.node = dap.adapters["pwa-node"]
end
if dap.adapters.node == nil and dap.adapters.node2 ~= nil then
  dap.adapters.node = dap.adapters.node2
end

