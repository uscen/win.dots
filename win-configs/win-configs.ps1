# =============================================================================== #
# General:                                                                        #
# =============================================================================== #
# Home: ==========================================================================================
$sourceHome = "$Env:USERPROFILE\win.dots\win-dotfiles\home"
$destHome = "$Env:USERPROFILE\"
Get-ChildItem -Path $sourceHome | ForEach-Object {
    $targetPath = Join-Path $destHome $_.Name
    if (Test-Path $targetPath) { Remove-Item $targetPath -Force -Recurse }
    New-Item -ItemType Junction -Path $targetPath -Target $_.FullName -Force
}

# Config: ========================================================================================
$sourceConfig = "$Env:USERPROFILE\win.dots\win-dotfiles\cfg"
$destConfig = "$Env:USERPROFILE\.config"
if (-Not (Test-Path -Path $destConfig)) {
    New-Item -Path $destConfig -ItemType Directory | Out-Null
}
Get-ChildItem -Path $sourceConfig | ForEach-Object {
    $targetPath = Join-Path $destConfig $_.Name
    if (Test-Path $targetPath) { Remove-Item $targetPath -Force -Recurse }
    New-Item -ItemType Junction -Path $targetPath -Target $_.FullName -Force
}

# AppData: =======================================================================================
if (-Not (Test-Path -Path $Env:localAppData)) {
    New-Item -Path $Env:localAppData -ItemType Directory | Out-Null
}
if (-Not (Test-Path -Path $Env:AppData)) {
    New-Item -Path $Env:AppData -ItemType Directory | Out-Null
}

# Roming: ========================================================================================
$sourceRoaming = "$Env:USERPROFILE\win.dots\win-dotfiles\app\roming"
Get-ChildItem -Path $sourceRoaming | ForEach-Object {
    $targetPath = Join-Path $Env:AppData $_.Name
    if (Test-Path $targetPath) { Remove-Item $targetPath -Force -Recurse }
    New-Item -ItemType Junction -Path $targetPath -Target $_.FullName -Force
}

# Local: =========================================================================================
$sourceLocal = "$Env:USERPROFILE\win.dots\win-dotfiles\app\local"
Get-ChildItem -Path $sourceLocal | ForEach-Object {
    $targetPath = Join-Path $Env:localAppData $_.Name
    if (Test-Path $targetPath) { Remove-Item $targetPath -Force -Recurse }
    New-Item -ItemType Junction -Path $targetPath -Target $_.FullName -Force
}

# Mpv: ===========================================================================================
$mpvSource = "$env:USERPROFILE\win.dots\win-dotfiles\app\roming\mpv"
$mpvDest = "$env:USERPROFILE\scoop\persist\mpv\portable_config"
if ((Test-Path $mpvSource) -and (Test-Path (Split-Path $mpvDest -Parent))) {
    if (Test-Path $mpvDest) { Remove-Item $mpvDest -Force -Recurse }
    New-Item -ItemType Junction -Path $mpvDest -Target $mpvSource -Force
}

# Tealdeer: ======================================================================================
$tealdeerSource = "$env:USERPROFILE\win.dots\win-dotfiles\app\roming\tealdeer\tealdeer"
$tealdeerDest = "$env:USERPROFILE\scoop\persist\tealdeer"
if (Test-Path $tealdeerSource) {
    if (Test-Path $tealdeerDest) { Remove-Item $tealdeerDest -Force -Recurse }
    New-Item -ItemType Junction -Path $tealdeerDest -Target $tealdeerSource -Force
}

# Tealdeer: ======================================================================================
$tealdeerSource = "$env:USERPROFILE\win.dots\win-dotfiles\app\roming\bat"
$tealdeerDest = "$env:USERPROFILE\scoop\apps\bat\current"
if (Test-Path $tealdeerSource) {
    if (Test-Path $tealdeerDest) { Remove-Item $tealdeerDest -Force -Recurse }
    New-Item -ItemType Junction -Path $tealdeerDest -Target $tealdeerSource -Force
}

# Others: ========================================================================================
$wtSource = "$Env:USERPROFILE\win.dots\win-dotfiles\app\roming\wt\LocalState"
$wtDest = "$Env:USERPROFILE\scoop\persist\windows-terminal\settings"
if ((Test-Path $wtSource) -and (Test-Path (Split-Path $wtDest -Parent))) {
    if (Test-Path $wtDest) { Remove-Item $wtDest -Force -Recurse }
    New-Item -ItemType Junction -Path $wtDest -Target $wtSource -Force
}
