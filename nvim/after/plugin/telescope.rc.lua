local status, telescope = pcall(require, 'telescope')

if (not status) then return end

local actions = require('telescope.actions')

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:n')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup({
  defaults = {
    mapping = {
      n = {
        ['q'] = actions.close
      }
    }
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      hijack_netrw = true,
      mappings = {
        ['i'] = {
          ['<C-w>'] = function() vim.cmd('normal vbd') end,
        },
        ['n'] = {
          ['N'] = fb_actions.create,
          ['h'] = fb_actions.goto_parent_dir,
          ['/'] = function()
            vim.cmd('startinsert')
          end
        }
      }
    }
  }
})

-- telescope.load_extension('file_browser')

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>ff',
  '<cmd>lua require("telescope.builtin").find_files({ no_ignore = false, hidden = true})<cr>',
  opts)
vim.keymap.set('n', '<leader>gc',
  '<cmd>lua require("telescope.builtin").git_commits({ no_ignore = false, hidden = true})<cr>',
  opts)
vim.keymap.set('n', '<leader>fb',
  '<cmd>lua require("telescope.builtin").file_browser({ no_ignore = false, hidden = true})<cr>',
  opts)
vim.keymap.set('n', '<leader>gb',
  '<cmd>lua require("telescope.builtin").git_branches({ no_ignore = false, hidden = true})<cr>',
  opts)
vim.keymap.set('n', '<leader>gs',
  '<cmd>lua require("telescope.builtin").git_status({ no_ignore = false, hidden = true})<cr>',
  opts)
vim.keymap.set('n', '<leader>fw', '<cmd>lua require("telescope.builtin").live_grep()<cr>',
  opts)
vim.keymap.set('n', '<leader>jl', '<cmd>lua require("telescope.builtin").jumplist()<cr>',
  opts)
vim.keymap.set('n', '////', '<cmd>lua require("telescope.builtin").buffers()<cr>',
  opts)
vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)
