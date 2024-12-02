return {
  updater = { channel = "nightly" },
  colorscheme = "catppuccin",
  plugins = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end,
    },
  },
}
