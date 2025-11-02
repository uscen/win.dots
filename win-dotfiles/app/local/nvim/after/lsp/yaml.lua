--          ╔═════════════════════════════════════════════════════════╗
--          ║                       Yaml LSP                          ║
--          ╚═════════════════════════════════════════════════════════╝
return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  settings = {
    yaml = { schemas = {
      kubernetes = 'k8s/**/*.{yaml}',
    }, redhat = { telemetry = { enabled = false } } },
  },
  single_file_support = true,
  root_markers = { '.git' },
}
