local get_icon = require("astronvim.utils").get_icon
return {
  "dinhhuy258/git.nvim",
  enabled = vim.fn.executable "git" == 1,
  event = "User AstroGitFile",
  opts = function()
    require('git').setup({
      keymaps = {
        -- Open blame window
        blame = "<leader>gb",
        -- Close blame window
        quit_blame = "q",
        -- Open blame commit
        blame_commit = "<CR>",
        -- Open file/folder in git repository
        browse = "<leader>go",
        -- Open pull request of the current branch
        open_pull_request = "<leader>gp",
        -- Create a pull request with the target branch is set in the `target_branch` option
        create_pull_request = "<leader>gn",
        -- Opens a new diff that compares against the current index
        diff = "<leader>gd",
        -- Close git diff
        diff_close = "<leader>gD",
        -- Revert to the specific commit
        revert = "<leader>gr",
        -- Revert the current file to the specific commit
        revert_file = "<leader>gR",
      },
      -- Default target branch when create a pull request
      target_branch = "master",
      -- Private gitlab hosts, if you use a private gitlab, put your private gitlab host here
      -- private_gitlabs = { "https://git.u-next.com" },
      -- Enable winbar in all windows created by this plugin
      winbar = false,
    })
    return {
      signs = {
        add = { text = get_icon "GitSign" },
        change = { text = get_icon "GitSign" },
        delete = { text = get_icon "GitSign" },
        topdelete = { text = get_icon "GitSign" },
        changedelete = { text = get_icon "GitSign" },
        untracked = { text = get_icon "GitSign" },
      },
      worktrees = vim.g.git_worktrees,
    };
  end;
};
