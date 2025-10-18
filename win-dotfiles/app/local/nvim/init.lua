--              ╔═════════════════════════════════════════════════════════╗
--              ║                          Plugins                        ║
--              ╚═════════════════════════════════════════════════════════╝
--              ┌─────────────────────────────────────────────────────────┐
--                    Clone 'mini.nvim manually in a way that it gets
--                                managed by 'mini.deps'
--              └─────────────────────────────────────────────────────────┘
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Deps                           │
--              ╰─────────────────────────────────────────────────────────╯
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Git                            │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  require('mini.git').setup()
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Diff                           │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  require('mini.diff').setup({ view = { style = 'sign' } })
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Notify                         │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  local MiniNotify = require('mini.notify')
  MiniNotify.setup({
    lsp_progress = { enable = false, duration_last = 500 },
    window = {
      config = function()
        local has_statusline = vim.o.laststatus > 0
        local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
        return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
      end,
      max_width_share = 0.75,
    },
  })
  vim.notify = MiniNotify.make_notify()
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                         Mini.Ai                         │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  local MiniAi = require('mini.ai')
  local MiniExtra = require('mini.extra')
  local gen_ai_spec = MiniExtra.gen_ai_spec
  MiniExtra.setup()
  MiniAi.setup({
    n_lines = 500,
    search_method = 'cover_or_nearest',
    mappings = {
      around = 'a',
      inside = 'i',
      around_next = 'an',
      inside_next = 'in',
      around_last = 'al',
      inside_last = 'il',
      goto_left = '{',
      goto_right = '}',
    },
    custom_textobjects = {
      r = gen_ai_spec.diagnostic(),
      s = gen_ai_spec.buffer(),
      i = gen_ai_spec.indent(),
      d = gen_ai_spec.number(),
      c = gen_ai_spec.line(),
      g = gen_ai_spec.buffer(),
      u = MiniAi.gen_spec.function_call(),
			a = MiniAi.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      F = MiniAi.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
      e = { { '%f[%a]%l+%d*', '%f[%w]%d+', '%f[%u]%u%f[%A]%d*', '%f[%u]%u%l+%d*', '%f[%u]%u%u+%d*' } },
    },
  })
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Pairs                          │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
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
      ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^%w][^%w]', register = { cr = false } },
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%w][^%w]', register = { cr = false } },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^%w][^%w]', register = { cr = false } },
      ['<'] = { action = 'closeopen', pair = '<>', neigh_pattern = '[^%S][^%S]', register = { cr = false } },
    },
  })
  local cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      local item_selected = vim.fn.complete_info()['selected'] ~= -1
      return item_selected and '\25' or '\25\r'
    else
      return MiniPairs.cr()
    end
  end
  vim.keymap.set('i', '<cr>', cr_action, { expr = true })
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Surround                       │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
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
  -- custom quotes surrounding rotation for quick access: ========================================
  local function SurroundOrReplaceQuotes()
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
      vim.cmd('normal ysiw\"')
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
  vim.keymap.set({ 'n' }, 'sq', SurroundOrReplaceQuotes)
  -- Remap adding surrounding to Visual mode selection: ==========================================
  vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Hipatterns                     │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  local MiniHiPatterns = require('mini.hipatterns')
  local censor_extmark_opts = function(_, match, _)
    local mask = string.rep('x', vim.fn.strchars(match))
    return { virt_text = { { mask, 'Comment' } }, virt_text_pos = 'overlay', priority = 2000, right_gravity = false }
  end
  local tw_store = {
    hl = {},
    -- stylua: ignore
    cl = {
      slate={[50]='f8fafc',[100]='f1f5f9',[200]='e2e8f0',[300]='cbd5e1',[400]='94a3b8',
      [500]='64748b',[600]='475569',[700]='334155',[800]='1e293b',[900]='0f172a',[950]='020617'},
      gray={[50]='f9fafb',[100]='f3f4f6',[200]='e5e7eb',[300]='d1d5db',[400]='9ca3af',
      [500]='6b7280',[600]='4b5563',[700]='374151',[800]='1f2937',[900]='111827',[950]='030712'},
      zinc={[50]='fafafa',[100]='f4f4f5',[200]='e4e4e7',[300]='d4d4d8',[400]='a1a1aa',
      [500]='71717a',[600]='52525b',[700]='3f3f46',[800]='27272a',[900]='18181b',[950]='09090B'},
      neutral={[50]='fafafa',[100]='f5f5f5',[200]='e5e5e5',[300]='d4d4d4',[400]='a3a3a3',
      [500]='737373',[600]='525252',[700]='404040',[800]='262626',[900]='171717',[950]='0a0a0a'},
      stone={[50]='fafaf9',[100]='f5f5f4',[200]='e7e5e4',[300]='d6d3d1',[400]='a8a29e',
      [500]='78716c',[600]="57534e",[700]="44403c",[800]='292524',[900]='1c1917',[950]='0a0a0a'},
      red={[50]='fef2f2',[100]="fee2e2",[200]="fecaca",[300]='fca5a5',[400]='f87171',
      [500]="ef4444",[600]="dc2626",[700]="b91c1c",[800]='991b1b',[900]='7f1d1d',[950]='450a0a'},
      orange={[50]="fff7ed",[100]="ffedd5",[200]="fed7aa",[300]='fdba74',[400]='fb923c',
      [500]='f97316',[600]="ea580c",[700]="c2410c",[800]='9a3412',[900]='7c2d12',[950]='431407'},
      amber={[50]='fffbeb',[100]='fef3c7',[200]='fde68a',[300]='fcd34d',[400]='fbbf24',
      [500]='f59e0b',[600]='d97706',[700]='b45309',[800]='92400e',[900]='78350f',[950]='451a03'},
      yellow={[50]='fefce8',[100]="fef9c3",[200]="fef08a",[300]="fde047",[400]='facc15',
      [500]='eab308',[600]="ca8a04",[700]="a16207",[800]='854d0e',[900]='713f12',[950]='422006'},
      lime={[50]='f7fee7',[100]="ecfccb",[200]="d9f99d",[300]="bef264",[400]='a3e635',
      [500]='84cc16',[600]='65a30d',[700]='4d7c0f',[800]='3f6212',[900]='365314',[950]='1a2e05'},
      green={[50]='f0fdf4',[100]='dcfce7',[200]='bbf7d0',[300]='86efac',[400]='4ade80',
      [500]='22c55e',[600]='16a34a',[700]='15803d',[800]='166534',[900]='14532d',[950]='052e16'},
      emerald={[50]='ecfdf5',[100]='d1fae5',[200]='a7f3d0',[300]='6ee7b7',[400]='34d399',
      [500]='10b981',[600]='059669',[700]='047857',[800]='065f46',[900]='064e3b',[950]='022c22'},
      teal={[50]='f0fdfa',[100]='ccfbf1',[200]='99f6e4',[300]='5eead4',[400]='2dd4bf',
      [500]='14b8a6',[600]='0d9488',[700]='0f766e',[800]='115e59',[900]='134e4a',[950]='042f2e'},
      cyan={[50]='ecfeff',[100]='cffafe',[200]='a5f3fc',[300]='67e8f9',[400]='22d3ee',
      [500]='06b6d4',[600]='0891b2',[700]='0e7490',[800]='155e75',[900]='164e63',[950]='083344'},
      sky={[50]='f0f9ff',[100]='e0f2fe',[200]='bae6fd',[300]='7dd3fc',[400]='38bdf8',
      [500]='0ea5e9',[600]='0284c7',[700]='0369a1',[800]='075985',[900]='0c4a6e',[950]='082f49'},
      blue={[50]='eff6ff',[100]='dbeafe',[200]='bfdbfe',[300]='93c5fd',[400]='60a5fa',
      [500]='3b82f6',[600]='2563eb',[700]='1d4ed8',[800]='1e40af',[900]='1e3a8a',[950]='172554'},
      indigo={[50]='eef2ff',[100]='e0e7ff',[200]='c7d2fe',[300]='a5b4fc',[400]='818cf8',
      [500]='6366f1',[600]='4f46e5',[700]='4338ca',[800]="3730a3",[900]='312e81',[950]='1e1b4b'},
      violet={[50]='f5f3ff',[100]='ede9fe',[200]='ddd6fe',[300]='c4b5fd',[400]='a78bfa',
      [500]='8b5cf6',[600]='7c3aed',[700]='6d28d9',[800]='5b21b6',[900]='4c1d95',[950]='2e1065'},
      purple={[50]='faf5ff',[100]="f3e8ff",[200]="e9d5ff",[300]="d8b4fe",[400]='c084fc',
      [500]='a855f7',[600]='9333ea',[700]='7e22ce',[800]='6b21a8',[900]='581c87',[950]='3b0764'},
      fuchsia={[50]='fdf4ff',[100]='fae8ff',[200]='f5d0fe',[300]='f0abfc',[400]='e879f9',
      [500]='d946ef',[600]='c026d3',[700]='a21caf',[800]='86198f',[900]='701a75',[950]='4a044e'},
      pink={[50]='fdf2f8',[100]='fce7f3',[200]='fbcfe8',[300]='f9a8d4',[400]='f472b6',
      [500]='ec4899',[600]='db2777',[700]='be185d',[800]='9d174d',[900]='831843',[950]='500724'},
      rose={[50]='fff1f2',[100]='ffe4e6',[200]='fecdd3',[300]='fda4af',[400]='fb7185',
      [500]='f43f5e',[600]='e11d48',[700]='be123c',[800]='9f1239',[900]='881337',[950]='4c0519'},
    },
  }
  MiniHiPatterns.setup({
    highlighters = {
      censor = { pattern = 'password: ()%S+()', group = '', extmark_opts = censor_extmark_opts },
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
      done = { pattern = '%f[%w]()DONE()%f[%W]', group = 'MiniHipatternsNote' },
      hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      hex_shorthand = {
        pattern = '()#%x%x%x()%f[^%x%w]',
        group = function(_, _, data)
          local match = data.full_match
          local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
          local hex_color = '#' .. r .. r .. g .. g .. b .. b
          return MiniHiPatterns.compute_hex_color_group(hex_color, 'bg')
        end,
      },
      hsl_color = {
        pattern = 'hsl%(%d+, ?%d+%%, ?%d+%%%)',
        group = function(_, match)
          local hue, saturation, lightness = match:match('hsl%((%d+), ?(%d+)%%, ?(%d+)%%%)')
          local function hsl_to_rgb(h, s, l)
            h, s, l = h % 360, s / 100, l / 100
            if h < 0 then h = h + 360 end
            local function f(n)
              local k = (n + h / 30) % 12
              local a = s * math.min(l, 1 - l)
              return l - a * math.max(-1, math.min(k - 3, 9 - k, 1))
            end
            return f(0) * 255, f(8) * 255, f(4) * 255
          end
          local red, green, blue = hsl_to_rgb(hue, saturation, lightness)
          local hex = string.format('#%02x%02x%02x', red, green, blue)
          return MiniHiPatterns.compute_hex_color_group(hex, 'bg')
        end,
      },
      tailwind = {
        pattern = function()
          local ft = { 'css', 'html', 'javascript', 'javascriptreact', 'svelte', 'typescript', 'typescriptreact', 'vue' }
          if not vim.tbl_contains(ft, vim.bo.filetype) then
            return
          end
          return '%f[%w:-]()[%w:-]+%-[a-z%-]+%-%d+()%f[^%w:-]'
          -- compact
          -- return "%f[%w:-][%w:-]+%-()[a-z%-]+%-%d+()%f[^%w:-]"
        end,
        group = function(_, _, d)
          local match = d.full_match
          local color, shade = match:match('[%w-]+%-([a-z%-]+)%-(%d+)')
          shade = tonumber(shade)
          local bg = vim.tbl_get(tw_store.cl, color, shade)
          if bg then
            local hl = 'MiniHipatternsTailwind' .. color .. shade
            if not tw_store.hl[hl] then
              tw_store.hl[hl] = true
              local bg_shade = shade == 500 and 950 or shade < 500 and 900 or 100
              local fg = vim.tbl_get(tw_store.cl, color, bg_shade)
              vim.api.nvim_set_hl(0, hl, { bg = '#' .. bg, fg = '#' .. fg })
            end
            return hl
          end
        end,
      },
    },
  })
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Pick                           │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  local MiniPick = require('mini.pick')
  local MiniExtra = require('mini.extra')
  MiniPick.setup({
    mappings = {
      choose             = '<Tab>',
      move_down          = '<C-j>',
      move_up            = '<C-k>',
      toggle_preview     = '<C-p>',
      choose_in_split    = '<C-v>',
      choose_in_vsplit   = '<C-s>',
      marked_to_quickfix = {
        char = '<S-q>',
        func = function()
          local items = MiniPick.get_picker_matches().marked or {}
          MiniPick.default_choose_marked(items)
          MiniPick.stop()
        end,
      },
      all_to_quickfix    = {
        char = '<C-q>',
        func = function()
          local matched_items = MiniPick.get_picker_matches().all or {}
          MiniPick.default_choose_marked(matched_items)
          MiniPick.stop()
        end,
      },
    },
    options = { use_cache = true, content_from_bottom = false },
    window = { config = { height = vim.o.lines, width = vim.o.columns }, prompt_caret = '|', prompt_prefix = '󱓇 ' },
    source = {
      preview = function(buf_id, item)
        return MiniPick.default_preview(buf_id, item, { line_position = 'center' })
      end,
    },
  })
  vim.ui.select = MiniPick.ui_select
  -- UI: =========================================================================================
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniPickStart',
    callback = function()
      local win_id = vim.api.nvim_get_current_win()
      vim.wo[win_id].winblend = 15
    end,
  })
  -- Pick Directory  Form Zoxide : ===============================================================
  MiniPick.registry.home = function()
    local cwd = vim.fn.expand('~/')
    local choose = function(item)
      vim.schedule(function()
        MiniPick.builtin.files(nil, { source = { cwd = item.path } })
      end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end
  -- Pick Projects: ==============================================================================
  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/Projects')
    local choose = function(item)
      vim.schedule(function()
        MiniPick.builtin.files(nil, { source = { cwd = item.path } })
      end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Completion                     │
--              ╰─────────────────────────────────────────────────────────╯
now(function()
  -- enable Mini.Completion: =====================================================================
  local MiniCompletion = require('mini.completion')
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  MiniCompletion.setup({
    fallback_action = '<C-n>',
    delay = { completion = 100, info = 100, signature = 50 },
    window = { info = { border = 'bold' }, signature = { border = 'bold' } },
    mappings = { force_twostep = '<C-n>', force_fallback = '<C-S-n>', scroll_down = '<C-f>', scroll_up = '<C-b>' },
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
  })
  -- enable configured language servers 0.11: ====================================================
  local lsp_configs = { 'lua', 'html', 'css', 'emmet', 'json', 'typescript', 'eslint' }
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, MiniCompletion.get_lsp_capabilities())
  vim.lsp.config('*', { capabilities = capabilities })
  for _, config in ipairs(lsp_configs) do
    vim.lsp.enable(config)
  end
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Snippets                       │
--              ╰─────────────────────────────────────────────────────────╯
now(function()
  local MiniSnippets    = require('mini.snippets')
  -- Languge Patterns: ===========================================================================
  local config_path     = vim.fn.stdpath('config')
  local latex_patterns  = { 'latex/**/*.json', '**/latex.json' }
  local markdown        = { 'markdown.json' }
  local webHtmlPatterns = { 'html.json', 'ejs.json' }
  local webJsTsPatterns = { 'web/javascript.json' }
  local webPatterns     = { 'web/*.json' }
  local lang_patterns   = {
    tex = latex_patterns,
    markdown_inline = markdown,
    html = webHtmlPatterns,
    ejs = webHtmlPatterns,
    tsx = webPatterns,
    javascriptreact = webPatterns,
    typescriptreact = webPatterns,
    javascript = webJsTsPatterns,
    typescript = webJsTsPatterns,
  }
  -- Expand Patterns: ============================================================================
  local match_strict    = function(snips)
    -- Do not match with whitespace to cursor's left =============================================
    -- return require('mini.snippets').default_match(snips, { pattern_fuzzy = '%S+' })
    -- Match exact from the start to the end of the string =======================================
    return MiniSnippets.default_match(snips, { pattern_fuzzy = '^%S+$' })
  end
  -- Setup Snippets ==============================================================================
  MiniSnippets.setup({
    snippets = {
      MiniSnippets.gen_loader.from_file(config_path .. '/snippets/global.json'),
      MiniSnippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
    },
    mappings = { expand = '<C-e>', jump_next = '<C-l>', jump_prev = '<C-h>', stop = '<C-c>' },
    expand   = {
      match = match_strict,
      insert = function(snippet)
        return MiniSnippets.default_insert(snippet, { empty_tabstop = '', empty_tabstop_final = '†' })
      end,
    },
  })
  -- Expand Snippets Or complete by Tab ==========================================================
  local expand_or_complete = function()
    if #MiniSnippets.expand({ insert = false }) > 0 then
      vim.schedule(MiniSnippets.expand); return ''
    end
    return vim.fn.pumvisible() == 1 and
        (vim.fn.complete_info().selected == -1 and vim.keycode('<c-n><c-y>') or vim.keycode('<c-y>')) or '<Tab>'
  end
  vim.keymap.set('i', '<Tab>', expand_or_complete, { expr = true, replace_keycodes = true })
  -- exit snippet sessions on entering normal mode: ==============================================
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniSnippetsSessionStart',
    callback = function()
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*:n',
        once = true,
        callback = function()
          while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
          end
        end,
      })
    end,
  })
  -- exit snippets upon reaching final tabstop: ==================================================
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniSnippetsSessionJump',
    callback = function(args)
      if args.data.tabstop_to == '0' then MiniSnippets.session.stop() end
    end,
  })
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Files                          │
--              ╰─────────────────────────────────────────────────────────╯
now_if_args(function()
  local MiniFiles = require('mini.files')
  MiniFiles.setup({
    mappings = {
      go_in_plus  = '<Tab>',
      go_out_plus = '<C-h>',
      synchronize = '<C-s>',
      close       = 'q',
      reset       = 'gh',
      mark_goto   = 'gb',
      show_help   = '?',
      go_in       = '',
      go_out      = '',
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
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowOpen',
    callback = function(args)
      local win_id = args.data.win_id
      -- Customize window-local settings =========================================================
      vim.wo[win_id].winblend = 15
      local config = vim.api.nvim_win_get_config(win_id)
      config.border, config.title_pos = 'double', 'left'
      vim.api.nvim_win_set_config(win_id, config)
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesWindowUpdate',
    callback = function(args)
      local config = vim.api.nvim_win_get_config(args.data.win_id)
      -- Ensure fixed height =====================================================================
      config.height = vim.o.lines
      -- Ensure no title padding =================================================================
      local n = #config.title
      config.title[1][1] = config.title[1][1]:gsub('^ ', '')
      config.title[n][1] = config.title[n][1]:gsub(' $', '')
      vim.api.nvim_win_set_config(args.data.win_id, config)
    end,
  })
  -- BookMarks: ==================================================================================
  local minifiles_augroup = vim.api.nvim_create_augroup('ec-mini-files', {})
  vim.api.nvim_create_autocmd('User', {
    group = minifiles_augroup,
    pattern = 'MiniFilesExplorerOpen',
    callback = function()
      MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
      MiniFiles.set_bookmark('m', vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim', { desc = 'mini.nvim' })
      MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/deps/opt', { desc = 'Plugins' })
      MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
    end,
  })
  -- Toggle dotfiles : ===========================================================================
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
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args) vim.keymap.set('n', '.', toggle_dotfiles, { buffer = args.data.buf_id }) end,
  })
  -- Open In Splits : ============================================================================
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
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      map_split(buf_id, '<C-v>', 'belowright horizontal')
      map_split(buf_id, '<C-b>', 'belowright vertical')
    end,
  })
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Mini.Icons                          │
--              ╰─────────────────────────────────────────────────────────╯
now(function()
  local MiniIcons = require('mini.icons')
  MiniIcons.setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
    default = {
      ['file'] = { glyph = '󰪷', hl = 'MiniIconsYellow' },
      ['filetype'] = { glyph = '󰪷', hl = 'MiniIconsYellow' },
      ['extension'] = { glyph = '󰪷', hl = 'MiniIconsYellow' },
    },
    file = {
      ['init.lua'] = { glyph = '󰢱', hl = 'MiniIconsBlue' },
      ['README.md'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['pre-commit'] = { glyph = '󰊢', hl = 'MiniIconsYellow' },
      ['Brewfile'] = { glyph = '󱄖', hl = 'MiniIconsYellow' },
      ['.ignore'] = { glyph = '󰈉', hl = 'MiniIconsGrey' },
      ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
      ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
      ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
      ['.gitignore'] = { glyph = '', hl = 'MiniIconsRed' },
      ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
      ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
      ['vite.config.ts'] = { glyph = '', hl = 'MiniIconsYellow' },
      ['pnpm-lock.yaml'] = { glyph = '', hl = 'MiniIconsYellow' },
      ['pnpm-workspace.yaml'] = { glyph = '', hl = 'MiniIconsYellow' },
      ['.dockerignore'] = { glyph = '󰡨', hl = 'MiniIconsBlue' },
      ['react-router.config.ts'] = { glyph = '', hl = 'MiniIconsRed' },
      ['bun.lockb'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['bun.lock'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
    },
    filetype = {
      ['css'] = { glyph = '', hl = 'MiniIconsCyan' },
      ['vim'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['sh'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['elvish'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['bash'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['dotenv'] = { glyph = '', hl = 'MiniIconsYellow' },
    },
    extension = {
      ['d.ts'] = { glyph = '', hl = 'MiniIconsRed' },
      ['applescript'] = { glyph = '󰀵', hl = 'MiniIconsGrey' },
      ['log'] = { glyph = '󱂅', hl = 'MiniIconsGrey' },
      ['gitignore'] = { glyph = '', hl = 'MiniIconsRed' },
      ['adblock'] = { glyph = '', hl = 'MiniIconsRed' },
      ['add'] = { glyph = '', hl = 'MiniIconsGreen' },
    },
    directory = {
      ['.vscode'] = { glyph = '', hl = 'MiniIconsBlue' },
      ['app'] = { glyph = '󰀻', hl = 'MiniIconsRed' },
      ['routes'] = { glyph = '󰑪', hl = 'MiniIconsGreen' },
      ['config'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['configs'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['server'] = { glyph = '󰒋', hl = 'MiniIconsCyan' },
      ['api'] = { glyph = '󰒋', hl = 'MiniIconsCyan' },
      ['web'] = { glyph = '󰖟', hl = 'MiniIconsBlue' },
      ['client'] = { glyph = '󰖟', hl = 'MiniIconsBlue' },
      ['database'] = { glyph = '󰆼', hl = 'MiniIconsOrange' },
      ['db'] = { glyph = '󰆼', hl = 'MiniIconsOrange' },
      ['cspell'] = { glyph = '󰓆', hl = 'MiniIconsPurple' },
    },
    lsp = {
      ['text'] = { glyph = '󰉿' },
      ['method'] = { glyph = '󰆦' },
      ['function'] = { glyph = '󰡱' },
      ['constructor'] = { glyph = '󰒓' },
      ['field'] = { glyph = '󰜢' },
      ['variable'] = { glyph = '' },
      ['class'] = { glyph = '󰠱' },
      ['interface'] = { glyph = '' },
      ['module'] = { glyph = '' },
      ['property'] = { glyph = '' },
      ['unit'] = { glyph = '󰑭' },
      ['value'] = { glyph = '󰔌' },
      ['enum'] = { glyph = '' },
      ['keyword'] = { glyph = '󰌆' },
      ['snippet'] = { glyph = '' },
      ['color'] = { glyph = '󰏘' },
      ['file'] = { glyph = '󰈙' },
      ['reference'] = { glyph = '󰬲' },
      ['folder'] = { glyph = '󰝰' },
      ['enumMember'] = { glyph = '' },
      ['constant'] = { glyph = '󰐀' },
      ['struct'] = { glyph = '󰐫' },
      ['event'] = { glyph = '' },
      ['operator'] = { glyph = '󰙴' },
      ['typeParameter'] = { glyph = '󰬛' },
    },
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind('replace'))
end)
--              ╔═════════════════════════════════════════════════════════╗
--              ║                      Treesitter                         ║
--              ╚═════════════════════════════════════════════════════════╝
now_if_args(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  add({ source = 'nvim-treesitter/nvim-treesitter-textobjects', checkout = 'main' })
  -- Ensure installed: ===========================================================================
  --stylua: ignore
  local ensure_installed = {
    'bash',
    'powershell',
    'elvish',
    'c',
    'cpp',
    'python',
    'regex',
    'diff',
    'html',
    'css',
    'scss',
    'javascript',
    'typescript',
    'tsx',
    'prisma',
    'json',
    'jsonc',
    'toml',
    'yaml',
    'lua',
    'luadoc',
    'vim',
    'vimdoc',
    'markdown',
    'markdown_inline',
  }
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
  local to_install = vim.tbl_filter(isnt_installed, ensure_installed)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end
  -- Ensure enabled: =============================================================================
  local filetypes = vim.iter(ensure_installed):map(vim.treesitter.language.get_filetypes):flatten():totable()
  vim.list_extend(filetypes, { 'markdown', 'pandoc' })
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  vim.api.nvim_create_autocmd('FileType', { pattern = filetypes, callback = ts_start })
  -- Disable injections in 'lua' language: =======================================================
  local ts_query = require('vim.treesitter.query')
  local ts_query_set = vim.fn.has('nvim-0.9') == 1 and ts_query.set or ts_query.set_query
  ts_query_set('lua', 'injections', '')
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                      TS Auto Close/Rename               │
--              ╰─────────────────────────────────────────────────────────╯
now_if_args(function()
  add('windwp/nvim-ts-autotag')
  require('nvim-ts-autotag').setup()
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                    TS Rainbow delimiters                │
--              ╰─────────────────────────────────────────────────────────╯
now_if_args(function()
  add('hiphish/rainbow-delimiters.nvim')
  require('rainbow-delimiters.setup').setup()
end)
--              ╔═════════════════════════════════════════════════════════╗
--              ║                         Formatting                      ║
--              ╚═════════════════════════════════════════════════════════╝
now_if_args(function()
  add('stevearc/conform.nvim')
  require('conform').setup({
    formatters_by_ft = {
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      jsx = { 'prettier' },
      tsx = { 'prettier' },
      svelte = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      graphql = { 'prettier' },
      liquid = { 'prettier' },
      lua = { 'stylua' },
      ['_'] = { 'trim_whitespace' },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1000, lsp_format = 'fallback' }
    end,
  })
  vim.keymap.set({ 'n', 'v' }, '<leader>l', function()
    require('conform').format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
  end)
end)
--              ╔═════════════════════════════════════════════════════════╗
--              ║                          NVIM                           ║
--              ╚═════════════════════════════════════════════════════════╝
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Neovim Colorscheme                  │
--              ╰─────────────────────────────────────────────────────────╯
now(function() vim.cmd.colorscheme('macro') end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Neovim Options                      │
--              ╰─────────────────────────────────────────────────────────╯
now(function()
  -- Leader:  ====================================================================================
  vim.g.mapleader                = vim.keycode('<space>')
  vim.g.maplocalleader           = vim.g.mapleader
  -- Os:  ========================================================================================
  vim.g.is_win                   = vim.uv.os_uname().sysname:find('Windows') ~= nil
  vim.g.is_windows               = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
  -- Enable all filetype plugins and syntax (if not enabled, for better startup): ================
  vim.cmd('filetype plugin indent on')
  if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
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
  vim.o.fileencoding             = 'utf-8'
  vim.o.encoding                 = 'utf-8'
  vim.o.fileformats              = 'unix,dos'
  vim.o.fileformats              = 'unix,dos'
  vim.o.clipboard                = 'unnamedplus'
  vim.o.wildmode                 = 'noselect:lastused,full'
  vim.o.wildoptions              = 'fuzzy,pum'
  vim.o.wildignore               = '*.zip,*.tar.gz,*.png,*.jpg,*.pdf,*.mp4,*.exe,*.pyc,*.o,*.dll,*.so,*.swp,*.zip,*.gz,*.svg,*.cache,*/.git/*,*/node_modules/*'
  vim.o.omnifunc                 = 'v:lua.vim.lsp.omnifunc'
  vim.o.completeopt              = 'menuone,noselect,fuzzy,nosort'
  vim.o.completeitemalign        = 'kind,abbr,menu'
  vim.o.complete                 = '.,w,b,kspell'
  vim.o.switchbuf                = 'usetab'
  vim.o.includeexpr              = "substitute(v:fname,'\\.','/','g')"
  vim.o.viminfo                  = "'20,<1000,s1000"
  vim.o.shada                    = "'100,<50,s10,:1000,/100,@100,h"
  vim.o.undodir                  = vim.fn.stdpath('data') .. '/undo'
  -- Spelling ====================================================================================
  vim.o.spell                    = false
  vim.o.spelllang                = 'en_us'
  vim.o.spelloptions             = 'camel'
  vim.o.spellsuggest             = 'best,8'
  vim.o.spellfile                = vim.fn.stdpath('config') .. '/misc/spell/en.utf-8.add'
  vim.o.dictionary               = vim.fn.stdpath('config') .. '/misc/dict/english.txt'
  -- UI: =========================================================================================
  vim.o.number                   = true
  vim.o.termguicolors            = true
  vim.o.smoothscroll             = true
  vim.o.splitright               = true
  vim.o.splitbelow               = true
  vim.o.equalalways              = true
  vim.o.tgc                      = true
  vim.o.ttyfast                  = true
  vim.o.showcmd                  = true
  vim.o.cursorline               = true
  vim.o.relativenumber           = false
  vim.o.title                    = false
  vim.o.list                     = false
  vim.o.modeline                 = false
  vim.o.showmode                 = false
  vim.o.errorbells               = false
  vim.o.visualbell               = false
  vim.o.emoji                    = false
  vim.o.ruler                    = false
  vim.o.numberwidth              = 3
  vim.o.linespace                = 3
  vim.o.laststatus               = 0
  vim.o.cmdheight                = 0
  vim.o.helpheight               = 12
  vim.o.previewheight            = 12
  vim.o.winwidth                 = 20
  vim.o.winminwidth              = 10
  vim.o.scrolloff                = 10
  vim.o.sidescrolloff            = 10
  vim.o.sidescroll               = 0
  vim.o.showtabline              = 0
  vim.o.pumblend                 = 8
  vim.o.pumheight                = 8
  vim.o.cmdwinheight             = 10
  vim.o.pumwidth                 = 20
  vim.o.titlelen                 = 127
  vim.o.scrollback               = 100000
  vim.o.display                  = vim.o.display .. ',lastline'
  vim.o.winbar                   = ''
  vim.o.guicursor                = ''
  vim.o.guifont                  = 'jetBrainsMono Nerd Font:h10'
  vim.o.colorcolumn              = '+1'
  vim.o.background               = 'dark'
  vim.o.showcmdloc               = 'statusline'
  vim.o.belloff                  = 'all'
  vim.o.titlestring              = '%{getcwd()} : %{expand(\"%:r\")} [%M] ― Neovim'
  vim.o.splitkeep                = 'screen'
  vim.o.mouse                    = 'a'
  vim.o.mousemodel               = 'extend'
  vim.o.mousescroll              = 'ver:3,hor:6'
  vim.o.winborder                = 'double'
  vim.o.backspace                = 'indent,eol,start'
  vim.o.cursorlineopt            = 'screenline,number'
  vim.o.tabclose                 = 'uselast'
  vim.o.shortmess                = 'FOSWICaco'
  vim.wo.signcolumn              = 'yes'
  vim.o.statuscolumn             = ''
  vim.o.showbreak                = '󰘍' .. string.rep(' ', 2)
  vim.o.fillchars                = table.concat( { 'eob: ', 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' }, ',')
  vim.o.listchars                = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'space:⋅', 'trail:.', 'tab:↦ ' }, ',')
  -- Editing:  ===================================================================================
  vim.o.cindent                  = true
  vim.o.autoindent               = true
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
  vim.o.tildeop                  = true
  vim.o.mousemoveevent           = true
  vim.o.exrc                     = true
  vim.o.secure                   = true
  vim.o.autoread                 = true
  vim.o.autowrite                = true
  vim.o.autowriteall             = true
  vim.o.modifiable               = true
  vim.o.autochdir                = false
  vim.o.showmatch                = false
  vim.o.magic                    = false
  vim.o.wrap                     = false
  vim.o.joinspaces               = false
  vim.o.textwidth                = 128
  vim.o.matchtime                = 2
  vim.o.wrapmargin               = 2
  vim.o.tabstop                  = 2
  vim.o.shiftwidth               = 2
  vim.o.softtabstop              = 2
  vim.o.conceallevel             = 0
  vim.o.concealcursor            = 'c'
  vim.o.cedit                    = '^F'
  vim.o.breakat                  = [[\ \	;:,!?]]
  vim.o.keywordprg               = ':help'
  vim.o.breakindentopt           = 'list:-1'
  vim.o.inccommand               = 'nosplit'
  vim.o.jumpoptions              = 'stack,view'
  vim.o.selection                = 'old'
  vim.o.nrformats                = 'bin,hex,alpha,unsigned'
  vim.o.whichwrap                = 'b,s,<,>,[,],h,l'
  vim.o.iskeyword                = '@,48-57,_,192-255,-'
  vim.o.formatlistpat            = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
  vim.o.virtualedit              = 'block'
  vim.o.formatoptions            = 'rqnl1j'
  vim.o.formatexpr               = "v:lua.require'conform'.formatexpr()"
  vim.o.sessionoptions           = table.concat( { 'blank', 'buffers', 'curdir', 'folds', 'help', 'tabpages', 'winsize', 'terminal', 'localoptions' }, ',')
  vim.o.diffopt                  = table.concat( { 'algorithm:minimal', 'closeoff', 'context:8', 'filler', 'internal', 'linematch:100', 'indent-heuristic' }, ',')
  vim.o.suffixesadd              = table.concat( { '.css', '.html', '.js', '.json', '.jsx', '.lua', '.md', '.rs', '.scss', '.sh', '.ts', '.tsx', '.yaml', '.yml' }, ',')
  -- Folds:  =====================================================================================
  vim.o.foldenable               = false
  vim.o.foldlevel                = 1
  vim.o.foldlevelstart           = 99
  vim.o.foldnestmax              = 10
  vim.o.foldminlines             = 4
  vim.o.foldtext                 = ''
  vim.o.foldcolumn               = '0'
  vim.o.foldmethod               = 'indent'
  vim.o.foldopen                 = 'hor,mark,tag,search,insert,quickfix,undo'
  vim.o.foldexpr                 = '0'
  -- Memory: =====================================================================================
  vim.o.timeout                  = true
  vim.o.lazyredraw               = true
  vim.o.hidden                   = true
  vim.o.ttimeoutlen              = 10
  vim.o.updatetime               = 50
  vim.o.redrawtime               = 100
  vim.o.history                  = 100
  vim.o.synmaxcol                = 200
  vim.o.timeoutlen               = 300
  vim.o.redrawtime               = 500
  vim.o.maxmempattern            = 10000
  -- Disable netrw: ==============================================================================
  vim.g.loaded_netrw             = 1
  vim.g.loaded_netrwPlugin       = 1
  vim.g.loaded_netrwSettings     = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.loaded_netrw_gitignore   = 1
  -- Disable health checks for these providers:. =================================================
  vim.g.loaded_python_provider   = 0
  vim.g.loaded_python3_provider  = 0
  vim.g.loaded_ruby_provider     = 0
  vim.g.loaded_perl_provider     = 0
  vim.g.loaded_node_provider     = 0
  -- Disable builtin plugins: ====================================================================
  local disabled_built_ins       = {
    'osc52',
    'parser',
    'health',
    'man',
    'tohtml',
    '2html',
    'remote',
    'shadafile',
    'spellfile',
    'editorconfig',
    '2html_plugin',
    'getscript',
    'getscriptPlugin',
    'gzip',
    'logipat',
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'matchit',
    'matchparen',
    'tar',
    'tarPlugin',
    'rrhelper',
    'spellfile_plugin',
    'vimball',
    'vimballPlugin',
    'zip',
    'zipPlugin',
    'tutor',
    'rplugin',
    'synmenu',
    'optwin',
    'compiler',
    'bugreport',
    'ftplugin',
  }
  for _, plugin in pairs(disabled_built_ins) do
    vim.g['loaded_' .. plugin] = 1
  end
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Neovim Diagnostics                  │
--              ╰─────────────────────────────────────────────────────────╯
local diagnostic_opts = {
  severity_sort = false,
  update_in_insert = false,
  virtual_lines = false,
  float = { border = 'bold', header = '', title = ' Diagnostics ', source = 'if_many' },
  virtual_text = { spacing = 2, source = 'if_many', current_line = true, severity = { min = 'ERROR', max = 'ERROR' } },
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  signs = {
    priority = 9999,
    severity = { min = 'WARN', max = 'ERROR' },
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN] = '●',
      [vim.diagnostic.severity.HINT] = '●',
      [vim.diagnostic.severity.INFO] = '●',
    },
    -- interference With Mini.Diff ===============================================================
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
}
-- Use `later()` to avoid sourcing `vim.diagnostic` on startup: ==================================
later(function() vim.diagnostic.config(diagnostic_opts) end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Neovim automads                     │
--              ╰─────────────────────────────────────────────────────────╯
now(function()
  -- Auto Save: ==================================================================================
  vim.api.nvim_create_autocmd({ 'FocusLost', 'VimLeavePre' }, {
    group = vim.api.nvim_create_augroup('save_buffers', {}),
    callback = function(event)
      local buf = event.buf
      if vim.api.nvim_get_option_value('modified', { buf = buf }) then
        vim.schedule(function()
          vim.api.nvim_buf_call(buf, function()
            vim.cmd 'silent! write'
          end)
        end)
      end
    end,
  })
  -- Don't Comment New Line ======================================================================
  vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
    group = vim.api.nvim_create_augroup('bg_correct', {}),
    callback = function()
      if vim.api.nvim_get_hl(0, { name = 'Normal' }).bg then
        io.write(string.format('\027]11;#%06x\027\\', vim.api.nvim_get_hl(0, { name = 'Normal' }).bg))
      end
      vim.api.nvim_create_autocmd('UILeave', { callback = function()
        io.write('\027]111\027\\')
      end })
    end,
  })
  -- Remove background for all WinSeparator sections =============================================
  vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('sp_bg_removed', { clear = true }),
    desc = 'Remove background for all WinSeparator sections',
    callback = function()
      vim.cmd('highlight WinSeparator guibg=None')
    end,
  })
  -- Disable diagnostics in node_modules =========================================================
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('disable_diagnostics', { clear = true }),
    pattern = '*/node_modules/*',
    callback = function()
      vim.diagnostic.enable(false, { bufnr = 0 })
    end,
  })
  -- Clear the last used search pattern when opening a new buffer ================================
  vim.api.nvim_create_autocmd('BufReadPre', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('clear_search', { clear = true }),
    callback = function()
      vim.fn.setreg('/', '')
      vim.cmd 'let @/ = ""'
    end,
  })
  -- Don't Comment New Line ======================================================================
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('diable_new_line_comments', {}),
    callback = function()
      vim.opt_local.formatoptions:remove('o')
      vim.opt_local.formatoptions:remove('r')
      vim.opt_local.formatoptions:remove('c')
    end,
  })
  -- Highlight Yank ==============================================================================
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_yank', {}),
    callback = function()
      if vim.v.operator == 'y' then
        vim.fn.setreg('+', vim.fn.getreg('0'))
        vim.hl.on_yank({ on_macro = true, on_visual = true, higroup = 'IncSearch', timeout = 600 })
      end
    end,
  })
  -- Auto-resize splits on window resize:  =======================================================
  vim.api.nvim_create_autocmd('VimResized', {
    group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd('tabdo wincmd =')
      vim.cmd('tabnext ' .. current_tab)
    end,
  })
  -- Automatically adjust scrolloff based on window size: ======================================
  vim.api.nvim_create_autocmd('WinResized', {
    group = vim.api.nvim_create_augroup('smart_scrolloff', { clear = true }),
    callback = function()
      local percentage = 0.16
      local percentage_lines = math.floor(vim.o.lines * percentage)
      local max_lines = 10
      vim.o.scrolloff = math.min(max_lines, percentage_lines)
    end,
  })
  -- Fix broken macro recording notification for cmdheight 0 : ===================================
  local show_recordering = vim.api.nvim_create_augroup('show_recordering', { clear = true })
  vim.api.nvim_create_autocmd('RecordingEnter', {
    pattern = '*',
    group = show_recordering,
    callback = function()
      vim.opt_local.cmdheight = 1
    end,
  })
  vim.api.nvim_create_autocmd('RecordingLeave', {
    pattern = '*',
    group = show_recordering,
    desc = 'Fix broken macro recording notification for cmdheight 0, pt2',
    callback = function()
      local timer = vim.loop.new_timer()
      -- NOTE: Timer is here because we need to close cmdheight AFTER
      -- the macro is ended, not during the Leave event
      ---@diagnostic disable-next-line: need-check-nil
      timer:start(
        50,
        0,
        vim.schedule_wrap(function()
          vim.opt_local.cmdheight = 0
        end)
      )
    end,
  })
  -- Remove hl search when move or  enter insert : ===============================================
  local clear_hl = vim.api.nvim_create_augroup('hl_clear', { clear = true })
  vim.api.nvim_create_autocmd({ 'InsertEnter', 'CmdlineEnter' }, {
    group = clear_hl,
    callback = vim.schedule_wrap(function()
      vim.schedule(function()
        vim.cmd.nohlsearch()
      end)
    end),
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = clear_hl,
    callback = function()
      if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
        vim.schedule(function()
          vim.cmd.nohlsearch()
        end)
      end
    end,
  })
  -- Trim space and lastlines if empty : =========================================================
  local trim_spaces = vim.api.nvim_create_augroup('trim_spaces', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = trim_spaces,
    callback = function()
      local curpos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[keeppatterns %s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, curpos)
    end,
  })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = trim_spaces,
    callback = function()
      local n_lines = vim.api.nvim_buf_line_count(0)
      local last_nonblank = vim.fn.prevnonblank(n_lines)
      if last_nonblank < n_lines then vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, {}) end
    end,
  })
  -- Opts in command window: =====================================================================
  vim.api.nvim_create_autocmd('CmdwinEnter', {
    group = vim.api.nvim_create_augroup('cmd_open', { clear = true }),
    callback = function()
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.foldcolumn = '0'
      vim.wo.signcolumn = 'no'
      vim.wo.statuscolumn = ''
      vim.wo.colorcolumn = ''
    end,
  })
  -- Large file handling: ========================================================================
  vim.api.nvim_create_autocmd('BufReadPre', {
    group = vim.api.nvim_create_augroup('handle_bigfile', { clear = true }),
    callback = function(ev)
      local max_size = 10 * 1024 * 1024
      local file_size = vim.fn.getfsize(ev.match)
      if file_size > max_size or file_size == -2 then
        -- Options:
        vim.cmd('filetype off')
        vim.cmd('syntax clear')
        vim.cmd('syntax off')
        vim.opt_local.cursorline = false
        vim.opt_local.spell = false
        vim.opt_local.undofile = false
        vim.opt_local.swapfile = false
        vim.opt_local.backup = false
        vim.opt_local.smoothscroll = false
        vim.opt_local.linebreak = false
        vim.opt_local.writebackup = false
        vim.opt_local.foldenable = false
        vim.opt_local.breakindent = false
        vim.opt_local.breakindentopt = ''
        vim.opt_local.foldmethod = 'manual'
        vim.opt_local.foldexpr = '0'
        vim.opt_local.virtualedit = ''
        vim.opt_local.statuscolumn = ''
        vim.opt_local.showbreak = ''
        vim.bo.indentexpr = ''
        vim.bo.autoindent = false
        vim.bo.smartindent = false
        -- Plugins:
        vim.b.minicompletion_disable = true
        vim.b.minisnippets_disable = true
        vim.b.minihipatterns_disable = true
        vim.defer_fn(function()
          vim.treesitter.stop()
          require('rainbow-delimiters').disable(0)
        end, 100)
        vim.notify('Large file detected. Some features disabled.', vim.log.levels.WARN)
      end
    end,
  })
  -- Opts in terminal buffer: ====================================================================
  vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('term_open', { clear = true }),
    callback = function()
      vim.opt_local.scrollback = 10000
      vim.opt_local.scrolloff = 0
      vim.opt_local.swapfile = false
      vim.opt_local.spell = false
      vim.opt_local.buflisted = false
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.ruler = false
      vim.opt_local.foldenable = false
      vim.opt_local.bufhidden = 'hide'
      vim.opt_local.signcolumn = 'no'
      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.foldexpr = '0'
      vim.opt_local.filetype = 'terminal'
      vim.bo.filetype = 'terminal'
      vim.cmd.startinsert()
    end,
  })
  -- Auto-close terminal when process exits: =====================================================
  vim.api.nvim_create_autocmd('TermClose', {
    group = vim.api.nvim_create_augroup('term_close', {}),
    callback = function()
      if vim.v.event.status == 0 then
        vim.api.nvim_buf_delete(0, {})
      end
    end,
  })
  vim.api.nvim_create_autocmd('TermClose', {
    group = vim.api.nvim_create_augroup('term_close', {}),
    pattern = { 'term://*' },
    callback = function()
      vim.api.nvim_input('<CR>')
    end,
  })
  -- Auto create directories before save: ========================================================
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
    callback = function(event)
      local file = vim.fn.fnamemodify(event.match, ':p')
      local dir = vim.fn.fnamemodify(file, ':p:h')
      local success, _ = vim.fn.isdirectory(dir)
      if not success then
        vim.fn.system({ 'mkdir', '-p', dir })
      end
    end,
  })
  -- Go to old position when opening a buffer: ===================================================
  vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('remember_position', { clear = true }),
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
  })
  -- Highlight cursor line briefly when neovim regains focus: ====================================
  vim.api.nvim_create_autocmd({ 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('track_cursor', { clear = true }),
    callback = function()
      vim.o.cursorline = false
      vim.cmd('redraw')
      vim.defer_fn(function()
        vim.o.cursorline = true
        vim.cmd('redraw')
      end, 600)
    end,
  })
  -- Show cursor line only in active window: =====================================================
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'TermLeave' }, {
    group = vim.api.nvim_create_augroup('auto_cursorline_show', { clear = true }),
    callback = function(event)
      if vim.bo[event.buf].buftype == '' then
        vim.opt_local.cursorline = true
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
    group = vim.api.nvim_create_augroup('auto_cursorline_hide', { clear = true }),
    callback = function()
      vim.opt_local.cursorline = false
    end,
  })
  -- Check if we need to reload the file when it changed: ========================================
  vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = vim.api.nvim_create_augroup('checktime', { clear = true }),
    callback = function()
      if vim.o.buftype ~= 'nofile' then
        vim.cmd('checktime')
      end
    end,
  })
  -- Close all non-existing buffers on `FocusGained`: ============================================
  vim.api.nvim_create_autocmd('FocusGained', {
    group = vim.api.nvim_create_augroup('close_non_existing_buffer', { clear = true }),
    callback = function()
      local closedBuffers = {}
      local allBufs = vim.fn.getbufinfo { buflisted = 1 }
      vim.iter(allBufs):each(function(buf)
        if not vim.api.nvim_buf_is_valid(buf.bufnr) then return end
        local stillExists = vim.uv.fs_stat(buf.name) ~= nil
        local specialBuffer = vim.bo[buf.bufnr].buftype ~= ''
        local newBuffer = buf.name == ''
        if stillExists or specialBuffer or newBuffer then return end
        table.insert(closedBuffers, vim.fs.basename(buf.name))
        vim.api.nvim_buf_delete(buf.bufnr, { force = false })
      end)
      if #closedBuffers == 0 then return end
      if #closedBuffers == 1 then
        vim.notify(closedBuffers[1], nil, { title = 'Buffer closed', icon = '󰅗' })
      else
        local text = '- ' .. table.concat(closedBuffers, '\n- ')
        vim.notify(text, nil, { title = 'Buffers closed', icon = '󰅗' })
      end
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
  -- Reload buffer on enter or focus: ============================================================
  vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
    group = vim.api.nvim_create_augroup('reload_buffer_on_enter_or_focus', { clear = true }),
    command = 'silent! !',
  })
  -- Always open quickfix window automatically: ==================================================
  vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('auto_open_quickfix', { clear = true }),
    pattern = '[^l]*',
    command = 'cwindow',
    nested = true,
  })
  -- Always show quotes: =========================================================================
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'json', 'jsonc', 'json5', 'markdown' },
    callback = function()
      vim.opt_local.conceallevel = 0
    end,
  })
  -- Disallow change buf for quickfix: ===========================================================
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('noedit_quickfix', { clear = true }),
    pattern = 'qf',
    desc = 'Disallow change buf for quickfix',
    callback = function()
      vim.wo.winfixbuf = true
    end,
  })
  -- delete entries from a quickfix list with `dd` ===============================================
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = vim.api.nvim_create_augroup('quickfix', { clear = true }),
    pattern = { 'qf' },
    callback = function()
      vim.keymap.set('n', 'dd', function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local quickfix_list = vim.fn.getqflist()
        table.remove(quickfix_list, cursor[1])
        vim.fn.setqflist(quickfix_list, 'r')
        vim.api.nvim_win_set_cursor(0, cursor)
        if #quickfix_list == 0 then
          vim.cmd.cclose()
        end
      end, { buffer = true })
      vim.keymap.set('n', '<cr>', '<cr>:cclose<cr>', { buffer = 0, silent = true })
    end,
  })
  -- Start insert mode in git commit messages: ===================================================
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('git_insert', { clear = true }),
    pattern = { 'gitcommit', 'gitrebase' },
    command = 'startinsert | 1',
  })
  -- Clear jump list at start:====================================================================
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('clear_jumps', { clear = true }),
    callback = function()
      vim.cmd('clearjumps')
    end,
  })
  -- When at eob, bring the current line towards center screen:===================================
  vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved', 'CursorHoldI' }, {
    group = vim.api.nvim_create_augroup('at_eob', { clear = true }),
    callback = function(event)
      local bo = vim.bo[event.buf]
      if bo.filetype ~= 'minifiles' then
        local win_h = vim.api.nvim_win_get_height(0)
        local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
        local dist = vim.fn.line('$') - vim.fn.line('.')
        local rem = vim.fn.line('w$') - vim.fn.line('w0') + 1

        if dist < off and win_h - rem + dist < off then
          local view = vim.fn.winsaveview()
          view.topline = view.topline + off - (win_h - rem + dist)
          vim.fn.winrestview(view)
        end
      end
    end,
  })
  -- close some filetypes with <q>: ==============================================================
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('q_close', { clear = true }),
    pattern = { 'qf', 'man', 'help', 'query', 'notify', 'lspinfo', 'startuptime', 'git', 'checkhealth' },
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
  -- Create an autocmd group for executing files: ================================================
  local exec_by_ft = vim.api.nvim_create_augroup('exec_by_ft', { clear = true })
  local function RunKeymap(filetype, command)
    vim.api.nvim_create_autocmd('FileType', {
      group = exec_by_ft,
      pattern = filetype,
      callback = function()
        vim.api.nvim_buf_set_keymap(
          0,
          'n',
          '<leader>a',
          ':w<cr>:split term://' .. command .. ' %<cr>:resize 10<cr>',
          { noremap = true, silent = true }
        )
      end,
    })
  end
  -- Define the commands for each filetype
  RunKeymap('lua', 'lua')
  RunKeymap('python', 'python3')
  RunKeymap('javascript', 'node')
  RunKeymap('rust', 'cargo run')
  RunKeymap('go', 'go run')
  RunKeymap('cpp', 'g++ % -o %:r && ./%:r')
  RunKeymap('c', 'gcc % -o %:r && ./%:r')
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                 Neovim user_commands                    │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  -- Source and edit vimrc file =================================================================
  vim.api.nvim_create_user_command('SourceVimrc', 'silent source $MYVIMRC', { bang = true })
  vim.api.nvim_create_user_command('VimrcSource', 'silent source $MYVIMRC', { bang = true })
  vim.api.nvim_create_user_command('EditVimrc', 'edit $MYVIMRC', { bang = true })
  vim.api.nvim_create_user_command('VimrcEdit', 'edit $MYVIMRC', { bang = true })
  -- Change working directory to current file's: =================================================
  vim.api.nvim_create_user_command('CdHere', 'cd %:p:h', {})
  vim.api.nvim_create_user_command('TcdHere', 'tcd %:p:h', {})
  -- LSP code action:=============================================================================
  vim.api.nvim_create_user_command('CodeAction', function() vim.lsp.buf.code_action() end, {})
  -- Search literally, with no regex: ============================================================
  vim.api.nvim_create_user_command('Search', ':let @/="\\\\V" . escape(<q-args>, "\\\\\") | normal! n', { nargs = 1 })
  vim.api.nvim_create_user_command('Grep', function(opts)
    local keyword = opts.args
    vim.cmd('vimgrep ' .. keyword .. ' %:p:.:h/**/*')
  end, { nargs = 1 })
  -- Move current window to its own tab: =========================================================
  vim.api.nvim_create_user_command('Tab', function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd [[ tab split ]]
    vim.api.nvim_win_close(win, true)
  end, {})
  -- Tmp is a command to create a temporary file: ================================================
  vim.api.nvim_create_user_command('Tmp', function()
    local path = vim.fn.tempname()
    vim.cmd('e ' .. path)
    vim.notify(path)
    -- delete the file when the buffer is closed
    vim.cmd('au BufDelete <buffer> !rm -f ' .. path)
  end, { nargs = '*' })
  -- Windows: "E138: main.shada.tmp.X files exist, cannot write ShaDa" on close: =================
  vim.api.nvim_create_user_command('RemoveShadaTemp', function()
    for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath('data') .. '/shada', '*tmp*', false, true)) do
      vim.fn.system({ 'rm', f })
    end
  end, {})
  -- Open a scratch buffer: ===========================================================================
  vim.api.nvim_create_user_command('Scratch', function()
    vim.cmd 'bel 10new'
    local buf = vim.api.nvim_get_current_buf()
    for name, value in pairs {
      filetype = 'scratch',
      buftype = 'nofile',
      bufhidden = 'wipe',
      swapfile = false,
      modifiable = true,
    } do
      vim.api.nvim_set_option_value(name, value, { buf = buf })
    end
  end, {})
  -- Toggle dark Mode: ===========================================================================
  vim.api.nvim_create_user_command('DarkMode', function()
    if vim.o.background == 'light' then
      vim.o.background = 'dark'
    else
      vim.o.background = 'light'
    end
  end, {})
  -- Resizes: ======================================================================================
  vim.api.nvim_create_user_command('Vr', function(opts)
    local usage = 'Usage: [VerticalResize] :Vr {number (%)}'
    if not opts.args or not string.len(opts.args) == 2 then
      print(usage)
      return
    end
    vim.cmd(':vertical resize ' .. vim.opt.columns:get() * (opts.args / 100.0))
  end, { nargs = '*' })

  vim.api.nvim_create_user_command('Hr', function(opts)
    local usage = 'Usage: [HorizontalResize] :Hr {number (%)}'
    if not opts.args or not string.len(opts.args) == 2 then
      print(usage)
      return
    end
    vim.cmd(':resize ' .. ((vim.opt.lines:get() - vim.opt.cmdheight:get()) * (opts.args / 100.0)))
  end, { nargs = '*' })
  -- Print and copy file full path: ==============================================================
  vim.api.nvim_create_user_command('Path', function()
    local path = vim.fn.expand('%:p')
    if path == '' then return end
    vim.notify(path)
    vim.fn.setreg('+', path)
  end, {})
  -- copy current file path with number of line: =================================================
  vim.api.nvim_create_user_command('PathLine', function()
    local path = vim.fn.expand('%:p:h') .. '/' .. vim.fn.expand('%:t') .. ':' .. vim.fn.line('.')
    vim.fn.setreg('+', path)
    vim.notify('Copied: ' .. path)
  end, {})
  -- TrimSpaces and LastLine: ====================================================================
  vim.api.nvim_create_user_command('TrimSpaces', function()
    local curpos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, curpos)
  end, {})
  vim.api.nvim_create_user_command('TrimLastLines', function()
    local n_lines = vim.api.nvim_buf_line_count(0)
    local last_nonblank = vim.fn.prevnonblank(n_lines)
    if last_nonblank < n_lines then vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, {}) end
  end, {})
  -- Toggle conform.nvim auto-formatting: ========================================================
  vim.api.nvim_create_user_command('ToggleFormat', function()
    vim.g.autoformat = not vim.g.autoformat
    vim.notify(string.format('%s formatting...', vim.g.autoformat and 'Enabling' or 'Disabling'), vim.log.levels.INFO)
  end, { nargs = 0 })
  -- Enable Format: ===============================================================================
  vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = { start = { args.line1, 0 }, ['end'] = { args.line2, end_line:len() } }
    end
    require('conform').format({ async = true, lsp_format = 'fallback', range = range })
  end, { range = true })
  -- Enable FormatOnSave ==========================================================================
  vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
    vim.notify('Format On Save Enable')
  end, {})
  -- Disable FormatOnSave ========================================================================
  vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
    vim.notify('Format On Save Disable')
  end, { bang = true })
  -- Alternative Files ===========================================================================
  local go_to_relative_file = function(n, relative_to)
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
  vim.api.nvim_create_user_command('FileNext', go_to_relative_file(1), {})
  vim.api.nvim_create_user_command('FilePrev', go_to_relative_file(-1), {})
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                Neovim misspelled_commands               │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  local misspelled_commands = { 'W', 'Wq', 'WQ', 'Q', 'Qa', 'QA', 'Wqa', 'WQa', 'WQA' }
  for _, command in pairs(misspelled_commands) do
    vim.api.nvim_create_user_command(command, function()
      vim.cmd(string.lower(command))
    end, { bang = true })
  end
