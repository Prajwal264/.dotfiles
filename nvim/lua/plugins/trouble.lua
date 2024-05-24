return {
    "folke/trouble.nvim",
    config = true,
    keys = {
      { "F", "<cmd>Trouble<cr>" },
      { "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>" },
      { "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>" },
      { "<leader>tq", "<cmd>TroubleToggle quickfix<cr>" },
      { "<leader>tl", "<cmd>TroubleToggle loclist<cr>" },
    },
}
