# =============================================================================== #
# Privilege:                                                                      #
# =============================================================================== #
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting."
    Exit 1
}

# =============================================================================== #
# Parameters:                                                                     #
# =============================================================================== #
$DaysOld     = 5
$LogPath     = "C:\Windows\Logs"
$ComponentLog= "$LogPath\CBS"
$DismLog     = "$LogPath\DISM"
$PantherLog  = "C:\Windows\Panther"

# =============================================================================== #
# Clean:                                                                          #
# =============================================================================== #
Function Remove-OldFiles {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][int]$Days
    )
    Try {
        Get-ChildItem -Path $Path -Recurse -Force -ErrorAction Stop |
          Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$Days) } |
          Remove-Item -Force -Recurse -ErrorAction Stop
        Write-Host "Cleaned files older than $Days days in $Path"
    }
    Catch {
        Write-Warning "Error cleaning $Path : $_"
    }
}

# =============================================================================== #
# Cache:                                                                          #
# =============================================================================== #
Write-Host "Stopping Windows Update service..."
Stop-Service wuauserv -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv
Write-Host "Windows Update cache cleared."

# =============================================================================== #
# Tmp:                                                                            #
# =============================================================================== #
$TempDirs = @("$env:TEMP","C:\Windows\Temp")
ForEach ($dir in $TempDirs) {
    Remove-OldFiles -Path $dir -Days $DaysOld
}

# =============================================================================== #
# Prefetch:                                                                       #
# =============================================================================== #
Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
Write-Host "Prefetch folder emptied."

# =============================================================================== #
# Log:                                                                            #
# =============================================================================== #
Remove-OldFiles -Path $ComponentLog -Days $DaysOld
Remove-OldFiles -Path $DismLog      -Days $DaysOld
Remove-OldFiles -Path $PantherLog   -Days $DaysOld

# =============================================================================== #
# DISM:                                                                           #
# =============================================================================== #
Write-Host "Running DISM component cleanup (StartComponentCleanup)..."
& DISM.exe /Online /Cleanup-Image /StartComponentCleanup /NoRestart | Out-Null

Write-Host "Optionally resetting base (ResetBase)..."
& DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase /NoRestart | Out-Null

# =============================================================================== #
# Disk:                                                                           #
# =============================================================================== #
Write-Host "Launching Disk Cleanup for system files..."
Start-Process cleanmgr.exe -ArgumentList "/sagerun:99" -NoNewWindow -Wait

# =============================================================================== #
# Sfc:                                                                            #
# =============================================================================== #
Write-Host "Running System File Checker (sfc /scannow)..."
sfc /scannow | Out-Null

# =============================================================================== #
# Summary:                                                                        #
# =============================================================================== #
Write-Host "Cleanup complete! It's recommended to reboot your PC now."
