--- State object for nui UI.
---
---@module 'arco-iris.picker.nui.state'
---

---@class arco-iris.nui.State
---@field callback function | nil
---@field colors string[]
---@field filtered_colors string[]
---@field filter arco-iris.Options.filter | nil

---@type arco-iris.nui.State
local M = {
  callback = nil,
  colors = {},
  filtered_colors = {},
  filter = nil,
}

return M
