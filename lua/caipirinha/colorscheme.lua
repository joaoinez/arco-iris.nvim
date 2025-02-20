local config = require 'caipirinha.config'
local filesystem = require 'caipirinha.filesystem'

--- All operations related to applying colorschemes.
---
---@module 'caipirinha.colorscheme'
---
local M = {}

M.default_colorschemes = {
  'blue',
  'darkblue',
  'default',
  'delek',
  'desert',
  'elflord',
  'evening',
  'habamax',
  'industry',
  'koehler',
  'lunaperche',
  'morning',
  'murphy',
  'pablo',
  'peachpuff',
  'quiet',
  'retrobox',
  'ron',
  'shine',
  'slate',
  'sorbet',
  'torte',
  'unokai',
  'vim',
  'wildcharm',
  'zaibatsu',
  'zellner',
}

--- Starts up colorschemes
---
---@param options caipirinha.Options
function M.start(options)
  local path = filesystem.colorscheme_config_path

  -- TODO: Abstract this
  if not filesystem.file_exists(path) then
    filesystem.write_file(
      path,
      vim.json.encode(config.default_colorscheme_config)
    )
  end

  local colors_name = M._get_current_colorscheme()
  local write = true

  if options.random.enabled then
    local random_colorscheme =
      M.get_random_colorscheme(options.random.colorschemes)

    colors_name = random_colorscheme
    write = false
  end

  if options.auto_start == true then
    M.apply_colorscheme(colors_name, write)
    M.execute_callback(options.callback)
  end
end

--- Returns current colorscheme
---
---@return string
function M._get_current_colorscheme()
  if filesystem.file_exists(filesystem.colorscheme_config_path) then
    return vim.json.decode(
      filesystem.read_file(filesystem.colorscheme_config_path)
    ).colorscheme
  elseif vim.g.colors_name then
    return vim.g.colors_name
  else
    return 'default'
  end
end

--- Returns all colorschemes detected by neovim
---
---@param filter? caipirinha.Options.filter
---@return string[]
function M.get_installed_colorschemes(filter)
  if filter == nil then filter = {} end

  local colors = vim.fn.getcompletion('', 'color')

  if filter.installed == 'default' then return M.default_colorschemes end

  if filter.installed == 'user' then
    local filtered_colors = {}
    for _, color in ipairs(colors) do
      local is_default = false
      for _, default_color in ipairs(M.default_colorschemes) do
        if color == default_color then
          is_default = true
          break
        end
      end
      if not is_default then table.insert(filtered_colors, color) end
    end
    colors = filtered_colors
  end

  local lazy = package.loaded['lazy.core.util']
  if lazy and lazy.get_unloaded_rtp then
    local paths = lazy.get_unloaded_rtp ''
    local all_files =
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.fn.globpath(table.concat(paths, ','), 'colors/*', 1, 1)
    for _, f in ipairs(all_files) do
      table.insert(colors, vim.fn.fnamemodify(f, ':t:r'))
    end
  end

  for i, color in ipairs(colors) do
    if color == M._get_current_colorscheme() then
      table.remove(colors, i)
      table.insert(colors, 1, color)
      break
    end
  end

  return colors
end

--- Returns a random colorscheme
---
---@param colorschemes string[]
---@return string
function M.get_random_colorscheme(colorschemes)
  math.randomseed(os.time())
  local random_colorscheme = colorschemes[math.random(#colorschemes)]

  return random_colorscheme
end

--- Applies provided colorscheme and optionally writes it to the config file
---
---@param colorscheme string
---@param write boolean
function M.apply_colorscheme(colorscheme, write)
  if write then filesystem.write_colorscheme(colorscheme) end

  vim.g.colors_name = colorscheme

  vim.cmd.colorscheme(colorscheme)
end

--- Executes provided callback function
---
---@param callback function
function M.execute_callback(callback)
  if callback then callback(vim.g.colors_name) end
end

return M
