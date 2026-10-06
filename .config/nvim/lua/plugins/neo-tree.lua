return {
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
							"node_modules",
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
}
