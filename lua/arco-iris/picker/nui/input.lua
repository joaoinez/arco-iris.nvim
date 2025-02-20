local state = require 'arco-iris.picker.nui.state'
local ui = require 'arco-iris.picker.nui.ui'

--- nui UI input.
---
---@module 'arco-iris.picker.nui.input'
---
local M = {}

--- Init function for nui header
---
---@return NuiInput
function M.init()
  local Input = require 'nui.input'
  local Layout = require 'nui.layout'

  local input_options = {
    zindex = 61,
    relative = {
      type = 'win',
      winid = ui.container.win,
    },
    position = {
      row = '99%',
      col = 0,
    },
    size = {
      width = '100%',
      height = 1,
    },
    border = {
      style = 'rounded',
      text = {
        top = '[Search]',
        top_align = 'left',
      },
    },
  }

  local input = Input(input_options, {
    prompt = '> ',
    on_close = function()
      ui.layout.instance:update(
        nil,
        Layout.Box({
          Layout.Box(ui.menu.init(), { grow = 1 }),
          Layout.Box(ui.preview.instance, { grow = 3 }),
        }, { dir = 'row', grow = 1 })
      )
    end,
    on_change = function(value)
      vim.schedule(function()
        local filtered_colors = {}
        for _, color in ipairs(state.colors) do
          if color:match(value) then table.insert(filtered_colors, color) end
        end
        state.filtered_colors = filtered_colors

        ui.layout.instance:update(
          nil,
          Layout.Box({
            Layout.Box(ui.menu.init(false), { grow = 1 }),
            Layout.Box(ui.preview.instance, { grow = 3 }),
          }, { dir = 'row', grow = 1 })
        )
      end)
    end,
    on_submit = function()
      vim.schedule(
        function()
          ui.layout.instance:update(
            nil,
            Layout.Box({
              Layout.Box(ui.menu.init(), { grow = 1 }),
              Layout.Box(ui.preview.instance, { grow = 3 }),
            }, { dir = 'row', grow = 1 })
          )
        end
      )
    end,
  })

  input:map('n', '<Esc>', function() input:unmount() end, { noremap = true })

  ui.input = { instance = input, init = M.init }

  return input
end

return M
