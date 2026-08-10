-- ============================================================================== #
-- Autocommands:                                                                  #
-- ============================================================================== #
Config.now(function()
  -- Auto command helper to add autocommands to my custom group: =================================
  local custom_group = vim.api.nvim_create_augroup('uscen-custom-config', {})
  _G.Config.new_autocmd = function(event, opts)
    opts.group = opts.group or custom_group
    vim.api.nvim_create_autocmd(event, opts)
  end

  -- Highlight Yank ==============================================================================
  Config.new_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    callback = function()
      (vim.hl or vim.highlight).on_yank()
    end,
  })

  -- Yanking registers: ==========================================================================
  Config.new_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('registers_yank', { clear = true }),
    callback = function()
      if vim.v.event.operator == 'y' then
        for i = 9, 1, -1 do
          vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
        end
      end
    end,
  })

  -- Don't Comment New Line ======================================================================
  Config.new_autocmd('FileType', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('diable_new_line_comments', { clear = true }),
    callback = function()
      vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' })
    end,
  })

  -- auto detects filetype if the filetype is empty: =============================================
  Config.new_autocmd('BufWritePost', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('file_detect', { clear = true }),
    callback = function()
      if vim.bo.filetype == '' then vim.cmd('filetype detect') end
    end,
  })

  -- Auto-resize splits on window resize:  =======================================================
  Config.new_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd('tabdo wincmd =')
      vim.cmd('tabnext ' .. current_tab)
    end,
  })

  -- Auto Complete: ==============================================================================
  Config.new_autocmd('CmdlineChanged', { pattern = { ':', '/', '?' }, callback = function()
    vim.fn.wildtrigger()
  end })

  -- Auto Save: ==================================================================================
  Config.new_autocmd({ 'BufLeave', 'FocusLost' }, {
    group = vim.api.nvim_create_augroup('save_buffers', {}),
    callback = function(event)
      local buf = event.buf
      if vim.api.nvim_get_option_value('modified', { buf = buf }) then
        vim.schedule(function()
          vim.api.nvim_buf_call(buf, function()
            vim.cmd('silent! write')
          end)
        end)
      end
    end,
  })

  ---Auto Cleanup: ===============================================================================
  Config.new_autocmd('FocusLost', {
    once = true,
    callback = function()
      if vim.g.is_windows then return end
      vim.system { 'find', vim.o.undodir, '-mtime', '+30d', '-delete' }
      vim.system { 'find', vim.lsp.log.get_filename(), '-size', '+20M', '-delete' }
    end,
  })

  -- No share or backup files: ===================================================================
  Config.new_autocmd({ 'BufWritePre' }, {
    pattern = vim.g.is_windows and { 'C:/users/lli/scoop/*', 'C:/users/lli/win.dots/*' } or { '/mnt/*', '/boot/*' },
    callback = function()
      vim.opt_local.undofile = false
      vim.opt_local.shada = 'NONE'
    end,
  })

  -- Disable swap/undo/backup files in temp directories or shm: ==================================
  Config.new_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('undo_disable', { clear = true }),
    pattern = { '/tmp/*', '*.tmp', '*.bak', 'COMMIT_EDITMSG', 'MERGE_MSG' },
    callback = function(event)
      vim.opt_local.undofile = false
      if event.file == 'COMMIT_EDITMSG' or event.file == 'MERGE_MSG' then
        vim.opt_local.swapfile = false
      end
    end,
  })

  -- Switch to Normal mode on focus/tab/window leave if in Insert mode: ==========================
  Config.new_autocmd({ 'FocusLost', 'WinLeave' }, {
    group = vim.api.nvim_create_augroup('leave_insert', {}),
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'i' or mode == 'ic' then
        vim.cmd('stopinsert')
      end
    end,
  })

  -- Highlight cursor line briefly when neovim regains focus: ====================================
  Config.new_autocmd({ 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('track_cursor', { clear = true }),
    callback = function()
      vim.o.cursorline = false
      vim.cmd('redraw')
      vim.defer_fn(function()
        vim.o.cursorline = true
        vim.cmd('redraw')
      end, 300)
    end,
  })

  --  Restore cursor position: ===================================================================
  Config.new_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('preserve_cursor', { clear = true }),
    callback = function(event)
      if vim.bo[event.buf].buftype ~= '' then return end
      vim.cmd([[silent! normal! g`"]])
    end,
  })

  -- Show cursor line only in active window: =====================================================
  Config.new_autocmd({ 'BufWinEnter', 'WinEnter', 'WinLeave', 'TabLeave' }, {
    group = vim.api.nvim_create_augroup('auto_show_cursorline', { clear = true }),
    callback = function(event)
      if vim.bo[event.buf].buftype ~= '' then return end
      vim.opt_local.cursorline = event.event ~= 'WinLeave'
    end,
  })

  -- Jump to last accessed window on closing the current one: ====================================
  Config.new_autocmd('WinClosed', {
    nested = true,
    group = vim.api.nvim_create_augroup('jump_to_last_window', { clear = true }),
    callback = function()
      if vim.fn.expand('<amatch>') == vim.fn.win_getid() then vim.cmd('wincmd p') end
    end,
  })

  -- Clear the last used search pattern when opening a new buffer ================================
  Config.new_autocmd('BufReadPre', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('clear_search', { clear = true }),
    callback = function()
      vim.fn.setreg('/', '')
      vim.cmd 'let @/ = ""'
    end,
  })

  -- Disable diagnostics in node_modules =========================================================
  Config.new_autocmd({ 'BufRead', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('disable_diagnostics', { clear = true }),
    pattern = '*/node_modules/*',
    callback = function()
      vim.diagnostic.enable(false, { bufnr = 0 })
    end,
  })

  -- Disable diagnostics while typing: ===========================================================
  local mode_diagnostoc = vim.api.nvim_create_augroup('diagnostic_cmds', { clear = true })
  Config.new_autocmd('ModeChanged', {
    group = mode_diagnostoc,
    pattern = { 'n:i', 'v:s' },
    callback = function(event) vim.diagnostic.enable(false, { bufnr = event.buf }) end,
  })
  Config.new_autocmd('ModeChanged', {
    group = mode_diagnostoc,
    pattern = 'i:n',
    callback = function(event) vim.diagnostic.enable(true, { bufnr = event.buf }) end,
  })

  -- Fix broken macro recording notification for cmdheight 0: ====================================
  local show_recordering = vim.api.nvim_create_augroup('show_recordering', { clear = true })
  Config.new_autocmd('RecordingEnter', {
    pattern = '*',
    group = show_recordering,
    callback = function()
      vim.opt_local.cmdheight = 1
    end,
  })
  Config.new_autocmd('RecordingLeave', {
    pattern = '*',
    group = show_recordering,
    callback = function()
      local timer = vim.loop.new_timer()
      ---@diagnostic disable-next-line: need-check-nil
      timer:start(50, 0, vim.schedule_wrap(function()
        vim.opt_local.cmdheight = 0
      end))
    end,
  })

  -- Remove hl search when move or enter insert: =================================================
  local clear_hl = vim.api.nvim_create_augroup('hl_clear', { clear = true })
  Config.new_autocmd('ModeChanged', {
    pattern = '*',
    group = clear_hl,
    callback = function()
      local mode = vim.fn.mode()
      if mode:match('i') then
        vim.opt.hlsearch = false
      else
        vim.opt.hlsearch = true
      end
    end,
  })
  Config.new_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
    group = clear_hl,
    callback = vim.schedule_wrap(function()
      vim.cmd.nohlsearch()
    end),
  })
  Config.new_autocmd('CursorMoved', {
    group = clear_hl,
    callback = function()
      if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
        vim.schedule(function()
          vim.cmd.nohlsearch()
        end)
      end
    end,
  })

  -- Removes trailing whitespace and trailing newlines on save : =================================
  Config.new_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('rm_trailing_lines_and_whitespace', { clear = true }),
    callback = function()
      local cur_search = vim.fn.getreg('/')
      local cur_view = vim.fn.winsaveview()
      vim.cmd([[%s/\s\+$//e]])
      vim.cmd([[%s/\($\n\s*\)\+\%$//e]])
      vim.fn.setreg('/', cur_search)
      vim.fn.winrestview(cur_view)
    end,
  })

  -- Opts in command window: =====================================================================
  Config.new_autocmd('CmdwinEnter', {
    group = vim.api.nvim_create_augroup('cmd_open', { clear = true }),
    callback = function()
      vim.wo.number = false
      vim.wo.signcolumn = 'no'
      vim.wo.foldcolumn = '0'
    end,
  })

  -- Show when lines are longer than 100 chars: ==================================================
  Config.new_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('color_column', { clear = true }),
    callback = function()
      vim.schedule(function()
        if vim.o.buftype == '' and vim.o.filetype ~= 'dbout' then
          vim.fn.matchadd('ColorColumn', '\\%100v', 100)
        end
      end)
    end,
  })

  -- Auto start insert when opening or focusing a terminal: ======================================
  Config.new_autocmd('BufEnter', {
    pattern = 'term://*',
    group = vim.api.nvim_create_augroup('term_focus', { clear = true }),
    callback = function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd.startinsert()
      end
    end,
  })

  -- Opts in terminal buffer: ====================================================================
  Config.new_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('term_open', { clear = true }),
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.cursorline = false
      vim.opt_local.buflisted = false
      vim.opt_local.scrollback = 10000
      vim.opt_local.scrolloff = 0
      vim.opt_local.signcolumn = 'no'
      vim.opt_local.filetype = 'terminal'
      vim.bo.filetype = 'terminal'
      vim.bo.bufhidden = 'wipe'
      if vim.startswith(vim.api.nvim_buf_get_name(0), 'term://') then
        vim.cmd('startinsert')
      end
    end,
  })

  -- Auto-close lazygit when process exits: ======================================================
  Config.new_autocmd('TermClose', {
    group = vim.api.nvim_create_augroup('term_close', {}),
    pattern = { 'term:lazygit' },
    callback = function()
      if vim.v.event.status == 0 then
        vim.api.nvim_buf_delete(0, {})
      end
      vim.api.nvim_input('<CR>')
    end,
  })

  -- Auto create dir when saving a file, in case some intermediate directory does not exist: =====
  Config.new_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('auto_create_dir', {}),
    callback = function(event)
      if event.match:match('^%w%w+:[\\/][\\/]') then return end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })

  -- Check if we need to reload the file when it changed: ========================================
  Config.new_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = vim.api.nvim_create_augroup('checktime', { clear = true }),
    callback = function()
      local regex = vim.regex([[\(c\|r.?\|!\|t\)]])
      local mode = vim.api.nvim_get_mode()['mode']
      if (not regex:match_str(mode)) and vim.fn.getcmdwintype() == '' then
        vim.cmd('checktime')
      end
    end,
  })

  -- Notify when file is reloaded: ===============================================================
  Config.new_autocmd('FileChangedShellPost', {
    group = vim.api.nvim_create_augroup('reload_notify', { clear = true }),
    callback = function()
      vim.notify('File changed on disk. Buffer reloaded!', vim.log.levels.WARN)
    end,
  })

  -- Always open quickfix window automatically: ==================================================
  Config.new_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('auto_open_quickfix', { clear = true }),
    pattern = '[^l]*',
    command = 'cwindow',
    nested = true,
  })

  -- Always open loclist window automatically: ===================================================
  Config.new_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('auto_open_localist', { clear = true }),
    pattern = 'l*',
    command = 'lwindow',
    nested = true,
  })

  -- Clear jump list at start:====================================================================
  Config.new_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('clear_jumps', { clear = true }),
    callback = function()
      vim.cmd.clearjumps()
    end,
  })

  -- Remove stale shada temp files left by crashes (avoids E138 on quit): ========================
  Config.new_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('shada_cleanup', { clear = true }),
    callback = function()
      local dir = vim.fn.stdpath('state') .. '/shada'
      local cutoff = os.time() - 3600
      for name in vim.fs.dir(dir) do
        if name:match('^main%.shada%.tmp%.%a$') then
          local path = dir .. '/' .. name
          local st = vim.uv.fs_stat(path)
          if st and st.mtime.sec < cutoff then vim.fn.delete(path) end
        end
      end
    end,
  })

  -- Close some filetypes with <q>: ==============================================================
  Config.new_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('q_close', { clear = true }),
    pattern = { 'qf', 'man', 'help', 'query', 'notify', 'lspinfo', 'startuptime', 'git', 'checkhealth', 'nvim-undotree' },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      local close_buffer = vim.schedule_wrap(function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end)
      ---@type vim.keymap.set.Opts
      local keymap_opts = { buffer = event.buf, silent = true, desc = 'Close buffer', nowait = true }
      vim.keymap.set('n', 'q', close_buffer, keymap_opts)
    end,
  })

  -- Close [No Name] buffers: ===================================================================
  Config.new_autocmd('BufHidden', {
    group = vim.api.nvim_create_augroup('no_name_close', { clear = true }),
    callback = function(event)
      if event.file == '' and vim.bo[event.buf].buftype == '' then
        vim.schedule(function() pcall(vim.api.nvim_buf_delete, event.buf, { force = true }) end)
      end
    end,
  })

  -- Open images in imv and close buffer automatically: ==========================================
  Config.new_autocmd('BufReadCmd', {
    pattern = { '*.png', '*.jpg', '*.jpeg', '*.webp', '*.gif', '*.bmp', '*.svg' },
    callback = function(args)
      vim.fn.jobstart({ 'imv', args.file }, { detach = true })
      vim.schedule(function()
        local prev_buf = vim.fn.bufnr('#')
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_delete(args.buf, { force = true })
        end
        if prev_buf > 0 and vim.api.nvim_buf_is_valid(prev_buf) and vim.api.nvim_buf_is_loaded(prev_buf) then
          vim.cmd.buffer(prev_buf)
        else
          for _, file in ipairs(vim.v.oldfiles) do
            if vim.uv.fs_stat(file) and vim.fs.basename(file) ~= 'COMMIT_EDITMSG' then
              vim.cmd.edit(file)
              return
            end
          end
        end
      end)
    end,
  })

  -- Open pdf/epub files in zathura and close buffer automatically: ==============================
  Config.new_autocmd('BufReadCmd', {
    pattern = { '*.pdf', '*.epub' },
    callback = function(args)
      vim.fn.jobstart({ 'zathura', args.file }, { detach = true })
      vim.schedule(function()
        local prev_buf = vim.fn.bufnr('#')
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_delete(args.buf, { force = true })
        end
        if prev_buf > 0 and vim.api.nvim_buf_is_valid(prev_buf) and vim.api.nvim_buf_is_loaded(prev_buf) then
          vim.cmd.buffer(prev_buf)
        else
          for _, file in ipairs(vim.v.oldfiles) do
            if vim.uv.fs_stat(file) and vim.fs.basename(file) ~= 'COMMIT_EDITMSG' then
              vim.cmd.edit(file)
              return
            end
          end
        end
      end)
    end,
  })

  -- Auto close deleted buffers: =================================================================
  Config.new_autocmd('FocusGained', {
    callback = function()
      local allBufs = vim.fn.getbufinfo { buflisted = 1 }
      local closedBuffers = vim.iter(allBufs):fold({}, function(acc, buf)
        if not vim.api.nvim_buf_is_valid(buf.bufnr) then return acc end
        local stillExists = vim.uv.fs_stat(buf.name) ~= nil
        local specialBuffer = vim.bo[buf.bufnr].buftype ~= ''
        local newBuffer = buf.name == ''
        if stillExists or specialBuffer or newBuffer then return acc end
        table.insert(acc, vim.fs.basename(buf.name))
        vim.api.nvim_buf_delete(buf.bufnr, { force = false })
        return acc
      end)
      if #closedBuffers == 0 then return end

      if #closedBuffers == 1 then
        vim.notify(closedBuffers[1], nil, { title = 'Buffer closed', icon = '󰅗' })
      else
        local text = '- ' .. table.concat(closedBuffers, '\n- ')
        vim.notify(text, nil, { title = 'Buffers closed', icon = '󰅗' })
      end
      -- If ending up in empty buffer, re-open the first oldfile that exists
      vim.schedule(function()
        if vim.api.nvim_buf_get_name(0) ~= '' then return end
        for _, file in ipairs(vim.v.oldfiles) do
          if vim.uv.fs_stat(file) and vim.fs.basename(file) ~= 'COMMIT_EDITMSG' then
            vim.cmd.edit(file)
            return
          end
        end
      end)
    end,
  })
end)
