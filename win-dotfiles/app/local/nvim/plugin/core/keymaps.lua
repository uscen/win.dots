-- ============================================================================== #
-- Keymaps:                                                                       #
-- ============================================================================== #
Config.later(function()
  -- ============================================================================== #
  -- Helpers:                                                                       #
  -- ============================================================================== #
  local L = function(key) return '<leader>' .. key end
  local C = function(cmd) return '<Cmd>' .. cmd .. '<CR>' end
  local map = function(mode, lhs, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    vim.keymap.set(vim.split(mode, ''), lhs, rhs, opts)
  end

  -- ============================================================================== #
  -- Basic:                                                                         #
  -- ============================================================================== #
  map('n', L 'rr', C 'Match', 'Search and Replace')
  map('n', L 'rs', C 'MatchWord', 'Search and Replace word under cursor')
  map('n', L 'rc', C 'EditConfig', 'Edit configuration')
  map('n', L 're', C 'restart', 'Restart editor')
  map('n', L 'qq', C 'quitall', 'Quit all window')
  map('n', L 's', C 'SmartWord', 'Switch [boolean | word]')
  map('n', L 'j', C 'SmartDuplicate', 'Smart duplicate line')

  -- ============================================================================== #
  -- Frequently:                                                                    #
  -- ============================================================================== #
  map('n', L ' ', C 'Pick files', 'Search files')
  map('n', L '"', C 'Pick registers', 'Search registers')
  map('n', L ',', C 'Pick buffers', 'Switch buffer')
  map('n', L '.', C 'Pick resume', 'Resume picker')
  map('n', L ';', C 'Pick commands', 'Run command')
  map('n', L ':', C 'Pick history scope=":"', '":" history')
  map('n', L '/', C 'Pick history scope="/"', '"/" history')
  map('n', L '?', C 'Pick keymaps', 'Find keymap')
  map('n', L '=', C 'Pick spellsuggest', 'Fix spelling')

  -- ============================================================================== #
  -- Quickfix:                                                                      #
  -- ============================================================================== #
  map('n', L 'co', C 'copen', 'Open quickfix list')
  map('n', L 'cc', C 'cclose', 'Close quickfix list')
  map('n', L 'cn', C 'cnext', 'Next quickfix item')
  map('n', L 'cp', C 'cprev', 'Previous quickfix item')
  map('n', L 'cN', C 'cnfile', 'Next file in quickfix')
  map('n', L 'cP', C 'cpfile', 'Previous file in quickfix')
  map('n', L 'cl', C 'clist', 'Just list quickfix items')
  map('n', L 'cs', C 'cfirst', 'First quickfix item')
  map('n', L 'ce', C 'clast', 'Last quickfix item')
  map('n', L 'ca', C 'caddbuffer', 'Add buffer to quickfix list')
  map('n', L 'ch', C 'chistory', 'Show quickfix history')

  -- ============================================================================== #
  -- Explore:                                                                       #
  -- ============================================================================== #
  map('n', L 'ee', C 'ExploreAtFile', 'Toggle File directory')
  map('n', L 'er', C 'ExploreAtRoot', 'Toggle Root directory')
  map('n', L 'eq', C 'ExploreQuickfix', 'Toggle quickfix list')
  map('n', L 'el', C 'ExploreLocations', 'Toggle location list')
  map('n', L 'eu', C 'Undotree', 'Toggle undotree history')
  map('n', L 'ed', C 'Pick zoxide', 'Directory (zoxide)')
  map('n', L 'em', C 'Pick plugins', 'Plugin (module)')
  map('n', L 'ec', C 'Pick config', 'Config (nvim)')
  map('n', L 'eh', C 'Pick home', 'Config (/home/[user])')
  map('n', L 'ep', C 'Pick project', 'Project (/home/[user]/projects)')

  -- ============================================================================== #
  -- Buffer:                                                                        #
  -- ============================================================================== #
  map('n', L 'bn', C 'bnext', 'Next buffer')
  map('n', L 'bp', C 'bprevious', 'Previous buffer')
  map('n', L 'ba', C 'b#', 'Alternate buffer')
  map('n', L 'bd', C 'DeleteBuffer', 'Delete buffer')
  map('n', L 'bo', C 'DeleteOtherBuffers', 'Delete other buffers')
  map('n', L 'bi', C 'DeleteInactiveBuffers', 'Delete inactive buffers')
  map('n', L 'bb', C 'DeleteInactiveBuffers', 'Delete inactive buffers')
  map('n', L 'bs', C 'ScratchBuffer', 'New scratch buffer')
  map('n', L 'bt', C 'TrailspaceTrim', 'Remove trailing whitespace')
  map('n', L 'bj', C 'JoinEmptyLines', 'Remove empty lines')

  -- ============================================================================== #
  -- Language:                                                                      #
  -- ============================================================================== #
  map('nx', L 'lf', C 'Format', 'Format')
  map('nx', L 'la', C 'lua vim.lsp.buf.code_action()', 'Actions')
  map('n', L 'ld', C 'lua vim.diagnostic.open_float()', 'Diagnostic popup')
  map('n', L 'li', C 'lua vim.lsp.buf.implementation()', 'Implementation')
  map('n', L 'lI', C 'LspInfo', 'LSP info')
  map('n', L 'lh', C 'lua vim.lsp.buf.hover()', 'Hover')
  map('n', L 'll', C 'lua vim.lsp.codelens.run()', 'Run codelens')
  map('n', L 'lL', C 'lua vim.lsp.codelens.refresh()', 'Refresh & display codelens')
  map('n', L 'lr', C 'lua vim.lsp.buf.rename()', 'Rename')
  map('n', L 'lR', C 'lua vim.lsp.buf.references()', 'References')
  map('n', L 'ls', C 'lua vim.lsp.buf.definition()', 'Source definition')
  map('n', L 'lt', C 'lua vim.lsp.buf.type_definition()', 'Type definition')

  -- ============================================================================== #
  -- Git:                                                                           #
  -- ============================================================================== #
  map('n', L 'gg', C 'Lazygit', 'Open lazygit')
  map('n', L 'gq', C 'DiffToQf', 'Quickfix diffs')
  map('n', L 'gl', C 'MinigitLog', 'Log')
  map('n', L 'gL', C 'MinigitLogBuf', 'Log (buf)')
  map('n', L 'ga', C 'Git add --all', 'Added')
  map('n', L 'gA', C 'Git add -- %', 'Added (buf)')
  map('n', L 'gi', C 'Git diff --cached', 'Added diff')
  map('n', L 'gI', C 'Git diff --cached -- %', 'Added diff (buf)')
  map('n', L 'gc', C 'Git commit', 'Commit')
  map('n', L 'gC', C 'Git commit --amend', 'Commit amend')
  map('n', L 'gp', C 'Git push', 'Push to origin')
  map('n', L 'gP', C 'Git pull', 'Pull from origin')
  map('n', L 'gd', C 'Git diff', 'Diff')
  map('n', L 'gD', C 'Git diff -- %', 'Diff (buf)')
  map('n', L 'go', C 'lua MiniDiff.toggle_overlay()', 'Toggle overlay')
  map('n', L 'gh', C 'lua MiniDiff.toggle_overlay()', 'Toggle overlay')
  map('nx', L 'gb', C 'lua MiniGit.show_range_history()', 'Range history')
  map('nx', L 'gs', C 'lua MiniGit.show_at_cursor()', 'Show at cursor')

  -- ============================================================================== #
  -- Window:                                                                        #
  -- ============================================================================== #
  map('n', L 'ww', C 'RotateWindows', 'Rotate window position')
  map('n', L 'wm', C 'MoveWindowToTab', 'Move current window to tab')
  map('n', L 'wq', C 'close', 'Close window')
  map('n', L 'wo', C 'only', 'Close other windows')
  map('n', L 'wb', C 'vsplit', 'Vertical split')
  map('n', L 'wv', C 'split', 'Horizontal split')
  map('n', L 'wk', C 'resize +10', 'Resize window height')
  map('n', L 'wj', C 'resize -10', 'Resize window height')
  map('n', L 'wh', C 'vertical resize +10', 'Resize window width')
  map('n', L 'wl', C 'vertical resize -10', 'Resize window width')
  map('n', L 'wK', C 'wincmd K', 'Move window to top')
  map('n', L 'wJ', C 'wincmd J', 'Move window to bottom')
  map('n', L 'wH', C 'wincmd H', 'Move window to left')
  map('n', L 'wL', C 'wincmd L', 'Move window to right')
  map('n', L 'wT', C 'wincmd T', 'Move window to new tab')
  map('n', L 'wR', C 'wincmd R', 'Rotate windows (Up/Left)')
  map('n', L 'wr', C 'wincmd r', 'Rotate windows (Down/Right)')
  map('n', L 'w=', C 'wincmd =', 'Balance window sizes')
  map('n', L 'w0', C 'wincmd =', 'Resize to default width')
  map('n', L 'w|', C 'wincmd v', 'Vertical split')
  map('n', L 'w-', C 'wincmd s', 'Horizontal split')

  -- ============================================================================== #
  -- Find:                                                                          #
  -- ============================================================================== #

  map('n', L 'f/', C "Pick history scope='/'", '"/" history')
  map('n', L 'f:', C "Pick history scope=':'", '":" history')
  map('n', L 'f.', C 'Pick resume', 'Resume')
  map('n', L 'fa', C "Pick git_hunks scope='staged'", 'Added hunks (all)')
  map('n', L 'fA', C "Pick git_hunks path='%' scope='staged'", 'Added hunks (buf)')
  map('n', L 'fb', C 'Pick buffers', 'Buffers')
  map('n', L 'fc', C 'Pick git_commits', 'Commits (all)')
  map('n', L 'fC', C "Pick git_commits path='%'", 'Commits (buf)')
  map('n', L 'fd', C "Pick diagnostic scope='all'", 'Diagnostic (workspace)')
  map('n', L 'fD', C "Pick diagnostic scope='current'", 'Diagnostic (buf)')
  map('n', L 'ff', C 'Pick files', 'Files')
  map('n', L 'fg', C 'Pick grep_live', 'Grep live')
  map('n', L 'fG', C "Pick grep pattern='<cword>'", 'Grep current word')
  map('n', L 'fh', C 'Pick help', 'Help tags')
  map('n', L 'fH', C 'Pick hl_groups', 'Highlight groups')
  map('n', L 'fl', C "Pick buf_lines scope='all' preserver_order=true", 'Lines (all)')
  map('n', L 'fL', C "Pick buf_lines scope='current' preserve_order=true", 'Lines (buf)')
  map('n', L 'fm', C 'Pick git_hunks', 'Modified hunks (all)')
  map('n', L 'fM', C "Pick git_hunks path='%'", 'Modified hunks (buf)')
  map('n', L 'fk', C 'Pick keymaps', 'Pick keymaps')
  map('n', L 'fo', C 'Pick options', 'Find option')
  map('n', L 'fr', C 'Pick oldfiles', 'Old files')
  map('n', L 'fR', C "Pick lsp scope='references'", 'References (LSP)')
  map('n', L 'fs', C "Pick lsp scope='workspace_symbol'", 'Symbols workspace')
  map('n', L 'fS', C "Pick lsp scope='document_symbol'", 'Symbols document')
  map('n', L 'ft', C 'Pick grep_todo_keywords', 'Search todo/fixme/hack/note')
  map('n', L 'fT', C 'Pick colorschemes', 'Search colorschemes')
  map('n', L 'fv', C "Pick visit_paths cwd=''", 'Visit paths (all)')
  map('n', L 'fV', C 'Pick visit_paths', 'Visit paths (cwd)')

  -- ============================================================================== #
  -- Other:                                                                         #
  -- ============================================================================== #
  map('n', L 'oa', C 'Mason', 'Mason')
  map('n', L 'ox', C 'OpenUrl', 'Open url')
  map('n', L 'os', C 'Dashboard', 'Open Dashboard')
  map('n', L 'ou', C 'PackUpdate', 'Update plugins')
  map('n', L 'oc', C 'PackClean', 'Clean plugins')
  map('n', L 'ol', C 'PackList', 'List plugins')

  -- ============================================================================== #
  -- Noneleader:                                                                    #
  -- ============================================================================== #
  -- General: ====================================================================================
  map('n', '<C-H>', '<C-w>h', 'Go to left window')
  map('n', '<C-J>', '<C-w>j', 'Go to lower window')
  map('n', '<C-K>', '<C-w>k', 'Go to upper window')
  map('n', '<C-L>', '<C-w>l', 'Go to right window')
  map('n', '<C-n>', '*N', 'Highlight word under cursor')
  map('x', '<Tab>', '>gv', 'Indent selection')
  map('x', '<S-Tab>', '<gv', 'Unindent selection')
  map('n', '<Tab>', C 'bnext', 'Next buffer')
  map('n', '<S-Tab>', C 'bprevious', 'Previous buffer')
  map('n', '<Esc>', C 'nohlsearch', 'Clear search highlights')
  map('n', '<C-c>', C 'ChangeInTag', 'Change between tag')
  map('in', '<C-s>', C 'silent update', 'Save buffer')
  map('in', '<C-Tab>', C 'InAndOut', 'Jump in and out')

  -- Bracketed: ==================================================================================
  map('n', ']f', C 'RelativeFileNext', 'Next file in directory')
  map('n', '[f', C 'RelativeFilePrev', 'Previous file in directory')
  map('n', ']a', C 'next', 'Next argument list file')
  map('n', '[a', C 'previous', 'Previous argument list file')
  map('n', ']b', C 'bnext', 'Next buffer')
  map('n', '[b', C 'bprevious', 'Previous buffer')
  map('n', ']B', C 'blast', 'Last buffer')
  map('n', '[B', C 'bfirst', 'First buffer')
  map('n', ']q', C 'cnext', 'Next quickfix item')
  map('n', '[q', C 'cprevious', 'Previous quickfix item')
  map('n', ']Q', C 'clast', 'Last quickfix item')
  map('n', '[Q', C 'cfirst', 'First quickfix item')
  map('n', ']l', C 'lnext', 'Next location list item')
  map('n', '[l', C 'lprevious', 'Previous location list item')
  map('n', ']t', C 'tnext', 'Next tab')
  map('n', '[t', C 'tprevious', 'Previous tab')
  map('n', ']T', C 'tlast', 'Last tab')
  map('n', '[T', C 'tfirst', 'First tab')
  map('n', '[p', C 'exe "iput! " . v:register', 'Paste Above (linewise)')
  map('n', ']p', C 'exe "iput "  . v:register', 'Paste Below (linewise)')
  map('n', '[<space>', C "<c-u>put! =repeat(nr2char(10), v:count1)'[", 'Add blank line(s) above')
  map('n', ']<space>', C "<c-u>put =repeat(nr2char(10), v:count1)']", 'Add blank line(s) below')

  -- Misc: ======================================================================================
  map('n', '-', C 'ExploreAtFile', 'Toggle file explorer')
  map('x', 'S', C 'VisualSurround', 'Surround visual selection')
  map('n', 'sw', C 'SurroundOrReplaceQuotes', 'Surround or replace quotes')
  map('n', 'gF', C 'OpenOrCreateFile', 'Open or create file under the cursor')
  map('n', 'gv', C 'GetSelection', 'Yank last visual selection')
  map('n', 'gp', C 'GetPasteText', 'Select last pasted text')
  map('n', 'g?', C 'YankDiagnostic', 'Yank diagnostic to system clipboard')
  map('n', 'gy', C 'YankToClipboard', 'Yank last into system clipboard')
  map('x', 'gb', C 'YankCodeBlock', 'Yank selection as formatted code block')

  -- Pmenu: ===================================================================================
  map('ic', '<C-j>', [[pumvisible() ? "\<C-n>" : "\<C-j>"]], 'Next completion item', { expr = true })
  map('ic', '<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]], 'Previous completion item', { expr = true })
end)
