require "nvchad.mappings"

-- add yours here (ported from AstroNvim-like layout where possible)

local map = vim.keymap.set
local function plugin_available(name)
  local ok, _ = pcall(require, name)
  return ok
end

-- Basics
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor down" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor up" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<C-s>", "<cmd>w!<cr>", { desc = "Force write" })
map("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force quit" })
map("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
map("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })

-- Plugin Manager (lazy.nvim)
map("n", "<leader>p", "<Nop>", { desc = "Packages" })
map("n", "<leader>pi", function() require("lazy").install() end, { desc = "Plugins Install" })
map("n", "<leader>ps", function() require("lazy").home() end, { desc = "Plugins Status" })
map("n", "<leader>pS", function() require("lazy").sync() end, { desc = "Plugins Sync" })
map("n", "<leader>pu", function() require("lazy").check() end, { desc = "Plugins Check Updates" })
map("n", "<leader>pU", function() require("lazy").update() end, { desc = "Plugins Update" })
-- Mason
if plugin_available("mason") then
  map("n", "<leader>pm", "<cmd>Mason<cr>", { desc = "Mason Installer" })
  map("n", "<leader>pM", "<cmd>MasonUpdateAll<cr>", { desc = "Mason Update" })
end

-- Explorer (nvim-tree)
map("n", "<leader>o", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle Explorer" })
map("n", "<leader>e", function()
  if vim.bo.filetype == "NvimTree" then
    vim.cmd.wincmd "p"
  else
    require("nvim-tree.api").tree.focus()
  end
end, { desc = "Toggle Explorer Focus" })

-- Telescope
if plugin_available("telescope") then
  map("n", "<leader>f", "<Nop>", { desc = "Find" })
  map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
  map("n", "<leader>fF", function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
    { desc = "Find all files" })
  map("n", "<leader>fo", function() require("telescope.builtin").oldfiles() end, { desc = "Find history" })
  map("n", "<leader>fw", function() require("telescope.builtin").live_grep() end, { desc = "Find words" })
  map("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", { desc = "Find themes" })
  map("n", "<leader>fk", function() require("telescope.builtin").keymaps() end, { desc = "Find keymaps" })
  map("n", "<leader>gt", function() require("telescope.builtin").git_status() end, { desc = "Git status" })
end

-- Buffers
map("n", "[b", ":bprev<CR>", { desc = "Previous buffer" })
map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>c", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "<leader>C", "<cmd>bd!<cr>", { desc = "Force close buffer" })
map("n", "<leader>b", "<Nop>", { desc = "Buffers" })
if plugin_available("bufferline") then
  map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer tab" })
  map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer tab" })
  map("n", ">b", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer tab right" })
  map("n", "<b", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer tab left" })
end

-- Tabs
map("n", "]t", function() vim.cmd.tabnext() end, { desc = "Next tab" })
map("n", "[t", function() vim.cmd.tabprevious() end, { desc = "Previous tab" })

-- Comment
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

-- Formatting
map("n", "<leader>l", "<Nop>", { desc = "LSP" })
map("n", "<leader>lf", function() require("conform").format() end, { desc = "Format buffer" })

-- LSP Navigation
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Go to definition" })
map("n", "gr", function()
  local ok, tb = pcall(require, "telescope.builtin")
  if ok then tb.lsp_references() else vim.lsp.buf.references() end
end, { desc = "Go to references" })

-- Gitsigns
if plugin_available("gitsigns") then
  map("n", "<leader>g", "<Nop>", { desc = "Git" })
  map("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next Git hunk" })
  map("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Previous Git hunk" })
  map("n", "<leader>gl", function() require("gitsigns").blame_line() end, { desc = "View Git blame" })
  map("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview Git hunk" })
  map("n", "<leader>gh", function() require("gitsigns").reset_hunk() end, { desc = "Reset Git hunk" })
  map("n", "<leader>gr", function() require("gitsigns").reset_buffer() end, { desc = "Reset Git buffer" })
  map("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage Git hunk" })
  map("n", "<leader>gS", function() require("gitsigns").stage_buffer() end, { desc = "Stage Git buffer" })
  map("n", "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Unstage Git hunk" })
  map("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "View Git diff" })
end

-- Terminal (toggleterm)
if plugin_available("toggleterm") then
  map("n", "<leader>t", "<Nop>", { desc = "Terminal" })
  map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
  map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm float" })
  map("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", { desc = "ToggleTerm horizontal" })
  map("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm vertical" })
  map("n", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
  map("t", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
end

-- Misc
map("n", "<leader>s", "<cmd>w<cr>", { desc = "Save File" })
map("v", "<S-Up>", "<Up>")
map("v", "<S-Down>", "<Down>")
map("v", "<S-Left>", "<Left>")
map("v", "<S-Right>", "<Right>")
map("n", "L", function() vim.diagnostic.open_float() end, { desc = "Line diagnostics" })

-- Harpoon (navigation between active files)
if plugin_available("harpoon") then
  map("n", "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end,
    { desc = "Toggle harpoon quick menu" })
  map("n", "<leader>hm", function() require("harpoon.mark").add_file() end,
    { desc = "Add file to harpoon" })
  map("n", "<leader>hy", function() require("harpoon.term").gotoTerminal(1) end, { desc = "Go to terminal" })
  map("n", "<leader>h>", function() require("harpoon.ui").nav_next() end, { desc = "Harpoon next file" })
  map("n", "<leader>h<", function() require("harpoon.ui").nav_prev() end, { desc = "Harpoon prev file" })
  map("n", "<leader>h1", function() require("harpoon.ui").nav_file(1) end, { desc = "Go to file 1" })
  map("n", "<leader>h2", function() require("harpoon.ui").nav_file(2) end, { desc = "Go to file 2" })
  map("n", "<leader>h3", function() require("harpoon.ui").nav_file(3) end, { desc = "Go to file 3" })
  map("n", "<leader>h4", function() require("harpoon.ui").nav_file(4) end, { desc = "Go to file 4" })
end

-- DAP
if plugin_available("dap") then
  map("n", "<leader>d", "<Nop>", { desc = "Debugger" })
  map("v", "<leader>d", "<Nop>", { desc = "Debugger" })
  map("n", "<F5>", function() require("dap").continue() end, { desc = "Debugger: Start" })
  map("n", "<leader>bb", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
  map("n", "<leader>bB", function() require("dap").clear_breakpoints() end, { desc = "Clear Breakpoints" })
  map("n", "<leader>bs", function() require("dap").continue() end, { desc = "Start/Continue" })
  map("n", "<leader>bC", function()
    vim.ui.input({ prompt = "Condition: " }, function(condition)
      if condition then require("dap").set_breakpoint(condition) end
    end)
  end, { desc = "Conditional Breakpoint" })
  map("n", "<leader>bi", function() require("dap").step_into() end, { desc = "Step Into" })
  map("n", "<leader>bn", function() require("dap").step_over() end, { desc = "Step Over" })
  map("n", "<leader>bo", function() require("dap").step_out() end, { desc = "Step Out" })
  map("n", "<leader>bq", function() require("dap").close() end, { desc = "Close Session" })
  map("n", "<leader>bQ", function() require("dap").terminate() end, { desc = "Terminate Session" })
  map("n", "<leader>bp", function() require("dap").pause() end, { desc = "Pause" })
  map("n", "<leader>br", function() require("dap").restart_frame() end, { desc = "Restart" })
  map("n", "<leader>bR", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
  map("n", "<leader>bc", function() require("dap").run_to_cursor() end, { desc = "Run To Cursor" })
  if plugin_available("dapui") then
    map("n", "<leader>E", function()
      vim.ui.input({ prompt = "Expression: " }, function(expr)
        if expr then require("dapui").eval(expr) end
      end)
    end, { desc = "Evaluate Input" })
    map("v", "E", function() require("dapui").eval() end, { desc = "Evaluate Selection" })
    map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle Debugger UI" })
    map("n", "H", function() require("dap.ui.widgets").hover() end, { desc = "Debugger Hover" })
  end
end
