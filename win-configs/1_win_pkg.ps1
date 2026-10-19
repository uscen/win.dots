# =============================================================================== #
# Packages:				                                                                #
# =============================================================================== #
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser => Recomanded
# Set-ExecutionPolicy RemoteSigned => RemoteSigned requires that scripts downloaded from the internet have a digital signature# Set-ExecutionPolicy Unrestricted -Scope LocalMachine =>
# Set-ExecutionPolicy Unrestricted -Scope LocalMachine => Unrestricted does not enforce any restrictions
# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force => Bypass In Current Session Only
# Set-ExecutionPolicy Restricted => Revert to Default
$scoopPackages = @(
    "nu",
    "aria2",
    "curl",
    "mingw",
    "carapace-bin",
    "gsudo",
    "glazeWM",
    "alacritty",
    "yazi",
    "fd",
    "pastel",
    "fzf",
    "zoxide",
    "ripgrep",
    "neovim",
    "chafa",
    "jq",
    "fastfetch",
    "bat",
    "glow",
    "tealdeer",
    "lazygit",
    "delta",
    "btop",
    "eza",
    "brave",
    "localsend",
    "obs-studio",
    "shotcut",
    "gimp",
    "thunderbird",
    "sumatrapdf",
    "JetBrainsMono-NF",
    "imagemagick",
    "ffmpeg",
    "yt-dlp",
    "ouch",
    "mpv",
    "qview",
    "nodejs"
)

# =============================================================================== #
# Scoop:	                                                                        #
# =============================================================================== #
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop ..."
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
scoop bucket add extras
scoop bucket add nerd-fonts

# =============================================================================== #
# Pkg:	                                                                          #
# =============================================================================== #
foreach ($package in $scoopPackages) {
    Write-Host "Installing $package..."
    scoop install $package
}
Write-Host "Installation Of Scoop Packages Is Complete!"
