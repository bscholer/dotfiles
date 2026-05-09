---@type ChadrcConfig
local M = {}
M.mappings = require "custom.mappings"
M.plugins = "custom.plugins"
vim.opt.ignorecase = true

-- use node from nvm if version number is specified
-- export NEOVIM_NODE_VERSION=v16.14.2
-- to verify:
--   :checkhealth
if vim.fn.has('unix') == 1 and vim.fn.empty(vim.env.NEOVIM_NODE_VERSION) == 0 then
  local node_dir = vim.env.HOME .. '/.nvm/versions/node/' .. vim.env.NEOVIM_NODE_VERSION .. '/bin/'
  if (vim.fn.isdirectory(node_dir)) then
    vim.env.PATH = node_dir .. ':' .. vim.env.PATH
  end
end

vim.g.copilot_assume_mapped = true

M.ui = { theme = 'catppuccin' }
return M
