local colorscheme = require 'arco-iris.colorscheme'
local commands = require 'arco-iris.commands'
local config = require 'arco-iris.config'
local picker = require 'arco-iris.picker'

--- Public API for users to setup and use arco-iris.
---
---@module 'arco-iris'
---
local M = {}

--- Returns whether the setup function has been called by the user or not
---
---@return boolean
local function is_configured() return M.options ~= nil end

--- Plugin setup function
---
---@param options? arco-iris.Options
function M.setup(options)
  M.options = config.with_defaults(options)

  colorscheme.start(M.options)

  vim.api.nvim_create_user_command('ArcoIris', commands.runner(M.options), {
    nargs = '*',
    complete = commands.parser,
  })
end

--- Returns current colorscheme
---
---@return string
function M.get_current_colorscheme()
  return colorscheme._get_current_colorscheme()
end

--- Applies and optionally saves provided colorscheme
---
---@param name string
---@param save? boolean
function M.apply_colorscheme(name, save)
  if not name then return end
  if save == nil then save = true end

  colorscheme.apply_colorscheme(name, save)
  colorscheme.execute_callback(M.options.callback)
end

---@class picker.Options
---@field picker? arco-iris.Options.picker
---@field filter? arco-iris.Options.filter

--- Calls provided picker to view and apply colorschemes
---
---@param opts? picker.Options
function M.pick_colorscheme(opts)
  if not is_configured() then return end
  if opts == nil then opts = {} end

  picker.pick(opts.picker or M.options.picker or 'nui', function(color)
    colorscheme.apply_colorscheme(color, true)
    colorscheme.execute_callback(M.options.callback)
  end, opts.filter or M.options.filter)
end

M.options = nil

return M
