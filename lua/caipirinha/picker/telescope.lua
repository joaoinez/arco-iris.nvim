--- telescope picker integration for caipirinha.
---
---@module 'caipirinha.picker.telescope'
---
local M = {}

-- NOTE: From https://github.com/brianhuster/live-preview.nvim/blob/main/lua/livepreview/picker.lua

--- Uses telescope to pick a colorscheme
---
---@param callback function
---@param filter caipirinha.Options.filter
function M.pick(callback, filter)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local colorschemes = require 'caipirinha.colorscheme'
  local colors = colorschemes.get_installed_colorschemes(filter)

  pickers
    .new({}, {
      sorting_strategy = 'ascending',
      layout_config = {
        width = 0.5,
        height = 0.5,
        prompt_position = 'top',
        anchor = 'NE',
      },
      prompt_title = 'Colorschemes',
      finder = finders.new_table {
        results = colors,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(_, _)
        actions.select_default:replace(function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          local selected = entry.value
          callback(selected)
        end)
        return true
      end,
    })
    :find()
end

return setmetatable(M, {
  __call = function(self, ...) return self.pick(...) end,
})
