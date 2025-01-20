--- All functions and data to help customize `caipirinha` for this user.
---
---@module 'caipirinha.config'
---
local M = {}

---@class caipirinha.Options
---@field auto_start? boolean
---@field picker? caipirinha.Options.picker
---@field filter? caipirinha.Options.filter
---@field callback? fun(): nil
---@field random? caipirinha.Options.random

---@alias caipirinha.Options.picker "nui" | 'fzf' | "telescope" | 'mini' | 'snacks'

---@class caipirinha.Options.filter
---@field installed? 'all' | 'user' | 'default'

---@class caipirinha.Options.random
---@field enabled boolean
---@field colorschemes string[]

---@type caipirinha.Options
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
---@param options? caipirinha.Options
---@return caipirinha.Options
function M.with_defaults(options)
  return vim.tbl_deep_extend('force', defaults, options or {})
end

M.default_colorscheme_config = {
  colorscheme = vim.g.colors_name or 'default',
}

return M
