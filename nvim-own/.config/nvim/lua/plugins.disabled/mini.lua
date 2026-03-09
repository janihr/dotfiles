return {
  'nvim-mini/mini.nvim',
  keys = {
    {
      "<leader>fm",
      function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
      desc = "Open mini.files (directory of current file)",
    },
  },
  config = function()
    require('mini.nvim').setup({})
  end,
}


