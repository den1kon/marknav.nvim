-- frontmatter.lua
local M = {}
local utils = require("slipnote.utils")
local Config = require("slipnote.config")

---Checks if buffer has frontmatter
---@param buffer number Buffer id
---@return boolean
local function buffer_has_frontmatter(buffer)
	local first_line = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1]
	return first_line == "---"
end

---@param lines string[]
---@return integer|nil
local function find_frontmatter_end(lines)
	if #lines == 0 or lines[1] ~= "---" then
		return nil
	end

	for i = 2, #lines do
		if lines[i] == "---" then
			return i - 1
		end
	end

	return nil
end

---Generates YAML frontmatter
---@return string[]
local function generate_yaml_frontmatter()
	local now = utils.generate_unix_timestamp()
	local utc_ts = utils.generate_iso8601_utc_timestamp(now)

	local frontmatter = {
		"---",
		"id: " .. now,
		'created_at: "' .. utc_ts .. '"',
		'updated_at: "' .. utc_ts .. '"',
		"tags: ",
		"  - fleeting-note",
		"---",
		"",
	}

	return frontmatter
end

---Inserts YAML frontmatter at the beginning of the current buffer
---@return boolean
function M.insert_frontmatter()
	local current_buffer = utils.get_current_buffer()

	if buffer_has_frontmatter(current_buffer) then
		vim.notify("Buffer already has frontmatter", vim.log.levels.WARN)
		return false
	end

	local frontmatter = generate_yaml_frontmatter()

	-- TODO: save the current position of the cursor and put it back after inserting

	-- Insert at line 0 (beginning of buffer)
	vim.api.nvim_buf_set_lines(current_buffer, 0, 0, false, frontmatter)

	-- Move cursor after frontmatter
	-- vim.api.nvim_win_set_cursor(0, {#frontmatter + 1, 0})
	return true
end

---Updates the updated_at field in YAML frontmatter before save
---@param bufnr? number
function M.update_frontmatter_updated_at(bufnr)
	bufnr = bufnr or 0

	if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) ~= "markdown" then
		return
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local frontmatter_end = find_frontmatter_end(lines)
	if not frontmatter_end then
		return
	end

	local updated_at_line
	for i = 2, frontmatter_end do
		if lines[i]:match("^updated_at:") then
			updated_at_line = i
			break
		end
	end

	if not updated_at_line then
		return
	end

	local utc_ts = utils.generate_iso8601_utc_timestamp()
	lines[updated_at_line] = 'updated_at: "' .. utc_ts .. '"'
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

---@param config SlipnoteConfig
---@param augroup integer
function M.setup(config, augroup)
	if not Config.frontmatter_enabled(config) then
		return
	end

	vim.api.nvim_create_user_command("InsertFrontmatter", M.insert_frontmatter, { desc = "Insert YAML frontmatter" })

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		callback = function(args)
			M.update_frontmatter_updated_at(args.buf)
		end,
	})
end

return M
