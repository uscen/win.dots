-- ============================================================================== #
-- Text:                                                                         #
-- ============================================================================== #
-- Options: ======================================================================================
vim.opt_local.textwidth   = 80
vim.opt_local.spell       = true
vim.opt_local.wrap        = true
vim.opt_local.linebreak   = true
vim.opt_local.breakindent = true
vim.opt_local.expandtab   = false
vim.opt_local.formatoptions:append({ 't', 'a' })

-- Keymaps: ======================================================================================
vim.keymap.set('n', 'j', 'gj', { buffer = 0 })
vim.keymap.set('n', 'k', 'gk', { buffer = 0 })
