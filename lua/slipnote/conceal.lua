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

	if c.cursor ~= "" then
		vim.opt_local.concealcursor = c.cursor
	end

	if c.wikilinks then
		WikilinkSyntax.apply()
	end
end

---@param config SlipnoteConfig
local function apply_to_loaded_markdown_buffers(config)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "markdown" then
			vim.api.nvim_buf_call(buf, function()
				M.apply_to_buffer(config)
			end)
		end
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

	-- lazy.nvim ft=markdown: slipnote loads after FileType on the triggering buffer.
	-- Defer one tick, then patch buffers that already have markdown syntax.
	vim.schedule(function()
		apply_to_loaded_markdown_buffers(config)
	end)
end

return M
