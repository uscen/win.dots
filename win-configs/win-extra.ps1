# =============================================================================== #
# List Packages:      		                                                        #
# =============================================================================== #
$packages=@(
    # LANGUGE SERVER PORTOCOL:                                                        #
    # =============================================================================== #
    "@typescript/native-preview",
    "@olrtg/emmet-language-server",
    "@tailwindcss/language-server",
    "vscode-langservers-extracted",
    "prettier",
    # PACKAGE MANAGER:                                                                #
    # =============================================================================== #
    "yarn",
    "pnpm",
    # HOT-RELOAD:                                                                     #
    # =============================================================================== #
    "browser-sync",
    # Tree-sitter-cli:                                                                #
    # =============================================================================== #
    "tree-sitter-cli"
)
# =============================================================================== #
# NPM Packages:      		                                                          #
# =============================================================================== #
foreach ($package in $packages) {
        Write-Host "Installing $package..."
        npm install -g $package
}
Write-Host "Installation Of NPM Packages Is Complete!"
