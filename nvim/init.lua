if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

if vim.g.vscode then
  -- VSCode extension
  for _, source in ipairs {
    "astronvim.bootstrap",
    "astronvim.options",
    "vscode.mappings"
  } do
    local status_ok, fault = pcall(require, source)
    if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
  end
else
  -- ordinary Neovim
  for _, source in ipairs {
    "astronvim.bootstrap",
    "astronvim.options",
    "astronvim.lazy",
    "astronvim.autocmds",
    "astronvim.mappings",
  } do
    local status_ok, fault = pcall(require, source)
    if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
  end

  if astronvim.default_colorscheme then
    if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
      require("astronvim.utils").notify(
        ("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
        vim.log.levels.ERROR
      )
    end
  end

  vim.api.nvim_exec(
    [[
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  ]] ,
    false
  )
  vim.opt.fixendofline = false
  require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)
end 