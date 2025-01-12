-- local Layout = require 'nui.layout'
-- local Menu = require 'nui.menu'
-- local Popup = require 'nui.popup'
-- local colorschemes = require 'caipirinha.colorschemes'
-- -- local event = require('nui.utils.autocmd').event
-- --   Info  07:18:30 PM notify.info [Fzf-lua] Cloning Everforest (everforest-nvim) [path:~/.cache/nvim/fzf-lua/pack/fzf-lua/opt/everforest-nvim] [job_id:45]...
--
-- local M = {}
--
-- function M.pick()
--   local lines = {}
--   for _, color in ipairs(colorschemes.get()) do
--     local item = Menu.item(color)
--     table.insert(lines, item)
--   end
--
--   local boxes = {
--     a = Menu({
--       border = {
--         style = 'single',
--         text = {
--           top = '[Colorschemes]',
--           top_align = 'center',
--           bottom = '[Colorschemes]',
--           bottom_align = 'center',
--         },
--       },
--       win_options = {
--         winhighlight = 'Normal:Normal,FloatBorder:Normal',
--       },
--     }, {
--       lines = lines,
--       max_width = 20,
--       keymap = {
--         focus_next = { 'j', '<Down>', '<Tab>' },
--         focus_prev = { 'k', '<Up>', '<S-Tab>' },
--         close = { 'q', '<Esc>', '<C-c>' },
--         submit = { '<CR>', '<Space>' },
--       },
--       on_close = function() vim.cmd.colorscheme(vim.g.colorscheme) end,
--       on_submit = function(item) print('Menu Submitted: ', item.text) end,
--       on_change = function(item) vim.cmd.colorscheme(item.text) end,
--     }),
--     b = Popup {
--       enter = true,
--       border = 'single',
--     },
--   }
--
--   local layout = Layout(
--     {
--       relative = 'editor',
--       position = {
--         row = 0,
--         col = '100%',
--       },
--       size = {
--         width = math.floor(vim.o.columns * 0.5),
--         height = math.floor(vim.o.lines * 0.33),
--       },
--     },
--     Layout.Box({
--       Layout.Box(boxes.a, { grow = 1 }),
--       Layout.Box(boxes.b, { grow = 1 }),
--     }, { dir = 'row' })
--   )
--
--   for _, box in pairs(boxes) do
--     box:on('BufLeave', function()
--       vim.schedule(function()
--         local curr_bufnr = vim.api.nvim_get_current_buf()
--         for _, p in pairs(boxes) do
--           if p.bufnr == curr_bufnr then return end
--         end
--         layout:unmount()
--       end)
--     end)
--   end
--
--   return layout
-- end
--
-- return M
