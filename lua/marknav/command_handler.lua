local LinkParser = require("marknav.link_parser")
local BufferManager = require("marknav.buffer_manager")

local M = {}

local function print_err(err)
	vim.api.nvim_err_writeln("MARKNAV: " .. err)
end

-- Jump to previous buffer unless stack is empty
function M.back_jump()
	local prev_buf = BufferManager.get_previous_buffer()
	if prev_buf ~= nil then
		vim.api.nvim_command("buffer " .. prev_buf)
		return
	end
	print_err("Buffer history is empty")
end

-- Opens a link at the cursor location
function M.forward_jump()
	local ok, err = LinkParser.follow_link_at_cursor()
	if not ok then
		print_err(err or "Failed to follow link.")
	end
end

-- Opens a link at the cursor location IN A NEW TAB
function M.forward_tab_jump()
	local ok, err = LinkParser.follow_link_at_cursor({ tab = true })
	if not ok then
		print_err(err or "Failed to follow link.")
	end
end

return M
