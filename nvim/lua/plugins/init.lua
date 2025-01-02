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
    init = function()
      vim.g.neo_tree_remove_legacy_commands = true
    end,
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
            enabled = true,
          },
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
          },
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(_)
              vim.opt_local.signcolumn = "auto"
            end,
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
      require("toggleterm").setup {
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
    end,
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("harpoon").setup()
      require("telescope").load_extension "harpoon"
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local trouble = require "trouble"
      trouble.setup {}

      local keymap = vim.keymap.set
      keymap("n", "F", function()
        trouble.open()
      end)

      -- vim.keymap.set("n", "[t", function()
      --  require("trouble").next({skip_groups = true, jump = true});
      -- end)
      --
      -- vim.keymap.set("n", "]t", function()
      --     require("trouble").previous({skip_groups = true, jump = true}):
      -- end)
      --
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- bigfile = { enabled = true },
      -- dashboard = { enabled = true },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      -- quickfile = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
      -- lazygit = {
      --   -- automatically configure lazygit to use the current colorscheme
      --   -- and integrate edit with the current neovim instance
      --   configure = true,
      --   -- extra configuration for lazygit that will be merged with the default
      --   -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
      --   -- you need to double quote it: `"\"test\""`
      --   config = {
      --     os = { editPreset = "nvim-remote" },
      --     gui = {
      --       -- set to an empty string "" to disable icons
      --       nerdFontsVersion = "3",
      --     },
      --   },
      --   theme_path = vim.fs.normalize("~/.config/lazygit/colors.yml"),
      --   -- Theme for lazygit
      --   -- theme = {
      --   --   [241] = { fg = "Special" },
      --   --   activeBorderColor = { fg = "MatchParen", bold = true },
      --   --   cherryPickedCommitBgColor = { fg = "Identifier" },
      --   --   cherryPickedCommitFgColor = { fg = "Function" },
      --   --   defaultFgColor = { fg = "Normal" },
      --   --   inactiveBorderColor = { fg = "FloatBorder" },
      --   --   optionsTextColor = { fg = "Function" },
      --   --   searchingActiveBorderColor = { fg = "MatchParen", bold = true },
      --   --   selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
      --   --   unstagedChangesColor = { fg = "DiagnosticError" },
      --   -- },
      --   win = {
      --     style = "lazygit",
      --   },
      -- },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
    },
    keys = {
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      -- {
      --   "<leader>gg",
      --   function()
      --     Snacks.lazygit()
      --   end,
      --   desc = "Lazygit",
      -- },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      -- {
      --   "<c-\\>",
      --   function()
      --     Snacks.terminal()
      --   end,
      --   desc = "Toggle Terminal",
      -- },
      {
        "]]",
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
          Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
          Snacks.toggle.diagnostics():map "<leader>ud"
          Snacks.toggle.line_number():map "<leader>ul"
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map "<leader>uc"
          Snacks.toggle.treesitter():map "<leader>uT"
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
          Snacks.toggle.inlay_hints():map "<leader>uh"
          Snacks.toggle.indent():map "<leader>ug"
          Snacks.toggle.dim():map "<leader>uD"
        end,
      })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig" },
    keys = {
      {
        "<leader>gg",
        function()
          local cmd = [[lua require"lazygit".lazygit(nil)]]
          vim.api.nvim_command(cmd)

          vim.cmd "stopinsert"
          vim.cmd [[execute "normal i"]]
          vim.fn.feedkeys "j"
          vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", "<Esc>", { noremap = true, silent = true })
        end,
        silent = true,
        desc = "LazyGit",
        mode = "n",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability: omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    -- dev = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      { "nvim-neotest/neotest-plenary" },
      "nvim-neotest/neotest-go",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("neotest").setup {
        log_level = vim.log.levels.TRACE,
        adapters = {
          require "neotest-go",
        },
      }
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
      "mxsdev/nvim-dap-vscode-js",
      "leoluz/nvim-dap-go"
    },
    opts = {
      automatic_installation = { "delve" },
      handlers = {
        function(config)
          local dapgo = require('dap-go')
          dapgo.setup()
          -- JS
          require('dap-vscode-js').setup({
            node_path = 'ts-node',
            debugger_path = os.getenv('HOME') .. '/.DAP/vscode-js-debug',
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
          })
          require("dap").configurations = {
           go = {
              {
                type = 'go';
                name = 'Debug';
                request = 'launch';
                showLog = false;
                program = "${workspaceFolder}/main.go";
                dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
              },
            },
            -- delve = {
            --   {
            --     type = "delve",
            --     name = "Main Debug",
            --     request = "launch",
            --     program = "${workspaceFolder}/main.go",
            --   },
            -- },
            typescript = {
              {
                type = 'pwa-node',
                request = "launch",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
                name = "ts-node-dev",
                restart = true,
                runtimeExecutable = "tsnd",
                skipFiles = {
                  "<node_internals>/**"
                },
                runtimeArgs = {"--respawn"},
                args = {"${workspaceFolder}/src/index.ts"},
                resolveSourceMapLocations = {
                    "${workspaceFolder}/dist/**/*.js",
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
              },
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
                outFiles = { "${workspaceFolder}/dist/**/*.js" },
                runtimeExecutable = "ts-node",
                skipFiles = { "<node_internals>/**", "node_modules/**" },
                resolveSourceMapLocations = {
                    "${workspaceFolder}/dist/**/*.js",
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
              },
              {
                type = "pwa-node",
                request = "launch",
                name = "Launch microservices",
                program = "${file}",
                arg = { '--exec','ts-node', '-r', 'dotenv/config', './src/index.ts' },
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                protocol = "inspector",
                console = "integratedTerminal",
                outFiles = { "${workspaceFolder}/dist/**/*.js" },
                runtimeExecutable = "nodemon",
                skipFiles = { "<node_internals>/**", "node_modules/**" },
                resolveSourceMapLocations = {
                    "${workspaceFolder}/dist/**/*.js",
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
              },
            },
            {
              name = "Current TS File",
              type = "pwa-node",
              request = "launch",
              args = {"${relativeFile}"},
              runtimeArgs ={"--nolazy", "-r", "ts-node/register"},
              sourceMaps = true,
              cwd = "${workspaceRoot}",
              protocol = "inspector",
              resolveSourceMapLocations = {
                "${workspaceFolder}/dist/**/*.js",
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              },
            }
          }
        end,
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
