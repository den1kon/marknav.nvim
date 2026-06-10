local BufferManager = require("slipnote.buffer_manager")
local CmdHandler = require("slipnote.command_handler")

local M = {}

-- Set up commands for Markdown file navigation
function M.setup(user_config)
	user_config = user_config or {}

	local augroup = vim.api.nvim_create_augroup("SlipnoteAutocommands", { clear = true })

	-- Update buffer every time the buffer or window is entered, while in markdown file
	vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
		group = augroup,
		pattern = { "*.md", "*.markdown" },
		callback = BufferManager.handle_stack,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = "markdown",
		callback = function()
			-- Set conceal options for syntax
			vim.opt_local.conceallevel = 2

			-- User Commands
			vim.api.nvim_create_user_command("FollowLink", CmdHandler.follow_link, { nargs = 0 })
			vim.api.nvim_create_user_command("FollowBack", CmdHandler.follow_back, { nargs = 0 })
			vim.api.nvim_create_user_command("FollowLinkInNewTab", CmdHandler.follow_link_in_new_tab, { nargs = 0 })
		end,
	})
end

return M
