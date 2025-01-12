if vim.fn.has 'nvim-0.5.0' == 0 then
  vim.api.nvim_err_writeln 'caipirinha.nvim requires at least nvim-0.5.0.1'
  return
end

if vim.g.loaded_caipirinha == 1 then return end
vim.g.loaded_caipirinha = 1
