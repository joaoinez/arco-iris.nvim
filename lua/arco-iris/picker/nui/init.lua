local colorscheme = require 'arco-iris.colorscheme'
local render = require 'arco-iris.picker.nui.render'
local state = require 'arco-iris.picker.nui.state'

--- nui picker integration for arco-iris.
---
---@module 'arco-iris.picker.nui'
---
local M = {}

--- Uses nui to pick a colorscheme
---
---@param callback function
---@param filter? arco-iris.Options.filter
function M.pick(callback, filter)
  local highlights = {
    ArcoIrisButton = { default = true, link = 'CursorLine' },
    ArcoIrisButtonActive = { default = true, link = 'Visual' },
    ArcoIrisKeybind = { default = true, link = '@punctuation.special' },
  }

  for hl_name, hl_config in pairs(highlights) do
    vim.api.nvim_set_hl(0, hl_name, hl_config)
    vim.api.nvim_command 'redraw'
  end

  state.callback = callback
  state.colors = colorscheme.get_installed_colorschemes(filter)
  state.filtered_colors = { unpack(state.colors) }
  state.filter = filter or {
    installed = 'all',
  }

  render()
end

return setmetatable(M, {
  __call = function(self, ...) return self.pick(...) end,
})
