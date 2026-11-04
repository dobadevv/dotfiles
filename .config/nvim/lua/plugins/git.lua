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
}
