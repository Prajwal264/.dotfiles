return {
  { lazy = true, "nvim-lua/plenary.nvim" },

  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "Neotree",
    init = function() vim.g.neo_tree_remove_legacy_commands = true end,
    opts = function()
      return {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = {
            { source = "filesystem", display_name = "File" },
            { source = "buffers", display_name = "Bufs" },
            { source = "git_status", display_name = "Git" },
            { source = "diagnostics", display_name = "Diagnostic" },
          },
        },
        default_component_configs = {
          indent = { padding = 0 },
        },
        commands = {
          system_open = function(state)
            -- TODO: just use vim.ui.open when dropping support for Neovim <0.10
            (vim.ui.open)(state.tree:get_node():get_id())
          end,
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if (node.type == "directory" or node:has_children()) and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          child_or_open = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" or node:has_children() then
              if not node:is_expanded() then -- if unexpanded, expand
                state.commands.toggle_node(state)
              else -- if expanded and has children, seleect the next child
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            else -- if not a directory just open it
              state.commands.open(state)
            end
          end,
          copy_selector = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local results = {
              e = { val = modify(filename, ":e"), msg = "Extension only" },
              f = { val = filename, msg = "Filename" },
              F = { val = modify(filename, ":r"), msg = "Filename w/o extension" },
              h = { val = modify(filepath, ":~"), msg = "Path relative to Home" },
              p = { val = modify(filepath, ":."), msg = "Path relative to CWD" },
              P = { val = filepath, msg = "Absolute path" },
            }

            local messages = {
              { "\nChoose to copy to clipboard:\n", "Normal" },
            }
            for i, result in pairs(results) do
              if result.val and result.val ~= "" then
                vim.list_extend(messages, {
                  { ("%s."):format(i), "Identifier" },
                  { (" %s: "):format(result.msg) },
                  { result.val, "String" },
                  { "\n" },
                })
              end
            end
            vim.api.nvim_echo(messages, false, {})
            local result = results[vim.fn.getcharstr()]
            if result and result.val and result.val ~= "" then
              utils.notify(("Copied: `%s`"):format(result.val))
              vim.fn.setreg("+", result.val)
            end
          end,
          find_in_dir = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            require("telescope.builtin").find_files {
              cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
            }
          end,
        },
        window = {
          width = 30,
          mappings = {
            ["<space>"] = false, -- disable space until we figure out which-key disabling
            ["[b"] = "prev_source",
            ["]b"] = "next_source",
            O = "system_open",
            Y = "copy_selector",
            h = "parent_or_close",
            l = "child_or_open",
            o = "open",
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = true
          },
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
          }
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(_) vim.opt_local.signcolumn = "auto" end,
          },
        },
      }
    end,
  },
  -- {
  --   "nvim-tree/nvim-tree.lua",
  --   cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  --   opts = {},
  -- },
  --
  {
    "nvim-tree/nvim-web-devicons",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    opts = require "plugins.configs.bufferline",
  },

  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup { set_vim_settings = false }
    end,
  },

  -- we use cmp plugin only when in insert mode
  -- so lets lazyload it at InsertEnter event, to know all the events check h-events
  -- completion , now all of these plugins are dependent on cmp, we load them after cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- cmp sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",

      --list of default snippets
      "rafamadriz/friendly-snippets",

      -- snippets engine
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },

      -- autopairs , autocompletes ()[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()

          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          local cmp = require "cmp"
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    -- made opts a function cuz cmp config calls cmp module
    -- and we lazyloaded cmp so we dont want that file to be read on startup!
    opts = function()
      return require "plugins.configs.cmp"
    end,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall" },
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },

  {
    "stevearc/conform.nvim",
    lazy = true,
    opts = require "plugins.configs.conform",
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ibl").setup {
        indent = { char = "│" },
        scope = { char = "│", highlight = "Comment" },
      }
    end,
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    opts = require "plugins.configs.telescope",
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
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
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function ()
      require("harpoon").setup()
      require("telescope").load_extension('harpoon')
    end,
  },
  {
   "folke/trouble.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
    local trouble = require("trouble");
    trouble.setup({
     icons = false,
    })

    vim.keymap.set("n", "F", function()
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
   end
  }
}
