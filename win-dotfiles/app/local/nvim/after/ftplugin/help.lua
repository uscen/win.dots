--              ╔═════════════════════════════════════════════════════════╗
--              ║                           Help                          ║
--              ╚═════════════════════════════════════════════════════════╝
-- Options: =====================================================================================
vim.opt_local.list          = not vim.opt_local.list
vim.opt_local.foldenable    = false
vim.opt_local.buflisted     = false
vim.opt_local.laststatus    = 0
vim.opt_local.concealcursor = 'nc'
-- Autocmds: =====================================================================================
vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.api.nvim_exec2('wincmd L', {})
    vim.cmd.wincmd('=')
  end,
})
