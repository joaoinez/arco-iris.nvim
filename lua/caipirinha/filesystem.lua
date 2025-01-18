--- Functions to read, write and check for files in the filesystem.
---
---@module 'caipirinha.filesystem'
---
local M = {}

M.colorscheme_config_path = vim.fn.stdpath 'data'
  .. '/caipirinha.nvim/colorscheme.json'

--- Checks if a file exists in the given path
---
---@param path string
---@return boolean
function M.file_exists(path) return vim.uv.fs_stat(path) ~= nil end

--- Reads file in the given path
---
---@param path string
---@return string
function M.read_file(path)
  local fd = assert(io.open(path, 'r'))
  ---@type string
  local data = fd:read '*a'

  fd:close()

  return data
end

--- Writes file in the given path
---
---@param path string
---@param contents string
function M.write_file(path, contents)
  local dir = path:match '(.*/)'

  if dir then
    local is_windows = package.config:sub(1, 1) == '\\'

    if is_windows then
      os.execute('mkdir "' .. dir .. '"')
    else
      os.execute('mkdir -p "' .. dir .. '"')
    end
  end

  local fd = assert(io.open(path, 'w+'))

  fd:write(contents)
  fd:close()
end

--- Writes provided colorscheme in the colorscheme config file
---
---@param colorscheme string
function M.write_colorscheme(colorscheme)
  local colorscheme_config =
    vim.json.decode(M.read_file(M.colorscheme_config_path))

  colorscheme_config.colorscheme = colorscheme

  M.write_file(M.colorscheme_config_path, vim.json.encode(colorscheme_config))
end

return M
