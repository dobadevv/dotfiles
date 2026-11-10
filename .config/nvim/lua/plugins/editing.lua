return {
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},

	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "jsx", "tsx", "xml" },
		opts = {
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
		},
	},

	{
		"nvim-mini/mini.surround",
		opts = {
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "Sa", -- Add surrounding in Normal and Visual modes
				delete = "Sd", -- Delete surrounding
				find = "Sf", -- Find surrounding (to the right)
				find_left = "SF", -- Find surrounding (to the left)
				highlight = "Sh", -- Highlight surrounding
				replace = "Sr", -- Replace surrounding
				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
		},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	{
		"mg979/vim-visual-multi",
		branch = "master",
	},

	{
		'Wansmer/treesj',
		keys = { '<space>m' },
		dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require('treesj').setup({})
		end,
	},

	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup({})
	        -- require("telescope").load_extension("refactoring")

			vim.keymap.set({ "n", "x" }, "<leader>rr", function()
				require("telescope").extensions.refactoring.refactors()
			end, { desc = "Refactoring menu" })
		end,
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		lazy = false,
		keys = {
			{ "zR", function() require("ufo").openAllFolds() end },
			{ "zM", function() require("ufo").closeAllFolds() end },
		},
		config = function()
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "treesitter", "indent" }
				end,
			})
		end,
	},
}
