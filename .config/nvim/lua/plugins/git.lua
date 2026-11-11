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
		init = function()
			-- Claude Code's dark-theme diff palette
			local function set_claude_diff_colors()
				vim.api.nvim_set_hl(0, "ClaudeDiffAdded", { bg = "#225c2b" })
				vim.api.nvim_set_hl(0, "ClaudeDiffAddedDim", { bg = "#47584a" })
				vim.api.nvim_set_hl(0, "ClaudeDiffAddedWord", { bg = "#38a660" })
				vim.api.nvim_set_hl(0, "ClaudeDiffRemoved", { bg = "#7a2936" })
				vim.api.nvim_set_hl(0, "ClaudeDiffRemovedDim", { bg = "#69484d" })
				vim.api.nvim_set_hl(0, "ClaudeDiffRemovedWord", { bg = "#b3596b" })
				vim.api.nvim_set_hl(0, "ClaudeDiffFiller", { fg = "#45475a" })
			end
			set_claude_diff_colors()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_claude_diff_colors })
		end,
		opts = {
			hooks = {
				-- Red on the old side, green on the new side, like Claude Code; merge layouts keep the defaults
				diff_buf_win_enter = function(_, winid, ctx)
					if not ctx.layout_name:match("^diff2") then
						return
					end
					local tone = ctx.symbol == "a" and "Removed" or "Added"
					vim.wo[winid].winhighlight = table.concat({
						"DiffAdd:ClaudeDiff" .. tone,
						"DiffChange:ClaudeDiff" .. tone .. "Dim",
						"DiffText:ClaudeDiff" .. tone .. "Word",
						"DiffDelete:ClaudeDiffFiller",
					}, ",")
				end,
			},
		},
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
		init = function()
			-- VS Code's merge conflict colors, sampled from a screenshot; the plugin only sets these as defaults
			local function set_vscode_conflict_colors()
				vim.api.nvim_set_hl(0, "GitConflictCurrentLabel", { bg = "#526857" })
				vim.api.nvim_set_hl(0, "GitConflictCurrent", { bg = "#37423f" })
				vim.api.nvim_set_hl(0, "GitConflictAncestorLabel", { bg = "#4e5163" })
				vim.api.nvim_set_hl(0, "GitConflictAncestor", { bg = "#353642" })
				vim.api.nvim_set_hl(0, "GitConflictIncoming", { bg = "#303951" })
				vim.api.nvim_set_hl(0, "GitConflictIncomingLabel", { bg = "#45557a" })
				vim.api.nvim_set_hl(0, "GitConflictCodeLens", { fg = "#747990" })
			end
			set_vscode_conflict_colors()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_vscode_conflict_colors })
		end,
		config = function()
			require("git-conflict").setup()
			require("config.conflict_codelens").setup()
		end,
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
