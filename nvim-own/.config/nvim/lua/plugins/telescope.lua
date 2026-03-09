return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
        { "<leader> ", "<cmd>Telescope find_files<cr>", desc = "find files" },  
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },  
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "live grep" },  
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "buffers" },  
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "help tags" },  
    },
}
