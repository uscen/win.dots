-- ============================================================================== #
-- Files:                                                                         #
-- ============================================================================== #
Config.now_if_args(function()
  local MiniFiles = require('mini.files')
  MiniFiles.setup({
    mappings = {
      synchronize = '<C-s>',
      go_in       = '<C-l>',
      go_out      = '<C-h>',
      go_in_plus  = '<Tab>',
      go_out_plus = '<S-Tab>',
      reset       = '<BS>',
      close       = 'q',
      mark_goto   = "'",
      mark_set    = 'm',
      reveal_cwd  = '@',
      show_help   = 'g?',
      trim_left   = '<',
      trim_right  = '>',
    },
    content = {
      filter = function(fs_entry)
        local ignore = { 'node_modules', 'build', 'depes', 'incremental' }
        local filter_hidden = not vim.tbl_contains(ignore, fs_entry.name)
        return filter_hidden and not vim.startswith(fs_entry.name, '.')
      end,
    },
    windows = { max_number = 1, width_focus = vim.o.columns },
  })

  -- UI: =========================================================================================
  Config.new_autocmd('User', {
    pattern = 'MiniFilesWindowOpen',
    callback = function(args)
      local win_id = args.data.win_id
      -- Customize window-local settings
      vim.wo[win_id].winblend = 5
      local config = vim.api.nvim_win_get_config(win_id)
      config.border, config.title_pos = 'single', 'left'
      vim.api.nvim_win_set_config(win_id, config)
    end,
  })
  Config.new_autocmd('User', {
    pattern = 'MiniFilesWindowUpdate',
    callback = function(args)
      local config = vim.api.nvim_win_get_config(args.data.win_id)
      -- Ensure fixed height
      config.height = vim.o.lines
      -- Ensure no title padding
      local n = #config.title
      config.title[1][1] = config.title[1][1]:gsub('^ ', '')
      config.title[n][1] = config.title[n][1]:gsub(' $', '')
      vim.api.nvim_win_set_config(args.data.win_id, config)
    end,
  })

  -- BookMarks: ==================================================================================
  local minifiles_augroup = vim.api.nvim_create_augroup('ec-mini-files', {})
  Config.new_autocmd('User', {
    group = minifiles_augroup,
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark('m', vim.fn.stdpath('data') .. '/site/pack/core/opt/mini.nvim', { desc = 'mini.nvim' })
      MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/core/opt', { desc = 'Plugins' })
      MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
    end,
  })

  -- Dotfiles : ==================================================================================
  local toggle = { enabled = true }
  local toggle_dotfiles = function()
    function toggle:bool()
      self.enabled = not self.enabled
      return self.enabled
    end

    local is_enabled = not toggle:bool()
    MiniFiles.refresh({
      content = {
        filter = function(fs_entry)
          local ignore = { 'node_modules', 'build', 'depes', 'incremental' }
          local filter_hidden = not vim.tbl_contains(ignore, fs_entry.name)
          return is_enabled and true or (filter_hidden and not vim.startswith(fs_entry.name, '.'))
        end,
      },
    })
  end
  Config.new_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args) vim.keymap.set('n', '.', toggle_dotfiles, { buffer = args.data.buf_id }) end,
  })

  -- Splits : ====================================================================================
  local map_split = function(buf_id, lhs, direction)
    local function rhs()
      -- Make new window and set it as target
      local cur_target = MiniFiles.get_explorer_state().target_window
      local path = (MiniFiles.get_fs_entry() or {}).path
      if path == nil then path = '' end
      local new_target = vim.api.nvim_win_call(cur_target, function()
        vim.cmd(direction .. ' split ' .. path)
        return vim.api.nvim_get_current_win()
      end)
      MiniFiles.set_target_window(new_target)
    end
    -- Adding `desc` will result into `show_help` entries
    local desc = 'Split ' .. direction
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
  end
  Config.new_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      map_split(buf_id, '<C-b>', 'belowright vertical')
      map_split(buf_id, '<C-v>', 'belowright horizontal')
    end,
  })

  -- Explorer : ==================================================================================
  Config.later(function()
    -- View current root directory in explorer: ==================================================
    Config.new_command('ExploreAtRoot', function()
      if MiniFiles.close() then return end
      MiniFiles.open()
    end)

    -- View current file in explorer: ============================================================
    Config.new_command('ExploreAtFile', function()
      if MiniFiles.close() then return end
      local buf_path = vim.api.nvim_buf_get_name(0)
      local path = vim.loop.fs_stat(buf_path) ~= nil and buf_path or vim.fn.getcwd()
      MiniFiles.open(path)
    end)
  end)
end)
