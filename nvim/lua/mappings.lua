local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

-- neo-tree mappings
map("n", "<leader>o", "<cmd>Neotree toggle<cr>")
map("n", "<leader>e", function()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd.wincmd "p"
  else
    vim.cmd.Neotree "focus"
  end
end)

-- telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
map("n", "<leader>gt", "<cmd> Telescope git_status <CR>")
map("n", "<leader>fc", "<cmd> Telescope colorscheme <CR>")

-- bufferline, cycle buffers
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>")
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>")
map("n", "<C-q>", "<cmd> bd <CR>")

-- comment.nvim
map("n", "<leader>/", "gcc", { remap = true })
map("v", "<leader>/", "gc", { remap = true })

-- format
map("n", "<leader>lf", function()
  require("conform").format()
end)

-- harpoon
map("n", "<leader>hh", function()
  require("harpoon.ui").toggle_quick_menu()
end)
map("n", "<leader>hm", function()
  require("harpoon.mark").add_file()
  Snacks.notify.info("File added to harpoon")
end)
map("n", "<leader>h1", function()
  require("harpoon.ui").nav_file(1)
end)
map("n", "<leader>h2", function()
  require("harpoon.ui").nav_file(2)
end)
map("n", "<leader>h3", function()
  require("harpoon.ui").nav_file(3)
end)
map("n", "<leader>h4", function()
  require("harpoon.ui").nav_file(4)
end)

-- buffers
map("n", "[b", ":bprev<CR>")
map("n", "]b", ":bnext<CR>")

local function get_nearest_function_name()
  local ts_utils = require "nvim-treesitter.ts_utils"
  local node = ts_utils.get_node_at_cursor()

  while node do
    if node:type() == "function_declaration" then
      return ts_utils.get_node_text(node:child(1))[1]
    end
    node = node:parent()
  end
end

map("n", "<leader>tf", function()
  local name = get_nearest_function_name()
  if not name then
    return
  end

  require("neotest").run.run {
    extra_args = { "-run", name },
  }
end)

-- neo tests
map("n", "<leader>tn", ':lua require("neotest").run.run()<CR>')
map("n", "<leader>tl", ':lua require("neotest").run.run_last()<CR>')
map("n", "<leader>to", ':lua require("neotest").output.open({ enter = true })<CR>')

-- Stay in indent mode
map("v", "<S-Tab>", "<gv")
map("v", "<Tab>", ">gv")

-- git signs
map("n", "]g", function()
  require("gitsigns").next_hunk()
end)
map("n", "[g", function()
  require("gitsigns").prev_hunk()
end)
map("n", "<leader>gl", function()
  require("gitsigns").blame_line()
end)
map("n", "<leader>gh", function()
  require("gitsigns").reset_hunk()
end)
map("n", "<leader>gs", function()
  require("gitsigns").stage_hunk()
end)

map("n", "<leader>s", "<cmd>w<cr>")
map("v", "<S-Up>", "<Up>")
map("v", "<S-Down>", "<Down>")
map("v", "<S-Left>", "<Left>")
map("v", "<S-Right>", "<Right>")

map("n", "L", function()
  vim.diagnostic.open_float()
end)

-- dap
map("n", "<leader>bb", ':lua require("dap").toggle_breakpoint()<CR>')
map("n", "<leader>bs", ':lua require("dap").continue()<CR>')
map("n", "<leader>bB", ':lua require("dap").clear_breakpoints()<CR>')
map("n", "<leader>E",
  function()
    vim.ui.input({ prompt = "Expression: " }, function(expr)
      if expr then require("dapui").eval(expr) end
    end)
  end
)
map("v", "E", ':lua require("dapui").eval()<CR>')
map("n", "H", ':lua require("dap.ui.widgets").hover()<CR>')
map("n", "<leader>bC", function()
  vim.ui.input({ prompt = "Condition: " }, function(condition)
    if condition then
      require("dap").set_breakpoint(condition)
    end
  end)
end)
map("n", "<leader>du", ':lua require("dapui").toggle()<CR>')
