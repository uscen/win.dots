--          ╔═════════════════════════════════════════════════════════╗
--          ║                     Html LSP                            ║
--          ╚═════════════════════════════════════════════════════════╝
return {
  cmd = { 'superhtml', 'lsp' },
  filetypes = { 'html', 'shtml', 'htm' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git' }, { upward = true })[1]),
  single_file_support = true,
}
