--          ╔═════════════════════════════════════════════════════════╗
--          ║                   Typescript GO LSP                     ║
--          ╚═════════════════════════════════════════════════════════╝
---@type vim.lsp.Config
return {
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', },
  root_markers = { 'package.json' },
}
