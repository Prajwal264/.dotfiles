local utils = require "astronvim.utils"
local maps = require("astronvim.utils").empty_map_table()
local vscode = require 'vscode-neovim'

vim.api.mapleader = " ";
vim.notify = vscode.notify

maps.n["<leader>s"] = { "<cmd>Write<cr>", desc = "Save File" }
maps.n["<leader>e"] = { function() vscode.call("workbench.explorer.fileView.focus") end, desc = "Focus sidebar" }
maps.n["<leader>ff"] = { function() vscode.call("workbench.action.quickOpen") end, desc = "Find Files" }
maps.n["<leader>fw"] = { function() vscode.call("workbench.action.findInFiles") end, desc = "Grep in Files" }
maps.n["<leader>gh"] = { function() vscode.call("git.revertChange") end, desc = "Git revert change" }
-- Harpoon
maps.n["<leader>hm"] = { 
  function() 
    vscode.call("vscode-harpoon.addEditor");
    vim.notify('Added file to harpoon')
  end, 
  desc = "Add file to harpoon" 
}
maps.n["<leader>hh"] = { function() vscode.call("vscode-harpoon.editorQuickPick") end, desc = "Pick from harpoon" }
maps.n["<leader>h1"] = { function() vscode.call("vscode-harpoon.gotoEditor1") end, desc = "Go to harpoon file 1" }
maps.n["<leader>h2"] = { function() vscode.call("vscode-harpoon.gotoEditor2") end, desc = "Go to harpoon file 2" }
maps.n["<leader>h3"] = { function() vscode.call("vscode-harpoon.gotoEditor1") end, desc = "Go to harpoon file 3" }
maps.n["<leader>h4"] = { function() vscode.call("vscode-harpoon.gotoEditor1") end, desc = "Go to harpoon file 4" }
maps.n["<leader>gg"] = { function() vscode.call('lazygit.openLazygit') end , desc = "Open Lazygit" }
maps.n["]b"] = { function() vscode.call('workbench.action.nextEditor') end , desc = "Next Buffer" }
maps.n["[b"] = { function() vscode.call('workbench.action.previousEditor') end , desc = "Previous Buffer" }
maps.n["<leader>/"] = { 
  function()
    vscode.action("editor.action.commentLine");
  end, 
  desc = "Toggle Comment" 
}
maps.v["<leader>/"] = { 
  function()
    vscode.action("editor.action.commentLine");
  end, 
  desc = "Toggle Comment" 
}
maps.v["<S-Tab>"] = { "<gv", desc = "Unindent line" }
maps.v["<Tab>"] = { ">gv", desc = "Indent line" }

utils.set_mappings(astronvim.user_opts("mappings", maps));
