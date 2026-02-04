return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		views = {
			cmdline_popup = {
				position = { row = 5, col = "50%" },
				size = { width = "40%", height = "auto" },
			},
		},
		routes = {
			{
				filter = {
					event = "lsp",
					kind = "progress",
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "NotifyBackground" },
						{ find = "deprecated" },
						{ find = "editorconfig" },
					},
				},
				opts = { skip = true },
			},
		},
		notify = { enabled = false },
		cmdline = {
			enabled = true,
			view = "cmdline_popup", -- Keep popup for commands
			format = {
				search_down = { view = "cmdline" }, -- Search at bottom
				search_up = { view = "cmdline" }, -- Search at bottom
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				timeout = 1000,
			},
		},
		{
			"stevearc/dressing.nvim",
			opts = {
				input = {
					enabled = true,
					default_prompt = "Input:",
					win_options = {
						winblend = 0,
					},
				},
				select = {
					enabled = true,
					backend = { "telescope", "fzf_lua", "builtin", "nui" },
				},
			},
		},
	},
}
