local M = {}

-- Push current buffer into window-scoped table
function M.handle_stack()
  local current_buf = vim.api.nvim_get_current_buf()
  local temp_stack = vim.w.buffer_stack or {}
  -- Happens while tab switching
  if #temp_stack > 0 and current_buf == temp_stack[#temp_stack] then table.remove(temp_stack) end
  -- If the stack got too big, then start removing the last elements
  if #temp_stack > 1000 then table.remove(temp_stack, 1) end
  -- Update window-scoped table
  table.insert(temp_stack, current_buf)
  vim.w.buffer_stack = temp_stack
  -- Clear errors if any
  vim.cmd("echo")
end

function M.get_previous_buffer()
  local temp_stack = vim.w.buffer_stack
  -- return if stack is empty
  if #temp_stack <= 1 then return end
  -- pop the last buffer (the current one)
  table.remove(temp_stack)
  -- get previous buffer
  local prevBuf = table.remove(temp_stack)
  -- update buffer_stack
  vim.w.buffer_stack = temp_stack
  return prevBuf
end

return M
