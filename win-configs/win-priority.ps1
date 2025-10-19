# =============================================================================== #
# region — Privilege Check:                                                       #
# =============================================================================== #
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script must be run as Administrator. Exiting."
    Exit 1
}

$applications = @(
    "WindowsTerminal.exe",
    "alacritty.exe",
    "neovide.exe",
    "nvim.exe",
    "node.exe",
    "Zed.exe"
)
$name = "CpuPriorityClass"
$value = 3
foreach ($app in $applications) {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$app\PerfOptions"
    # Safely create registry path only for these specific apps
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    # Set only the specific value we want
    Set-ItemProperty -Path $regPath -Name $name -Value $value -Type DWord
    Write-Host "Applied performance boost for: $app"
}
