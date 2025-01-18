local colorscheme = require 'caipirinha.colorscheme'
local render = require 'caipirinha.picker.nui.render'
local state = require 'caipirinha.picker.nui.state'

--- nui picker integration for caipirinha.
---
---@module 'caipirinha.picker.nui'
---
local M = {}

--- Uses nui to pick a colorscheme
---
---@param callback function
---@param filter caipirinha.Options.filter
function M.pick(callback, filter)
  local highlights = {
    CaipirinhaButton = { default = true, link = 'CursorLine' },
    CaipirinhaButtonActive = { default = true, link = 'Visual' },
    CaipirinhaKeybind = { default = true, link = '@punctuation.special' },
  }

  for hl_name, hl_config in pairs(highlights) do
    vim.api.nvim_set_hl(0, hl_name, hl_config)
    vim.api.nvim_command 'redraw'
  end

  state.callback = callback
  state.colors = colorscheme.get_installed_colorschemes(filter)
  state.filtered_colors = { unpack(state.colors) }
  state.filter = filter

  render()
end

return setmetatable(M, {
  __call = function(self, ...) return self.pick(...) end,
})
