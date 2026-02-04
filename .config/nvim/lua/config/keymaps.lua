local cinnamon = require("cinnamon")

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

-- Smooth Scrolling (Cinnamon)
vim.keymap.set("n", "<C-e>", function() cinnamon.scroll("5<C-e>") end, { silent = true, desc = "Smooth scroll down 5 lines" })
vim.keymap.set("n", "<C-y>", function() cinnamon.scroll("5<C-y>") end, { silent = true, desc = "Smooth scroll up 5 lines" })

-- Clipboard Operations
vim.keymap.set({ 'n', 'x' }, '<M-c>', '"+y', { noremap = true, silent = true, desc = 'Copy to clipboard' })

-- Text Insertion
vim.keymap.set("n", "<C-o>", 'O', { silent = true, desc = "Insert a new line above" })
vim.keymap.set("i", "<M-BS>", '<C-w>', { silent = true, desc = "Remove whole word" })

-- Checktime
vim.keymap.set("n", "<leader>r", '<cmd>checktime<CR>', { silent = true, desc = "Restart terminal" })

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

-- Neotree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true, desc = "Toggle file explorer" })

-- Telescope
local find_files = function()
    require("telescope.builtin").find_files({
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
    })
end
local live_grep = function()
    require("telescope.builtin").live_grep({
        additional_args = {
            "--hidden",
            "--no-ignore",
            "--glob", "!node_modules/**",
            "--glob", "!dist/**",
        },
    })
end
vim.keymap.set("n", "<leader>ff", find_files, { silent = true, desc = "Find files" })
vim.keymap.set("n", "<leader>fg", live_grep, { silent = true, desc = "Live grep" })

-- Buffer
vim.keymap.set("n", "<S-w>", "<CMD>bd<CR>", { silent = true, desc = "Close current buffer" })
vim.keymap.set("n", "<S-n>", "<CMD>bnext<CR>", { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-p>", "<CMD>bprev<CR>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<S-o>", "<CMD>BufferLineCloseOthers<CR>", { silent = true, desc = "Close other buffer" })

-- LSP
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
vim.keymap.set("n", "<leader>gd", require('telescope.builtin').lsp_definitions, { silent = true, desc = "Go to definition" })
vim.keymap.set("n", "<leader>gr", require('telescope.builtin').lsp_references, { silent = true, desc = "Go to references" })
vim.keymap.set("n", "<leader>gi", require("telescope.builtin").lsp_implementations, { silent = true, desc = "Go to implementation" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { silent = true, desc = "Code action" })
vim.keymap.set("n", "K", hover, { silent = true, desc = "Hover" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true, desc = "Rename" })
vim.keymap.set("n", "<leader>i", vim.lsp.buf.format, { silent = true, desc = "Format" })
vim.keymap.set("n", "<leader>o", optimize_import, { silent = true, desc = "Optimize import" })
vim.keymap.set("n", "<leader>ce", "<CMD>LspEslintFixAll<CR>", { silent = true, desc = "Fix all eslint" })
vim.keymap.set("n", "<leader>ts", "<cmd>Telescope lsp_document_symbols<CR>")

-- Fold 
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- Lazy tools
vim.keymap.set("n", "<leader>lg", "<CMD>LazyGit<CR>", { silent = true, desc = "Open LazyGit" })
vim.keymap.set("n", "<leader>ll", "<CMD>Lazy<CR>", { silent = true, desc = "Open LazyVim" })
vim.keymap.set("n", "<leader>ls", "<CMD>DBUIToggle<CR>", { silent = true, desc = "Open DadbodUI" })

-- Debugger
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { silent = true, desc = "Debug" })
vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, { silent = true, desc = "Step over" })
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, { silent = true, desc = "Step into" })
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, { silent = true, desc = "Step out" })
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { silent = true, desc = "Toggle breakpoint" })
vim.keymap.set({'n', 'v'}, '<leader>dh', function() require('dap.ui.widgets').hover() end, { silent = true, desc = "Debug hover" })
vim.keymap.set({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').preview() end, { silent = true, desc = "Debug preview" })
vim.keymap.set('n', '<leader>du', function() require("dapui").toggle() end, { silent = true, desc = "Open debug UI" })

-- Git
vim.keymap.set('n', '<leader>gv', "<CMD>DiffviewOpen<CR>", { silent = true, desc = "Open diff view" })
vim.keymap.set('n', '<leader>gc', "<CMD>DiffviewClose<CR>", { silent = true, desc = "Close diff view" })
vim.keymap.set('n', '<leader>gh', "<CMD>DiffviewFileHistory<CR>", { silent = true, desc = "Open file history" })
vim.keymap.set('n', '<leader>gf', "<CMD>DiffviewFileHistory %<CR>", { silent = true, desc = "Open current file history" })
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status, { silent = true, desc = "Git status" })
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, { silent = true, desc = "Git branches" })
vim.keymap.set('n', '<leader>gl', require('telescope.builtin').git_commits, { silent = true, desc = "Git commits" })
vim.keymap.set('n', '<leader>ga', require('telescope.builtin').git_bcommits, { silent = true, desc = "Git buffer commits" })
vim.keymap.set('n', '<leader>gxn', "<CMD>GitConflictNextConflict<CR>", { silent = true, desc = "Move to the next conflict" })
vim.keymap.set('n', '<leader>gxp', "<CMD>GitConflictPrevConflict<CR>", { silent = true, desc = "Move to the previous conflict" })
vim.keymap.set('n', '<leader>gxo', "<CMD>GitConflictChooseOurs<CR>", { silent = true, desc = "Select the current changes" })
vim.keymap.set('n', '<leader>gxt', "<CMD>GitConflictChooseTheirs<CR>", { silent = true, desc = "Select the incoming changes" })
vim.keymap.set('n', '<leader>gxb', "<CMD>GitConflictChooseBoth<CR>", { silent = true, desc = "Select both changes" })
vim.keymap.set('n', '<leader>gxz', "<CMD>GitConflictChooseNone<CR>", { silent = true, desc = "Select none of the changes" })
vim.keymap.set('n', '<leader>gxl', "<CMD>GitConflictListQf<CR>", { silent = true, desc = "Get all conflict to quickfix" })
