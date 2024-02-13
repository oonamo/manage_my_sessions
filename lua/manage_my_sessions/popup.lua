local has_plenary, popup = pcall(require, "plenary.popup")
local M = {}
local MENU = "manage_my_sessions"
local Win_id

---@class Sessions
---@field sesssions table

---@param session_items Sessions
---@param cb function
function M.open_popup(session_items, cb)
	--FIX: Should only use plenary if its wanted
	if has_plenary then
		M.plenary_popup(session_items, cb)
	end
end

---@param session_items Sessions
---@param callback function
function M.plenary_popup(session_items, callback)
	local sessions = {}
	for _, v in pairs(session_items) do
		if type(v) == "string" then
			table.insert(sessions, v)
		end
		if type(v) == "table" then
			table.insert(sessions, v[1])
		end
	end

	local height = #session_items + 1
	local width = math.floor(vim.o.columns / 2)
	local cb = function(id, session)
		callback(id, session)
	end

	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	Win_id = popup.create(sessions, {
		title = MENU,
		borderchars = borderchars,
		highlight = "NormalFloat",
		line = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		callback = cb,
	})

	local buffer = vim.api.nvim_win_get_buf(Win_id)
	function M.CloseWin()
		vim.api.nvim_win_close(Win_id, true)
	end
	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"q",
		":lua require('manage_my_sessions.popup').CloseWin()<CR>",
		{ noremap = true, silent = true }
	)

	vim.api.nvim_buf_set_keymap(
		buffer,
		"n",
		"<esc>",
		":lua require('manage_my_sessions.popup').CloseWin()<CR>",
		{ noremap = true, silent = true }
	)
end

return M
