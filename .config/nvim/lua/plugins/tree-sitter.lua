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
				"bash",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = { enable = true },
		})
		vim.filetype.add({
			filename = {
				[".env"] = "dotenv",
			},
			pattern = {
				["%.env%.[%w_.-]+"] = "dotenv", -- .env.local, .env.production, .env.test ...
			},
		})
		vim.treesitter.language.register("bash", "dotenv")
	end,
}
