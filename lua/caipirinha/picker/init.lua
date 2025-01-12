---@diagnostic disable: undefined-field

local M = {}

M.fzf_lua = require('caipirinha.picker.fzf-lua').pick

-- From: https://github.com/brianhuster/live-preview.nvim/blob/main/lua/livepreview/picker.lua
---@brief Open a picker to select a colorscheme.
---
---This function will try to use fzf-lua, telescope.nvim, or mini.pick to open a picker to select a colorscheme.
---@param callback function: Callback function to run after selecting a colorscheme
function M.pick(picker, callback, filter)
  if picker == 'fzf' and pcall(require, 'fzf-lua') then
    M.fzf_lua(callback, filter)
  elseif picker == 'telescope' and pcall(require, 'telescope') then
    M.telescope(callback, filter)
  elseif picker == 'mini' and pcall(require, 'mini.pick') then
    M.minipick(callback, filter)
  else
    vim.api.nvim_err_writeln 'No picker found. Please install fzf-lua, telescope.nvim, or mini.pick'
  end
end

return M
