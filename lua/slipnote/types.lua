---@meta _
---@alias LinkKind "markdown" | "wikilink"

---@class (exact) LinkMatch
---@field startIdx integer
---@field endIdx integer
---@field capture string|nil
---@field kind LinkKind

---@alias luaPattern string
---@alias filePath string

---@class SlipnoteConcealConfig
---@field enable? boolean Master switch; when false, wikilinks and cursor are ignored (default: false)
---@field wikilinks? boolean Apply [[wikilink]] conceal syntax (default: false)
---@field cursor? string Set concealcursor (default: "")

---@class SlipnoteConfig
---@field conceal? SlipnoteConcealConfig
