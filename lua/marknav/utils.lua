-- utils.lua
local M = {}

---@alias luaPattern string
---@alias filePath string

---Characters forbidden in a filename (mostly Windows rules)
---@type luaPattern
local FORBIDDEN_FILENAME_CHARS = '[<>:"|?*]'

--- Filename cannot end with a dot or trailing space (Windows rule)
---@type luaPattern
local INVALID_FILENAME_ENDING = "[%s%.]$"

---Check whether generic lua table is empty
---@param tbl table Lua table
---@return boolean
function M.is_table_empty(tbl)
	return next(tbl) == nil
end

---Check whether filepath is an absolute path
---@param path filePath Filepath
---@return boolean
function M.is_absolute_path(path)
	return vim.fn.fnamemodify(path, ":p") == path
end

---Expand relative filepath to an absolute filepath
---@param relative_path filePath Relative filepath
---@return filePath
function M.expand_relative_path(relative_path)
	local current_file_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
	local full_path = vim.fn.fnamemodify(current_file_dir .. "/" .. relative_path, ":p")
	return full_path
end

---@param filepath filePath
---@return string|nil basename
local function get_file_basename(filepath)
	local basename = vim.fn.fnamemodify(filepath, ":t")
	if basename == "" then
		return nil
	end
	return basename
end

---@param filepath filePath
---@return string fileExtension
function M.getFileExtension(filepath)
	return vim.fn.fnamemodify(filepath, ":t:e")
end

---@param filepath filePath|nil Relative/absolute file path
---@return boolean valid
---@return string|nil reason
function M.isLinkValid(filepath)
	if filepath == nil or filepath == "" then
		return false, "Link path is empty."
	end

	if filepath:match(FORBIDDEN_FILENAME_CHARS) then
		return false, "Path contains forbidden characters."
	end

	local basename = get_file_basename(filepath)
	if basename == nil then
		return false, "Path has no filename."
	end

	if basename:match(INVALID_FILENAME_ENDING) then
		return false, "Filename cannot end with a space or dot."
	end

	return true, nil
end

return M
