local config = require("manage_my_sessions.config")

---@class Fzf
---@field fzf_exec function()

---@return boolean, Fzf
local function hasFZF()
	local ok, fzf = pcall(require, "fzf-lua")

	return ok, fzf
end

---@class FzFSessions
---@field fzf Fzf
---@field command string
local M = {}

function M:create_command()
	local session = config.values.sessions
	local command = config.values.search_command
	local dirs = ""
	for _, v in pairs(session) do
		local last_char = string.sub(v[1], -1)
		if last_char ~= "/" or last_char ~= "\\" then
			v[1] = v[1] .. "/"
		end
		dirs = dirs .. " " .. v[1]
	end
	command = string.gsub(command, "{sessions}", dirs)
	print(command)
	M.command = command
end
function M:run()
	local has_fzf, fzf = hasFZF()
	if not has_fzf then
		print("fzf not found")
		return
	end
	if not M.command then
		M:create_command()
	end
	fzf.fzf_exec(M.command, {
		actions = {
			---@param selected string
			["default"] = function(selected)
				if selected == nil then
					return
				end
				local actions
				for _, v in pairs(config.values.sessions) do
					local expanded = vim.fn.fnamemodify(v[1], ":p")
					local first_expanded = vim.fn.fnamemodify(selected[1], ":p:h")
					local second_expanded = vim.fn.fnamemodify(selected[1], ":p:h:h")

					expanded = string.gsub(expanded, "\\", "/")
					first_expanded = string.gsub(first_expanded, "\\", "/") .. "/"
					second_expanded = string.gsub(second_expanded, "\\", "/") .. "/"
					if expanded == first_expanded or expanded == second_expanded then
						actions = v
						break
					end
				end
				actions.before()
				local is_ok, _ = pcall(actions.select, selected[1])
				if not is_ok then
					print("invalid path: " .. selected[1])
					return
				end
				if config.values.term_cd then
					vim.cmd("!cd " .. vim.fn.expand(selected[1]))
				end
				actions.after(selected[1])
			end,
		},
	})
end
return M
