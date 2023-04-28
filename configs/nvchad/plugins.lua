local plugins = {
  -- ... other plugins ...

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
  }
 --  {
 --  "neovim/nvim-lspconfig",
 --
 --   dependencies = {
 --     "jose-elias-alvarez/null-ls.nvim",
 --     config = function()
 --       require "custom.configs.null-ls"
 --     end,
 --   },
 -- 
 --   config = function()
 --      require "plugins.configs.lspconfig"
 --      require "custom.configs.lspconfig"
 --   end,
 --  }

  -- ... other plugins ...

}

return plugins
