---@diagnostic disable: undefined-field

local colorscheme = require 'caipirinha.colorscheme'
local state = require 'caipirinha.picker.nui.state'

local M = {}

local function close_window()
  if state.ui.layout.instance then state.ui.layout.instance:unmount() end
  if state.ui.header.instance then state.ui.header.instance:unmount() end

  for _, tab in ipairs(state.ui.tabs) do
    tab.instance:unmount()
  end

  state.ui.tabs = {}

  vim.api.nvim_win_close(state.ui.container.win, true)
end

local function apply_filter(filter)
  local Layout = require 'nui.layout'

  state.filter = filter
  state.colors = colorscheme.get_installed_colorschemes(state.filter)
  state.filtered_colors = { unpack(state.colors) }

  vim.schedule(function()
    if state.ui.header.instance then state.ui.header.instance:unmount() end

    for _, tab in ipairs(state.ui.tabs) do
      tab.instance:unmount()
    end

    state.ui.tabs = {}

    vim.schedule(function()
      state.ui.header.init()
      state.ui.layout.instance:update(
        nil,
        Layout.Box({
          Layout.Box(state.ui.layout.menu.init(), { grow = 1 }),
          Layout.Box(state.ui.layout.preview, { grow = 3 }),
        }, { dir = 'row', grow = 1 })
      )
    end)
  end)
end

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
    if state.ui.input.instance then state.ui.input.instance:unmount() end

    vim.schedule(function() state.ui.input.init():mount() end)
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
