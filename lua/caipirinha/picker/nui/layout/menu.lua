local colorscheme = require 'caipirinha.colorscheme'
local filesystem = require 'caipirinha.filesystem'
local state = require 'caipirinha.picker.nui.state'
local ui = require 'caipirinha.picker.nui.ui'

--- nui UI menu.
---
---@module 'caipirinha.picker.nui.layout.menu'
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
---@param filter caipirinha.Options.filter
local function apply_filter(filter)
  local Layout = require 'nui.layout'

  state.filter = filter
  if filter.installed == 'remote' then
    local colorschemes_data = vim.json.decode(
      filesystem.read_file(
        vim.fn.stdpath 'data' .. '/lazy/caipirinha.nvim/colorschemes.json'
      )
    )

    local colors = {}
    for _, color_data in pairs(colorschemes_data) do
      if color_data.colorschemes then
        for _, colorscheme_data in ipairs(color_data.colorschemes) do
          if type(colorscheme_data) == 'table' then
            table.insert(colors, {
              disp_name = colorschemes_data.disp_name or colorschemes_data.name,
              name = colorschemes_data.name,
            })
          elseif type(colorscheme_data) == 'string' then
            table.insert(
              colors,
              {
                disp_name = color_data.disp_name or colorschemes_data,
                name = colorschemes_data,
              }
            )
          end
        end
      else
        table.insert(colors, color_data)
      end
    end

    -- table.sort(colors)

    state.colors = colors
  else
    state.colors = colorscheme.get_installed_colorschemes(state.filter)
  end
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
    local item = nil
    if type(color) == 'table' then
      item = Menu.item(
        ' ' .. (color.disp_name or 'nil'),
        { colors_name = color.disp_name }
      )
    else
      item = Menu.item(' ' .. color, { colors_name = color })
    end
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
      vim.schedule(function()
        close_window()
        vim.cmd.colorscheme(colorscheme._get_current_colorscheme())
      end)
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
  menu:map(
    'n',
    '4',
    function() apply_filter { installed = 'remote' } end,
    { noremap = true }
  )

  return menu
end

return M
