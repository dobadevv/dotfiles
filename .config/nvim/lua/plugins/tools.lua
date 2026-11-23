-- one terminal per command, so reopening a tool resumes its session instead of spawning a new one
local tool_terminals = {}

local function toggle_tool(cmd)
	tool_terminals[cmd] = tool_terminals[cmd]
		or require("toggleterm.terminal").Terminal:new({
			cmd = cmd,
			direction = "float",
			hidden = true, -- keep tools out of :ToggleTerm so <C-q> only manages plain shells
			close_on_exit = true,
		})
	tool_terminals[cmd]:toggle()
end

return {
	{
		"folke/lazy.nvim",
		-- lazy.nvim ignores `keys` on its own spec, so map them in init
		init = function()
			vim.keymap.set("n", "<leader>ll", "<CMD>Lazy<CR>", { silent = true, desc = "Open LazyVim" })
			vim.keymap.set("n", "<leader>ls", "<cmd>LazySql<CR>", { silent = true, desc = "Toggle LazySql" })
		end,
	},

	{
		"mgierada/lazydocker.nvim",
		dependencies = { "akinsho/toggleterm.nvim" },
		config = function()
			require("lazydocker").setup({
				border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
				width = 0.9, -- width of the floating window (0-1 for percentage, >1 for absolute columns)
				height = 0.9, -- height of the floating window (0-1 for percentage, >1 for absolute rows)
			})
		end,
		event = "BufRead",
		keys = {
			{
				"<leader>ld",
				function()
					require("lazydocker").open()
				end,
				desc = "Open Lazydocker floating window",
			},
		},
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		cmd = { "ToggleTerm", "TermExec" },
		keys = {
			{ "<C-q>", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal float" },
			{ "<C-q>", "<cmd>hide<cr>", mode = "t", desc = "Hide terminal" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal horizontal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "Terminal vertical" },
			{
				"<leader>lp",
				function()
					-- gitignored: returns { name = "path/to/.posting", ... }
					local ok, collections = pcall(require, "config.posting_collections")
					if not ok then
						vim.notify("Missing lua/config/posting_collections.lua", vim.log.levels.WARN)
						return
					end
					vim.ui.select(vim.tbl_keys(collections), { prompt = "Posting collection" }, function(project)
						if not project then
							return
						end
						toggle_tool("posting --collection " .. vim.fn.expand(collections[project]))
					end)
				end,
				desc = "Open Posting",
			},
			{
				"<leader>lc",
				function()
					toggle_tool("claude --dangerously-skip-permissions")
				end,
				desc = "Open Claude",
			},
		},
		opts = {
			direction = "float",
			float_opts = { border = "curved" },
		},
	},

	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({})
		end,
	},
}
