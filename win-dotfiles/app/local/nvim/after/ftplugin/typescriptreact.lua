--              ╔═════════════════════════════════════════════════════════╗
--              ║                    Typescript React                     ║
--              ╚═════════════════════════════════════════════════════════╝
-- Autocmds: =====================================================================================
vim.api.nvim_create_augroup('js_template_string', { clear = true })
vim.api.nvim_create_autocmd('InsertCharPre', {
  group = 'js_template_string',
  callback = function(opts)
    -- Only run if template literal character is typed
    if vim.v.char ~= '{' then return end

    -- Get node and return early if not in a string
    local node = vim.treesitter.get_node()

    if not node then return end
    if node:type() ~= 'string' then node = node:parent() end
    if not node or node:type() ~= 'string' then return end

    -- Return early if string is already a template literal
    local row, col, _, _ = vim.treesitter.get_node_range(node)
    local first_char = vim.api.nvim_buf_get_text(opts.buf, row, col, row, col + 1, {})[1]
    if first_char == '`' then return end

    -- Otherwise, change quotes to backticks using surround and return to insert mode
    vim.api.nvim_input('<Esc>cs\"`' .. '<Esc>f{a')
  end,
})
