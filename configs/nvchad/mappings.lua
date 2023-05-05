local M = {}

-- In order to disable a default keymap, use
M.disabled = {
  n = {
    ["<leader>h"] = "",
    ["<C-a>"] = ""
  }
}

-- Your custom mappings
M.abc = {
  n = {
    ["<C-n>"] = { "<cmd> Telescope <CR>", "Telescope" },
    ["<C-s>"] = { ":Telescope Files <CR>", "Telescope Files" },
    ["<leader>gg"] = { ":LazyGit <CR>", "LazyGit" },
    ["<leader>zn"] = { ":TZNarrow<CR>", "TrueZen Narrow" },
    ["<leader>zf"] = { ":TZFocus<CR>", "TrueZen Focus" },
    ["<leader>zm"] = { ":TZMinimalist<CR>", "TrueZen Minimalist" },
    ["<leader>za"] = { ":TZAtaraxis<CR>", "TrueZen Ataraxis" },
    ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "Window Left" },
    ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "Window Right" },
    ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "Window Down" },
    ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "Window Up" },
  },
  v = {
    ["<leader>zn"] = { ":'<,'>TZNarrow<CR>", "TrueZen Narrow" },
  },
  i = {
    ["jj"] = { "<Esc>", "escape insert mode", opts = { nowait = true } },
  }
}

return M
