--          ╔═════════════════════════════════════════════════════════╗
--          ║                     Lua LSP                             ║
--          ╚═════════════════════════════════════════════════════════╝
return {
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
      workspace = { ignoreSubmodules = true, library = { vim.env.VIMRUNTIME, '${3rd}/luv/library' } },
      diagnostics = { globals = { 'MiniDeps' } },
      signatureHelp = { enabled = true },
      format = { enable = true },
      telemetry = { enable = false },
    },
  },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
    '.git',
  },
  on_attach = function(client, buf_id)
    -- Reduce very long list of triggers for better 'mini.completion' experience
    client.server_capabilities.completionProvider.triggerCharacters =
    { '.', ':', '#', '(' }
  end,
}
