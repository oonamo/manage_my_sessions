local config = require("manage_my_sessions.config")
local Sessions = require("manage_my_sessions.sessions")

function Sessions.setup(opts)
	opts = opts or config.defaults()
	config.setup(opts)
end

return Sessions
