local filesystem = require 'caipirinha.filesystem'

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
  'vim',
  'wildcharm',
  'zaibatsu',
  'zellner',
}

function M.get_current_colorscheme()
  if filesystem.file_exists(filesystem.colorscheme_config_path) then
    return vim.json.decode(filesystem.read_file(filesystem.colorscheme_config_path)).colorscheme
  elseif vim.g.colors_name then
    return vim.g.colors_name
  else
    return 'default'
  end
end

function M.get_installed_colorschemes(filter)
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
    ---@diagnostic disable-next-line: param-type-mismatch
    local all_files = vim.fn.globpath(table.concat(paths, ','), 'colors/*', 1, 1)
    for _, f in ipairs(all_files) do
      table.insert(colors, vim.fn.fnamemodify(f, ':t:r'))
    end
  end

  return colors
end

function M.get_random_colorscheme(colorschemes)
  math.randomseed(os.time())
  local random_colorscheme = colorschemes[math.random(#colorschemes)]

  return random_colorscheme
end

function M.apply_colorscheme(colorscheme)
  filesystem.write_colorscheme(colorscheme)

  vim.g.colors_name = colorscheme

  vim.cmd.colorscheme(colorscheme)
end

function M.execute_callback(callback)
  if callback then callback(vim.g.colors_name) end
end

return M