end)
--              ╭─────────────────────────────────────────────────────────╮
--              │                     Neovim keymaps                      │
--              ╰─────────────────────────────────────────────────────────╯
later(function()
  -- General: ====================================================================================
  vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>')
  vim.keymap.set('n', '<leader>qw', '<cmd>close<cr>')
  vim.keymap.set('n', '<leader>wq', '<cmd>close<cr>')
  vim.keymap.set('n', 'ZQ', '<cmd>quitall!<cr>')
  vim.keymap.set('n', '<C-s>', '<cmd>silent up<cr>')
  vim.keymap.set('i', '<C-s>', '<ESC> <cmd>up<cr>')
  vim.keymap.set('i', '<c-y>', '<Esc>viwUea')
  vim.keymap.set('i', '<c-t>', '<Esc>b~lea')
  vim.keymap.set('i', '<C-A>', '<HOME>')
  vim.keymap.set('i', '<C-E>', '<END>')
  vim.keymap.set('c', '<C-A>', '<HOME>')
  vim.keymap.set('n', '<c-y>', '<c-y><c-y><c-y>')
  vim.keymap.set('n', '<c-e>', '<c-e><c-e><c-e>')
  vim.keymap.set('n', '<C-c>', 'cit')
  vim.keymap.set('n', 'gk', 'gg')
  vim.keymap.set('n', 'gj', 'G')
  vim.keymap.set('n', 'gh', '^')
  vim.keymap.set('n', 'gl', 'g_')
  vim.keymap.set('v', 'gk', 'gg')
  vim.keymap.set('v', 'gj', 'G')
  vim.keymap.set('v', 'gh', '^')
  vim.keymap.set('v', 'gl', '$')
  vim.keymap.set('n', ';', ':')
  vim.keymap.set('x', ';', ':')
  vim.keymap.set('n', 'U', '<C-r>')
  vim.keymap.set('n', 'Q', '<nop>')
  vim.keymap.set('n', '<Space>', '<Nop>')
  vim.keymap.set('n', '<ESC>', ':nohl<cr>')
  vim.keymap.set('n', 'yco', 'o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>')
  vim.keymap.set('n', 'ycO', 'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>')
  vim.keymap.set('n', 'J', 'mzJ`z:delmarks z<cr>')
  vim.keymap.set('x', '/', '<Esc>/\\%V')
  vim.keymap.set('x', 'R', ':s###g<left><left><left>')
  vim.keymap.set('n', '<leader>y', '<cmd>%yank<cr>')
  vim.keymap.set('v', 'y', 'y`]')
  vim.keymap.set('v', 'p', 'p`]')
  vim.keymap.set('n', 'p', 'p`]')
  vim.keymap.set('x', 'gr', '"_dP')
  vim.keymap.set('n', 'x', '"_x')
  vim.keymap.set('n', 'c', '"_c')
  vim.keymap.set('n', 'cc', '"_cc')
  vim.keymap.set('n', 'C', '"_C')
  vim.keymap.set('x', 'c', '"_c')
  vim.keymap.set('v', '<', '<gv')
  vim.keymap.set('v', '>', '>gv')
  vim.keymap.set('v', '<TAB>', '>gv')
  vim.keymap.set('v', '<S-TAB>', '<gv')
  vim.keymap.set('x', '<TAB>', '>gv')
  vim.keymap.set('x', '<S-TAB>', '<gv')
  vim.keymap.set('x', '$', 'g_')
  vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv")
  vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv")
  vim.keymap.set('c', '%%', "<C-R>=expand('%:h').'/'<cr>")
  vim.keymap.set('n', '<leader>nc', ':e ~/AppData/local/nvim/init.lua<cr>')
  vim.keymap.set('n', '<leader>p', 'm`o<ESC>p``')
  vim.keymap.set('n', '<leader>P', 'm`O<ESC>p``')
  vim.keymap.set('n', '<leader>M', '<cmd>messages<cr>')
  vim.keymap.set('n', '<leader>uu', ':earlier ')
  vim.keymap.set('n', '<leader><leader>', 'zz')
  vim.keymap.set('n', '~', 'v~')
  vim.keymap.set('x', '/', '<esc>/\\%V')
  vim.keymap.set('n', 'g/', '*')
  vim.keymap.set('n', 'gy', '`[v`]')
  vim.keymap.set('n', '<C-i>', 'gg=G``')
  vim.keymap.set('n', '<C-m>', '%')
  vim.keymap.set('n', '<C-n>', '*N', { remap = true })
  vim.keymap.set('n', 'ycc', 'yygccp', { remap = true })
  vim.keymap.set('n', '<space>o', "printf('m`%so<ESC>``', v:count1)", { expr = true })
  vim.keymap.set('n', '<space>O', "printf('m`%sO<ESC>``', v:count1)", { expr = true })
  vim.keymap.set('n', '<leader>v', "printf('`[%s`]', getregtype()[0])", { expr = true })
  vim.keymap.set('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, replace_keycodes = false })
  -- Completion: ======================================================================================
  vim.keymap.set('i', '<C-j>', [[pumvisible() ? "\<C-n>" : "\<C-j>"]], { expr = true })
  vim.keymap.set('i', '<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]], { expr = true })
  -- window: =====================================================================================
  vim.keymap.set('n', '<leader>wc', '<cmd>close<cr>')
  vim.keymap.set('n', '<leader>wo', '<cmd>only<cr>')
  vim.keymap.set('n', '<leader>wv', '<cmd>split<cr>')
  vim.keymap.set('n', '<leader>ws', '<cmd>vsplit<cr>')
  vim.keymap.set('n', '<leader>|', '<cmd>wincmd v<cr>')
  vim.keymap.set('n', '<leader>-', '<cmd>wincmd s<cr>')
  vim.keymap.set('n', '<leader>wT', '<cmd>wincmd T<cr>')
  vim.keymap.set('n', '<leader>wr', '<cmd>wincmd r<cr>')
  vim.keymap.set('n', '<leader>wR', '<cmd>wincmd R<cr>')
  vim.keymap.set('n', '<leader>wH', '<cmd>wincmd H<cr>')
  vim.keymap.set('n', '<leader>wJ', '<cmd>wincmd J<cr>')
  vim.keymap.set('n', '<leader>wK', '<cmd>wincmd K<cr>')
  vim.keymap.set('n', '<leader>wL', '<cmd>wincmd L<cr>')
  vim.keymap.set('n', '<leader>w=', '<cmd>wincmd =<cr>')
  vim.keymap.set('n', '<leader>wk', '<cmd>resize +5<cr>')
  vim.keymap.set('n', '<leader>wj', '<cmd>resize -5<cr>')
  vim.keymap.set('n', '<leader>wh', '<cmd>vertical resize +3<cr>')
  vim.keymap.set('n', '<leader>wl', '<cmd>vertical resize -3<cr>')
  -- Focus : =====================================================================================
  vim.keymap.set('n', '<C-H>', '<C-w>h')
  vim.keymap.set('n', '<C-J>', '<C-w>j')
  vim.keymap.set('n', '<C-K>', '<C-w>k')
  vim.keymap.set('n', '<C-L>', '<C-w>l')
  -- Move: =======================================================================================
  vim.keymap.set('n', '<leader>L', '<C-w>L')
  vim.keymap.set('n', '<leader>H', '<C-w>H')
  vim.keymap.set('n', '<leader>K', '<C-w>K')
  vim.keymap.set('n', '<leader>J', '<C-w>J')
  -- Resize:  ====================================================================================
  vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>')
  vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>')
  vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>')
  vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>')
  -- Buffers: ====================================================================================
  vim.keymap.set('n', '<Tab>', '<cmd>bnext<cr>')
  vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<cr>')
  vim.keymap.set('n', '<leader><tab>', '<cmd>b#<cr>')
  vim.keymap.set('n', '<leader>ba', '<cmd>b#<cr>')
  vim.keymap.set('n', '<leader>bn', '<cmd>bnext<cr>')
  vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<cr>')
  -- Center:  ====================================================================================
  vim.keymap.set('n', 'n', 'nzzzv')
  vim.keymap.set('n', 'N', 'Nzzzv')
  vim.keymap.set('n', '<C-d>', '<C-d>zz')
  vim.keymap.set('n', '<C-u>', '<C-u>zz')
  -- Theme: ======================================================================================
  vim.keymap.set('n', '<leader>tt', '<cmd>DarkMode<cr>')
  vim.keymap.set('n', '<leader>td', '<cmd>set background=dark<cr>')
  vim.keymap.set('n', '<leader>tl', '<cmd>set background=light<cr>')
  vim.keymap.set('n', '<leader>tr', '<cmd>colorscheme randomhue<cr>')
  -- Marks: ======================================================================================
  vim.keymap.set('n', '<leader>mm', '<cmd>CycleMarks<cr>')
  vim.keymap.set('n', '<leader>mr', '<cmd>DeleteAllMarks<cr>')
  vim.keymap.set('n', '<leader>ms', '<cmd>SetCycleMarksDynamic<cr>')
  vim.keymap.set('n', '<leader>fm', '<cmd>PickMark<cr>')
  -- Subtitle Keys: ==============================================================================
  vim.keymap.set('n', '<Leader>rs', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]])
  vim.keymap.set('n', '<leader>rr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
  -- Jumps: ======================================================================================
  vim.keymap.set('n', '<C-o>', '<C-o>')
  vim.keymap.set('n', '<C-p>', '<C-i>')
  -- Misc: =======================================================================================
  vim.keymap.set('n', 'gcb', '<cmd>BoxComment<cr>')
  vim.keymap.set('n', 'gx', '<cmd>OpenUrlInBuffer<cr>')
  vim.keymap.set('n', '<leader>j', '<cmd>SmartDuplicate<cr>')
  vim.keymap.set('n', '<leader>s', '<cmd>ToggleWorld<cr>')
  vim.keymap.set('n', '<leader>lc', '<cmd>LspCapabilities<cr>')
  vim.keymap.set('n', '<leader>`', '<cmd>ToggleTitleCase<cr>')
  vim.keymap.set('n', '<leader>bm', '<cmd>ZoomToggle<cr>')
  vim.keymap.set('n', '<leader>bd', '<cmd>DeleteBuffer<cr>')
  vim.keymap.set('n', '<leader>bb', '<cmd>DeleteOtherBuffers<cr>')
  -- Terminal: ===================================================================================
  vim.keymap.set('n', '<C-t>', '<cmd>FloatTermToggle<cr>')
  vim.keymap.set('t', '<C-t>', '<cmd>FloatTermToggle<cr>')
  vim.keymap.set('n', '<leader>gg', '<cmd>FloatTermLazyGit<cr>')
  vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>')
  -- Git: ========================================================================================
  vim.keymap.set('n', '<leader>ga', '<cmd>Git add .<cr>')
  vim.keymap.set('n', '<leader>gc', '<cmd>Git commit<cr>')
  vim.keymap.set('n', '<leader>gC', '<Cmd>Git commit --amend<cr>')
  vim.keymap.set('n', '<leader>gp', '<cmd>Git push -u origin main<cr>')
  vim.keymap.set('n', '<leader>gP', '<cmd>Git pull<cr>')
  vim.keymap.set('n', '<leader>gd', '<Cmd>Git diff<cr>')
  vim.keymap.set('n', '<leader>gD', '<Cmd>Git diff -- %<cr>')
  vim.keymap.set('n', '<leader>gs', '<Cmd>lua MiniGit.show_at_cursor()<cr>')
  vim.keymap.set('n', '<leader>gS', [[<Cmd>Git status -s<cr>]])
  vim.keymap.set('n', '<leader>gl', [[<Cmd>Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order<cr>]])
  vim.keymap.set('n', '<leader>gh', [[<Cmd>lua MiniDiff.toggle_overlay()<cr>]])
  vim.keymap.set('n', '<leader>go', [[<Cmd>lua MiniDiff.toggle_overlay()<cr>]])
  vim.keymap.set('n', '<leader>gx', [[<Cmd>lua MiniGit.show_at_cursor()<cr>]])
  -- Picker ======================================================================================
  vim.keymap.set('n', '<leader>fb', '<cmd>Pick buffers include_current=true<cr>')
  vim.keymap.set('n', '<leader>fl', '<cmd>Pick buf_lines scope="current"<cr>')
  vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>')
  vim.keymap.set('n', '<leader>fr', '<cmd>Pick oldfiles<cr>')
  vim.keymap.set('n', '<leader>ft', '<cmd>Pick grep_live<cr>')
  vim.keymap.set('n', '<leader>fe', '<cmd>Pick explorer<cr>')
  vim.keymap.set('n', '<leader>fn', '<cmd>Pick hipatterns<cr>')
  vim.keymap.set('n', '<leader>fo', '<cmd>Pick options<cr>')
  vim.keymap.set('n', '<leader>fp', '<cmd>Pick projects<cr>')
  vim.keymap.set('n', '<leader>fd', '<cmd>Pick home<cr>')
  vim.keymap.set('n', '<leader>fk', '<cmd>Pick keymaps<cr>')
  vim.keymap.set('n', '<leader>fc', '<cmd>Pick commands<cr>')
  vim.keymap.set('n', '<leader>fh', '<cmd>Pick history<cr>')
  vim.keymap.set('n', '<leader>ftp', '<cmd>Pick colorschemes<cr>')
  vim.keymap.set('n', '<leader>fgf', '<cmd>Pick git_files<cr>')
  vim.keymap.set('n', '<leader>fgd', '<cmd>Pick git_hunks<cr>')
  vim.keymap.set('n', '<leader>fgc', '<cmd>Pick git_commits<cr>')
  vim.keymap.set('n', '<leader>fgb', '<cmd>Pick git_branches<cr>')
  vim.keymap.set('n', 'gR', "<Cmd>Pick lsp scope='references'<cr>")
  vim.keymap.set('n', 'gD', "<Cmd>Pick lsp scope='definition'<cr>")
  vim.keymap.set('n', 'gI', "<Cmd>Pick lsp scope='declaration'<cr>")
  vim.keymap.set('n', 'gS', "<Cmd>Pick lsp scope='document_symbol'<cr>")
  -- Brackted: ===================================================================================
  vim.keymap.set('n', '[a', '<cmd>previous<cr>')
  vim.keymap.set('n', ']a', '<cmd>next<cr>')
  vim.keymap.set('n', '[b', '<cmd>bprevious<cr>')
  vim.keymap.set('n', ']b', '<cmd>bnext<cr>')
  vim.keymap.set('n', '[q', '<cmd>cprevious<cr>')
  vim.keymap.set('n', ']q', '<cmd>cnext<cr>')
  vim.keymap.set('n', '[Q', '<cmd>cfirst<cr>')
  vim.keymap.set('n', ']Q', '<cmd>clast<cr>')
  vim.keymap.set('n', '[l', '<cmd>lprevious<cr>')
  vim.keymap.set('n', ']l', '<cmd>lnext<cr>')
  vim.keymap.set('n', '[f', '<cmd>FilePrev<cr>')
  vim.keymap.set('n', ']f', '<cmd>FileNext<cr>')
  vim.keymap.set('n', '[<space>', ":<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[")
  vim.keymap.set('n', ']<space>', ":<c-u>put =repeat(nr2char(10), v:count1)<cr>']")
  vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
  vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
  vim.keymap.set('n', '[c', function() require('mini.diff').goto_hunk('prev') end)
  vim.keymap.set('n', ']c', function() require('mini.diff').goto_hunk('next') end)
  -- Explorer: ====================================================================================
  vim.keymap.set('n', '<leader>e', function() require('mini.files').open(vim.bo.buftype ~= 'nofile' and vim.api.nvim_buf_get_name(0) or nil, true) end)
  vim.keymap.set('n', '<leader>E', function() require('mini.files').open(vim.uv.cwd(), true) end)
end)
--              ╔═════════════════════════════════════════════════════════╗
--              ║                          Neovide                        ║
--              ╚═════════════════════════════════════════════════════════╝
later(function()
  if vim.g.neovide then
    -- General: ==================================================================================
    vim.g.neovide_scale_factor = 1
    vim.g.neovide_refresh_rate = 120
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_left = 0
    -- Appearance: ===============================================================================
    vim.g.neovide_opacity = 1
    vim.g.neovide_underline_stroke_scale = 2.5
    vim.g.neovide_show_border = false
    -- floating: =================================================================================
    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    -- floating: =================================================================================
    vim.g.neovide_floating_shadow = false
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
    -- behavior: =================================================================================
    vim.g.neovide_remember_window_size = false
    vim.g.neovide_hide_mouse_when_typing = false
    vim.g.neovide_no_idle = false
    vim.g.neovide_cursor_smooth_blink = false
    vim.g.neovide_cursor_antialiasing = false
    vim.g.neovide_cursor_animate_in_insert_mode = false
    vim.g.neovide_cursor_animate_command_line = false
    -- cursor: ===================================================================================
    vim.g.neovide_position_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.00
    vim.g.neovide_cursor_trail_size = 0
    vim.g.neovide_scroll_animation_far_lines = 0
    vim.g.neovide_scroll_animation_length = 0.00
    -- Options: ==================================================================================
    vim.opt.guicursor = 'a:block,a:Cursor/lCursor'
    vim.o.guifont = 'jetBrainsMono Nerd Font:h10:b'
    vim.o.mousescroll = 'ver:10,hor:6'
    vim.o.linespace = 1
    -- Keymap: ===================================================================================
    vim.keymap.set({ 'n', 'v' }, '<C-=>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<cr>')
    vim.keymap.set({ 'n', 'v' }, '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<cr>')
    vim.keymap.set({ 'n', 'v' }, '<C-0>', ':lua vim.g.neovide_scale_factor = 1<cr>')
  end
end)
--              ╔═════════════════════════════════════════════════════════╗
--              ║                          FileType                       ║
--              ╚═════════════════════════════════════════════════════════╝
later(function()
  vim.filetype.add({
    extension = {
      ['scm'] = 'query',
      ['http'] = 'http',
      ['json'] = 'jsonc',
      ['map'] = 'json',
      ['mdx'] = 'markdown',
      ['ipynb'] = 'ipynb',
      ['pcss'] = 'css',
      ['ejs'] = 'ejs',
      ['mts'] = 'javascript',
      ['cts'] = 'javascript',
      ['es6'] = 'javascript',
      ['conf'] = 'conf',
      ['ahk2'] = 'autohotkey',
      ['xaml'] = 'xml',
      ['h'] = 'c',
    },
    filename = {
      ['TODO'] = 'markdown',
      ['README'] = 'markdown',
      ['readme'] = 'markdown',
      ['xhtml'] = 'html',
      ['tsconfig.json'] = 'jsonc',
      ['.eslintrc.json'] = 'jsonc',
      ['.prettierrc'] = 'jsonc',
      ['.babelrc'] = 'jsonc',
      ['.stylelintrc'] = 'jsonc',
      ['.yamlfmt'] = 'yaml',
      ['nginx.conf'] = 'nginx',
      ['Dockerfile'] = 'dockerfile',
      ['dockerfile'] = 'dockerfile',
    },
    pattern = {
      ['requirements.*.txt'] = 'requirements',
      ['.*config/git/config'] = 'gitconfig',
      ['.*/git/config.*'] = 'git_config',
      ['.gitconfig.*'] = 'gitconfig',
      ['%.env%.[%w_.-]+'] = 'sh',
      ['.*%.variables.*'] = 'sh',
      ['.*/%.vscode/.*%.json'] = 'jsonc',
      ['.*/*.conf*'] = 'conf',
      ['*.MD'] = 'markdown',
      ['Dockerfile*'] = 'dockerfile',
      ['.*%.dockerfile'] = 'dockerfile',
      ['*.dockerfile'] = 'dockerfile',
      ['*.user.css'] = 'ess',
    },
  })
end)
