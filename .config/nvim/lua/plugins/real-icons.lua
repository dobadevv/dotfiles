return {
	{
		"Mirsmog/real-icons.nvim",
		build = ":RealIcons install",
		opts = {
			integrations = {
				lualine = true,
				bufferline = true,
				neo_tree = true,
				telescope = true,
			},
		},
	},
}
