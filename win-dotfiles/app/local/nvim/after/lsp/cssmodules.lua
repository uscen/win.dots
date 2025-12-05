--          ╔═════════════════════════════════════════════════════════╗
--          ║                       Css Modules LSP                   ║
--          ╚═════════════════════════════════════════════════════════╝
return {
  cmd = { 'cssmodules-language-server' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'package.json' },
}
