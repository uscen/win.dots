--          ╔═════════════════════════════════════════════════════════╗
--          ║                       Ggraphql LSP                      ║
--          ╚═════════════════════════════════════════════════════════╝
---@type vim.lsp.Config
return {
  cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
  filetypes = { 'graphql', 'typescriptreact', 'javascriptreact' },
}
