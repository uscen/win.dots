--              ╔═════════════════════════════════════════════════════════╗
--              ║                          Bigfile                        ║
--              ╚═════════════════════════════════════════════════════════╝
-- Options: ======================================================================================
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.cursorline = false
vim.opt_local.wrap = false
vim.opt_local.linebreak = false
vim.opt_local.statuscolumn = ''
vim.opt_local.showbreak = ''
vim.opt_local.smoothscroll = false
vim.opt_local.foldenable = false
vim.opt_local.foldmethod = 'manual'
vim.opt_local.foldexpr = '0'
vim.opt_local.spell = false
vim.opt_local.conceallevel = 0
vim.opt_local.concealcursor = ''
vim.opt_local.breakindent = false
vim.opt_local.breakindentopt = ''
vim.opt_local.virtualedit = ''
vim.opt_local.shiftround = false
vim.opt_local.hlsearch = false
vim.bo.undofile = false
vim.bo.swapfile = false
vim.bo.backup = false
vim.bo.writebackup = false
vim.bo.autoindent = false
vim.bo.indentexpr = ''
vim.bo.smartindent = false
vim.bo.expandtab = false
vim.bo.softtabstop = 0
vim.bo.shiftwidth = 8
-- Disable Plugins: ==============================================================================
vim.b.minicompletion_disable = true
vim.b.minisnippets_disable = true
vim.b.minihipatterns_disable = true
-- Disable Treesitter: ===========================================================================
vim.defer_fn(function()
  vim.treesitter.stop()
end, 100)
-- Disable builtin: ==============================================================================
if vim.fn.exists ':NoMatchParen' ~= 0 then
  vim.cmd 'NoMatchParen'
end
vim.bo.syntax = 'off'
vim.diagnostic.enable(false, { bufnr = 0 })
vim.schedule(function()
  vim.bo.syntax = vim.filetype.match { buf = 0 } or ''
end)
vim.notify('Large file detected. Some features disabled.', vim.log.levels.WARN)
