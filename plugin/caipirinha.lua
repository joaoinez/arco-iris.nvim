if vim.fn.has 'nvim-0.10.0' == 0 then
  vim.api.nvim_err_writeln 'caipirinha.nvim requires at least nvim-0.10.0.1'
  return
end

if vim.g.loaded_caipirinha == 1 then return end
vim.g.loaded_caipirinha = 1
