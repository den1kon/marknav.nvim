local M = {}

---@type SlipnoteConfig
M.defaults = {
	conceal = {
		enable = false,
		wikilinks = false,
		cursor = "",
	},
}

---@param user_config? SlipnoteConfig
---@return SlipnoteConfig
function M.resolve(user_config)
	return vim.tbl_deep_extend("force", M.defaults, user_config or {})
end

---@param config SlipnoteConfig
---@return SlipnoteConcealConfig
function M.get_conceal(config)
	local c = config.conceal
	if type(c) ~= "table" then
		return M.defaults.conceal
	end
	return c
end

---@param config SlipnoteConfig
---@return boolean
function M.conceal_enabled(config)
	return M.get_conceal(config).enable == true
end

return M
