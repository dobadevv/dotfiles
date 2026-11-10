return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Toggles
					map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Git blames" })
				end,
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		keys = {
			{ "<leader>gv", "<CMD>DiffviewOpen<CR>", silent = true, desc = "Open diff view" },
			{ "<leader>gc", "<CMD>DiffviewClose<CR>", silent = true, desc = "Close diff view" },
			{ "<leader>gh", "<CMD>DiffviewFileHistory<CR>", silent = true, desc = "Open file history" },
			{ "<leader>gf", "<CMD>DiffviewFileHistory %<CR>", silent = true, desc = "Open current file history" },
		},
	},
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		lazy = false,
		config = true,
		keys = {
			{ "<leader>gxn", "<CMD>GitConflictNextConflict<CR>", silent = true, desc = "Move to the next conflict" },
			{ "<leader>gxp", "<CMD>GitConflictPrevConflict<CR>", silent = true, desc = "Move to the previous conflict" },
			{ "<leader>gxo", "<CMD>GitConflictChooseOurs<CR>", silent = true, desc = "Select the current changes" },
			{ "<leader>gxt", "<CMD>GitConflictChooseTheirs<CR>", silent = true, desc = "Select the incoming changes" },
			{ "<leader>gxb", "<CMD>GitConflictChooseBoth<CR>", silent = true, desc = "Select both changes" },
			{ "<leader>gxz", "<CMD>GitConflictChooseNone<CR>", silent = true, desc = "Select none of the changes" },
			{ "<leader>gxl", "<CMD>GitConflictListQf<CR>", silent = true, desc = "Get all conflict to quickfix" },
		},
	},
	{
		"harrisoncramer/gitlab.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"sindrets/diffview.nvim",
			"stevearc/dressing.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			keymaps = {
				global = {
					add_assignee = "<leader>gmaa",
					delete_assignee = "<leader>gmad",
					add_label = "<leader>gmla",
					delete_label = "<leader>gmld",
					add_reviewer = "<leader>gmra",
					delete_reviewer = "<leader>gmrd",
					approve = "<leader>gmA",
					revoke = "<leader>gmR",
					merge = "<leader>gmM",
					set_auto_merge = "<leader>gmm",
					rebase = "<leader>gmrr",
					rebase_skip_ci = "<leader>gmrs",
					rebase_force = "<leader>gmrf",
					create_mr = "<leader>gmC",
					choose_merge_request = "<leader>gmc",
					start_review = "<leader>gmS",
					reload_review = "<leader>gm<C-R>",
					close_review = "<leader>gmQ",
					summary = "<leader>gms",
					copy_mr_url = "<leader>gmu",
					open_in_browser = "<leader>gmo",
					create_note = "<leader>gmn",
					pipeline = "<leader>gmp",
					toggle_discussions = "<leader>gmd",
					toggle_draft_mode = "<leader>gmD",
					publish_all_drafts = "<leader>gmP",
				},
			},
		},
	},

	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<CMD>LazyGit<CR>", silent = true, desc = "Open LazyGit" },
		},
	},
}
