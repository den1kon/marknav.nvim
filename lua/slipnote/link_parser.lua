-- link_parser.lua
local M = {}

local utils = require("slipnote.utils")

---@type luaPattern
local MARKDOWN_LINK_PATTERN = "%[[^%]]+%]%(([^%)%]]*)%)"
---@type luaPattern
local WIKILINK_PATTERN = "%[%[([^|%]]+)[^%]]*%]%]"

local ERRORS = {
	NO_LINKS_ON_LINE = "No markdown or wikilinks found on this line.",
	NO_LINK_AT_CURSOR = "No link found at cursor position.",
	EMPTY_LINK_TARGET = "Link target is empty.",
	MISSING_CAPTURE = "Could not extract link target.",
}

---@param path filePath
---@param opts? { tab?: boolean }
local function open_path(path, opts)
	if opts and opts.tab then
		vim.cmd.tabnew({ args = { path } })
	else
		vim.cmd.edit({ args = { path } })
	end
end

---Search for links within input string and return a table of matches <br>
---or nil if no matches found.
---@param str string The string to search within
---@param pattern luaPattern
---@param kind LinkKind either "markdown" or "wikilink"
---@return LinkMatch[]|nil
local function find_link_matches(str, pattern, kind)
	local matches = {}
	local start = 1
	while start <= #str do
		local startIdx, endIdx, capture = string.find(str, pattern, start)
		if not startIdx then
			break
		end

		table.insert(matches, {
			startIdx = startIdx,
			endIdx = endIdx,
			capture = capture,
			kind = kind,
		})

		start = startIdx + math.max(1, endIdx - startIdx + 1)
	end

	if #matches == 0 then
		return nil
	end

	return matches
end

---Find all links in an input string
---@param str string The string to search within
---@return LinkMatch[]|nil
function M.get_links(str)
	local markdown_links = find_link_matches(str, MARKDOWN_LINK_PATTERN, "markdown")
	local wikilinks = find_link_matches(str, WIKILINK_PATTERN, "wikilink")

	if wikilinks == nil then
		return markdown_links
	end

	if markdown_links == nil then
		return wikilinks
	end

	for _, v in ipairs(wikilinks) do
		markdown_links[#markdown_links + 1] = v
	end

	return markdown_links
end

---Find links in the current line
---@return LinkMatch[]|nil
function M.get_links_at_current_line()
	local cur_line = vim.api.nvim_get_current_line()
	return M.get_links(cur_line)
end

---Find the link at cursor position
---@return LinkMatch|nil, string|nil
local function get_link_match_at_cursor_pos()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)[2]
	local links = M.get_links_at_current_line()

	if links == nil then
		return nil, ERRORS.NO_LINKS_ON_LINE
	end

	for _, match in ipairs(links) do
		if cursor_pos + 1 >= match.startIdx and cursor_pos + 1 <= match.endIdx then
			return match, nil
		end
	end

	return nil, ERRORS.NO_LINK_AT_CURSOR
end

---@param markdown_link filePath
---@param opts? { tab?: boolean }
---@return boolean ok
---@return string|nil err
local function follow_markdown_link(markdown_link, opts)
	if markdown_link == nil or markdown_link == "" then
		return false, ERRORS.EMPTY_LINK_TARGET
	end

	local valid, reason = utils.is_link_valid(markdown_link)
	if not valid then
		return false, reason
	end

	local absolute_path = markdown_link
	if not utils.is_absolute_path(markdown_link) then
		absolute_path = utils.expand_relative_path(markdown_link)
	end

	open_path(absolute_path, opts)
	return true, nil
end

---@param wikilink filePath
---@param opts? { tab?: boolean }
---@return boolean ok
---@return string|nil err
local function follow_wikilink(wikilink, opts)
	if wikilink == nil or wikilink == "" then
		return false, ERRORS.EMPTY_LINK_TARGET
	end

	local valid, reason = utils.is_link_valid(wikilink)
	if not valid then
		return false, reason
	end

	local path = wikilink
	if utils.get_file_extension(path) == "" then
		path = path .. ".md"
	end

	local absolute_path = path
	if not utils.is_absolute_path(absolute_path) then
		absolute_path = utils.expand_relative_path(path)
	end

	open_path(absolute_path, opts)
	return true, nil
end

---@param opts? { tab?: boolean }
---@return boolean ok
---@return string|nil err
function M.follow_link_at_cursor(opts)
	local link_match, err = get_link_match_at_cursor_pos()
	if not link_match then
		return false, err
	end

	local capture = link_match.capture
	if capture == nil then
		return false, ERRORS.MISSING_CAPTURE
	end
	if capture == "" then
		return false, ERRORS.EMPTY_LINK_TARGET
	end

	if link_match.kind == "wikilink" then
		return follow_wikilink(capture, opts)
	end

	return follow_markdown_link(capture, opts)
end

return M
