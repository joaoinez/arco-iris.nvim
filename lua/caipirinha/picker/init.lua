---@diagnostic disable: undefined-field

local M = {}

M.fzf = require 'caipirinha.picker.fzf'
M.telescope = require 'caipirinha.picker.telescope'
M.mini = require 'caipirinha.picker.mini'
M.nui = require 'caipirinha.picker.nui'

-- From: https://github.com/brianhuster/live-preview.nvim/blob/main/lua/livepreview/picker.lua
---@brief Open a picker to select a colorscheme.
---
---This function will try to use fzf-lua, telescope.nvim, or mini.pick to open a picker to select a colorscheme.
---@param callback function: Callback function to run after selecting a colorscheme
function M.pick(picker, callback, filter)
  if picker == 'fzf' and pcall(require, 'fzf-lua') then
    M.fzf(callback, filter)
  elseif picker == 'telescope' and pcall(require, 'telescope') then
    M.telescope(callback, filter)
  elseif picker == 'mini' and pcall(require, 'mini.pick') then
    M.mini(callback, filter)
  elseif picker == 'nui' and pcall(require, 'nui.popup') then
    M.nui(callback, filter)
  else
    vim.api.nvim_err_writeln 'No picker found. Please install fzf-lua, telescope.nvim, mini.pick or nui.nvim'
  end
end

return M
