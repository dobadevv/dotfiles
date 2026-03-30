return {
	{
		"jay-babu/mason-null-ls.nvim",
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"prettierd",
					"goimports",
					"eslint_d",
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
}
