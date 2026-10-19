# =============================================================================== #
# Environments:				                                                            #
# =============================================================================== #
$userProfile = [Environment]::GetEnvironmentVariable("USERPROFILE")
$appData     = [Environment]::GetEnvironmentVariable("APPDATA")
$localAppData = [Environment]::GetEnvironmentVariable("LOCALAPPDATA")
$vars = @{
    "XDG_HOME_DIR"      = $userProfile
    "XDG_CONFIG_DIR"    = $appData
    "XDG_CONFIG_HOME"   = $appData
    "XDG_DATA_HOME"     = $localAppData
    "XDG_CACHE_HOME"    = "$localAppData\Temp"
    "XDG_DESKTOP_DIR"   = "$userProfile\Desktop"
    "XDG_DOCUMENTS_DIR" = "$userProfile\Documents"
    "XDG_DOWNLOAD_DIR"  = "$userProfile\Downloads"
    "XDG_MUSIC_DIR"     = "$userProfile\Music"
    "XDG_PICTURES_DIR"  = "$userProfile\Pictures"
    "XDG_VIDEOS_DIR"    = "$userProfile\Videos"
}
foreach ($key in $vars.Keys) {
    [Environment]::SetEnvironmentVariable($key, $vars[$key], "User")
}

# =============================================================================== #
# Autostart:                                                                      #
# =============================================================================== #
# paths: =========================================================================================
$scoopPath = "$env:USERPROFILE\scoop\apps\glazewm\current"
$programFilesPath = "C:\Program Files\glzr.io\GlazeWM"

# Checker: =======================================================================================
if (Test-Path $scoopPath) {
    $installPath = $scoopPath
} elseif (Test-Path $programFilesPath) {
    $installPath = $programFilesPath
} else {
    Write-Host "GlazeWM is not installed in the expected locations."
    exit
}

# Startup: =======================================================================================
$startupFolderPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcutPath = "$startupFolderPath\GlazeWM.lnk"

# shortcut: ======================================================================================
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "$installPath\glazewm.exe"
$Shortcut.WorkingDirectory = $installPath
$Shortcut.Save()
Write-Host "Shortcut created at $shortcutPath"

# =============================================================================== #
# Pics:                                                                           #
# =============================================================================== #
$sourcePics = "$Env:USERPROFILE\win.dots\win-dotfiles\pics"
$destPics = "$Env:USERPROFILE\Pictures"
Get-ChildItem -Path $sourcePics | ForEach-Object {
    $targetPath = Join-Path $destPics $_.Name
    if (Test-Path $targetPath) { Remove-Item $targetPath -Force -Recurse }
    New-Item -ItemType Junction -Path $targetPath -Target $_.FullName -Force
}

# =============================================================================== #
# dotfiles:                                                                       #
# =============================================================================== #
# Home: ==========================================================================================
$sourceHome = "$Env:USERPROFILE\win.dots\win-dotfiles\home"
$destHome = "$Env:USERPROFILE\"
Get-ChildItem -Path $sourceHome | ForEach-Object {
    $targetPath = Join-Path $destHome $_.Name
    if (Test-Path $targetPath) { Remove-Item $targetPath -Force -Recurse }
    New-Item -ItemType Junction -Path $targetPath -Target $_.FullName -Force
}

# AppData: =======================================================================================
if (-Not (Test-Path -Path $Env:AppData)) {
    New-Item -Path $Env:AppData -ItemType Directory | Out-Null
}
$sourceRoaming = "$Env:USERPROFILE\win.dots\win-dotfiles\apps"
Get-ChildItem -Path $sourceRoaming | ForEach-Object {
    $targetPath = Join-Path $Env:AppData $_.Name
    if (Test-Path $targetPath) { Remove-Item $targetPath -Force -Recurse }
    New-Item -ItemType Junction -Path $targetPath -Target $_.FullName -Force
}
