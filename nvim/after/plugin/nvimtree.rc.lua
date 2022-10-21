require("nvim-tree").setup({
  sort_by = "case_sensitive",
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = { ".git", "node_modules", ".cache", 'dist' },
  },
  actions = { open_file = {
    resize_window = true,
  }
  },
  git = {
    enable = true,
    ignore = true,
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
    custom = { ".git", "node_modules", "dist" },
    exclude = {
      'node_modules',
      'dist'
    }
  },
})
