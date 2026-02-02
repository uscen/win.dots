# =============================================================================== #
# List Packages:      		                                                        #
# =============================================================================== #
$packages=@(
    # Tree-sitter-cli:                                                                #
    # =============================================================================== #
    "tree-sitter-cli",
    # HOT-RELOAD:                                                                     #
    # =============================================================================== #
    "browser-sync",
    # PACKAGE MANAGER:                                                                #
    # =============================================================================== #
    "yarn",
    "pnpm"
    # LANGUGE SERVER PORTOCOL:                                                        #
    # =============================================================================== #
    "@typescript/native-preview",
    "@olrtg/emmet-language-server",
    "@tailwindcss/language-server",
    "vscode-langservers-extracted",
    "prettier",
)
# =============================================================================== #
# NPM Packages:      		                                                          #
# =============================================================================== #
foreach ($package in $packages) {
        Write-Host "Installing $package..."
        npm install -g $package
}
Write-Host "Installation Of NPM Packages Is Complete!"
