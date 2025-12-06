--          ╔═════════════════════════════════════════════════════════╗
--          ║                             Misc                        ║
--          ╚═════════════════════════════════════════════════════════╝
local M = {}
-- Open url in buffer: ===========================================================================
function M.openUrlInBuffer()
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  local urls = {}
  for url in text:gmatch([[%l%l%l+://[^%s)%]}"'`>]+]]) do
    urls[#urls + 1] = url
  end
  if #urls == 0 then
    return vim.notify('No URL found in file.', vim.log.levels.WARN)
  elseif #urls == 1 then
    return vim.ui.open(urls[1])
  end
  vim.ui.select(urls, { prompt = ' Open URL:' }, function(url)
    if url then vim.ui.open(url) end
  end)
end

vim.api.nvim_create_user_command('OpenUrlInBuffer', M.openUrlInBuffer, {})
-- Toggle word: ==================================================================================
function M.toggleWord()
  local toggles = {
    ['useState(true)'] = 'useState(false)',
    ['relative'] = 'absolute',
    ['active'] = 'inactive',
    ['enable'] = 'disable',
    ['visible'] = 'hidden',
    ['success'] = 'error',
    ['always'] = 'never',
    ['left'] = 'right',
    ['top'] = 'bottom',
    ['true'] = 'false',
    ['True'] = 'False',
    ['allow'] = 'deny',
    ['light'] = 'dark',
    ['show'] = 'hide',
    ['let'] = 'const',
    ['up'] = 'down',
    ['yes'] = 'no',
  }
  local cword = vim.fn.expand('<cword>')
  local newWord
  for word, opposite in pairs(toggles) do
    if cword == word then newWord = opposite end
    if cword == opposite then newWord = word end
  end
  if newWord then
    local prevCursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd.normal { '"_ciw' .. newWord, bang = true }
    vim.api.nvim_win_set_cursor(0, prevCursor)
  end
end

vim.api.nvim_create_user_command('ToggleWorld', M.toggleWord, {})
-- Smart duplicate line: =========================================================================
function M.smartDuplicate()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local ft = vim.bo.filetype
  -- FILETYPE-SPECIFIC TWEAKS
  if ft == 'css' then
    local newLine = line
    if line:find('top:') then newLine = line:gsub('top:', 'bottom:') end
    if line:find('bottom:') then newLine = line:gsub('bottom:', 'top:') end
    if line:find('right:') then newLine = line:gsub('right:', 'left:') end
    if line:find('left:') then newLine = line:gsub('left:', 'right:') end
    if line:find('height:') then newLine = line:gsub('height:', 'width:') end
    if line:find('width:') then newLine = line:gsub('width:', 'height:') end
    line = newLine
  elseif ft == 'javascript' or ft == 'typescript' or ft == 'swift' then
    line = line:gsub('^(%s*)if(.+{)$', '%1} else if%2')
  elseif ft == 'lua' then
    line = line:gsub('^(%s*)if( .* then)$', '%1elseif%2')
  elseif ft == 'zsh' or ft == 'bash' then
    line = line:gsub('^(%s*)if( .* then)$', '%1elif%2')
  elseif ft == 'python' then
    line = line:gsub('^(%s*)if( .*:)$', '%1elif%2')
  end
  -- INSERT DUPLICATED LINE
  vim.api.nvim_buf_set_lines(0, row, row, false, { line })
  -- MOVE CURSOR DOWN, AND TO VALUE/FIELD (IF THERE IS ANY)
  local _, luadocFieldPos = line:find('%-%-%-@%w+ ')
  local _, valuePos = line:find('[:=] ')
  local targetCol = luadocFieldPos or valuePos or col
  vim.api.nvim_win_set_cursor(0, { row + 1, targetCol })
end

vim.api.nvim_create_user_command('SmartDuplicate', M.smartDuplicate, {})
-- lspCapabilities: ==============================================================================
function M.lspCapabilities()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    vim.notify('No LSPs attached.', vim.log.levels.WARN, { icon = '󱈄' })
    return
  end
  vim.ui.select(clients, { prompt = '󱈄 Select LSP:', format_item = function(client) return client.name end },
    function(client)
      if not client then return end
      local info = {
        capabilities = client.capabilities,
        server_capabilities = client.server_capabilities,
        config = client.config,
      }
      local opts = { icon = '󱈄', title = client.name .. ' capabilities', ft = 'lua' }
      local header = '-- For a full view, open in notification history.\n'
      vim.notify(header .. vim.inspect(info), vim.log.levels.INFO, opts)
    end)
end

vim.api.nvim_create_user_command('LspCapabilities', M.lspCapabilities, {})
-- Capabilities: =================================================================================
function M.toggleTitleCase()
  local prevCursor = vim.api.nvim_win_get_cursor(0)
  local cword = vim.fn.expand('<cword>')
  local cmd = cword == cword:lower() and 'guiwgUl' or 'guiw'
  vim.cmd.normal { cmd, bang = true }
  vim.api.nvim_win_set_cursor(0, prevCursor)
end

vim.api.nvim_create_user_command('ToggleTitleCase', M.toggleTitleCase, {})
-- Delete buff: ==================================================================================
local winclose = function() vim.cmd.wincmd({ args = { 'c' } }) end
local tab_win_bufnrs = function(tabnr)
  local tab_wins = vim.tbl_filter(function(win)
    local win_buf = vim.api.nvim_win_get_buf(win)
    if 1 ~= vim.fn.buflisted(win_buf) then return true end
    return true
  end, vim.api.nvim_tabpage_list_wins(tabnr))
  return tab_wins
end
local loaded_bufnrs = function()
  local bufnrs = vim.tbl_filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then return false end
    -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
    if not vim.api.nvim_buf_is_loaded(b) then return false end
    return true
  end, vim.api.nvim_list_bufs())
  return bufnrs
end
M.delete_buffer = function()
  local tabnr = vim.api.nvim_get_current_tabpage()
  local bufnr = vim.api.nvim_get_current_buf()
  local num_tabs = #vim.api.nvim_list_tabpages()
  local bufs = loaded_bufnrs()
  local tab_wins = tab_win_bufnrs(tabnr)

  if #tab_wins > 1 then
    winclose()
  elseif num_tabs > 1 then
    if bufs[1] == bufnr then
      vim.cmd.tabclose()
    else
      winclose()
    end
  elseif #bufs <= 1 then
    if bufs[1] == bufnr then
      vim.cmd.quitall()
    else
      winclose()
    end
  else
    require('mini.bufremove').wipeout(0, true)
  end
end
vim.api.nvim_create_user_command('DeleteBuffer', M.delete_buffer, {})
-- Delete others buff: ===========================================================================
function M.deleteOthersBuffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= vim.fn.bufnr() and vim.fn.buflisted(buf) == 1 then
      require('mini.bufremove').wipeout(buf, true)
    end
  end
end

vim.api.nvim_create_user_command('DeleteOtherBuffers', M.deleteOthersBuffers, {})
-- Open All hunks in quickfix: =====================================================================
function M.diffInQuickFix()
  local hunks = require('mini.diff').export('qf')
  if #hunks == 0 then
    vim.notify('No changes to show', vim.log.levels.INFO)
    return
  end
  vim.fn.setqflist(hunks)
  vim.cmd('copen')
end

vim.api.nvim_create_user_command('MiniDiffInQuickFixList', M.diffInQuickFix, {})
-- Box Comment: ==================================================================================
function M.boxComment()
  local count = vim.v.count1
  local total_width = 79
  local tl, tr, bl, br = '╭', '╮', '╰', '╯'
  local horizontal, vertical = '─', '│'
  local comment_string = vim.bo.commentstring:gsub('%%s', ' ')
  local line_num = vim.fn.line('.')
  local border_top = comment_string .. tl .. string.rep(horizontal, total_width - #comment_string - 2) .. tr
  local border_bottom = comment_string .. bl .. string.rep(horizontal, total_width - #comment_string - 2) .. br
  local text_lines = {}
  for _ = 1, count do
    local text = ' '
    local padding = math.floor((total_width - #comment_string - 2 - #text) / 2)
    local text_line = comment_string
        .. vertical
        .. string.rep(' ', padding)
        .. text
        .. string.rep(' ', total_width - #comment_string - 2 - #text - padding)
        .. vertical
    table.insert(text_lines, text_line)
  end
  local content = { border_top }
  for _, line in ipairs(text_lines) do
    table.insert(content, line)
  end
  table.insert(content, border_bottom)
  vim.fn.append(line_num, content)
  local inner_start = #comment_string + 5
  vim.fn.cursor(line_num + 2, inner_start)
  vim.cmd([[startreplace]])
end

vim.api.nvim_create_user_command('BoxComment', M.boxComment, {})
-- Surround: =====================================================================================
function M.SurroundOrReplaceQuotes()
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
end

vim.api.nvim_create_user_command('SurroundOrReplaceQuotes', M.SurroundOrReplaceQuotes, {})
-- This is a simplified version of in-and-out.nvim: ==============================================
-- https://github.com/ysmb-wtsg/in-and-out.nvim
local function escape_lua_pattern(s)
  local matches = {
    ['^'] = '%^',
    ['$'] = '%$',
    ['('] = '%(',
    [')'] = '%)',
    ['%'] = '%%',
    ['.'] = '%.',
    ['['] = '%[',
    [']'] = '%]',
    ['*'] = '%*',
    ['+'] = '%+',
    ['-'] = '%-',
    ['?'] = '%?',
  }
  return s:gsub('.', matches)
end
local targets = { '"', "'", '(', ')', '{', '}', '[', ']', '`', '“', '”' }
function M.leap()
  local line_nr, col_nr = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  local target_col_nr = nil
  for _, char in ipairs(targets) do
    local found_col_nr =
        string.find(line, escape_lua_pattern(char), col_nr + 1)
    if
        found_col_nr and (not target_col_nr or found_col_nr < target_col_nr)
    then
      -- If char is a multibyte character, we need to take into
      -- account the extra bytes.
      target_col_nr = found_col_nr + vim.fn.strlen(char) - 1
    end
  end

  if target_col_nr then
    vim.api.nvim_win_set_cursor(0, { line_nr, target_col_nr })
  end
end

vim.api.nvim_create_user_command('Leap', M.leap, {})
-- go_to_relative_file: ==========================================================================
function M.go_to_relative_file(n, relative_to)
  return function()
    local this_dir = vim.fs.dirname(vim.fs.normalize(vim.fn.expand('%:p')))
    local files = {}
    for file, type in vim.fs.dir(this_dir) do
      if type == 'file' then
        table.insert(files, file)
      end
    end
    local this_file = relative_to or vim.fs.basename(vim.fn.bufname())
    local this_file_pos = -1
    for i, file in ipairs(files) do
      if file == this_file then
        this_file_pos = i
      end
    end
    if this_file_pos == -1 then
      error(('File `%s` not found in current directory'):format(this_file))
    end
    local new_file = files[((this_file_pos + n - 1) % #files) + 1]
    if not new_file then
      error(('Could not find file relative to `%s`'):format(this_file))
    end
    vim.cmd('edit ' .. this_dir .. '/' .. new_file)
  end
end

vim.api.nvim_create_user_command('RelativeFileNext', M.go_to_relative_file(1), {})
vim.api.nvim_create_user_command('RelativeFilePrev', M.go_to_relative_file(-1), {})
