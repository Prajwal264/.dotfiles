local status, n = pcall(require, 'tokyonight')
if (not status) then return end

n.setup({
  style = "moon"
})

vim.cmd('colorscheme tokyonight-night')
