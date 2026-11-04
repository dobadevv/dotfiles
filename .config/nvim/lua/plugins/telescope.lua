local function find_files()
	require("telescope.builtin").find_files({
		hidden = true,
		no_ignore = true,
		no_ignore_parent = true,
	})
end

local function live_grep()
	require("telescope.builtin").live_grep({
		additional_args = {
			"--hidden",
			"--no-ignore",
			"--glob", "!node_modules/**",
			"--glob", "!dist/**",
			"--glob", "!*.test.*",
			"--glob", "!*.spec.*",
			"--glob", "!pnpm-lock.yaml",
			"--glob", "!*.md",
		},
	})
end

return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.0",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	keys = {
		{ "<leader>ff", find_files, silent = true, desc = "Find files" },
		{ "<leader>fg", live_grep, silent = true, desc = "Live grep" },
		{ "<leader>gs", function() require("telescope.builtin").git_status() end, silent = true, desc = "Git status" },
		{ "<leader>gb", function() require("telescope.builtin").git_branches() end, silent = true, desc = "Git branches" },
		{ "<leader>gl", function() require("telescope.builtin").git_commits() end, silent = true, desc = "Git commits" },
		{ "<leader>ga", function() require("telescope.builtin").git_bcommits() end, silent = true, desc = "Git buffer commits" },
	},
	config = function()
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<Esc>"] = actions.close,
					},
					n = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<Esc>"] = actions.close,
					},
				},
				file_ignore_patterns = {
					"node_modules",
					".git",
					"dist",
					".next",
					"coverage",
                    ".venv",
                    "__pycache__",
                    "docs/superpowers",
                    ".superpowers",
                    "*.test.*",
                    "*.spec.*",
                    "*_test.go",
                    ".codegraph",
                    ".serena",
				},
			},
		})
	end,
}
