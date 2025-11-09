--              ╔═════════════════════════════════════════════════════════╗
--              ║                          Bigfile                        ║
--              ╚═════════════════════════════════════════════════════════╝
-- Options: ======================================================================================
vim.opt_local.undofile = false
vim.opt_local.swapfile = false
vim.opt_local.spell = false
vim.opt_local.backup = false
vim.opt_local.writebackup = false
vim.opt_local.shiftround = false
vim.opt_local.autoindent = false
vim.opt_local.smartindent = false
vim.opt_local.hlsearch = false
vim.opt_local.expandtab = false
vim.opt_local.linebreak = false
vim.opt_local.breakindent = false
vim.opt_local.foldenable = false
vim.opt_local.foldexpr = '0'
vim.opt_local.foldmethod = 'manual'
vim.opt_local.showbreak = ''
vim.opt_local.statuscolumn = ''
vim.opt_local.breakindentopt = ''
vim.opt_local.virtualedit = ''
vim.opt_local.indentexpr = ''
vim.opt_local.concealcursor = ''
vim.opt_local.conceallevel = 0
vim.opt_local.softtabstop = 0
-- Disable Plugins: ==============================================================================
vim.b.minicompletion_disable = true
vim.b.minisnippets_disable = true
vim.b.minihipatterns_disable = true
vim.b.minidiff_disable = true
-- Disable builtin: ==============================================================================
if vim.fn.exists ':NoMatchParen' ~= 0 then
  vim.cmd 'NoMatchParen'
end
vim.bo.syntax = 'off'
vim.diagnostic.enable(false, { bufnr = 0 })
vim.schedule(function()
  vim.bo.syntax = vim.filetype.match { buf = 0 } or ''
end)
