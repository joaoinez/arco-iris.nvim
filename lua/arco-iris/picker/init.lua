--- Picker integrations for arco-iris.
---
---@module 'arco-iris.picker'
---
local M = {}

M.fzf = require 'arco-iris.picker.fzf'
M.telescope = require 'arco-iris.picker.telescope'
M.mini = require 'arco-iris.picker.mini'
M.snacks = require 'arco-iris.picker.snacks'
M.nui = require 'arco-iris.picker.nui'

-- NOTE: From https://github.com/brianhuster/live-preview.nvim/blob/main/lua/livepreview/picker.lua

--- This function will try to use fzf-lua, telescope.nvim, mini.pick, snacks.picker
--- or nui to open a picker to select a colorscheme
---
---@param picker arco-iris.Options.picker
---@param callback function: Callback function to run after selecting a colorscheme
---@param filter? arco-iris.Options.filter
function M.pick(picker, callback, filter)
  if picker == 'fzf' and pcall(require, 'fzf-lua') then
    M.fzf(callback, filter)
  elseif picker == 'telescope' and pcall(require, 'telescope') then
    M.telescope(callback, filter)
  elseif picker == 'mini' and pcall(require, 'mini.pick') then
    M.mini(callback, filter)
  elseif picker == 'snacks' and pcall(require, 'snacks.picker') then
    M.snacks(callback, filter)
  elseif picker == 'nui' and pcall(require, 'nui.popup') then
    M.nui(callback, filter)
  else
    vim.api.nvim_err_writeln 'No picker found. Please install fzf-lua, telescope.nvim, mini.pick or nui.nvim'
  end
end

return M
