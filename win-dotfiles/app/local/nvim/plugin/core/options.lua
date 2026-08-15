-- ============================================================================== #
-- Options:                                                                       #
-- ============================================================================== #
Config.now(function()
  -- Enable all filetype plugins and syntax (if not enabled, for better startup): ================
  vim.cmd('filetype plugin indent on')
  if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

  -- Leader:  ====================================================================================
  vim.g.mapleader                = vim.keycode('<space>')
  vim.g.maplocalleader           = vim.g.mapleader

  -- Os:  ========================================================================================
  vim.g.is_win                   = vim.uv.os_uname().sysname:find('Windows') ~= nil
  vim.g.is_windows               = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1

  -- Useful for dynamically constructing paths in plugin configs or scripts: =====================
  vim.g.path_delimiter           = vim.g.is_windows and ';' or ':'
  vim.g.path_separator           = vim.g.is_windows and '\\' or '/'

  -- grep: =======================================================================================
  vim.o.grepprg                  = 'rg --vimgrep --smart-case --no-heading --color=never --glob !.git'
  vim.o.grepformat               = '%f:%l:%c:%m,%f:%l:%m'
  vim.o.path                     = vim.o.path .. ',**'

  -- General: ====================================================================================
  vim.o.undofile                 = true
  vim.o.wildmenu                 = true
  vim.o.wildignorecase           = true
  vim.o.compatible               = false
  vim.o.swapfile                 = false
  vim.o.writebackup              = false
  vim.o.backup                   = false
  vim.o.bomb                     = false
  vim.o.undolevels               = 1024
  vim.o.undoreload               = 65538
  vim.o.completetimeout          = 100
  vim.o.completeopt              = 'menuone,noselect,fuzzy,nosort'
  vim.o.completeitemalign        = 'abbr,kind,menu'
  vim.o.complete                 = '.,w,b,kspell'
  vim.o.clipboard                = 'unnamedplus'
  vim.o.wildmode                 = 'noselect:lastused,full'
  vim.o.wildoptions              = 'fuzzy,pum'
  vim.o.wildignore               = '*/node_modules/*,*/dist/*,*/target/*,*/.git/*,*/.next/*,*/build/*'
  vim.o.backupskip               = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim'
  vim.o.breakat                  = [[\ \	;:,!?@*-+/]]
  vim.o.omnifunc                 = 'v:lua.vim.lsp.omnifunc'
  vim.o.switchbuf                = 'usetab,uselast'
  vim.o.includeexpr              = "substitute(v:fname,'\\.','/','g')"
  vim.o.viminfo                  = "'20,<1000,s1000"
  vim.o.shada                    = "'100,<50,s10,:1000,/100,@100,h"
  vim.o.fileencoding             = 'utf-8'
  vim.o.encoding                 = 'utf-8'
  vim.o.wildcharm                = vim.keycode('<C-z>'):byte()
  vim.o.fileformats              = vim.g.is_windows and 'dos' or 'unix'
  vim.o.fileignorecase           = not vim.g.is_windows
  vim.o.undodir                  = vim.fn.stdpath('data') .. '/undo'

  -- Spelling ====================================================================================
  vim.o.spell                    = false
  vim.o.spelllang                = 'en_us'
  vim.o.spelloptions             = 'camel,noplainbuffer'
  vim.o.spellsuggest             = 'best,8'
  vim.o.spellfile                = vim.fn.stdpath('config') .. '/misc/spell/en.utf-8.add'
  vim.o.dictionary               = vim.fn.stdpath('config') .. '/misc/dict/english.txt'

  -- UI: =========================================================================================
  vim.o.number                   = true
  vim.o.termguicolors            = true
  vim.o.ttyfast                  = true
  vim.o.smoothscroll             = true
  vim.o.splitright               = true
  vim.o.splitbelow               = true
  vim.o.equalalways              = true
  vim.o.showcmd                  = true
  vim.o.cursorline               = true
  vim.o.mousefocus               = true
  vim.o.relativenumber           = false
  vim.o.title                    = false
  vim.o.list                     = false
  vim.o.modeline                 = false
  vim.o.showmode                 = false
  vim.o.errorbells               = false
  vim.o.visualbell               = false
  vim.o.emoji                    = false
  vim.o.ruler                    = false
  vim.o.scrolloff                = 999
  vim.o.sidescrolloff            = 4
  vim.o.numberwidth              = 4
  vim.o.linespace                = 3
  vim.o.sidescroll               = 0
  vim.o.showtabline              = 0
  vim.o.laststatus               = 0
  vim.o.cmdheight                = 0
  vim.o.helpheight               = 0
  vim.o.previewheight            = 12
  vim.o.winwidth                 = 20
  vim.o.winminwidth              = 10
  vim.o.winblend                 = 0
  vim.o.pumblend                 = 0
  vim.o.pummaxwidth              = 50
  vim.o.pumwidth                 = 30
  vim.o.pumheight                = 10
  vim.o.cmdwinheight             = 10
  vim.o.titlelen                 = 127
  vim.o.tabpagemax               = 10000
  vim.o.scrollback               = 100000
  vim.o.winbar                   = ''
  vim.o.colorcolumn              = ''
  vim.o.guicursor                = ''
  vim.o.guifont                  = ''
  vim.o.pumborder                = 'single'
  vim.o.background               = 'dark'
  vim.o.display                  = 'lastline,truncate,msgsep'
  vim.o.showcmdloc               = 'statusline'
  vim.o.belloff                  = 'all'
  vim.o.titlestring              = '%{getcwd()} : %{expand(\"%:r\")} [%M] ― Neovim'
  vim.o.splitkeep                = 'screen'
  vim.o.mouse                    = 'a'
  vim.o.mousemodel               = 'popup_setpos'
  vim.o.mousescroll              = 'ver:3,hor:6'
  vim.o.winborder                = 'single'
  vim.o.backspace                = 'indent,eol,start'
  vim.o.cursorlineopt            = 'screenline'
  vim.o.tabclose                 = 'uselast'
  vim.o.shortmess                = 'CFOWSsaco'
  vim.o.signcolumn               = 'yes'
  vim.o.statuscolumn             = ''
  vim.o.showbreak                = '󰘍' .. string.rep(' ', 1)
  vim.o.statusline               = string.rep('⎯', vim.o.columns)
  vim.o.fillchars                = 'eob: ,fold:⏤,diff:-,foldclose:▶,foldopen:▼,lastline:⋯,msgsep:─'
  vim.o.listchars                = 'tab:» ,eol:↲,trail:•,nbsp:␣,extends:→,precedes:←'

  -- Editing:  ===================================================================================
  vim.o.autoindent               = true
  vim.o.cindent                  = true
  vim.o.expandtab                = true
  vim.o.hlsearch                 = true
  vim.o.incsearch                = true
  vim.o.infercase                = true
  vim.o.smartcase                = true
  vim.o.ignorecase               = true
  vim.o.smartindent              = true
  vim.o.shiftround               = true
  vim.o.smarttab                 = true
  vim.o.gdefault                 = true
  vim.o.confirm                  = true
  vim.o.breakindent              = true
  vim.o.linebreak                = true
  vim.o.copyindent               = true
  vim.o.preserveindent           = true
  vim.o.startofline              = true
  vim.o.wrapscan                 = true
  vim.o.exrc                     = true
  vim.o.secure                   = true
  vim.o.autoread                 = true
  vim.o.modifiable               = true
  vim.o.autowrite                = false
  vim.o.autowriteall             = false
  vim.o.autocomplete             = false
  vim.o.autochdir                = false
  vim.o.mousemoveevent           = false
  vim.o.tildeop                  = false
  vim.o.showmatch                = false
  vim.o.magic                    = false
  vim.o.wrap                     = false
  vim.o.joinspaces               = false
  vim.o.rightleft                = false
  vim.o.matchtime                = 2
  vim.o.wrapmargin               = 2
  vim.o.tabstop                  = 2
  vim.o.shiftwidth               = 2
  vim.o.softtabstop              = 2
  vim.o.textwidth                = 80
  vim.o.conceallevel             = 0
  vim.o.concealcursor            = 'c'
  vim.o.cedit                    = '^F'
  vim.o.breakindentopt           = 'list:-1'
  vim.o.inccommand               = 'nosplit'
  vim.o.jumpoptions              = 'stack,view'
  vim.o.selection                = 'old'
  vim.o.nrformats                = 'bin,hex,alpha,unsigned'
  vim.o.whichwrap                = 'b,s,<,>,[,],h,l,~'
  vim.o.matchpairs               = '(:),[:],{:},<:>'
  vim.o.iskeyword                = '@,48-57,_,192-255,-'
  vim.o.formatlistpat            = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
  vim.o.virtualedit              = 'block'
  vim.o.formatoptions            = 'rqnl1j'
  vim.o.formatexpr               = "v:lua.require'conform'.formatexpr()"
  vim.o.sessionoptions           = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
  vim.o.diffopt                  = 'internal,filler,iwhite,closeoff,algorithm:histogram,indent-heuristic,linematch:60'
  vim.o.suffixesadd              = '.html,.css,.scss,.js,.ts,.jsx,.tsx,.json,.md,.yaml,.yml,.lua'
  vim.o.keywordprg               = vim.g.is_windows and ':help' or ':Man'

  -- Folds:  =====================================================================================
  vim.o.foldenable               = false
  vim.o.foldlevel                = 1
  vim.o.foldlevelstart           = 99
  vim.o.foldnestmax              = 10
  vim.o.foldminlines             = 4
  vim.o.foldtext                 = ''
  vim.o.foldcolumn               = '0'
  vim.o.foldmethod               = 'manual'
  vim.o.foldopen                 = 'hor,mark,tag,search,insert,quickfix,undo'
  vim.o.foldexpr                 = '0'

  -- Memory: =====================================================================================
  vim.o.timeout                  = true
  vim.o.lazyredraw               = true
  vim.o.hidden                   = true
  vim.o.maxmempattern            = 20000
  vim.o.redrawtime               = 10000
  vim.o.timeoutlen               = 500
  vim.o.ttimeoutlen              = 400
  vim.o.updatetime               = 300
  vim.o.synmaxcol                = 200
  vim.o.history                  = 100
  vim.o.regexpengine             = 0

  -- Disable builtin plugins: ====================================================================
  vim.g.loaded_gzip              = 1
  vim.g.loaded_tar               = 1
  vim.g.loaded_tarPlugin         = 1
  vim.g.loaded_zip               = 1
  vim.g.loaded_zipPlugin         = 1
  vim.g.loaded_getscript         = 1
  vim.g.loaded_getscriptPlugin   = 1
  vim.g.loaded_vimball           = 1
  vim.g.loaded_vimballPlugin     = 1
  vim.g.loaded_2html_plugin      = 1
  vim.g.loaded_osc52             = 1
  vim.g.loaded_rrhelper          = 1
  vim.g.loaded_netrw             = 1
  vim.g.loaded_netrwPlugin       = 1
  vim.g.loaded_netrwSettings     = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.loaded_matchit           = 1
  vim.g.loaded_matchparen        = 1
  vim.g.loaded_logipat           = 1
  vim.g.loaded_spellfile_plugin  = 1
  vim.g.loaded_tutor             = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_syntax_completion = 1
  vim.g.loaded_syntax            = 1
  vim.g.loaded_synmenu           = 1
  vim.g.loaded_man               = 1
  vim.g.loaded_shada_plugin      = 1
  vim.g.loaded_remote_plugins    = 1
  vim.g.loaded_optwin            = 1
  vim.g.loaded_compiler          = 1
  vim.g.loaded_bugreport         = 1
  vim.g.loaded_rplugin           = 1
  vim.g.loaded_ftplugin          = 1

  -- Disable health checks for these providers: ==================================================
  vim.g.loaded_perl_provider     = 0
  vim.g.loaded_ruby_provider     = 0
  vim.g.loaded_node_provider     = 0
  vim.g.loaded_python_provider   = 0
  vim.g.loaded_python3_provider  = 0
end)

