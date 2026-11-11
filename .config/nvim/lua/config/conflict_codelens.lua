-- VS Code style "Accept Current Change | Accept Incoming Change | Accept Both Changes"
-- line above each git conflict, clickable with the mouse
local M = {}

local namespace = vim.api.nvim_create_namespace("conflict_codelens")
local conflict_start_pattern = "^<<<<<<<"
local separator = " | "
local actions = {
	{ label = "Accept Current Change", side = "ours" },
	{ label = "Accept Incoming Change", side = "theirs" },
	{ label = "Accept Both Changes", side = "both" },
}

local function build_lens_chunks()
	local chunks = {}
	for index, action in ipairs(actions) do
		if index > 1 then
			table.insert(chunks, { separator, "GitConflictCodeLens" })
		end
		table.insert(chunks, { action.label, "GitConflictCodeLens" })
	end
	return chunks
end

function M.render(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
	if vim.bo[bufnr].buftype ~= "" then
		return
	end
	for index, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
		if line:match(conflict_start_pattern) then
			vim.api.nvim_buf_set_extmark(bufnr, namespace, index - 1, 0, {
				virt_lines = { build_lens_chunks() },
				virt_lines_above = true,
			})
		end
	end
end

local function find_side_at_offset(offset)
	local start = 0
	for _, action in ipairs(actions) do
		if offset >= start and offset < start + #action.label then
			return action.side
		end
		start = start + #action.label + #separator
	end
end

-- Returns the conflict's first line and the side whose label sits under the mouse, or nil
function M.find_clicked_action(mouse)
	if mouse.winid == 0 then
		return nil
	end
	local bufnr = vim.api.nvim_win_get_buf(mouse.winid)
	local text_offset = vim.fn.getwininfo(mouse.winid)[1].textoff
	-- A click on a virtual line may report the line below or above it, so check both
	for _, lnum in ipairs({ mouse.line, mouse.line + 1 }) do
		local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
		local is_lens_row = line
			and line:match(conflict_start_pattern)
			and vim.fn.screenpos(mouse.winid, lnum, 1).row - 1 == mouse.screenrow
		if is_lens_row then
			local side = find_side_at_offset(mouse.wincol - text_offset - 1)
			return side and { lnum = lnum, side = side } or nil
		end
	end
end

local function handle_left_mouse()
	local mouse = vim.fn.getmousepos()
	local clicked = M.find_clicked_action(mouse)
	if not clicked then
		return "<LeftMouse>"
	end
	-- expr mappings can't edit the buffer, so resolve the conflict right after
	vim.schedule(function()
		vim.api.nvim_set_current_win(mouse.winid)
		vim.api.nvim_win_set_cursor(mouse.winid, { clicked.lnum, 0 })
		require("git-conflict").choose(clicked.side)
	end)
	return ""
end

function M.setup()
	vim.api.nvim_create_autocmd({ "BufWinEnter", "TextChanged", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("ConflictCodeLens", { clear = true }),
		callback = function(event)
			M.render(event.buf)
		end,
	})
	vim.keymap.set("n", "<LeftMouse>", handle_left_mouse, { expr = true, desc = "Click conflict actions" })
	M.render(vim.api.nvim_get_current_buf())
end

return M
