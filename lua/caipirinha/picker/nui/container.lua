local state = require 'caipirinha.picker.nui.state'

local M = {}

function M.init()
  local width = math.floor(vim.o.columns * 0.5)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = width,
    height = math.floor(vim.o.lines * 0.5),
    style = 'minimal',
    row = 0,
    col = math.floor(vim.o.columns * 0.99) - width,
    border = 'rounded',
    title = 'Colorschemes',
    -- footer = 'keybinds',
  })

  state.ui.container = { win = win, buf = buf }
end

return M
