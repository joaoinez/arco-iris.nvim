---@diagnostic disable: duplicate-doc-field

if vim.fn.has 'nvim-0.10.0' == 0 then
  vim.api.nvim_err_writeln 'caipirinha.nvim requires at least nvim-0.10.0.1'
  return
end

if vim.g.loaded_caipirinha == 1 then return end
vim.g.loaded_caipirinha = 1

local highlights = {
  CaipirinhaButton = { default = true, link = 'CursorLine' },
  CaipirinhaButtonActive = { default = true, link = 'Visual' },
  CaipirinhaKeybind = { default = true, link = '@punctuation.special' },
}

for hl_name, hl_config in pairs(highlights) do
  vim.api.nvim_set_hl(0, hl_name, hl_config)
  vim.api.nvim_command 'redraw'
end
