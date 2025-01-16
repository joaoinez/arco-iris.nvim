local colorscheme = require 'caipirinha.colorscheme'
local render = require 'caipirinha.picker.nui.render'
local state = require 'caipirinha.picker.nui.state'

local M = {}

function M.pick(callback, filter)
  state.callback = callback
  state.colors = colorscheme.get_installed_colorschemes(filter)
  state.filtered_colors = { unpack(state.colors) }
  state.filter = filter

  render()
end

return setmetatable(M, {
  __call = function(self, ...) return self.pick(...) end,
})
