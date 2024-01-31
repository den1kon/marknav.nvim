-- Purpose: Handles parsing markdown links and validating file paths
local M = {}
-- find all link matches in a string and return as a table
local function find_links(str, pattern)
  local found = {}
  -- Start search from the beginning of the string (1-indexed)
  local start = 1 
  while start <= string.len(str) do
    local s, e, link = string.find(str, pattern, start)
    -- Break the loop if no more matches are found
    if not s then break end
    table.insert(found, {
      startPos = s,
      endPos = e,
      linkStr = link
    })
    -- Update the start position for the next search
    start = e + 1
  end
  return found
end

-- links = { {startPos = 1, endPos = 15, linkStr = "link.md"}, ...}
-- cursor_pos is 0-indexed
local function get_link_at_cursor_position(links, cursor_pos)
  for _, match in ipairs(links) do
    if cursor_pos + 1 >= match.startPos and cursor_pos + 1 <= match.endPos then
      return match.linkStr
    end
  end
  -- Explicitly return nil to indicate no link was found
  return nil
end

local function is_absolute_path(path)
  return vim.fn.fnamemodify(path, ":p") == path
end

-- Expands relative path to absolute
-- The current working directory (cwd) for file can be different to cwd the user is in
local function expand_relative_path(relative_path)
  -- get the full path to the buffer and make it headless
  local current_file_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
  -- concatenate and normalize the path to resolve any ".." or "." parts
  local full_path = vim.fn.fnamemodify(current_file_dir .. "/" .. relative_path, ":p")
  return full_path
end

local function validate(abs_path)
  if not abs_path:match("%.md$") then
    return false, "Link points to non-markdown file"
  end
  return true
end

local function is_ToC_link(str)
  return str:match("^%s*[%*%-]%s+%[[^%]]+%]%([^%)]+%)%s*$") ~= nil
end

function M.get_absolute_path(str, cursor_pos)
  -- pattern for markdown links e.g. [link](link.md) and extracts the path
  local pattern = '%[[^%]]+%]%(([^%)%]]*)%)'
  local links = find_links(str, pattern) -- get table of links
  local path = get_link_at_cursor_position(links, cursor_pos) -- get path based on cursor

  -- check whether the links is from Table of Contents
  if not path then
    if is_ToC_link(str) then
      path = links[1].linkStr
    else
      return nil, "No link found at cursor position" -- return nil and error message
    end
  end

  local absolute_path
  if is_absolute_path(path) then
    absolute_path = path
  else
    absolute_path = expand_relative_path(path)
  end

  local isValid, validationError = validate(absolute_path)
  if not isValid then
    return nil, validationError
  end

  return absolute_path
end

return M
