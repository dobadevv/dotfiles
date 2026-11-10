return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({})
		end
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		keys = {
			{ "<S-o>", "<CMD>BufferLineCloseOthers<CR>", silent = true, desc = "Close other buffer" },
		},
		config = function()
			require("bufferline").setup({
				options = {
					sort_by = "none",
				},
			})
		end,
	},

	{
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
	},

	{
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		config = function()
			local logo = [[
  ██████╗  ██████╗ ██████╗  █████╗ ██████╗ ███████╗██╗   ██╗
  ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗██╔════╝██║   ██║
  ██║  ██║██║   ██║██████╔╝███████║██║  ██║█████╗  ██║   ██║
  ██║  ██║██║   ██║██╔══██╗██╔══██║██║  ██║██╔══╝  ╚██╗ ██╔╝
 ██████╔╝╚██████╔╝██████╔╝██║  ██║██████╔╝███████╗ ╚████╔╝
╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝  ╚═══╝
    ]]

	    logo = string.rep("\n", 8) .. logo .. "\n\n"

			local opts = {
				theme = "doom",
				hide = {
					-- this is taken care of by lualine
					-- enabling this messes up the actual laststatus setting after loading a file
					statusline = false,
				},
				config = {
					header = vim.split(logo, "\n"),
					-- stylua: ignore
					center = {
						{ action = 'Telescope find_files',                           desc = " Find File",       icon = " ", key = "f" },
						{ action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
						{ action = 'Telescope live_grep',							 desc = " Find Text",       icon = " ", key = "g" },
						{ action = 'edit ~/.config/nvim/init.lua',                   desc = " Config",          icon = " ", key = "c" },
						{ action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
						{ action = "qa",                                             desc = " Quit",            icon = " ", key = "q" },
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
					end,
				},
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			-- open dashboard after closing lazy
			if vim.o.filetype == "lazy" then
				vim.api.nvim_create_autocmd("WinClosed", {
					pattern = tostring(vim.api.nvim_get_current_win()),
					once = true,
					callback = function()
						vim.schedule(function()
							vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
						end)
					end,
				})
			end	
			require("dashboard").setup(opts)
		end,
		dependencies = { {'nvim-tree/nvim-web-devicons'}},
	},

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

	{
		'mluders/comfy-line-numbers.nvim',
		config = function()
			require('comfy-line-numbers').setup({
				labels = {
					'1', '2', '3', '4', '5', '11', '12', '13', '14', '15', '21', '22', '23',
					'24', '25', '31', '32', '33', '34', '35', '41', '42', '43', '44', '45',
					'51', '52', '53', '54', '55', '111', '112', '113', '114', '115', '121',
					'122', '123', '124', '125', '131', '132', '133', '134', '135', '141',
					'142', '143', '144', '145', '151', '152', '153', '154', '155', '211',
					'212', '213', '214', '215', '221', '222', '223', '224', '225', '231',
					'232', '233', '234', '235', '241', '242', '243', '244', '245', '251',
					'252', '253', '254', '255',
				},
				up_key = 'k',
				down_key = 'j',

				-- Line numbers will be completely hidden for the following file/buffer types
				hidden_file_types = { 'undotree' },
				hidden_buffer_types = { 'terminal', 'nofile' }
			})
		end
	},

	{
		"declancm/cinnamon.nvim",
		version = "*",
		lazy = false,
		opts = {
			keymaps = {
				basic = true,
				extra = true,
			},
			options = {
				mode = "cursor",
				delay = 5,
				step_size = {
					vertical = 1,
					horizontal = 2,
				},
				max_delta = {
					line = false,
					column = false,
					time = 1000,
				},
			},
		},
		config = function(_, opts)
			local cinnamon = require("cinnamon")
			cinnamon.setup(opts)
			-- Set after setup so they override cinnamon's own "extra" <C-e>/<C-y> keymaps
			vim.keymap.set("n", "<C-e>", function() cinnamon.scroll("5<C-e>") end, { silent = true, desc = "Smooth scroll down 5 lines" })
			vim.keymap.set("n", "<C-y>", function() cinnamon.scroll("5<C-y>") end, { silent = true, desc = "Smooth scroll up 5 lines" })
		end,
		keys = {
			{ '<c-d>', '<cmd>lua require("cinnamon").scroll("<C-d>zz")<cr>', mode = 'n', },
			{ '<c-u>', '<cmd>lua require("cinnamon").scroll("<C-u>zz")<cr>', mode = 'n', },
			{ '<c-f>', '<cmd>lua require("cinnamon").scroll("<C-f>zz")<cr>', mode = 'n', },
			{ '<c-b>', '<cmd>lua require("cinnamon").scroll("<C-b>zz")<cr>', mode = 'n', },
			{ 'zz',    '<cmd>lua require("cinnamon").scroll("zz")<cr>',      mode = 'n', },
			{ 'zt',    '<cmd>lua require("cinnamon").scroll("zt")<cr>',      mode = 'n', },
			{ 'zb',    '<cmd>lua require("cinnamon").scroll("zb")<cr>',      mode = 'n', },
			{ 'gg',    '<cmd>lua require("cinnamon").scroll("gg")<cr>',      mode = 'n', },
			{ 'G',    '<cmd>lua require("cinnamon").scroll("G")<cr>',      mode = 'n', },
		}
	},

	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
}
