local colorscheme = require 'arco-iris.colorscheme'
local picker = require 'arco-iris.picker'

--- Utilities to parse and run `ArcoIris` user command.
---
---@module 'arco-iris.commands'
---
local M = {}

--- Command runner with user options
---
---@param user_opts arco-iris.Options
---@return fun(cmd_opts: command.Options): nil
function M.runner(user_opts)
  ---@class command.Options
  ---@field fargs string[]

  ---@param cmd_opts command.Options
  local function command_runner(cmd_opts)
    local args = cmd_opts.fargs

    if args[1] == 'pick' then
      picker.pick(args[2] or 'nui', function(color)
        colorscheme.apply_colorscheme(color, true)
        colorscheme.execute_callback(user_opts.callback)
      end)
    elseif args[1] == 'apply' then
      if args[2] ~= nil then
        colorscheme.apply_colorscheme(args[2], true)
        colorscheme.execute_callback(user_opts.callback)
      end
    elseif args[1] == 'get_current_colorscheme' then
      -- TODO: Replace this with notify
      vim.print(colorscheme._get_current_colorscheme())
    end
  end

  return command_runner
end

--- Command parser for autocompletion
---
---@param _ any
---@param line string
---@return table | nil
function M.parser(_, line)
  local l = vim.split(line, '%s+')
  local n = #l - 2

  if n == 0 then
    local commands = { 'pick', 'apply', 'get_current_colorscheme' }
    commands = vim.iter(commands):flatten():totable()
    table.sort(commands)

    return vim.tbl_filter(
      function(val) return vim.startswith(val, l[2]) end,
      commands
    )
  end

  if n == 1 then
    local commands = {}
    if l[2] == 'pick' then
      commands = { 'fzf', 'telescope', 'mini', 'snacks', 'nui' }
    elseif l[2] == 'apply' then
      commands = colorscheme.get_installed_colorschemes()
    end

    commands = vim.iter(commands):flatten():totable()
    table.sort(commands)

    return vim.tbl_filter(
      function(val) return vim.startswith(val, l[3]) end,
      commands
    )
  end
end

return M
