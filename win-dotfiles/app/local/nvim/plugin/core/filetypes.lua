-- ============================================================================== #
-- Filetypes:                                                                     #
-- ============================================================================== #
Config.now(function()
  vim.filetype.add({
    -- Extension: ================================================================================
    extension = {
      ['smd'] = 'markdown',
      ['scm'] = 'query',
      ['http'] = 'http',
      ['rest'] = 'http',
      ['json'] = 'jsonc',
      ['map'] = 'json',
      ['jq'] = 'json',
      ['mdx'] = 'markdown',
      ['ipynb'] = 'ipynb',
      ['pcss'] = 'css',
      ['ejs'] = 'ejs',
      ['mts'] = 'javascript',
      ['cts'] = 'javascript',
      ['es6'] = 'javascript',
      ['gs'] = 'javascript',
      ['conf'] = 'conf',
      ['tmpl'] = 'gotmpl',
      ['ahk2'] = 'autohotkey',
      ['ssh'] = 'sshconfig',
      ['rockspec'] = 'lua',
      ['xaml'] = 'xml',
      ['axaml'] = 'xml',
      ['h'] = 'c',
    },

    -- Filename: =================================================================================
    filename = {
      ['README'] = 'markdown',
      ['readme'] = 'markdown',
      ['nginx.conf'] = 'nginx',
      ['xhtml'] = 'html',
      ['tsconfig.json'] = 'jsonc',
      ['.eslintrc.json'] = 'jsonc',
      ['.prettierrc'] = 'jsonc',
      ['.babelrc'] = 'jsonc',
      ['.stylelintrc'] = 'jsonc',
      ['.yamlfmt'] = 'yaml',
      ['.envrc'] = 'sh',
      ['.clang-format'] = 'yaml',
      ['.clang-tidy'] = 'yaml',
      ['Dockerfile'] = 'dockerfile',
      ['dockerfile'] = 'dockerfile',
      ['tmux.conf'] = 'bash',
      ['ignore'] = 'gitignore',
    },

    -- Pattern: ==================================================================================
    pattern = {
      ['.*/.*%.component%.html'] = 'htmlangular',
      ['requirements.*.txt'] = 'requirements',
      ['.*config/git/config'] = 'gitconfig',
      ['.*/git/config.*'] = 'git_config',
      ['.gitconfig.*'] = 'gitconfig',
      ['.gitmodules'] = 'gitconfig',
      ['%.env%.[%w_.-]+'] = 'sh',
      ['.*%.variables.*'] = 'sh',
      ['.*/%.vscode/.*%.json'] = 'jsonc',
      ['.*%.code%-workspace'] = 'jsonc',
      ['.*%.json%.lock'] = 'json',
      ['.*/*.conf*'] = 'conf',
      ['*.MD'] = 'markdown',
      ['Dockerfile*'] = 'dockerfile',
      ['.*%.dockerfile'] = 'dockerfile',
      ['*.dockerfile'] = 'dockerfile',
      ['*.user.css'] = 'less',
      ['.*'] = function(path, bufnr)
        return vim.bo[bufnr]
            and vim.bo[bufnr].filetype ~= 'bigfile'
            and path
            and vim.fn.getfsize(path) > (1024 * 500)
            and 'bigfile'
            or nil
      end,
    },
  })
end)
