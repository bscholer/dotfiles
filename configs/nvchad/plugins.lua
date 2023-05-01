local plugins = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("custom.plugins.null-ls").setup()
    end
  },
  {
    "Pocco81/TrueZen.nvim",
    cmd = {
      "TZAtaraxis",
      "TZMinimalist",
      "TZFocus",
    },
    config = function()
      require("true-zen").setup()
    end
  },
  {
    'kdheepak/lazygit.nvim',
    lazy = false
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "angular-language-server",
        "typescript-language-server",

        "arduino-language-server",

        "bash-language-server",
        "beautysh",

        "black",
        "cfn-lint",
        "flake8",
        "isort",
        "pydocstyle",

        "codespell",
        "commitlint",
        "editorconfig-checker",
        "grammarly-languageserver",
        "markdownlint",
        "marksman",

        "docker-compose-language-service",
        "dockerfile-language-server",

        "eslint_d",
        "eslint-lsp",
        "prettier",
        "prettierd",
        "stylelint",
        "stylelint-lsp",

        "fixjson",
        "json-lsp",
        "jsonlint",

        "html-lsp",

        "lua-language-server",
        "stylua",

        "sql-formatter",

        "xmlformatter",

        "yaml-language-server",
        "yamlfix",
        "yamllint",
      },
    },
  }
}

return plugins
