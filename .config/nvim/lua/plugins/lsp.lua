local function optimize_import()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.removeUnused" },
			diagnostics = {},
		},
	})
end

local function hover()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		vim.lsp.buf.hover({
			border = "rounded",
		})
	end
end

local function go_to_definition()
	local params = vim.lsp.util.make_position_params(0, "utf-8")
	vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
		if err or not result or vim.tbl_isempty(result) then
			vim.lsp.buf.definition()
			return
		end
		if #result > 1 then
			require("telescope.builtin").lsp_definitions()
		else
			vim.lsp.util.jump_to_location(result[1], "utf-8")
		end
	end)
end

return {
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"ts_ls",
					"eslint",
					"rust_analyzer",
					"basedpyright",
					"ruff",
				},
			})
		end,
	},

	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = { "L3MON4D3/LuaSnip" },
		opts = {
			snippets = { preset = "luasnip" },
			keymap = {
				-- blink merges presets by keycode, and <Tab> == <C-i>, so any preset with <Tab> drops <C-i>.
				preset = "none",
				["<C-i>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-y>"] = { "select_and_accept", "fallback" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<A-j>"] = { "select_next", "snippet_forward", "fallback" },
				["<A-k>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { "saghen/blink.cmp" },
		keys = {
			{ "<leader>gd", go_to_definition, silent = true, desc = "Go to definition" },
			{ "<leader>gr", function() require("telescope.builtin").lsp_references() end, silent = true, desc = "Go to references" },
			{ "<leader>gi", function() require("telescope.builtin").lsp_implementations() end, silent = true, desc = "Go to implementation" },
			{ "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "v" }, silent = true, desc = "Code action" },
			{ "K", hover, silent = true, desc = "Hover" },
			{ "<leader>rn", vim.lsp.buf.rename, silent = true, desc = "Rename" },
			{ "<leader>i", vim.lsp.buf.format, silent = true, desc = "Format" },
			{ "<leader>o", optimize_import, silent = true, desc = "Optimize import" },
			{ "<leader>ce", "<CMD>LspEslintFixAll<CR>", silent = true, desc = "Fix all eslint" },
			{ "<leader>ts", "<cmd>Telescope lsp_document_symbols<CR>" },
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Lua LSP
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" }, -- Recognize 'vim' global
							enable = true,
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
						format = {
							enable = true,
							defaultConfig = {
								indent_style = "tab",
								indent_size = "4",
							},
						},
					},
				},
			})

			-- Go LSP
			vim.lsp.config("gopls", {
				capabilities = capabilities,
			})

			-- TypeScript LSP
			local merge_conflict_marker_code = 1185
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				handlers = {
					-- git-conflict already highlights conflicts, so drop "Merge conflict marker encountered."
					["textDocument/publishDiagnostics"] = function(err, result, ctx)
						result.diagnostics = vim.tbl_filter(function(diagnostic)
							return diagnostic.code ~= merge_conflict_marker_code
						end, result.diagnostics)
						vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx)
					end,
				},
			})

			-- ESLint LSP - Shows inline diagnostics
			vim.lsp.config("eslint", {
				capabilities = capabilities,
				settings = {
					workingDirectories = { mode = "auto" },
				},
			})

			-- Rust LSP
			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						checkOnSave = true,
						check = { command = "clippy" },
					},
				},
			})

			-- Python type checking LSP
			vim.lsp.config("basedpyright", {
				capabilities = capabilities,
				-- Prefer the uv workspace root over a member's own pyproject.toml,
				-- so the shared .venv at the workspace root is used.
				root_markers = { { "uv.lock", "pyrightconfig.json" }, "pyproject.toml", "setup.py", ".git" },
			})

			-- Python linting LSP (diagnostics only; basedpyright covers hover/completion)
			vim.lsp.config("ruff", {
				capabilities = capabilities,
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			})

			-- Enable LSP servers
			vim.lsp.enable({ "lua_ls", "gopls", "ts_ls", "eslint", "rust_analyzer", "basedpyright", "ruff" })
		end,
	},

	{
		"mason-org/mason.nvim",
		opts = {},
	},

	{
		"jay-babu/mason-null-ls.nvim",
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"prettierd",
					"goimports",
					"eslint_d",
					"sql_formatter",
					"ruff_format",
				},
			})
		end,
	},

	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local utils = require("null-ls.utils")

			null_ls.setup({
				root_dir = utils.root_pattern("eslint.config.mjs", "package.json", ".git"),

				on_attach = function(client)
					if client.name == "null-ls" then
						client.server_capabilities.documentFormattingProvider = false
					end
				end,

				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.formatting.sql_formatter,
					require("none-ls.formatting.ruff_format"),

					-- Linters
					require("none-ls.diagnostics.eslint_d").with({
						prefer_local = "node_modules/.bin",
						extra_args = {
							"--config",
							"eslint.config.mjs",
						},
					}),
				},
			})
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"go",
					"rust",
					"json",
					"yaml",
					"python",
					"html",
					"tsx",
					"prisma",
					"bash",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				incremental_selection = { enable = true },
			})
			vim.filetype.add({
				filename = {
					[".env"] = "dotenv",
				},
				pattern = {
					["%.env%.[%w_.-]+"] = "dotenv", -- .env.local, .env.production, .env.test ...
				},
			})
			vim.treesitter.language.register("bash", "dotenv")
		end,
	},
}
