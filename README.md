# manage_my_sessions
A simple session switcher for neovim
<!--toc:start-->
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Features](#features)
- [Usage](#uasge)
<!--toc:end-->
## Quick Start
Default config **requires _ripgrep_**

**Lazy**
```lua
return {
        "oonamo/manage_my_sessions",
        dependencies = { 
            "nvim-lua/plenary.nvim", -- Optional, see dependencies
            "ibhagwan/fzf-lua" -- Optional
        },
        opts = {
            sessions = {
                "~/projects", -- Sessions you would like to manage
            },
            term_cd = true, -- CD in your shell to directory after select
        },
}
```

**Packer**
```lua
use("oonamo/manage_my_sessions",
    require = {
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua",
    },
    config = function()
        require("manage_my_sessions").setup({
            sessions = {
                "~/projects"
            }
        })
    end
)
```
## Features
- fzf over your directories
- or have a pre-defined popup to go exactly where you want to go
- create hooks to use your favorite commands or plugins

## Usage
### Create custom hooks
```lua
local mms = require("manage_my_sessions")
mms.setup({
    sessions = {
        "~/projects", -- Use the default actions to switch to ~/projects
        {
            "~/.config/nvim", -- Directory to manage
            before = function() -- Function is called before any action
                vim.cmd("colorscheme rose-pine")
            end,
            select = function(path) -- Function is called after session is selected
                vim.cmd("cd " .. path .. " | e .") -- Default
            end,
            after = function() -- Function is called after an ok on the select function
                vim.cmd("vnew .") 
            end
        },
        -- Use default before and select functions
        {
            "~/notes/school",
            after = function(path)
                vim.cmd("Neorg index")
            end
        },
        -- The command that will be ran if fzf-lua is called to search for sessions
        -- {sessions} will be replaced by a space seperated string of your sessions
        search_command = "rg --files --max-depth 2 --null {sessions} | xargs -0 dirname | uniq",
    }
})
```
