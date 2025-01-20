--- State object for nui UI.
---
---@module 'caipirinha.picker.nui.state'
---

---@class caipirinha.nui.State
---@field callback function | nil
---@field colors string[]
---@field filtered_colors string[]
---@field filter caipirinha.Options.filter | nil

---@type caipirinha.nui.State
local M = {
  callback = nil,
  colors = {},
  filtered_colors = {},
  filter = nil,
}

return M
