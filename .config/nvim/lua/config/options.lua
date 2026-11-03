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
vim.opt.shiftwidth = 4

-- Number of spaces a tab counts for
vim.opt.tabstop = 4

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

-- Transparent background, re-applied whenever Themery switches the colorscheme
local function clear_backgrounds()
	vim.cmd([[
	  hi Normal guibg=NONE ctermbg=NONE
	  hi NormalNC guibg=NONE ctermbg=NONE
	  hi NormalFloat guibg=NONE ctermbg=NONE
	  hi SignColumn guibg=NONE ctermbg=NONE
	  hi StatusLine guibg=NONE ctermbg=NONE
	]])
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_backgrounds })

-- Colorscheme is restored by Themery; fall back to catppuccin before a theme has been picked
if vim.g.colors_name == nil or vim.g.colors_name == "default" then
	vim.cmd.colorscheme("catppuccin-mocha")
end
clear_backgrounds()

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
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

local buffer_watchers = {}

local function stop_watching(bufnr)
  local handle = buffer_watchers[bufnr]
  if not handle then return end

  buffer_watchers[bufnr] = nil
  if not handle:is_closing() then
    handle:stop()
    handle:close()
  end
end

local function watch_buffer(bufnr)
  stop_watching(bufnr)

  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then return end

  local handle = vim.uv.new_fs_event()
  if not handle then return end
  buffer_watchers[bufnr] = handle

  handle:start(path, {}, vim.schedule_wrap(function(err)
    if err or not vim.api.nvim_buf_is_valid(bufnr) then
      stop_watching(bufnr)
      return
    end
    vim.cmd("checktime " .. bufnr)
    -- Atomic writes (write temp + rename) swap the inode, which leaves this
    -- handle watching a dead file, so re-arm it on the new one.
    watch_buffer(bufnr)
  end))
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function(args) watch_buffer(args.buf) end,
})

vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete" }, {
  callback = function(args) stop_watching(args.buf) end,
})
