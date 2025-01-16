---@diagnostic disable: undefined-field

local menu = require 'caipirinha.picker.nui.layout.menu'
local preview = require 'caipirinha.picker.nui.layout.preview'
local state = require 'caipirinha.picker.nui.state'

local M = {}

function M.init(enter)
  if enter == nil then enter = true end

  local Layout = require 'nui.layout'

  local menu_instance = menu.init(enter)
  local preview_instance = preview.init()

  local config = {
    relative = {
      type = 'win',
      winid = state.ui.container.win,
    },
    position = {
      row = 3,
      col = '100%',
    },
    size = {
      width = '100%',
      height = '95%',
    },
  }

  local layout = Layout(
    config,
    Layout.Box({
      Layout.Box(menu_instance, { grow = 1 }),
      Layout.Box(preview_instance, { grow = 3 }),
    }, { dir = 'row', grow = 1 })
  )

  state.ui.layout = {
    config = config,
    instance = layout,
    init = M.init,
    menu = {
      instance = menu_instance,
      init = menu.init,
    },
    preview = preview_instance,
  }

  return layout
end

return M
