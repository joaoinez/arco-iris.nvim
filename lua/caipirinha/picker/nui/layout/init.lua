local menu = require 'caipirinha.picker.nui.layout.menu'
local preview = require 'caipirinha.picker.nui.layout.preview'
local ui = require 'caipirinha.picker.nui.ui'

--- nui UI layout.
---
---@module 'caipirinha.picker.nui.layout'
---
local M = {}

--- Init function for nui layout
---
---@param enter boolean
---@return NuiLayout
function M.init(enter)
  if enter == nil then enter = true end

  local Layout = require 'nui.layout'

  local menu_instance = menu.init(enter)
  local preview_instance = preview.init()

  local config = {
    relative = {
      type = 'win',
      winid = ui.container.win,
    },
    position = {
      row = 3,
      col = '100%',
    },
    size = {
      width = '100%',
      height = '93%',
    },
  }

  local layout = Layout(
    config,
    Layout.Box({
      Layout.Box(menu_instance, { grow = 1 }),
      Layout.Box(preview_instance, { grow = 3 }),
    }, { dir = 'row', grow = 1 })
  )

  ui.layout = {
    instance = layout,
    init = M.init,
  }
  ui.menu = {
    instance = menu_instance,
    init = menu.init,
  }
  ui.preview = {
    instance = preview_instance,
    init = preview.init,
  }

  return layout
end

return M
