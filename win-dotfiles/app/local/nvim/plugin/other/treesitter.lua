-- ============================================================================== #
-- Treesitter:                                                                    #
-- ============================================================================== #
Config.now_if_args(function()
  -- Update tree-sitter parsers after plugin is updated: =========================================
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')
  vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- Ensure installed: ===========================================================================
  local languages = { 'html', 'css', 'markdown', 'javascript', 'typescript', 'tsx', 'json', 'toml', 'yaml', 'jq', 'prisma', 'lua' }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Ensure enabled: =============================================================================
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  Config.new_autocmd('FileType', { pattern = filetypes, callback = function(ev) vim.treesitter.start(ev.buf) end })
end)
