-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'akinsho/toggleterm.nvim',
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
        direction = 'float',
        close_on_exit = false,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = {
            border = 'Normal',
            background = 'Normal',
          },
        },
      }
      local keymap = vim.keymap.set
      local s_opts = { silent = true }
      keymap('t', '<esc>', [[<C-\><C-n>]], s_opts)
    end,
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('harpoon').setup()
      require('telescope').load_extension 'harpoon'

      local mark = require 'harpoon.mark'
      local ui = require 'harpoon.ui'
      local term = require 'harpoon.term'

      vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu, { desc = 'Toggles harpoon quick menu' })
      vim.keymap.set('n', '<leader>hm', function()
        mark.add_file()
        vim.notify 'Added file to harpoon'
      end, { desc = 'Adds file to harpoon' })
      vim.keymap.set('n', '<leader>hy', function()
        term.gotoTerminal(1)
      end, { desc = 'Go to terminal' })
      vim.keymap.set('n', '<leader>h>', ui.nav_next, { desc = 'Go to next file in harpoon' })
      vim.keymap.set('n', '<leader>h<', ui.nav_prev, { desc = 'Go to previous file in harpoon' })
      vim.keymap.set('n', '<leader>h1', function()
        ui.nav_file(1)
      end, { desc = 'Go to file 1' })
      vim.keymap.set('n', '<leader>h2', function()
        ui.nav_file(2)
      end, { desc = 'Go to file 2' })
      vim.keymap.set('n', '<leader>h3', function()
        ui.nav_file(3)
      end, { desc = 'Go to file 3' })
      vim.keymap.set('n', '<leader>h4', function()
        ui.nav_file(4)
      end, { desc = 'Go to file 4' })
    end,
  },
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local trouble = require 'trouble'
      trouble.setup {
        icons = false,
      }

      vim.keymap.set('n', 'F', function()
        trouble.open()
      end)

      -- vim.keymap.set("n", "[t", function()
      --  require("trouble").next({skip_groups = true, jump = true});
      -- end)
      --
      -- vim.keymap.set("n", "]t", function()
      --     require("trouble").previous({skip_groups = true, jump = true});
      -- end)
      --
    end,
  },
  {
    'lewis6991/hover.nvim',
    config = function()
      require('hover').setup {
        init = function()
          -- Require providers
          require 'hover.providers.lsp'
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          require 'hover.providers.man'
          require 'hover.providers.dictionary'
        end,
        preview_opts = {
          border = nil,
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,
      }

      -- Setup keymaps
    end,
  },
  {
    'greggh/claude-code.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      -- Set SSL certificate for Zscaler proxy
      vim.env.NODE_EXTRA_CA_CERTS = vim.fn.expand '~/.ssl/ZscalerRootCertificate.crt'

      -- Use AWS Bedrock instead of direct Anthropic API
      vim.env.CLAUDE_CODE_USE_BEDROCK = '1'
      vim.env.ANTHROPIC_MODEL = 'apac.anthropic.claude-sonnet-4-20250514-v1:0'

      require('claude-code').setup {
        window = {
          position = 'float',
          float = {
            width = '90%',
            height = '90%',
            row = 'center',
            col = 'center',
            border = 'rounded',
          },
        },
        keymaps = {
          toggle = {
            normal = '<leader>cc',
            terminal = '<leader>cc',
          },
        },
      }

      -- Hide Claude Code window on Escape in terminal mode
      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = '*claude*',
        callback = function()
          vim.keymap.set('t', '<Esc>', '<cmd>ClaudeCode<cr>', { buffer = true, nowait = true, desc = 'Hide Claude Code' })
        end,
      })
    end,
  },
}
