return {
  "stevearc/oil.nvim",
  keys = {
    { "<leader>e", "<cmd>Oil --float<CR>", desc = "Oil explorer" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 5,
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
