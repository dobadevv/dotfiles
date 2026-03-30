vim.opt.laststatus = 3

-- Disable wrap text
vim.opt.wrap = false

-- Highlight search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Sync clipboard
vim.opt.clipboard = "unnamedplus"

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Number of spaces for each indentation level
vim.opt.shiftwidth = 2

-- Number of spaces a tab counts for
vim.opt.tabstop = 2

-- Number of spaces for tab in insert mode
vim.opt.softtabstop = 2

-- Copy indent from current line when starting new line
vim.opt.autoindent = true

-- Smart indenting for code
vim.opt.smartindent = true

-- Show absolute line numbers
vim.opt.number = true

-- Show relative line numbers
vim.opt.relativenumber = true

-- Term GUI color
vim.opt.termguicolors = true

-- Colorscheme
vim.cmd.colorscheme("catppuccin-mocha")

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
  hi NormalFloat guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi StatusLine guibg=NONE ctermbg=NONE
]])

-- Diagnostic configuration for inline errors
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Diagnostic signs in the gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- LSP float window color
vim.api.nvim_set_hl(0, "LspFloatWinNormal", {
  link = "NormalFloat",
})

vim.api.nvim_set_hl(0, "LspFloatWinBorder", {
  link = "FloatBorder",
})
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#89b4fa", bg = "#1e1e2e" })

-- Fold 
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = false

-- Debugger
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped" })

