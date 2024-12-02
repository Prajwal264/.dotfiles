return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig" },
  keys = {
    {
      "<leader>gg",
      function()
        local cmd = [[lua require"lazygit".lazygit(nil)]]
        vim.api.nvim_command(cmd)

        vim.cmd('stopinsert')
        vim.cmd([[execute "normal i"]])
        vim.fn.feedkeys('j')
        vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', '<Esc>', {noremap = true, silent = true})
      end,
      silent = true,
      desc = "LazyGit", 
      mode = "n"
    },
  },
}

