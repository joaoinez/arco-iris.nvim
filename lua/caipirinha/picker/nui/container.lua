local ui = require 'caipirinha.picker.nui.ui'

--- nui UI container.
---
---@module 'caipirinha.picker.nui.container'
---
local M = {}

--- Init function for nui container
---
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

  ui.container = { win = win }
end

return M
