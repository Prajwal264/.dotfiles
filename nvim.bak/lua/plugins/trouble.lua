return {
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
