return {
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		event = "BufReadPost",
		dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		"folke/twilight.nvim",
		cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
		keys = {
			{ "<leader>tt", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
		},
		opts = {
			context = 40, -- lines kept lit when treesitter finds no enclosing block
			expand = {
				"function", "method", "function_declaration", "function_definition",
				"method_definition", "method_declaration", "arrow_function",
			},
		},
	},

	{
		"giusgad/pets.nvim",
		cmd = { "PetsNew", "PetsNewCustom", "PetsList", "PetsKill", "PetsKillAll", "PetsPauseToggle", "PetsHideToggle", "PetsSleepToggle" },
		dependencies = { "MunifTanjim/nui.nvim", "edluffy/hologram.nvim" },
		opts = {},
	},
}
