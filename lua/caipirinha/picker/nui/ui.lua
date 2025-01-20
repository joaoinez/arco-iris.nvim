--- UI state object for nui UI.
---
---@module 'caipirinha.picker.nui.ui'
---

---@class caipirinha.nui.UI
---@field container {win: integer} | nil
---@field header {instance: NuiPopup, init: fun(): NuiPopup} | nil
---@field tabs {instance: NuiPopup, init: fun(): NuiPopup}[] | nil
---@field layout {instance: NuiLayout, init: fun(enter?: boolean): NuiLayout} | nil
---@field menu {instance: NuiMenu, init: fun(enter?: boolean): NuiMenu} | nil
---@field preview {instance: NuiPopup, init: fun(): NuiPopup} | nil
---@field input {instance: NuiInput, init: fun(): NuiInput} | nil
local M = {
  container = nil,
  header = nil,
  tabs = {},
  layout = nil,
  menu = nil,
  preview = nil,
  input = nil,
}

return M
