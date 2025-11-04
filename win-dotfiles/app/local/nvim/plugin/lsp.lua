--          ╔═════════════════════════════════════════════════════════╗
--          ║                         LSP                             ║
--          ╚═════════════════════════════════════════════════════════╝
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local bufnr = ev.buf
    local opts = { buffer = bufnr }
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
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    if pcall(require, 'mini.pick') then
      vim.keymap.set('n', 'gD', "<Cmd>Pick lsp scope='definition'<cr>", opts)
      vim.keymap.set('n', 'gI', "<Cmd>Pick lsp scope='declaration'<cr>", opts)
      vim.keymap.set('n', 'gR', "<Cmd>Pick lsp scope='references'<cr>", opts)
      vim.keymap.set('n', 'gS', "<Cmd>Pick lsp scope='document_symbol'<cr>", opts)
    end
  end,
})
