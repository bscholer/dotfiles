vim.g.lazygit_floating_window_winblend = 0                          -- transparency of floating window
vim.g.lazygit_floating_window_scaling_factor = 0.9                  -- scaling factor for floating window
vim.g.lazygit_floating_window_corner_chars = { '╭', '╮', '╰', '╯' } -- customize lazygit popup window corner characters
vim.g.lazygit_floating_window_use_plenary = 0                       -- use plenary.nvim to manage floating window if available
vim.g.lazygit_use_neovim_remote = 1                                 -- fallback to 0 if neovim-remote is not installed

vim.g.lazygit_use_custom_config_file_path = 0                       -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = ''                                 -- custom config file path


local ok, null_ls = pcall(require, "null_ls")

if not ok then
  return
end

local sources = {
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.clang_format,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.rustfmt,
  null_ls.builtins.formatting.prettierd.with {
    filetypes = { "html", "json", "markdown", "scss", "css", "typescript" },
  },
  null_ls.builtins.diagnostics.eslint.with {
    command = "eslint_d",
  },
  null_ls.builtins.formatting.shfmt,
  null_ls.builtins.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

local M = {}
M.setup = function(on_attach)
  null_ls.config {
    sources = sources,
  }
  require("lspconfig")["null-ls"].setup { on_attach = on_attach }
end

return M
