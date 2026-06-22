local BufferManager = require("slipnote.buffer_manager")
local CmdHandler = require("slipnote.command_handler")
local Conceal = require("slipnote.conceal")
local Config = require("slipnote.config")
local Frontmatter = require("slipnote.frontmatter")

local M = {}

---@param user_config? SlipnoteConfig
function M.setup(user_config)
	local config = Config.resolve(user_config)
	local frontmatter_config = Config.get_frontmatter(config)

	vim.api.nvim_create_user_command("FollowLink", CmdHandler.follow_link, { desc = "Follow link at cursor" })
	vim.api.nvim_create_user_command("FollowBack", CmdHandler.follow_back, { desc = "Go back to previos buffer" })
	vim.api.nvim_create_user_command(
		"FollowLinkInNewTab",
		CmdHandler.follow_link_in_new_tab,
		{ desc = "Follow link at cursor in new tab" }
	)

	if Config.frontmatter_enabled(config) then
		vim.api.nvim_create_user_command(
			"InsertFrontmatter",
			CmdHandler.insert_frontmatter,
			{ desc = "Insert YAML frontmatter" }
		)
	end

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

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		callback = function(args)
			Frontmatter.update_frontmatter_updated_at(args.buf)
		end,
	})

	Conceal.setup(config, augroup)
end

return M
