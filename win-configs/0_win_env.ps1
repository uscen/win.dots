# =============================================================================== #
# ENV:				                                                                    #
# =============================================================================== #
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser => Recomanded
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
    Write-Host "Set persistent variable: $key"
}
