local container = require 'arco-iris.picker.nui.container'
local header = require 'arco-iris.picker.nui.header'
local input = require 'arco-iris.picker.nui.input'
local layout = require 'arco-iris.picker.nui.layout'

--- Main render module for nui UI.
---
---@module 'arco-iris.picker.nui.render'
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
