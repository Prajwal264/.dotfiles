local status, nvim_tree = pcall(require, 'nvim-tree')

if (not status) then return end


nvim_tree.setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
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
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', opts)
vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', opts)
