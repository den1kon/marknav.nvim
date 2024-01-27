local M = {}


-- find all pattern matches in a string and return as a table
function M.find_matches(str, pattern)
  local found_matches = {}
  local index = 1

  while index < #str do
    -- end is reserved word
    local start, end_, matchStr = string.find(str, pattern, index)

    if not start then break end

    table.insert(found_matches, {
      str = matchStr,
      startPos = start,
      endPos = end_
    })
    index = end_ + 1
  end

  return found_matches
end

-- Extract path at cursor location
function M.extract_at_cursor(match_list, cursor_pos)
  for _, match in ipairs(match_list) do
    -- Lua's string indices start with 1, not 0!
    if cursor_pos + 1 >= match.startPos and cursor_pos + 1 <= match.endPos then
      return match.str
    end
  end
end

-- works for Unix-like systems only
-- if path absolute -> return
-- else make it absolute and return
function M.expand(file_path)
  if string.sub(file_path, 1, 1) == "/" then
    return file_path
  end
  return vim.fn.expand('%:p:h') .. '/' .. file_path
end

-- VALIDATION

-- used in MarknavTab
function M.validate(abs_path)
  -- File Unreadable
  --if vim.fn.filereadable(abs_path) == 0 then vim.api.nvim_err_writeln("MARKNAV: File doesn't exist or unreadable") return false end
  
  -- Non-Markdown file
  if not abs_path:match("%.md$") then vim.api.nvim_err_writeln("MARKNAV: Link points to non-markdown file") return false end 

  -- If file doesn't exist - print the it was created
  if vim.fn.filereadable(abs_path) == 0 then print("MARKNAV: Created New File") end
  return true
end

-- Used in MarknavJump and MarknavJumpTo
function M.extended_validate(abs_path)
  -- Previous cases
  if not M.validate(abs_path) then return false end
  -- Link points to current file
  if vim.fn.expand('%:p') == abs_path then vim.api.nvim_err_writeln("MARKNAV: Link points to current file") return false end
  return true
end


return M
