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
	{
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
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"DaikyXendo/nvim-material-icon",
		},
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<CR>", silent = true, desc = "Toggle file explorer" },
		},
		config = function()
			require("neo-tree").setup({
				window = {
					position = "right",
					mappings = {
						-- Map "Y" to copy the filename to the system clipboard register (+)
						["Y"] = function(state)
							local node = state.tree:get_node()
							local absolute_path = node:get_id()
							-- Convert the absolute path into a path relative to the current working directory
							local relative_path = vim.fn.fnamemodify(absolute_path, ":.")

							vim.fn.setreg("+", relative_path)
							vim.notify("Copied relative path: " .. relative_path)
						end,
					},
				},
				event_handlers = {
					{
						event = "file_open_requested",
						handler = function()
							require("neo-tree.command").execute({ action = "close" })
						end,
					},
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_by_name = {
							".git",
							"dist",
						},
					},
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
				},
			})
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			mode = {
				search = {
					enabled = true,
				},
	            char = {
	                jump_labels = true
	            }
			},
		},
		keys = {
		  { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		  { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		  { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
		  { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		  { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},

	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}
