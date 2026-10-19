-- ============================================================================== #
-- Surround:                                                                      #
-- ============================================================================== #
Config.later(function()
  local MiniSurround = require('mini.surround')
  MiniSurround.setup({
    n_lines = 500,
    custom_surroundings = {
      ['('] = { output = { left = '(', right = ')' } },
      ['['] = { output = { left = '[', right = ']' } },
      ['{'] = { output = { left = '{', right = '}' } },
      ['<'] = { output = { left = '<', right = '>' } },
    },
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = 'sf',
      find_left = 'sF',
      highlight = 'sh',
      replace = 'cs',
      update_n_lines = 'sn',
      suffix_last = 'l',
      suffix_next = 'n',
    },
  })

  -- Surround visual Selection: =================================================================
  Config.new_command('VisualSurround', function()
    vim.api.nvim_input('<esc>')
    vim.schedule(function()
      MiniSurround.add('visual')
    end)
  end, { range = true })

  -- Surround or replace quotes: =================================================================
  Config.new_command('SurroundOrReplaceQuotes', function()
    local word = vim.fn.expand('<cword>')
    local row, old_pos = unpack(vim.api.nvim_win_get_cursor(0))
    vim.fn.search(word, 'bc', row)
    local _, word_pos = unpack(vim.api.nvim_win_get_cursor(0))
    local line_str = vim.api.nvim_get_current_line()
    local before_word = line_str:sub(0, word_pos)
    local pairs_count = 0
    for _ in before_word:gmatch('["\'`]') do
      pairs_count = pairs_count + 1
    end
    if pairs_count % 2 == 0 then
      vim.cmd('normal ysiw\'')
      vim.api.nvim_win_set_cursor(0, { row, old_pos + 1 })
      return
    end
    for i = #before_word, 1, -1 do
      local char = before_word:sub(i, i)
      if char == "'" then
        vim.cmd("normal cs'\"")
        vim.api.nvim_win_set_cursor(0, { row, old_pos })
        return
      end
      if char == '"' then
        vim.cmd('normal cs\"`')
        vim.api.nvim_win_set_cursor(0, { row, old_pos })
        return
      end
      if char == '`' then
        vim.cmd("normal cs`'")
        vim.api.nvim_win_set_cursor(0, { row, old_pos })
        return
      end
    end
  end)
end)
