--              ╔═════════════════════════════════════════════════════════╗
--              ║                         Quickfix                        ║
--              ╚═════════════════════════════════════════════════════════╝
-- Options: ======================================================================================
vim.opt_local.number = false
vim.opt_local.buflisted = false
vim.opt_local.winfixbuf = true
vim.opt_local.colorcolumn = ''
vim.cmd.packadd 'cfilter'
-- Keymaps: ======================================================================================
vim.keymap.set('n', '<S-j>', '<cmd>cn<CR>zz<cmd>wincmd p<CR>', { buffer = 0, silent = true })
vim.keymap.set('n', '<S-k>', '<cmd>cN<CR>zz<cmd>wincmd p<CR>', { buffer = 0, silent = true })
vim.keymap.set('n', '<Tab>', '<CR>', { buffer = 0, silent = true })
vim.keymap.set('n', '<cr>', '<cr>:cclose<cr>', { buffer = 0, silent = true })
-- Edit all in quickfix list: ====================================================================
vim.keymap.set('n', 'o', '<cmd>silent! cfdo edit %<cr>',
  { buffer = 0, silent = true, desc = 'Edit all in quickfix list' })
-- Search and replace all in quickfix list: ======================================================
vim.keymap.set('n', 'r', function()
  return ':cdo s///gc<Left><Left><Left><Left>'
end, { silent = false, expr = true, noremap = true, desc = 'Search and replace all in quickfix list' })
-- Clear the quickfix list: ======================================================================
vim.keymap.set('n', 'lc', function()
  vim.fn.setqflist({}, 'r')
  vim.cmd.cclose()
end, { desc = 'Clear the quickfix list' })
-- Remove item under cursor: =====================================================================
vim.keymap.set('n', 'dd', function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local items = vim.fn.getqflist()
  table.remove(items, cursor[1])
  vim.fn.setqflist(items, 'r')
  -- close quickfix on last item remove: =========================================================
  if #items == 0 then
    vim.cmd.cclose()
  end
end, { buffer = 0, silent = true, desc = 'Remove item under cursor' })
-- toggle qflist: ================================================================================
vim.keymap.set('n', '<leader>lt', function()
  local orig = vim.fn.winnr('$')
  vim.cmd.cwindow()
  local new = vim.fn.winnr('$')

  if orig == new then
    vim.cmd.cclose()
  end
end, { buffer = 0, silent = true, desc = 'Remove item under cursor' })
-- toggle localist: ================================================================================
vim.keymap.set('n', '<leader>ll', function()
  local window = vim.api.nvim_get_current_win()

  if vim.tbl_count(vim.fn.getloclist(window)) == 0 then
    return
  end

  local orig = vim.fn.winnr('$')
  vim.cmd.lwindow()
  local new = vim.fn.winnr('$')

  if orig == new then
    vim.cmd.lclose()
  end
end, { buffer = 0, silent = true, desc = 'Remove item under cursor' })
