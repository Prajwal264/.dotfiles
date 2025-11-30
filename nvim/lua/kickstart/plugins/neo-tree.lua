-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '<leader>e',
      function()
        if vim.bo.filetype == 'neo-tree' then
          vim.cmd.wincmd 'p' -- Go to previous window (editor)
        else
          vim.cmd 'Neotree focus' -- Focus Neo-tree (opens if needed)
        end
      end,
      desc = 'Toggle focus between NeoTree and editor',
    },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
