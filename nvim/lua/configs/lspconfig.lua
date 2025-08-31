require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "javascript", "pyright", "gopls", "typescript-language-server" }
vim.lsp.enable(servers)

-- Ensure explicit setups for servers to guarantee attachment and capabilities
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"
local util = require "lspconfig.util"

local function setup_if_available(server)
  if lspconfig[server] then
    lspconfig[server].setup {
      on_attach = nvlsp.on_attach,
      capabilities = nvlsp.capabilities,
    }
  end
end

setup_if_available("html")
setup_if_available("cssls")

local function ts_root_dir(fname)
  local dir = util.find_git_ancestor(fname)
  local root = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
  return root or dir
end

if lspconfig.ts_ls then
  lspconfig.ts_ls.setup {
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
    root_dir = ts_root_dir,
    single_file_support = false,
  }
end

setup_if_available("pyright")
setup_if_available("gopls")

-- read :h vim.lsp.config for changing options of lsp servers 
