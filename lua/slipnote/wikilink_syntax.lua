-- Wikilink conceal syntax is added via vim.cmd after built-in markdown syntax loads.
local M = {}

function M.apply()
	vim.cmd("silent! syntax clear WikiLinkOpen WikiLinkFileName WikiLinkClose")
	vim.cmd("syntax match WikiLinkOpen '\\[\\[' conceal")
	vim.cmd([=[syntax match WikiLinkFileName '\[\[[^|]*|' conceal]=])
	vim.cmd("syntax match WikiLinkClose '\\]\\]' conceal")
end

return M
