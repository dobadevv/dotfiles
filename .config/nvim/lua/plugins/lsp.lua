return {
	"neovim/nvim-lspconfig",
	lazy = false,
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

		-- TypeScript LSP
		vim.lsp.config("rust-analyzer", {
			capabilities = capabilities,
		})

		-- ESLint LSP - Shows inline diagnostics
		vim.lsp.config("eslint", {
			capabilities = capabilities,
			settings = {
				workingDirectories = { mode = "auto" },
			},
		})

		-- Python LSP
		vim.lsp.config("basedpyright", {
			capabilities = capabilities,
			settings = {
				basedpyright = {
					analysis = {
						typeCheckingMode = "standard", -- "off", "basic", "standard", "strict"
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
				},
			},
		})

		-- Enable LSP servers
		vim.lsp.enable({ "lua_ls", "gopls", "ts_ls", "eslint", "rust-analyzer", "basedpyright" })
	end,
}
