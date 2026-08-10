-- ============================================================================== #
-- Commands:                                                                      #
-- ============================================================================== #
Config.later(function()
  -- User command helper: ========================================================================
  _G.Config.new_command = function(name, command, opts)
    opts = opts or {}
    vim.api.nvim_create_user_command(name, command, opts)
  end

  -- "E138: main.shada.tmp.X files exist, cannot write ShaDa" on close: ==========================
  Config.new_command('RemoveShadaTemp', function()
    for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath('data') .. '/shada', '*tmp*', false, true)) do
      vim.fn.system({ 'rm', f })
    end
  end)

  -- create a temporary file: ====================================================================
  Config.new_command('Tmp', function()
    local path = vim.fn.tempname()
    vim.cmd('e ' .. path)
    vim.notify(path)
    vim.cmd('au BufDelete <buffer> !rm -f ' .. path)
  end, { nargs = '*' })

  -- Permanently delete the current file from hard drive: ========================================
  Config.new_command('Del', function(args)
    local bufnr = vim.api.nvim_get_current_buf()
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.bo[bufnr].buftype == '' then
      local ok, err = os.remove(fname)
      assert(args.bang or ok, err)
    end
    vim.api.nvim_buf_delete(bufnr, { force = args.bang })
  end, { bang = true })

  -- Rename file: ================================================================================
  Config.new_command('Rename', function(_)
    local old_name = vim.fn.expand('%')
    local new_name = vim.fn.input('New file name: ', old_name, 'file')
    if new_name ~= '' and new_name ~= old_name then
      vim.api.nvim_command(' saveas ' .. new_name)
      vim.fn.delete(old_name)
      vim.cmd('redraw!')
    end
  end, { bang = true })

  -- Create Directory: ===========================================================================
  Config.new_command('Mkdir', function(o)
    local path = vim.fn.expand(o.args ~= '' and o.args or '%:p:h')
    vim.fn.mkdir(path, 'p')
  end, { nargs = '?', complete = 'dir' })

  -- Wipes all registers: ========================================================================
  Config.new_command('WipeReg', function()
    vim.cmd([[ for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor ]])
  end, { nargs = 0 })

  -- Toggle between diagnostic virtual_lines and virtual_text: ===================================
  Config.new_command('ToggleDiagnosticStyle', function()
    local virtual_lines_enabled = vim.diagnostic.config().virtual_lines
    if virtual_lines_enabled then
      vim.diagnostic.config({ jump = { float = true }, virtual_lines = false, virtual_text = { current_line = true } })
    else
      vim.diagnostic.config({ jump = { float = true }, virtual_lines = { current_line = true }, virtual_text = false })
    end
  end)

  -- Toggle inlay hints: =========================================================================
  Config.new_command('ToggleInlayHints', function()
    vim.g.inlay_hints = not vim.g.inlay_hints
    vim.notify(string.format('%s inlay hints...', vim.g.inlay_hints and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
    local mode = vim.api.nvim_get_mode().mode
    vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == 'n' or mode == 'v'))
  end, { nargs = 0 })

  -- Move current window to its own tab: =========================================================
  Config.new_command('MoveWindowToTab', function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd [[ tab split ]]
    vim.api.nvim_win_close(win, true)
  end)

  -- Change between tag: ========================================================================
  Config.new_command('ChangeInTag', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('cit', true, false, true), 'n', true)
  end)

  -- Insert current date and time: ===============================================================
  Config.new_command('InsertDate', function(_)
    local today = os.date('%a %b %d - %Y-%m-%d %H:%M:%S %Z')
    vim.api.nvim_command('norm i' .. today)
  end, { bang = true })

  -- Insert the last message from :messages ======================================================
  Config.new_command('InsertLastMessage', function()
    local messages = vim.split(vim.fn.execute('messages'), '\n')
    vim.api.nvim_put({ messages[#messages] }, 'c', false, false)
  end)

  -- Get selected text ===========================================================================
  Config.new_command('GetSelection', function()
    local f = vim.fn
    local temp = f.getreg('s')
    vim.cmd('normal! gv"sy')
    f.setreg('/', f.escape(f.getreg('s'), '/'):gsub('\n', '\\n'))
    f.setreg('s', temp)
  end)

  -- Get paste text ==============================================================================
  Config.new_command('GetPasteText', function()
    local reg_type = vim.fn.getregtype():sub(1, 1)
    local keys = '`[' .. reg_type .. '`]'
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
  end)

  -- Reload plugin: ==============================================================================
  Config.new_command('Reload', function(opts)
    local name = opts.fargs[1]
    package.loaded[name] = nil
    require(name).setup()
  end, { nargs = 1 })

  -- Print buffer info: ==========================================================================
  Config.new_command('BufInfo', function()
    local ft = vim.bo.filetype
    local bt = vim.bo.buftype
    if ft == '' then
      ft = '[none]'
    end
    if bt == '' then
      bt = '[normal]'
    end
    print('filetype: ' .. ft .. ' | buftype: ' .. bt)
  end)

  -- Yank diagnostic into clipboard: =============================================================
  Config.new_command('YankDiagnostic', function()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diags = vim.diagnostic.get(0, { lnum = row })
    if #diags == 0 then return end
    local msg = table.concat(vim.tbl_map(function(d) return d.message end, diags), '\n')
    vim.fn.setreg('+', msg)
    vim.notify('Yanked: ' .. msg)
  end)

  -- Yank last into clipboard ====================================================================
  Config.new_command('YankToClipboard', function()
    local copy = vim.fn.getreg('"')
    if copy == '' then
      return
    end
    vim.fn.setreg('+', copy)
    local msg = ''
    local _, ln = string.gsub(copy, '\n', '')
    if ln > 0 then
      msg = string.format('%d %s yanked into "+', ln, ln > 1 and 'lines' or 'line')
    else
      local ch = vim.fn.strdisplaywidth(copy)
      msg = string.format('%d %s yanked into "+', ch, ch > 1 and 'chars' or 'char')
    end
    vim.api.nvim_echo({ { msg } }, false, {})
  end)

  -- Yank text to clipboard using codeblock format ```{ft}{content}```: ==========================
  Config.new_command('YankCodeBlock', function(opts)
    local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, true)
    local content = table.concat(lines, '\n')
    local result = string.format('```%s\n%s\n```', vim.bo.filetype, content)
    vim.fn.setreg('+', result)
    vim.notify 'Text copied to clipboard'
  end, { range = true })

  -- fuzzy find oldfiles list with :Oldfiles: ====================================================
  Config.new_command('Oldfiles', function(args)
    vim.cmd('e ' .. args.args)
  end, {
    nargs = 1,
    complete = function(arglead)
      local files = vim.tbl_filter(function(f) return vim.fn.filereadable(f) > 0 end, vim.v.oldfiles)
      local list = vim.fn.matchfuzzy(files, arglead)
      return #list > 0 and list or files
    end,
  })

  -- Append char(s) to the end of each line (default: ";"): ======================================
  Config.new_command('AppendToEnd', function(args)
    local prefix = args.line1 .. ',' .. args.line2
    local chars = args.fargs[1] ~= nil and args.fargs[1] or ';'
    vim.cmd(prefix .. 'g/./normal A' .. chars)
    vim.cmd('nohlsearch')
  end, { nargs = '?', range = true })

  -- Delete extra whitespace: ====================================================================
  Config.new_command('TrailspaceTrim', function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, curpos)
  end, { nargs = '?', range = true })

  -- Delete Last lines: ==========================================================================
  Config.new_command('TrimLastLines', function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank < n_lines then vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, {}) end
  end)

  -- Join empty lines: ===========================================================================
  Config.new_command('JoinEmptyLines', function(args)
    if args.fargs[1] ~= nil then
      vim.cmd('silent! g/^$/,/./-' .. args.fargs[1] .. 'j')
    elseif args.bang then
      vim.cmd('silent! g/^$/-j')
    else
      vim.cmd('silent! g/^$/,/./-1j')
    end
    vim.cmd([[ %s/\_s*\%$//e ]])
    vim.cmd('nohlsearch')
  end, { bang = true, nargs = '?' })

  -- Clear register data: ========================================================================
  Config.new_command('ClearRegister', function(args)
    if #args.fargs == 0 then
      local registers = {
        '"',
        '-',
        '/',
        '*',
        '+',
        '=',
        '_',
        unpack(vim.fn.range(0, 9)), -- Registers 0-9
        unpack(vim.fn.map(vim.fn.range(97, 122), function(_, v)
          return string.char(v)
        end)),
      }
      for _, reg in pairs(registers) do
        vim.fn.setreg(reg, '')
      end
      vim.notify('All registers have been cleared')
      return
    end
    for _, reg in pairs(args.fargs) do
      if vim.fn.getreg(reg) ~= nil then
        vim.fn.setreg(reg, '')
        print('Cleared register: ' .. reg)
      else
        print('Invalid register: ' .. reg)
      end
    end
  end, { desc = 'Clear register data', nargs = '*' })

  -- Rotate Windows: ============================================================================
  Config.new_command('RotateWindows', function()
    local ignored_filetypes = { 'neo-tree', 'fidget', 'Outline', 'toggleterm', 'qf', 'notify' }
    local window_numbers = vim.api.nvim_tabpage_list_wins(0)
    local windows_to_rotate = {}
    for _, window_number in ipairs(window_numbers) do
      local buffer_number = vim.api.nvim_win_get_buf(window_number)
      local filetype = vim.bo[buffer_number].filetype
      if vim.fn.win_gettype(window_number) == '' and not vim.tbl_contains(ignored_filetypes, filetype) then
        table.insert(windows_to_rotate, { window_number = window_number, buffer_number = buffer_number })
      end
    end
    local num_eligible_windows = vim.tbl_count(windows_to_rotate)
    if num_eligible_windows == 0 then
      return
    elseif num_eligible_windows == 1 then
      vim.notify('There is no other window to rotate with.')
      return
    elseif num_eligible_windows == 2 then
      local firstWindow = windows_to_rotate[1]
      local secondWindow = windows_to_rotate[2]
      vim.api.nvim_win_set_buf(firstWindow.window_number, secondWindow.buffer_number)
      vim.api.nvim_win_set_buf(secondWindow.window_number, firstWindow.buffer_number)
    else
      vim.notify('You can only swap 2 open windows. Found ' .. num_eligible_windows .. '.')
    end
  end)

  -- Enable Format: ==============================================================================
  Config.new_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = { start = { args.line1, 0 }, ['end'] = { args.line2, end_line:len() } }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
  end, { range = true })

  -- Toggle conform.nvim auto-formatting: ========================================================
  Config.new_command('FormatToggle', function()
    vim.g.autoformat = not vim.g.autoformat
    vim.notify(string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
  end, { nargs = 0 })

  -- Enable Format On Save =======================================================================
  Config.new_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
    vim.notify('Format On Save Enable')
  end)

  -- Disable FormatOnSave ========================================================================
  Config.new_command('FormatDisable', function(args)
    if args.bang then
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
    vim.notify('Format On Save Disable')
  end, { bang = true })

  -- Format Json: ================================================================================
  Config.new_command('FormatJson', function(opts)
    if opts.range > 0 then
      vim.cmd(opts.line1 .. ',' .. opts.line2 .. '!jq')
    else
      -- No selection: apply to whole buffer
      vim.cmd('%!jq')
    end
  end, { desc = 'Format Json', range = true })

  -- Format Sql: =================================================================================
  Config.new_command('FormatSql', function(opts)
    if opts.range > 0 then
      vim.cmd(opts.line1 .. ',' .. opts.line2 .. '!sleek')
    else
      -- No selection: apply to whole buffer
      vim.cmd('%!sleek')
    end
  end, { range = true })

  -- Lazygit: ====================================================================================
  Config.new_command('Lazygit', function()
    vim.cmd.tabnew()
    vim.cmd.terminal('lazygit')
    local win = vim.api.nvim_get_current_win()
    Config.new_autocmd('WinClosed', {
      pattern = tostring(win),
      once = true,
      callback = function(e)
        vim.cmd.bwipeout({ args = { e.buf }, bang = true })
      end,
    })
    pcall(vim.cmd.file, 'term:lazygit')
  end)

  -- Search And Replace: =========================================================================
  Config.new_command('Match', function()
    local word = vim.fn.expand('<cword>')
    local cmd = ':%s/\\<' .. word .. '\\>/' .. word .. '/I'
    local keys = vim.api.nvim_replace_termcodes(cmd .. '<Left><Left>', true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
  end)
  Config.new_command('MatchWord', function()
    local word = vim.fn.expand('<cword>')
    vim.api.nvim_feedkeys(':%s/\\<' .. word .. '\\>/', 'n', false)
  end)

  -- Change Directory: ===========================================================================
  Config.new_command('CdHere', function()
    local path = vim.fn.expand('%:h')
    if path == '' then return end
    vim.cmd('silent cd ' .. path)
    vim.notify(path)
  end, {})
  Config.new_command('CdRoot', function()
    local root = vim.fn.systemlist('git -C ' .. vim.fn.expand('%:h') .. ' rev-parse --show-toplevel')[1]
    if root and root ~= '' then
      vim.cmd('silent cd ' .. root)
      vim.notify(root)
    else
      vim.notify('No git repository found', vim.log.levels.WARN)
    end
  end)

  -- Toggle Qucikfix and location list: ==========================================================
  Config.new_command('ExploreQuickfix', function()
    vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
  end)
  Config.new_command('ExploreLocations', function()
    vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and 'lclose' or 'lopen')
  end)

  -- Resizes By %: ===============================================================================
  Config.new_command('Vr', function(opts)
    local usage = 'Usage: [VerticalResize] :Vr {number (%)}'
    if not opts.args or not string.len(opts.args) == 2 then
      print(usage)
      return
    end
    vim.cmd(':vertical resize ' .. vim.opt.columns:get() * (opts.args / 100.0))
  end, { nargs = '*' })
  Config.new_command('Hr', function(opts)
    local usage = 'Usage: [HorizontalResize] :Hr {number (%)}'
    if not opts.args or not string.len(opts.args) == 2 then
      print(usage)
      return
    end
    vim.cmd(':resize ' .. ((vim.opt.lines:get() - vim.opt.cmdheight:get()) * (opts.args / 100.0)))
  end, { nargs = '*' })

  -- Edit file full path: ========================================================================
  Config.new_command('E', function(args)
    vim.cmd.edit(vim.fs.joinpath(vim.fn.expand('%:p:h'), args.args))
  end, { nargs = 1 })
  Config.new_command('Edit', function(args)
    vim.cmd.edit(vim.fs.joinpath(vim.fn.expand('%:p:h'), args.args))
  end, { nargs = 1 })
  Config.new_command('EditConfig', function()
    local config_dir = vim.fn.stdpath('config')
    assert(type(config_dir) == 'string', 'Expected string')
    vim.fn.chdir(config_dir)
    vim.api.nvim_cmd({ cmd = 'edit', args = { 'init.lua' } }, { output = false })
  end, {})

  -- Copy Absolute & Relative full path: =========================================================
  Config.new_command('CopyAbsPath', function()
    local path = vim.fn.expand('%:p')
    if path == '' then return end
    vim.notify(path)
    vim.fn.setreg('+', path)
  end)
  Config.new_command('CopyAbsPathNoFile', function()
    local path = vim.fn.expand('%:p:h')
    if path == '' then return end
    vim.notify(path)
    vim.fn.setreg('+', path)
  end)
  Config.new_command('CopyRelPath', function()
    local filename = vim.fn.expand '%:.'
    if filename == '' then return end
    vim.notify(filename)
    vim.fn.setreg('+', filename)
  end)
  Config.new_command('CopyRelPathNoFile', function()
    local path = vim.fn.expand('%:.')
    local dir = path:match('(.*/)')
    vim.notify(dir)
    vim.fn.setreg('+', dir)
  end)
  Config.new_command('CopyRelRootDir', function()
    local root = vim.fn.getcwd()
    if root == '' then return end
    vim.notify(root)
    vim.fn.setreg('+', root)
  end)
  Config.new_command('CopyAbsRootDir', function()
    local root = vim.fn.getcwd()
    if root == '' then return end
    vim.notify(root)
    vim.fn.setreg('+', root)
  end)

  -- Builtin packages manager: ===================================================================
  Config.new_command('PackUpdate', function() vim.pack.update() end)
  Config.new_command('PackSync', function() vim.pack.update(nil, { target = 'lockfile' }) end)
  Config.new_command('PackList', function()
    local packages = vim.pack.get(nil, { info = false })
    if vim.tbl_isempty(packages) then
      vim.notify('No packages managed', vim.log.levels.WARN)
      return
    end
    local names = {}
    for _, pkg in ipairs(packages) do
      if pkg.spec and pkg.spec.name then
        local name = pkg.spec.name
        if pkg.active == false then
          name = name .. ' [inactive]'
        end
        table.insert(names, name)
      end
    end
    table.sort(names)
    vim.notify(table.concat(names, '\n'), vim.log.levels.INFO, { title = 'Installed packages (' .. #names .. ')' })
  end)
  Config.new_command('PackClean', function()
    local packages = vim.pack.get(nil, { info = false })
    local inactive = {}
    for _, pkg in ipairs(packages) do
      if pkg.active == false and pkg.spec and pkg.spec.name then
        table.insert(inactive, pkg.spec.name)
      end
    end
    if #inactive == 0 then
      vim.notify('Nothing to clean', vim.log.levels.INFO)
      return
    end
    table.sort(inactive)
    local ok, err = pcall(vim.pack.del, inactive)
    if not ok then
      vim.notify('PackClean failed:\n' .. tostring(err), vim.log.levels.ERROR, { title = 'PackClean' })
      return
    end
    vim.notify('Removed:\n' .. table.concat(inactive, '\n'), vim.log.levels.INFO, { title = 'PackClean' })
  end)
end)
