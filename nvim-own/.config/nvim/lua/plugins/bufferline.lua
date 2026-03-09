return {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        options = {
            offsets = {
                { filetype = "NvimTree", text = "", padding = 1 },
            },
            separator_style = "thick",
            show_buffer_close_icons = false,
            buffer_background = "#000000",
            buffer_foreground = "#ffffff",
            sort_by = "insert_after_current",
        },
    },
    keys = {},
    lazy=false,
}
