# =============================================================================== #
# Packages:                                                                       #
# =============================================================================== #
$packages=@(
    "@vtsls/language-server"
    "@olrtg/emmet-language-server"
    "@tailwindcss/language-server"
    "vscode-langservers-extracted"
    "prettier"
    "tree-sitter-cli"
    "browser-sync"
)
foreach ($package in $packages) {
        Write-Host "Installing $package..."
        npm install -g $package
}
Write-Host "Installation Of NPM Packages Is Complete!"
