-- ============================================================================== #
-- Conform:                                                                       #
-- ============================================================================== #
Config.later(function()
  vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
  local conform = require('conform')
  conform.setup({
    default_format_opts = { lsp_format = 'fallback' },
    formatters_by_ft = {
      lua = { lsp_format = 'fallback' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      jsx = { 'prettier' },
      tsx = { 'prettier' },
      svelte = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      graphql = { 'prettier' },
      liquid = { 'prettier' },
      ['_'] = { 'trim_whitespace' },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = 'fallback' }
    end,
  })
end)
