--              ╔═════════════════════════════════════════════════════════╗
--              ║                           Help                          ║
--              ╚═════════════════════════════════════════════════════════╝
-- Options: =====================================================================================
vim.opt_local.list          = not vim.opt_local.list
vim.opt_local.foldenable    = false
vim.opt_local.buflisted     = false
vim.opt_local.laststatus    = 0
vim.opt_local.conceallevel  = 0
vim.opt_local.concealcursor = 'nc'
-- Autocmds: ====================================================================================
vim.api.nvim_create_autocmd('BufWinEnter', {
  buffer = 0,
  once = true,
  callback = function()
    vim.cmd('wincmd J')
    vim.cmd('horizontal resize 10')
    local help_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_option_value('winfixheight', true, { win = help_win })
  end,
})
