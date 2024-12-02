return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  opts = { silent = true },
  config = function()
    require('toggleterm').setup {
      size = 120,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = false,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
      },
    }
    local keymap = vim.keymap.set
    local s_opts = { silent = true }
    keymap("t", "<esc>", [[<C-\><C-n>]], s_opts)
  end
}
