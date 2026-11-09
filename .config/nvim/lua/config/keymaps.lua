-- Exit from terminal mode
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Toggle wrap text
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", { silent = true, desc = "Toggle line wrap" })

-- File Operations
vim.keymap.set("n", "<leader>qq", "<cmd>q!<CR>", { silent = true, desc = "Force quit" })
vim.keymap.set("n", "<leader>qa", "<cmd>qwa<CR>", { silent = true, desc = "Save all and quit" })
vim.keymap.set("n", "<leader>ww", "<cmd>w<CR>", { silent = true, desc = "Save" })
vim.keymap.set("n", "<leader>wa", "<cmd>wa<CR>", { silent = true, desc = "Save all" })

-- Redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Search & Highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlights" })

-- Clipboard Operations
vim.keymap.set({ 'n', 'x' }, '<M-c>', '"+y', { noremap = true, silent = true, desc = 'Copy to clipboard' })

-- Text Insertion
vim.keymap.set("n", "<C-o>", 'O', { silent = true, desc = "Insert a new line above" })
vim.keymap.set("i", "<M-BS>", '<C-w>', { silent = true, desc = "Remove whole word" })

-- Jumplist
vim.keymap.set("n", "<leader>p", "<C-o>", { silent = true, desc = "Jump back" })
vim.keymap.set("n", "<leader>n", "<C-i>", { silent = true, desc = "Jump forward" })

-- Checktime
vim.keymap.set("n", "<leader>r", '<cmd>checktime<CR><cmd>LspRestart<CR>', { silent = true, desc = "Restart terminal" })

-- Increment/Decrement Numbers
vim.keymap.set("n", "+", '<C-A>', { silent = true, desc = "Increase" })
vim.keymap.set("n", "-", '<C-X>', { silent = true, desc = "Decrease" })

-- Move current line up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Move like arrow keys in insert mode
vim.keymap.set("i", "<A-h>", "<Left>",  { silent = true })
vim.keymap.set("i", "<A-j>", "<Down>",  { silent = true })
vim.keymap.set("i", "<A-k>", "<Up>",    { silent = true })
vim.keymap.set("i", "<A-l>", "<Right>", { silent = true })

-- Stay in visual mode when indenting
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })

-- Split
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { silent = true, desc = "Split vertically" })
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { silent = true, desc = "Split horizontally" })

-- Buffer
vim.keymap.set("n", "<S-w>", "<CMD>bd<CR>", { silent = true, desc = "Close current buffer" })
vim.keymap.set("n", "<S-n>", "<CMD>bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-p>", "<CMD>bprev<CR>", { silent = true, desc = "Previous buffer" })

-- Copy
-- Relative path from the working directory (cwd), in the format Claude Code understands: @path
local function rel_path()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
end

local function copy(text, msg)
  vim.fn.setreg("+", text)
  vim.notify(msg or ("Copied: " .. text))
end

-- 1. Copy file: @path/to/file.ts
vim.keymap.set("n", "<leader>cf", function()
  copy("@" .. rel_path())
end, { desc = "Copy @file for Claude Code" })

-- 2. Copy current line: @path:LINE
vim.keymap.set("n", "<leader>cl", function()
  copy(("@%s:%d"):format(rel_path(), vim.fn.line(".")))
end, { desc = "Copy @file:line" })

-- 3. Copy visual selection: @path:START-END plus the code itself
vim.keymap.set("v", "<leader>cs", function()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then s, e = e, s end
  local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
  local ft = vim.bo.filetype
  local text = ("@%s:%d-%d\n```%s\n%s\n```"):format(
    rel_path(), s, e, ft, table.concat(lines, "\n"))
  copy(text, ("Copied %d lines"):format(#lines))
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
end, { desc = "Copy selection for Claude Code" })

-- 4. Copy the whole function (Treesitter)
local function current_function_node()
  local node = vim.treesitter.get_node()
  while node do
    local t = node:type()
    if t:match("function") or t:match("method") then
      return node
    end
    node = node:parent()
  end
end

vim.keymap.set("n", "<leader>cF", function()
  local node = current_function_node()
  if not node then
    return vim.notify("No function found at cursor position", vim.log.levels.WARN)
  end
  local sr, _, er, _ = node:range()
  local lines = vim.api.nvim_buf_get_lines(0, sr, er + 1, false)
  local text = ("@%s:%d-%d\n```%s\n%s\n```"):format(
    rel_path(), sr + 1, er + 1, vim.bo.filetype, table.concat(lines, "\n"))
  copy(text, ("Copied function (%d lines)"):format(#lines))
end, { desc = "Copy function for Claude Code" })

-- Open in browser
vim.keymap.set("n", "<leader>ob", function()
  vim.ui.open(vim.fn.expand("%:p"))
end, { desc = "Open file in browser" })
