-- ============================================================================== #
-- Pairs:                                                                         #
-- ============================================================================== #
Config.later(function()
  local MiniPairs = require('mini.pairs')
  MiniPairs.setup({
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { 'string' },
    skip_unbalanced = true,
    markdown = true,
    modes = { insert = true, command = true, terminal = true },
    mappings = {
      ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][%s%)%]%}]' },
      ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][%s%)%]%}]' },
      ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][%s%)%]%}]' },
      [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
      [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
      ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
      ['>'] = { action = 'open', pair = '><', neigh_pattern = '...%', register = { cr = true } },
      ['<'] = { action = 'close', pair = '><', register = { cr = true } },
      ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^%w][^%w]', register = { cr = false } },
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%w][^%w]', register = { cr = false } },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^%w][^%w]', register = { cr = false } },
    },
  })
end)
