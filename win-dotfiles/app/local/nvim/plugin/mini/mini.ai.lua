-- ============================================================================== #
-- Ai:                                                                            #
-- ============================================================================== #
Config.later(function()
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
      x = gen_ai_spec.diagnostic(),
      i = gen_ai_spec.indent(),
      d = gen_ai_spec.number(),
      r = gen_ai_spec.line(),
      a = MiniAi.gen_spec.argument({ separator = ',%s*' }),
      h = MiniAi.gen_spec.treesitter({ a = '@block.outer', i = '@block.inner' }),
      u = MiniAi.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      k = MiniAi.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
      l = MiniAi.gen_spec.treesitter({ a = '@loop.outer', i = '@loop.inner' }),
      c = MiniAi.gen_spec.treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
      o = MiniAi.gen_spec.treesitter({
        a = { '@block.outer', '@conditional.outer', '@loop.outer' },
        i = { '@block.inner', '@conditional.inner', '@loop.inner' },
      }),
      g = function()
        local from = { line = 1, col = 1 }
        local to = { line = vim.fn.line('$'), col = math.max(vim.fn.getline('$'):len(), 1) }
        return { from = from, to = to }
      end,
      e = function(ai_type, id, opts)
        if ai_type == 'a' then
          return {
            {
              -- pattern, [^_]pattern_*: =========================================================
              '%f[%a_%-]%l+%d*[_%-]*',
              '%f[%w_%-]%d+[_%-]*',
              '%f[%u_%-]%u%f[%A]%d*[_%-]*',
              '%f[%u_%-]%u%l+%d*[_%-]*',
              '%f[%u_%-]%u%u+%d*[_%-]*',

              -- __pattern: ======================================================================
              '%f[_%-][_%-]+%l+%d*',
              '%f[_%-][_%-]+%d+',
              '%f[_%-][_%-]+%u%f[%A]%d*',
              '%f[_%-][_%-]+%u%l+%d*',
              '%f[_%-][_%-]+%u%u+%d*',

              -- __pattern__: ====================================================================
              '[_%-]()()%l+%d*[_%-]+()()',
              '[_%-]()()%d+[_%-]+()()',
              '[_%-]()()%u%f[%A]%d*[_%-]+()()',
              '[_%-]()()%u%l+%d*[_%-]+()()',
              '[_%-]()()%u%u+%d*[_%-]+()()',
            },
          }
        end
        if ai_type == 'i' then
          local reg = MiniAi.find_textobject('a', id, opts)
          if reg then
            local line = vim.fn.getline(reg.from.line)
            local _, s = line:find('^[_%-]*.', reg.from.col)
            local e = line:sub(1, reg.to.col):find('.[_%-]*$')
            return vim.tbl_deep_extend('force', reg, { from = { col = s }, to = { col = e } })
          end
        end
      end,
      t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
    },
  })
end)
