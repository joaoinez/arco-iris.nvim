local M = {}

-- From: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/providers/colorschemes.lua
function M.pick(callback, filter)
  local actions = require 'fzf-lua.actions'
  local colorschemes = require 'caipirinha.colorscheme'
  local config = require 'fzf-lua.config'
  local core = require 'fzf-lua.core'
  local shell = require 'fzf-lua.shell'
  local utils = require 'fzf-lua.utils'

  local opts = {
    prompt = 'Colorschemes> ',
    live_preview = true,
    winopts = { row = 0, col = 0.99, width = 0.5, height = 0.5, backdrop = false },
    fzf_opts = { ['--no-multi'] = true },
    actions = { ['enter'] = actions.colorscheme },
    complete = function(selected) callback(selected[1]) end,
  }

  ---@diagnostic disable-next-line: cast-local-type
  opts = config.normalize_opts(opts, 'colorschemes')
  if not opts then return end

  local current_colorscheme = colorschemes.get_current_colorscheme()
  local current_background = vim.o.background
  local colors = colorschemes.get_installed_colorschemes(filter)

  if type(opts.ignore_patterns) == 'table' then
    colors = vim.tbl_filter(function(x)
      for _, p in ipairs(opts.ignore_patterns) do
        if x:match(p) then return false end
      end
      return true
    end, colors)
  end

  for i, c in ipairs(colors) do
    if c == current_colorscheme then
      table.remove(colors, i)
      table.insert(colors, 1, c)
      break
    end
  end

  if opts.live_preview then
    opts.fzf_opts['--preview-window'] = 'nohidden:right:0'
    opts.preview = shell.raw_action(function(sel)
      if opts.live_preview and sel then
        vim.cmd('colorscheme ' .. sel[1])
        if type(opts.cb_preview) == 'function' then opts.cb_preview(sel, opts) end
      end
    end, nil, opts.debug)
  end

  opts.fn_selected = function(selected, o)
    if opts.live_preview and (not selected or #selected[1] > 0) then
      vim.cmd('colorscheme ' .. current_colorscheme)
      vim.o.background = current_background
    end

    if selected then actions.act(opts.actions, selected, o) end

    utils.setup_highlights()

    if type(opts.cb_exit) == 'function' then opts.cb_exit(selected, opts) end
  end

  core.fzf_exec(colors, opts)
end

return setmetatable(M, {
  __call = function(self, ...) return self.pick(...) end,
})
