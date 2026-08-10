-- ============================================================================== #
-- Diff:                                                                          #
-- ============================================================================== #
Config.later(function()
  local MiniDiff = require('mini.diff')
  require('mini.diff').setup({ view = { style = 'sign', signs = { add = '▎', change = '▎', delete = '▎' } } })

  -- Open all hunks in quickfix: =================================================================
  Config.new_command('DiffToQf', function()
    local hunks = MiniDiff.export('qf')
    if #hunks == 0 then
      vim.notify('No changes to show', vim.log.levels.INFO)
      return
    end
    vim.fn.setqflist(hunks)
    vim.cmd('copen')
  end)
end)
