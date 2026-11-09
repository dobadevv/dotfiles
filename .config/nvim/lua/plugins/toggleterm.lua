return {
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
}