-- ============================================================================== #
-- Neovide:                                                                       #
-- ============================================================================== #
Config.later(function()
  if vim.g.neovide then
    -- General: ==================================================================================
    vim.o.guifont = 'JetBrainsMono Nerd Font:h12'
    vim.g.neovide_scale_factor = 1
    vim.g.neovide_refresh_rate = 120

    -- Appearance: ===============================================================================
    vim.g.neovide_opacity = 1
    vim.g.neovide_underline_stroke_scale = 2.5
    vim.g.neovide_show_border = false

    -- Padding: ==================================================================================
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0

    -- Floating: =================================================================================
    vim.g.neovide_floating_shadow = false
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0

    -- Behavior: =================================================================================
    vim.g.neovide_remember_window_size = false
    vim.g.neovide_hide_mouse_when_typing = false
    vim.g.neovide_no_idle = false
    vim.g.neovide_cursor_smooth_blink = false
    vim.g.neovide_cursor_antialiasing = false
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false

    -- Cursor: ===================================================================================
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00

    -- Options: ==================================================================================
    vim.o.mousescroll = 'ver:10,hor:6'
    vim.o.linespace = 0

    -- Keymap: ===================================================================================
    vim.keymap.set({ 'n', 'v' }, '<F11>', ':<C-u>let g:neovide_fullscreen = !g:neovide_fullscreen<CR>')
    vim.keymap.set({ 'n', 'v' }, '<C-=>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<cr>')
    vim.keymap.set({ 'n', 'v' }, '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<cr>')
    vim.keymap.set({ 'n', 'v' }, '<C-0>', ':lua vim.g.neovide_scale_factor = 1<cr>')
  end
end)

