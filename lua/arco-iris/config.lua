--- All functions and data to help customize `arco-iris` for this user.
---
---@module 'arco-iris.config'
---
local M = {}

---@class arco-iris.Options
---@field auto_start? boolean
---@field picker? arco-iris.Options.picker
---@field filter? arco-iris.Options.filter
---@field callback? fun(): nil
---@field random? arco-iris.Options.random

---@alias arco-iris.Options.picker "nui" | 'fzf' | "telescope" | 'mini' | 'snacks'

---@class arco-iris.Options.filter
---@field installed? 'all' | 'user' | 'default'

---@class arco-iris.Options.random
---@field enabled boolean
---@field colorschemes string[]

---@type arco-iris.Options
local defaults = {
  auto_start = true,
  picker = 'nui',
  filter = {
    installed = 'user',
  },
  callback = nil,
  random = {
    enabled = false,
    colorschemes = {},
  },
}

--- Applies user options
---
---@param options? arco-iris.Options
---@return arco-iris.Options
function M.with_defaults(options)
  return vim.tbl_deep_extend('force', defaults, options or {})
end

M.default_colorscheme_config = {
  colorscheme = vim.g.colors_name or 'default',
}

return M
