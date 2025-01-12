local files = require 'caipirinha.filesystem'

local M = {}

function M.apply_colorscheme(colorscheme)
  local path = files.colorscheme_config_path

  local colorscheme_config = vim.json.decode(files.read_file(path))
  colorscheme_config.colorscheme = colorscheme

  files.write_file(path, vim.json.encode(colorscheme_config))

  vim.g.colors_name = colorscheme

  vim.cmd.colorscheme(colorscheme)
end

return M
