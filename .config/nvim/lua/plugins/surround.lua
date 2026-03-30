return {
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
}
