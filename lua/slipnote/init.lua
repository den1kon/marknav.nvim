local BufferManager = require("slipnote.buffer_manager")
local CmdHandler = require("slipnote.command_handler")
local Conceal = require("slipnote.conceal")
local Config = require("slipnote.config")

local M = {}

---@param user_config? SlipnoteConfig
function M.setup(user_config)
	local config = Config.resolve(user_config)

	vim.api.nvim_create_user_command("FollowLink", CmdHandler.follow_link, { nargs = 0 })
	vim.api.nvim_create_user_command("FollowBack", CmdHandler.follow_back, { nargs = 0 })
	vim.api.nvim_create_user_command("FollowLinkInNewTab", CmdHandler.follow_link_in_new_tab, { nargs = 0 })

	local augroup = vim.api.nvim_create_augroup("SlipnoteAutocommands", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
		group = augroup,
		callback = function()
			if vim.bo.filetype ~= "markdown" then
				return
			end
			BufferManager.handle_stack()
		end,
	})

	Conceal.setup(config, augroup)
end

return M
