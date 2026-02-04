return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
        local devicons = require("nvim-web-devicons")
		wk.setup({
			preset = "helix",
			default = {},
            spec = {
                { "<leader>o", icon = devicons.get_icon("import") },
                { "<leader>-", icon = devicons.get_icon("tmux.conf") },
                { "<leader>|", icon = devicons.get_icon("tmux.conf") },
                { "<leader>l", icon = "󰒲", desc = "Lazy tools" },
                { "<leader>d",  group = "Debug" },
                { "<leader>f", group = "file/find" },
                { "<leader>g", group = "git" },
                { "<leader>c", group = "code" },
                { "<leader>a", group = "ai/opencode", icon = "" },
                { "<leader>q", group = "quit" },
                { "<leader>w", group = "save", icon = devicons.get_icon("torrent") },
                {
                    "<leader>b",
                    group = "buffer",
                    expand = function()
                        return require("which-key.extras").expand.buf()
                    end,
                },
            }
        })
    end,
}
