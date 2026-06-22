local Config = require("slipnote.config")
local WikilinkSyntax = require("slipnote.wikilink_syntax")

local M = {}

---@param config SlipnoteConfig
function M.apply_to_buffer(config)
	local c = Config.get_conceal(config)

	if not c.enable then
		return
	end

	vim.opt_local.conceallevel = 2
	vim.opt_local.colorcolumn = "100"
	vim.opt_local.textwidth = 100

	if type(c.cursor) == "string" and c.cursor ~= "" then
		vim.opt_local.concealcursor = c.cursor
	end

	if c.wikilinks then
		WikilinkSyntax.apply()
	end
end

---@param config SlipnoteConfig
---@param augroup integer
function M.setup(config, augroup)
	if not Config.conceal_enabled(config) then
		return
	end

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = "markdown",
		callback = function()
			M.apply_to_buffer(config)
		end,
	})
end

return M
