local popup = require("manage_my_sessions.popup")
local fzf_sessions = require("manage_my_sessions.fzf.sessions")
local config = require("manage_my_sessions.config")
local utils = require("manage_my_sessions.utils")
local command = vim.api.nvim_create_user_command

local M = {}

function M.get_sessions()
	if config.values.sessions then
		return config.values.sessions
	end
end

command("ManageMySessions", function(opts)
	if opts.fargs[1] == nil or opts.fargs[1] == "popup" then
		local cb = function(_, session)
			if session ~= nil then
				-- FIX: valiate path does not validate
				if utils.validate_path(session) then
					vim.schedule(function()
						local ok
						local session_actions
						for _, v in pairs(config.values.sessions) do
							if v[1] == session then
								session_actions = v
								session_actions.before()
								ok, _ = pcall(session_actions.select, session)
								if config.values.term_cd then
									vim.cmd("!cd " .. vim.fn.expand(session))
								end
								break
							end
						end
						if not ok then
							print("invalid path: " .. session)
							return
						end
						session_actions.after(session)
					end)
				else
					print("invalid path: " .. session)
				end
			end
		end
		popup.open_popup(M.get_sessions(), cb)
	elseif opts.fargs[1] == "fzf" then
		fzf_sessions:run()
	end
end, {
	desc = "Manage My Sessions",
	complete = function()
		return { "fzf", "popup" }
	end,
	nargs = "?",
})

return M
