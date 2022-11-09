local ok, harpoon = pcall(require, "harpoon")
if not ok then return end

local _, harpoonMark = pcall(require, "harpoon.mark")
if not ok then return end

local _, harpoonUi = pcall(require, "harpoon.ui")
if not ok then return end

vim.keymap.set("n", "<leader>a", harpoonMark.toggle_file)
vim.keymap.set("n", "<leader>>", harpoonUi.nav_next)
vim.keymap.set("n", "<leader><", harpoonUi.nav_prev)
vim.keymap.set("n", "<leader>m", harpoonUi.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function()
  harpoonUi.nav_file(1)
end
)

vim.keymap.set("n", "<leader>2", function()
  harpoonUi.nav_file(2)
end
)

vim.keymap.set("n", "<leader>3", function()
  harpoonUi.nav_file(3)
end
)
vim.keymap.set("n", "<leader>4", function()
  harpoonUi.nav_file(4)
end
)

harpoon.setup({})
