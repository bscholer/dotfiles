local plugins = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = { enabled = true },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
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
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = false,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    opts = {
      sources = {
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("custom.plugins-null-ls")
      end,
      -- "jay-babu/mason-null-ls.nvim",
      -- event = { "BufReadPre", "BufNewFile" },
      -- dependencies = {
      --   "williamboman/mason.nvim",
      --   "jose-elias-alvarez/null-ls.nvim",
      -- },
      -- config = function()
      --   require("custom.plugins-null-ls")
      --   -- require("custom.plugins.null-ls") -- require your null-ls config here (example below)
      -- end,
    },
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.plugins-lspconfig")
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "html-lsp",
        "stylua",
        "angular-language-server",
        "typescript-language-server",
        "eslint_d",
        "eslint-lsp",
        "prettier",
        "prettierd",
        "stylelint",
        "stylelint-lsp",
      },
    },
  },
}

return plugins
