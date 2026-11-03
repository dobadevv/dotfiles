return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			integrations = {
				neotree = true,
			},
		},
	},
	{ "rose-pine/neovim", name = "rose-pine", priority = 1000 },
	{ "rebelot/kanagawa.nvim", priority = 1000 },
	{ "folke/tokyonight.nvim", priority = 1000 },
	{ "sainnhe/gruvbox-material", priority = 1000 },
	{ "sainnhe/everforest", priority = 1000 },
	{ "EdenEast/nightfox.nvim", priority = 1000 },
	{
		"zaldih/themery.nvim",
		lazy = false,
        keys = { { "<leader>ut", "<cmd>Themery<cr>", desc = "Themery" } },
		opts = {
			themes = {
                "catppuccin-mocha",
                "gruvbox-material",
				"rose-pine",
				"kanagawa",
				"tokyonight-night",
				"everforest",
				"carbonfox",
			},
			livePreview = true,
		},
	},
}
