-- ============================================================================== #
-- Snippets:                                                                      #
-- ============================================================================== #
Config.later(function()
  local MiniSnippets    = require('mini.snippets')
  -- Languge Patterns: ===========================================================================
  local config_path     = vim.fn.stdpath('config')
  local markdown        = { 'markdown.json' }
  local webHtmlPatterns = { 'html.json', 'ejs.json' }
  local latex_patterns  = { 'latex.json', 'latex/**/*.json' }
  local webJsPatterns   = { 'javascript.json', 'javascriptreact.json' }
  local webTsPatterns   = { 'typescript.json', 'typescriptreact.json' }
  local lang_patterns   = {
    tex = latex_patterns,
    tsx = webTsPatterns,
    jsx = webJsPatterns,
    typescript = webTsPatterns,
    javascript = webJsPatterns,
    typescriptreact = webTsPatterns,
    javascriptreact = webJsPatterns,
    html = webHtmlPatterns,
    ejs = webHtmlPatterns,
    markdown_inline = markdown,
  }

  -- Expand Patterns: ============================================================================
  local match_strict    = function(snips)
    return MiniSnippets.default_match(snips, { pattern_fuzzy = '^%S+$' })
  end

  -- Setup Snippets ==============================================================================
  MiniSnippets.setup({
    snippets = {
      MiniSnippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
      MiniSnippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
    },
    mappings = { expand = '<C-e>', jump_next = '<C-l>', jump_prev = '<C-h>', stop = '<C-c>' },
    expand   = {
      match = match_strict,
      insert = function(snippet)
        return MiniSnippets.default_insert(snippet, { empty_tabstop = '', empty_tabstop_final = '†' })
      end,
    },
  })

  -- Expand Snippets Or complete by Tab ==========================================================
  vim.keymap.set('i', '<Tab>', function()
    if #MiniSnippets.expand({ insert = false }) > 0 then return vim.schedule(MiniSnippets.expand) or '' end
    if vim.fn.complete_info()['selected'] ~= -1 then return '<C-y>' end
    if vim.fn.pumvisible() ~= 0 then return '<C-n><c-y>' end
    return '<Tab>'
  end, { expr = true })

  -- Exit snippet sessions on entering normal mode: ==============================================
  Config.new_command('SnippetSessionStop', function()
    while MiniSnippets.session.get() do
      MiniSnippets.session.stop()
    end
  end, {})
  Config.new_autocmd('User', {
    pattern = 'MiniSnippetsSessionStart',
    callback = function()
      Config.new_autocmd('ModeChanged', { pattern = '*:n', once = true, command = 'SnippetSessionStop' })
    end,
  })

  -- Exit snippets upon reaching final tabstop: ==================================================
  Config.new_autocmd('User', {
    pattern = 'MiniSnippetsSessionJump',
    callback = function(args)
      if args.data.tabstop_to == '0' then MiniSnippets.session.stop() end
    end,
  })
end)
