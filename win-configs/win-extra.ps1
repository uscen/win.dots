# =============================================================================== #
# List Packages:      		                                                        #
# =============================================================================== #
$packages=@(
    # PACKAGE MANAGER:                                                                #
    # =============================================================================== #
    "bun",
    "yarn",
    "pnpm"
    # Tree-sitter-cli:                                                                #
    # =============================================================================== #
    "tree-sitter-cli",
    # LANGUGE SERVER PORTOCOL:                                                        #
    # =============================================================================== #
    "@vtsls/language-server",
    "@olrtg/emmet-language-server",
    "@tailwindcss/language-server",
    "vscode-langservers-extracted",
    "prettier"
)
# =============================================================================== #
# NPM Packages:      		                                                          #
# =============================================================================== #
foreach ($package in $packages) {
        Write-Host "Installing $package..."
        npm install -g $package
}
Write-Host "Installation Of NPM Packages Is Complete!"
