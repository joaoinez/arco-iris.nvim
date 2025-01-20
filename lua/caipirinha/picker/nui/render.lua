local container = require 'caipirinha.picker.nui.container'
local header = require 'caipirinha.picker.nui.header'
local input = require 'caipirinha.picker.nui.input'
local layout = require 'caipirinha.picker.nui.layout'

--- Main render module for nui UI.
---
---@module 'caipirinha.picker.nui.render'
---
local M = {}

--- Render function
---
function M.render()
  container.init()
  layout.init():mount()
  input.init()
  header.init():mount()
end

return setmetatable(M, {
  __call = function(self, ...) return self.render(...) end,
})
