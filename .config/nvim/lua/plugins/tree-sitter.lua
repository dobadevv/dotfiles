return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua",
				"javascript",
				"typescript",
				"go",
				"rust",
				"json",
				"yaml",
				"python",
				"html",
				"tsx",
				"prisma",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = { enable = true },
		})
	end,
}
