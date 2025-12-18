--          ╔═════════════════════════════════════════════════════════╗
--          ║                     Json LSP                            ║
--          ╚═════════════════════════════════════════════════════════╝
---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = { provideFormatter = false },
  root_markers = { '.git' },
  settings = { json = {
    format = { enable = false },
    validate = { enable = true },
  }, },
}
