return {
	{
		"folke/lazy.nvim",
		-- lazy.nvim ignores `keys` on its own spec, so map them in init
		init = function()
			vim.keymap.set("n", "<leader>ll", "<CMD>Lazy<CR>", { silent = true, desc = "Open LazyVim" })
			vim.keymap.set("n", "<leader>ls", "<cmd>LazySql<CR>", { silent = true, desc = "Toggle LazySql" })
		end,
	},

	{
		"mgierada/lazydocker.nvim",
		dependencies = { "akinsho/toggleterm.nvim" },
		config = function()
			require("lazydocker").setup({
				border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
				width = 0.9, -- width of the floating window (0-1 for percentage, >1 for absolute columns)
				height = 0.9, -- height of the floating window (0-1 for percentage, >1 for absolute rows)
			})
		end,
		event = "BufRead",
		keys = {
			{
				"<leader>ld",
				function()
					require("lazydocker").open()
				end,
				desc = "Open Lazydocker floating window",
			},
		},
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "TermExec" },
		keys = {
			{ "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal float" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal horizontal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "Terminal vertical" },
		},
		opts = {
			direction = "float",
			float_opts = { border = "curved" },
		},
	},

	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({})
		end,
	},
}
