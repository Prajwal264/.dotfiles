require("nvim-tree").setup({
  sort_by = "case_sensitive",
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  update_focused_file = {
    enable = true,
    update_cwd = false,
  },
  actions = { open_file = {
    resize_window = true,
  }
  },
  git = {
    enable = true,
    ignore = false,
  },
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "<leader>e", action = ":NvimTreeToggle" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})


local opts = { noremap = true, silent = true };


vim.keymap.set('n', '<leader>n', '<cmd>:NvimTreeToggle<CR>', opts);
