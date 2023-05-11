local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = {
  "html",
  "angularls",
  "eslint",
  "stylelint_lsp",
  "cssls",
  "bashls",
  "clangd",
  "tsserver",
  "pyright",
  "jsonls"
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
