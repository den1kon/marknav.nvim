local LinkParser = require("marknav/link_parser")
local BufferManager = require("marknav/buffer_manager")

local M = {}

local function print_err(err)
  vim.api.nvim_err_writeln("MARKNAV: " .. err)
end

-- Jump to previous buffer unless stack is empty
function M.back_jump()
  local prev_buf = BufferManager.get_previous_buffer()
  if prev_buf ~= nil then
    -- Open previous buffer
    vim.api.nvim_command('buffer ' .. prev_buf)
    return
  end
  print_err("Buffer history is empty")
end

-- Opens a link at the cursor location
function M.forward_jump()
  local current_line = vim.api.nvim_get_current_line()
  local current_cursor_position = vim.api.nvim_win_get_cursor(0)[2]

  local path, err = LinkParser.get_absolute_path(current_line, current_cursor_position)
  
  if not path then
    vim.api.nvim_err_writeln("MARKNAV: " .. err)
    return
  end

  vim.api.nvim_command('edit ' .. path)
end


-- Opens a link at the cursor location IN A NEW TAB
function M.forward_tab_jump()
  local current_line = vim.api.nvim_get_current_line()
  local current_cursor_position = vim.api.nvim_win_get_cursor(0)[2]
  
  local path, err = LinkParser.get_absolute_path(current_line, current_cursor_position)
  
  if not path then
    vim.api.nvim_err_writeln("MARKNAV: " .. err)
    return
  end

  vim.api.nvim_command('tabnew ' .. path)
end

return M
