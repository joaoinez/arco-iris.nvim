---@class caipirinha.nui.State
---@field callback function | nil
---@field colors string[]
---@field filtered_colors string[]
---@field filter caipirinha.Options.filter | nil
---@field ui table

---@type caipirinha.nui.State
local M = {
  callback = nil,
  colors = {},
  filtered_colors = {},
  filter = nil,
  ui = {
    tabs = {},
  },
}

return M
