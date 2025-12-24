--          ╔═════════════════════════════════════════════════════════╗
--          ║                       Latex LSP                         ║
--          ╚═════════════════════════════════════════════════════════╝
---@type vim.lsp.Config
return {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.git', 'main.tex' },
  settings = {
    texlab = {
      bibtexFormatter = 'texlab',
      build = { onSave = false, onType = false },
      diagnosticDelay = 100,
      formatterLineLength = 80,
      forwardSearch = { args = {} },
    },
  },
}
