---@diagnostic disable: undefined-field

local state = require 'caipirinha.picker.nui.state'

local M = {}

local function get_button_hl(on) return on and 'CaipirinhaButtonActive' or 'CaipirinhaButton' end

local function create_tab(text, keybind, active)
  local Popup = require 'nui.popup'
  local NuiText = require 'nui.text'
  local NuiLine = require 'nui.line'

  local col = 2
  if #state.ui.tabs > 0 then
    for _, tab in ipairs(state.ui.tabs) do
      col = col + vim.api.nvim_win_get_config(tab.instance.winid).width + 2
    end
  end

  local tab = Popup {
    zindex = 62,
    enter = false,
    focusable = false,
    border = 'none',
    relative = {
      type = 'win',
      winid = state.ui.header.instance.winid,
    },
    position = {
      row = 0,
      col = col,
    },
    size = {
      width = #text + 1 + 5,
      height = 1,
    },
    win_options = {
      winhighlight = 'Normal:' .. get_button_hl(active),
    },
  }

  tab:mount()

  local nui_text = NuiText(' ' .. text)
  local nui_kb = NuiText((' (%s) '):format(keybind), 'CaipirinhaKeybind')
  local line = NuiLine {
    nui_text,
    nui_kb,
  }

  line:render(tab.bufnr, -1, 1)

  local tabs = { unpack(state.ui.tabs) }

  table.insert(tabs, #tabs + 1, { id = text:lower(), instance = tab, active = active })

  state.ui.tabs = tabs
end

function M.init()
  local Popup = require 'nui.popup'

  local header = Popup {
    zindex = 61,
    enter = false,
    focusable = false,
    border = 'none',
    relative = {
      type = 'win',
      winid = state.ui.container.win,
    },
    position = {
      row = 1,
      col = '100%',
    },
    size = {
      width = '100%',
      height = 1,
    },
  }

  state.ui.header = {
    instance = header,
    init = M.init,
  }

  header:mount()

  create_tab('All', '1', state.filter.installed == 'all')
  create_tab('User', '2', state.filter.installed == 'user')
  create_tab('Default', '3', state.filter.installed == 'default')
end

return M
