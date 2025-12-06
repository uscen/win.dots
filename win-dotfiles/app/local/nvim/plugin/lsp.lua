--          ╔═════════════════════════════════════════════════════════╗
--          ║                            LSP                          ║
--          ╚═════════════════════════════════════════════════════════╝
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    --- Disable color, semantic tokens: ==========================================================
    if client and client.server_capabilities then
      client.server_capabilities.colorProvider = nil
      client.server_capabilities.semanticTokensProvider = nil
    end
    -- Mini.Completion support: ==================================================================
    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
    if client.server_capabilities.definitionProvider then
      vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    end
    -- Set the keymaps: ==========================================================================
    if client:supports_method('textDocument/definition') then
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = true })
    end

    if client:supports_method('textDocument/declaration') then
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = true })
    end

    if client:supports_method('textDocument/implementation') then
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = true })
    end

    if client:supports_method('textDocument/references') then
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = true })
    end

    if client:supports_method('textDocument/codeAction') then
      vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, { buffer = true })
    end

    if client:supports_method('textDocument/rename') then
      vim.keymap.set('n', 'gn', vim.lsp.buf.rename, { buffer = true })
    end

    if client:supports_method('textDocument/typeDefinition') then
      vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { buffer = true })
    end

    if client:supports_method('textDocument/signatureHelp') then
      vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { buffer = true })
    end

    if client:supports_method('textDocument/documentSymbol') then
      vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol, { buffer = true })
    end

    if client:supports_method('workspace/symbol') then
      if pcall(require, 'mini.pick') then
        vim.keymap.set('n', 'gS', '<Cmd>Pick lsp scope="document_symbol"<cr>', { buffer = true })
      end
    end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(false, client.id, bufnr, { autotrigger = false })
    end

    if client:supports_method('textDocument/prepareCallHierarchy') then
      if client:supports_method('callHierarchy/incomingCalls') then
        vim.keymap.set('n', 'g(', function() vim.lsp.buf.incoming_calls() end, { buffer = true })
      end
      if client:supports_method('callHierarchy/outgoingCalls') then
        vim.keymap.set('n', 'g)', function() vim.lsp.buf.outgoing_calls() end, { buffer = true })
      end
    end

    if client:supports_method('textDocument/inlayHint') then
      vim.keymap.set('n', 'yoh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        vim.notify(string.format('Show inlay hints set to %s', vim.lsp.inlay_hint.is_enabled()), vim.log.INFO)
      end, { buffer = true })
    end
  end,
})

--          ╔═════════════════════════════════════════════════════════╗
--          ║                       Command LSP                       ║
--          ╚═════════════════════════════════════════════════════════╝
-- Starts LSP clients in the current buffer: =====================================================
vim.api.nvim_create_user_command('LspStart', function()
  vim.cmd.e()
end, {})

-- Get all the lsp logs: =========================================================================
vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd.vsplit(vim.lsp.log.get_filename())
end, {})

-- Get all the information about all LSP attached: ===============================================
vim.api.nvim_create_user_command('LspInfo', function()
  vim.cmd('silent checkhealth vim.lsp')
end, {})

-- Stop all LSP clients or a specific client attached to the current buffer: =====================
vim.api.nvim_create_user_command('LspStop', function(opts)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if opts.args == '' or opts.args == client.name then
      client:stop(true)
      vim.notify(client.name .. ': stopped')
    end
  end
end, {
  nargs = '?',
  complete = function(_, _, _)
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end
    return client_names
  end,
})
-- Restart all the language client(s) attached to the current buffer: ============================
vim.api.nvim_create_user_command('LspRestart', function()
  local detach_clients = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    client:stop(true)
    if vim.tbl_count(client.attached_buffers) > 0 then
      detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
    end
  end
  local timer = vim.uv.new_timer()
  if not timer then
    return vim.notify('Servers are stopped but havent been restarted')
  end
  timer:start(
    100,
    50,
    vim.schedule_wrap(function()
      for name, client in pairs(detach_clients) do
        local client_id = vim.lsp.start(client[1].config, { attach = false })
        if client_id then
          for _, buf in ipairs(client[2]) do
            vim.lsp.buf_attach_client(buf, client_id)
          end
          vim.notify(name .. ': restarted')
        end
        detach_clients[name] = nil
      end
      if next(detach_clients) == nil and not timer:is_closing() then
        timer:close()
      end
    end)
  )
end, {})
-- Refresh all attached client: ==================================================================
vim.lsp.set_log_level('ERROR')
local function refresh()
  vim.lsp.stop_client(vim.lsp.get_clients(), true)
  vim.defer_fn(
    function()
      local window_buffer_map = {}
      for _, window_id in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buffer_id = vim.api.nvim_win_get_buf(window_id)
        table.insert(window_buffer_map, { window_id = window_id, buffer_id = buffer_id })
      end

      if #window_buffer_map > 0 then
        vim.cmd('bufdo if &modifiable | write | edit | endif')
      end

      for _, entry in pairs(window_buffer_map) do
        vim.api.nvim_win_set_buf(entry.window_id, entry.buffer_id)
      end
    end,
    100
  )
end
vim.keymap.set('n', 'gcr', refresh)
