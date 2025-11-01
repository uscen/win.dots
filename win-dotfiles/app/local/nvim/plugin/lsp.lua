--          ╔═════════════════════════════════════════════════════════╗
--          ║                         LSP                             ║
--          ╚═════════════════════════════════════════════════════════╝
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    --- Disable semantic tokens: =================================================================
    client.server_capabilities.semanticTokensProvider = nil
    -- Mini.Completion support: ==================================================================
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end
    -- Set the keymaps: ==========================================================================
    if pcall(require, 'mini.pick') then
      vim.keymap.set('n', 'gD', "<Cmd>Pick lsp scope='definition'<cr>")
      vim.keymap.set('n', 'gI', "<Cmd>Pick lsp scope='declaration'<cr>")
      vim.keymap.set('n', 'gR', "<Cmd>Pick lsp scope='references'<cr>")
      vim.keymap.set('n', 'gS', "<Cmd>Pick lsp scope='document_symbol'<cr>")
    end
  end,
})
