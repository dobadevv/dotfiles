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
		"neovim/nvim-lspconfig",
		lazy = false,
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
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
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
}
