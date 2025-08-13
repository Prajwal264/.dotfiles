require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local luv = vim.uv or vim.loop -- TODO: REMOVE WHEN DROPPING SUPPORT FOR Neovim v0.9

autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = augroup("highlightyank", { clear = true }),
  pattern = "*",
  callback = function() vim.highlight.on_yank() end,
})

-- open nvim-tree on launch
autocmd("VimEnter", {
  desc = "Open NvimTree on startup",
  group = augroup("open_nvimtree_on_startup", { clear = true }),
  callback = function()
    vim.schedule(function()
      local ok_lazy, lazy = pcall(require, "lazy")
      if ok_lazy then
        pcall(lazy.load, { plugins = { "nvim-tree.lua" } })
      end

      local ok_api, api = pcall(require, "nvim-tree.api")
      if ok_api then
        pcall(api.tree.open)
      else
        pcall(vim.cmd, "NvimTreeOpen")
      end
    end)
  end,
})

