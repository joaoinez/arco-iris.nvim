local colorscheme = require 'caipirinha.colorscheme'
local filesystem = require 'caipirinha.filesystem'
local picker = require 'caipirinha.picker'

local M = {}

local function with_defaults(options)
  return {
    auto_start = options.auto_start or true,
    picker = options.picker or 'fzf',
    filter = {
      installed = (options.filter or {}).installed,
    },
    callback = options.callback,
    random = {
      enabled = (options.random or {}).enabled or false,
      colorschemes = (options.random or {}).colorschemes or {},
    },
  }
end

local function is_configured() return M.options ~= nil end

function M.setup(options)
  M.options = with_defaults(options)

  local path = filesystem.colorscheme_config_path
  local default_colorscheme_config = {
    colorscheme = vim.g.colors_name or 'default',
  }

  if not filesystem.file_exists(path) then filesystem.write_file(path, vim.json.encode(default_colorscheme_config)) end

  local colors_name = colorscheme.get_current_colorscheme()

  if M.options.random.enabled then
    local random_colorscheme = colorscheme.get_random_colorscheme(M.options.random.colorschemes)

    filesystem.write_colorscheme(random_colorscheme)

    colors_name = random_colorscheme
  end

  if M.options.auto_start then
    colorscheme.apply_colorscheme(colors_name)
    colorscheme.execute_callback(M.options.callback)
  end

  vim.api.nvim_create_user_command('ColorschemeSwitch', M.switch_colorscheme, {})
end

function M.switch_colorscheme()
  if not is_configured() then return end

  picker.pick(M.options.picker, function(color)
    colorscheme.apply_colorscheme(color)
    colorscheme.execute_callback(M.options.callback)
  end, M.options.filter)
end

M.options = nil

return M
