return {
    "declancm/cinnamon.nvim",
    version = "*",
    lazy = false,
    opts = {
        keymaps = {
            basic = true,
            extra = true,
        },
        options = {
            mode = "cursor",
            delay = 5,
            step_size = {
                vertical = 1,
                horizontal = 2,
            },
            max_delta = {
                line = false,
                column = false,
                time = 1000,
            },
        },
    },
    config = function(_, opts)
        local cinnamon = require("cinnamon")
        cinnamon.setup(opts)
        -- Set after setup so they override cinnamon's own "extra" <C-e>/<C-y> keymaps
        vim.keymap.set("n", "<C-e>", function() cinnamon.scroll("5<C-e>") end, { silent = true, desc = "Smooth scroll down 5 lines" })
        vim.keymap.set("n", "<C-y>", function() cinnamon.scroll("5<C-y>") end, { silent = true, desc = "Smooth scroll up 5 lines" })
    end,
    keys = {
        { '<c-d>', '<cmd>lua require("cinnamon").scroll("<C-d>zz")<cr>', mode = 'n', },
        { '<c-u>', '<cmd>lua require("cinnamon").scroll("<C-u>zz")<cr>', mode = 'n', },
        { '<c-f>', '<cmd>lua require("cinnamon").scroll("<C-f>zz")<cr>', mode = 'n', },
        { '<c-b>', '<cmd>lua require("cinnamon").scroll("<C-b>zz")<cr>', mode = 'n', },
        { 'zz',    '<cmd>lua require("cinnamon").scroll("zz")<cr>',      mode = 'n', },
        { 'zt',    '<cmd>lua require("cinnamon").scroll("zt")<cr>',      mode = 'n', },
        { 'zb',    '<cmd>lua require("cinnamon").scroll("zb")<cr>',      mode = 'n', },
        { 'gg',    '<cmd>lua require("cinnamon").scroll("gg")<cr>',      mode = 'n', },
        { 'G',    '<cmd>lua require("cinnamon").scroll("G")<cr>',      mode = 'n', },
    }
}
