local M = {}

---Push current buffer into window-scoped table
---@return nil
function M.handle_stack()
	local current_buf = vim.api.nvim_get_current_buf()
	local temp_stack = vim.w.buffer_stack or {}
	-- Happens while tab switching
	if #temp_stack > 0 and current_buf == temp_stack[#temp_stack] then
		table.remove(temp_stack)
	end
	-- If the stack got too big, then start removing the oldest elements
	if #temp_stack > 1000 then
		table.remove(temp_stack, 1)
	end
	table.insert(temp_stack, current_buf)
	vim.w.buffer_stack = temp_stack
end

---Pop and return the previous buffer from the stack
---@return integer|nil bufnr Buffer number, or nil if stack is empty
function M.get_previous_buffer()
	local temp_stack = vim.w.buffer_stack or {}

	if #temp_stack <= 1 then
		return nil
	end

	table.remove(temp_stack)
	local prev_buf = table.remove(temp_stack)
	vim.w.buffer_stack = temp_stack

	if prev_buf ~= nil and not vim.api.nvim_buf_is_valid(prev_buf) then
		return nil
	end

	return prev_buf
end

return M
