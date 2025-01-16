local M = {}

function M.init()
  local Popup = require 'nui.popup'
  local NuiText = require 'nui.text'
  local NuiLine = require 'nui.line'

  local preview = Popup {
    border = {
      style = { ' ', '', ' ', ' ', ' ', '', ' ', '│' },
    },
    buf_options = {
      buftype = '',
      filetype = 'lua',
    },
    win_options = {
      winhighlight = 'Normal:Normal',
    },
  }

  local code = [[
-- Preview
 
local print = vim.print
 
---@param n integer
local function fizz_buzz(n)
  if n == nil then
    n = 42
  end
 
  for i = 1, n do
    if i % 15 == 0 then
      print("FizzBuzz")
    elseif i % 3 == 0 then
      print("Fizz")
    elseif i % 5 == 0 then
      print("Buzz")
    else
      print(i)
    end
  end
end
 
fizz_buzz(42)
  ]]

  local lines = {}
  for line in string.gmatch(code, '[^\n]+') do
    table.insert(lines, line)
  end

  for i, line in ipairs(lines) do
    if i ~= #lines then
      local cursor_line = NuiText((i < 10 and '   ' or '  ') .. i .. '  ', i == 6 and 'CursorLineNr' or 'LineNr')
      -- TODO: Improve this
      local nui_text = NuiText(line, i == 6 and 'CursorLine' or nil)
      local nui_line = NuiLine { cursor_line, nui_text }

      nui_line:render(preview.bufnr, -1, i)
    end
  end

  return preview
end

return M
