return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "jsx", "tsx", "xml" },
	opts = {
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = true,
		},
	},
}
