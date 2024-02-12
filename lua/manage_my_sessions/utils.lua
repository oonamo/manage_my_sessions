local M = {}

function M.validate_path(path)
	return vim.fn.isdirectory(path)
end

return M
