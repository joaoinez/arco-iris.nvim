local colorscheme = require 'arco-iris.colorscheme'
local state = require 'arco-iris.picker.nui.state'
local ui = require 'arco-iris.picker.nui.ui'

--- nui UI menu.
---
---@module 'arco-iris.picker.nui.layout.menu'
---
local M = {}

--- Closes whole nui UI
---
local function close_window()
  if ui.layout.instance then ui.layout.instance:unmount() end
  if ui.header.instance then ui.header.instance:unmount() end

  for _, tab in ipairs(ui.tabs) do
    tab.instance:unmount()
  end

  ui.tabs = {}

  vim.api.nvim_win_close(ui.container.win, true)
end

--- Applies filter to menu list
---
---@param filter arco-iris.Options.filter
local function apply_filter(filter)
  local Layout = require 'nui.layout'

  state.filter = filter
  state.colors = colorscheme.get_installed_colorschemes(state.filter)
  state.filtered_colors = { unpack(state.colors) }

  vim.schedule(function()
    if ui.header.instance then ui.header.instance:unmount() end

    for _, tab in ipairs(ui.tabs) do
      tab.instance:unmount()
    end

    ui.tabs = {}

    vim.schedule(function()
      ui.header.init():mount()
      ui.layout.instance:update(
        nil,
        Layout.Box({
          Layout.Box(ui.menu.init(), { grow = 1 }),
          Layout.Box(ui.preview.instance, { grow = 3 }),
        }, { dir = 'row', grow = 1 })
      )
    end)
  end)
end

--- Init function for nui menu
---
---@param enter boolean
---@return NuiMenu
function M.init(enter)
  if enter == nil then enter = true end

  local Menu = require 'nui.menu'

  local items = {}
  for _, color in ipairs(state.filtered_colors) do
    local item = Menu.item(' ' .. color, { colors_name = color })
    table.insert(items, item)
  end

  local menu = Menu({
    enter = enter,
    border = 'none',
  }, {
    lines = items,
    keymap = {
      focus_next = { 'j', '<Down>', '<Tab>', '<C-j>' },
      focus_prev = { 'k', '<Up>', '<S-Tab>', '<C-k>' },
      close = { 'q', '<Esc>', '<C-c>' },
      submit = { '<CR>', '<Space>' },
    },
    on_submit = function(item)
      state.callback(item.colors_name)

      close_window()
    end,
    on_change = function(item)
      if item.colors_name ~= vim.g.colors_name then
        vim.cmd.colorscheme(item.colors_name)
      end
    end,
    on_close = function()
      vim.cmd.colorscheme(colorscheme._get_current_colorscheme())

      vim.schedule(function() close_window() end)
    end,
  })

  menu:map('n', '/', function()
    if ui.input.instance then ui.input.instance:unmount() end

    vim.schedule(function() ui.input.init():mount() end)
  end, { noremap = true })

  menu:map(
    'n',
    '1',
    function() apply_filter { installed = 'all' } end,
    { noremap = true }
  )
  menu:map(
    'n',
    '2',
    function() apply_filter { installed = 'user' } end,
    { noremap = true }
  )
  menu:map(
    'n',
    '3',
    function() apply_filter { installed = 'default' } end,
    { noremap = true }
  )

  return menu
end

return M
