--              ╔═════════════════════════════════════════════════════════╗
--              ║                           Python                        ║
--              ╚═════════════════════════════════════════════════════════╝
-- Options: ======================================================================================
vim.opt_local.colorcolumn = '89'
-- Keymaps: ======================================================================================
vim.keymap.set('i', '<M-i>', ' = ', { buffer = 0 })
-- Indentation: ==================================================================================
vim.g.pyindent_open_paren = 'shiftwidth()'
vim.g.pyindent_continue = 'shiftwidth()'
-- Mini: =========================================================================================
vim.b.miniindentscope_config = { options = { border = 'top' } }
-- Autocmds: =====================================================================================
vim.api.nvim_create_augroup('py_fstring', { clear = true })
vim.api.nvim_create_autocmd('InsertCharPre', {
  group = 'py_fstring',
  callback = function(opts)
    -- Only run if f-string escape character is typed
    if vim.v.char ~= '{' then return end

    -- Get node and return early if not in a string
    local node = vim.treesitter.get_node()

    if not node then return end
    if node:type() ~= 'string' then node = node:parent() end
    if not node or node:type() ~= 'string' then return end

    vim.print(node:type())
    local row, col, _, _ = vim.treesitter.get_node_range(node)

    -- Return early if string is already a format string
    local first_char = vim.api.nvim_buf_get_text(opts.buf, row, col, row, col + 1, {})[1]
    vim.print('row ' .. row .. ' col ' .. col)
    vim.print("char: '" .. first_char .. "'")
    if first_char == 'f' then return end

    -- Otherwise, make the string a format string
    vim.api.nvim_input("<Esc>m'" .. row + 1 .. 'gg' .. col + 1 .. "|if<Esc>`'la")
  end,
})
