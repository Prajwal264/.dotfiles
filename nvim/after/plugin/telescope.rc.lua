local status, telescope = pcall(require, 'telescope')

if (not status) then return end

local actions = require('telescope.actions');
local builtin = require('telescope.builtin');

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:n')
end

local fb_actions = require 'telescope'.extensions.file_browser.actions

telescope.setup({
  defaults = {
    mapping = {
      n = {
        ['q'] = actions.close,
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
vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>gc', builtin.git_commits, opts)
-- vim.keymap.set('n', '<leader>fb', builtin.file_browser, opts)
vim.keymap.set('n', '<leader>gb', builtin.git_branches, opts)
vim.keymap.set('n', '<leader>gs', builtin.git_status, opts)
vim.keymap.set('n', '<leader>fw', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>jj', builtin.jumplist, opts)
vim.keymap.set('n', '<leader>bf', builtin.jumplist, opts)
vim.keymap.set('n', '<leader>fn', '<cmd>:Telescope find_files cwd=~/.config/nvim <CR>', opts);
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
