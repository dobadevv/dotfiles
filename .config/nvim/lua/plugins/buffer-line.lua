return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	lazy = false,
	keys = {
		{ "<S-o>", "<CMD>BufferLineCloseOthers<CR>", silent = true, desc = "Close other buffer" },
	},
	config = function()
		require("bufferline").setup({
			options = {
				sort_by = "none",
			},
		})
	end,
}