-- ============================================================================== #
-- Diagnostics:                                                                   #
-- ============================================================================== #
local diagnostic_signs = { Error = '\u{2503}', Warn = '\u{2503}', Hint = '\u{2503}', Info = '\u{2503}' }
local diagnostic_opts = {
  severity_sort = false,
  virtual_lines = false,
  update_in_insert = false,
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  signs = {
    priority = 9999,
    severity = { min = 'ERROR', max = 'ERROR' },
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
      [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
    },
  },
  float = {
    prefix = '󰨓 ',
    source = 'if_many',
    style = 'minimal',
    border = 'single',
    header = '',
    title = '󱓇 Diagnostics:',
    title_pos = 'left',
    max_height = 10,
    max_width = 130,
    focusable = false,
    close_events = { 'CursorMoved', 'BufLeave', 'WinLeave', 'InsertEnter' },
  },
  virtual_text = {
    current_line = true,
    spacing = 4,
    highlight = false,
    prefix = '●',
    source = 'if_many',
    virt_text_pos = 'eol_right_align',
    severity = { min = 'ERROR', max = 'ERROR' },
    format = function(diagnostic)
      local icon = '→ '
      local message = vim.split(diagnostic.message, '\n')[1]
      return ('%s %s '):format(icon, message)
    end,
  },
}
-- Use `later()` to avoid sourcing `vim.diagnostic` on startup: ==================================
Config.later(function() vim.diagnostic.config(diagnostic_opts) end)
