--              ╔═════════════════════════════════════════════════════════╗
--              ║                         Git Commit                      ║
--              ╚═════════════════════════════════════════════════════════╝
-- Options: ======================================================================================
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'
vim.opt_local.wrap = true
vim.opt_local.foldlevel = 1
vim.opt_local.textwidth = 72
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'v:lua.MiniGit.diff_foldexpr()'
vim.opt_local.colorcolumn = '+1'
-- Keymaps: ======================================================================================
vim.keymap.set('n', '<enter>', function() vim.cmd('normal! ZZ') end)
-- Others: =======================================================================================
vim.fn.setpos('.', { 0, 1, 1, 0 })
vim.cmd.startinsert()
vim.cmd([[match ErrorMsg /\%1l.\%>51v/]])
vim.fn.matchadd('DiffChange', '\\<a/[^ \t\r\n]\\+')
vim.fn.matchadd('DiffAdd', '\\<b/[^ \t\r\n]\\+')
