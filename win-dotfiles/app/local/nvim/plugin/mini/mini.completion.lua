-- ============================================================================== #
-- Completion:                                                                    #
-- ============================================================================== #
Config.now_if_args(function()
  local MiniCompletion = require('mini.completion')
  MiniCompletion.setup({
    delay = { completion = 200, info = 200, signature = 100 },
    lsp_completion = { source_func = 'omnifunc', auto_setup = false },
    mappings = { force_twostep = '<C-n>', force_fallback = '<C-S-n>', scroll_down = '<C-f>', scroll_up = '<C-b>' },
  })
  local on_attach = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end
  Config.new_autocmd('LspAttach', { callback = on_attach })

  -- Advertise to servers: =======================================================================
  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)
