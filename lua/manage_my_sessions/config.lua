---@class ManangeMySessions
---@field values ManageMySessionsConfig
local M = {}

---@class sessions
---@field path string
---@field before function
---@field after function
---@field select function

---@class ManageMySessionsConfig
---@field sessions sessions[]
---@field term_cd boolean

---@return ManageMySessionsConfig
function M.defaults()
	return {
		sessions = {},
		term_cd = false,
	}
end

---@param path string
local function before()
	print("before")
end

---@param path string
local function after(path)
	print("after")
	print(path)
end

---@param path string
local function select(path)
	vim.cmd("cd " .. path .. " | e .")
end

---@param opts ManageMySessionsConfig
function M.merge_configs(opts)
	opts = opts or {}
	local sessions = {}
	for k, v in pairs(opts.sessions) do
		if type(v) == "string" then
			local session = {
				v,
				before = v.before or before,
				after = v.after or after,
				select = v.select or select,
			}
			table.insert(sessions, session)
		end
		if type(v) == "table" then
			table.insert(sessions, v)
		end
	end
	local config = M.defaults()
	for k, v in pairs(config) do
		config[k] = opts[k] or v
	end
	config.sessions = sessions
	return config
end

---@param opts ManageMySessionsConfig
function M.setup(opts)
	if opts ~= nil then
		M.values = M.merge_configs(opts)
	end
	local has_plenary, _ = pcall(require, "plenary")
	if not has_plenary then
		M.use_plenary = false
	end
end

return M
