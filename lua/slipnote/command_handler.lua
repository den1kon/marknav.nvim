local LinkParser = require("slipnote.link_parser")
local BufferManager = require("slipnote.buffer_manager")
local Frontmatter = require("slipnote.frontmatter")

local M = {}

local function print_err(err)
	-- legacy
	-- vim.api.nvim_err_writeln("SLIPNOTE: " .. err)
	vim.notify("SLIPNOTE: " .. err, vim.log.levels.WARN)
end

-- Jump to previous buffer unless stack is empty
function M.follow_back()
	local prev_buf = BufferManager.get_previous_buffer()
	if prev_buf ~= nil then
		vim.api.nvim_command("buffer " .. prev_buf)
		return
	end
	print_err("Buffer history is empty")
end

-- Opens a link at the cursor location
function M.follow_link()
	local ok, err = LinkParser.follow_link_at_cursor()
	if not ok then
		print_err(err or "Failed to follow link.")
	end
end

-- Opens a link at the cursor location IN A NEW TAB
function M.follow_link_in_new_tab()
	local ok, err = LinkParser.follow_link_at_cursor({ tab = true })
	if not ok then
		print_err(err or "Failed to follow link.")
	end
end

return M
