local M = {}

-- From: https://github.com/brianhuster/live-preview.nvim/blob/main/lua/livepreview/picker.lua
function M.pick(callback, filter)
  local MiniPick = require 'mini.pick'
  local colorschemes = require 'caipirinha.colorscheme'
  local colors = colorschemes.get_installed_colorschemes(filter)

  local source = {
    items = colors,
    name = 'Colorschemes',
    choose = function(item) callback(item) end,
  }

  local win_config = function()
    local height = math.floor(0.8 * vim.o.lines)
    local width = math.floor(0.5 * vim.o.columns)
    return {
      anchor = 'NW',
      height = height,
      width = width,
      row = 0,
      col = (vim.o.columns - width),
    }
  end

  MiniPick.start {
    source = source,
    window = {
      config = win_config(),
    },
  }
end

return setmetatable(M, {
  __call = function(self, ...) return self.pick(...) end,
})
