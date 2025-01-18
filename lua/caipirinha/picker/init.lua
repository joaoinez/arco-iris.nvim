--- Picker integrations for caipirinha.
---
---@module 'caipirinha.picker'
---
local M = {}

M.fzf = require 'caipirinha.picker.fzf'
M.telescope = require 'caipirinha.picker.telescope'
M.mini = require 'caipirinha.picker.mini'
M.snacks = require 'caipirinha.picker.snacks'
M.nui = require 'caipirinha.picker.nui'

-- NOTE: From https://github.com/brianhuster/live-preview.nvim/blob/main/lua/livepreview/picker.lua

--- This function will try to use fzf-lua, telescope.nvim, mini.pick, snacks.picker
--- or nui to open a picker to select a colorscheme
---
---@param picker caipirinha.Options.picker
---@param callback function: Callback function to run after selecting a colorscheme
---@param filter? caipirinha.Options.filter
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
