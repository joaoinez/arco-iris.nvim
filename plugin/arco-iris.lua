---@diagnostic disable: duplicate-doc-field

if vim.fn.has 'nvim-0.10.0' == 0 then
  vim.api.nvim_err_writeln 'arco-iris.nvim requires at least nvim-0.10.0.1'
  return
end

if vim.g.loaded_arco-iris == 1 then return end
vim.g.loaded_arco-iris = 1
