-- ============================================================================== #
-- Lsp:                                                                           #
-- ============================================================================== #
Config.later(function()
  vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
  vim.lsp.enable({ 'html', 'cssls', 'tailwindcss', 'emmet_language_server', 'vtsls', 'jsonls', 'lua_ls' })
  Config.new_command('LspInfo', 'checkhealth lsp')
end)
