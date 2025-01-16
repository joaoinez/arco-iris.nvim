local colorscheme = require 'caipirinha.colorscheme'
local filesystem = require 'caipirinha.filesystem'
local picker = require 'caipirinha.picker'

local M = {}

local function with_defaults(options)
  local filter = options.filter or {}
  local random = options.random or {}

  return {
    auto_start = options.auto_start or true,
    picker = options.picker or 'nui',
    filter = {
      installed = filter.installed or 'user',
    },
    callback = options.callback,
    random = {
      enabled = random.enabled or false,
      colorschemes = random.colorschemes or {},
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
  local write = true

  if M.options.random.enabled then
    local random_colorscheme = colorscheme.get_random_colorscheme(M.options.random.colorschemes)

    colors_name = random_colorscheme
    write = false
  end

  if M.options.auto_start then
    colorscheme.apply_colorscheme(colors_name, write)
    colorscheme.execute_callback(M.options.callback)
  end

  vim.api.nvim_create_user_command('Caipirinha', function(opts)
    local args = opts.fargs

    if args[1] == 'pick' then
      M.pick_colorscheme { picker = args[2] }
    elseif args[1] == 'apply' then
      M.apply_colorscheme(args[2])
    elseif args[1] == 'get_current_colorscheme' then
      vim.print(M.get_current_colorscheme())
    end
  end, {
    nargs = '*',
    complete = function(_, line)
      local l = vim.split(line, '%s+')
      local n = #l - 2

      if n == 0 then
        local commands = { 'pick', 'apply', 'get_current_colorscheme' }
        commands = vim.iter(commands):flatten():totable()
        table.sort(commands)

        return vim.tbl_filter(function(val) return vim.startswith(val, l[2]) end, commands)
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

        return vim.tbl_filter(function(val) return vim.startswith(val, l[3]) end, commands)
      end
    end,
  })
end

function M.get_current_colorscheme() return colorscheme.get_current_colorscheme() end

function M.apply_colorscheme(name, save)
  if not name then return end
  if save == nil then save = true end

  colorscheme.apply_colorscheme(name, save)
  colorscheme.execute_callback(M.options.callback)
end

function M.pick_colorscheme(opts)
  if not is_configured() then return end
  if opts == nil then opts = {} end

  picker.pick(opts.picker or M.options.picker, function(color)
    colorscheme.apply_colorscheme(color, true)
    colorscheme.execute_callback(M.options.callback)
  end, opts.filter or M.options.filter)
end

M.options = nil

return M
