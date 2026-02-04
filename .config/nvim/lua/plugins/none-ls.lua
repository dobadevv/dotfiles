return {
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
					-- Formatters (NO ESLint)
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.rustfmt,
					null_ls.builtins.formatting.ruff,

					-- Linters
					require("none-ls.diagnostics.eslint_d").with({
						prefer_local = "node_modules/.bin",
						extra_args = {
							"--config",
							"eslint.config.mjs",
						},
					}),

					null_ls.builtins.diagnostics.ruff,
				},
			})
		end,
	},
}
