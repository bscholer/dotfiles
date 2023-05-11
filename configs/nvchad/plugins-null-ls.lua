-- require("mason").setup()
-- require("mason-null-ls").setup({
--   ensure_installed = {
--
--     "arduino-language-server",
--
--     "bash-language-server",
--     "beautysh",
--
--     "black",
--     "cfn-lint",
--     "flake8",
--     "isort",
--     "pydocstyle",
--
--     "codespell",
--     "commitlint",
--     "editorconfig-checker",
--     "grammarly-languageserver",
--     "markdownlint",
--     "marksman",
--
--     "docker-compose-language-service",
--     "dockerfile-language-server",
--
--     "angular-language-server",
--     "typescript-language-server",
--     "eslint_d",
--     "eslint-lsp",
--     "prettier",
--     "prettierd",
--     "stylelint",
--     "stylelint-lsp",
--
--     "fixjson",
--     "json-lsp",
--     "jsonlint",
--
--     "html-lsp",
--
--     "lua-language-server",
--     "stylua",
--
--     "sql-formatter",
--
--     "xmlformatter",
--
--     "yaml-language-server",
--     "yamlfix",
--     "yamllint",
--   },
--   automatic_installation = false,
--   handlers = {},
-- })
-- require("null-ls").setup({
--   -- anything not supported by mason
-- })

local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
  formatting.prettier,
  formatting.stylua,
  formatting.beautysh,
  formatting.eslint_d,
  formatting.fixjson,

  lint.shellcheck,
}

null_ls.setup {
  debug = true,
  sources = sources,
}

-- local ok, null_ls = pcall(require, "null-ls")
--
-- if not ok then
--   return
-- end
--
-- local sources = {
--   null_ls.builtins.formatting.black,
--   null_ls.builtins.formatting.clang_format,
--   null_ls.builtins.formatting.isort,
--   null_ls.builtins.formatting.rustfmt,
--   null_ls.builtins.formatting.prettierd.with {
--     filetypes = { "html", "json", "markdown", "scss", "css", "typescript" },
--   },
--   null_ls.builtins.diagnostics.eslint.with {
--     command = "eslint_d",
--   },
--   null_ls.builtins.formatting.shfmt,
--   null_ls.builtins.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
-- }
--
-- local M = {}
-- M.setup = function(on_attach)
--   null_ls.config {
--     sources = sources,
--   }
--   require("lspconfig")["null-ls"].setup { on_attach = on_attach }
-- end
--
-- return M
