# =============================================================================== #
# General:                                                                        #
# =============================================================================== #
$env.PATH = ($env.PATH | split row (char esep) | append "C:/Program Files/Git/bin/")
$env.SHELL = $nu.current-exe
$env.CC = "gcc"
$env.LANG = "en_US.utf-8"
$env.LC_ALL = "en_US.UTF-8"
$env.EDITOR = "nvim"
$env.VISUAL = $env.EDITOR
$env.PAGER = "less"
$env.TERMINAL = "alacritty"
$env.BROWSER = "brave"
export-env { load-env {
    XDG_HOME_DIR: ($env.USERPROFILE)
    XDG_CONFIG_DIR: ($env.APPDATA)
    XDG_CACHE_HOME: ($env.LOCALAPPDATA | path join "Temp")
    XDG_DOCUMENTS_DIR: ($env.USERPROFILE | path join "Documents")
    XDG_DOWNLOAD_DIR: ($env.USERPROFILE | path join "Downloads")
    XDG_MUSIC_DIR: ($env.USERPROFILE | path join "Music")
    XDG_PICTURES_DIR: ($env.USERPROFILE | path join "Pictures")
    XDG_VIDEOS_DIR: ($env.USERPROFILE | path join "Videos")
}}
export-env { load-env {
    MPV_HOME : ($env.XDG_CONFIG_DIR | path join "mpv")
    BAT_CONFIG_DIR : ($env.XDG_CONFIG_DIR | path join "bat")
    TEALDEER_CONFIG_DIR : ($env.XDG_CONFIG_DIR | path join "tealdeer")
    RIPGREP_CONFIG_PATH : ($env.XDG_CONFIG_DIR | path join "ripgrep" "rc")
    GIT_CONFIG_GLOBAL  : ($env.XDG_HOME_DIR | path join ".others" | path join "gitconfig")
}}

# =============================================================================== #
# FZF:                                                                            #
# =============================================================================== #
$env.FZF_DEFAULT_OPTS = "
    --prompt='󱓇  ' --layout=reverse
    --preview-window=right,30%
    --style=minimal --height=100% --border --preview-window right,40%
    --color fg:#DBD2C7,bg:#172526
    --color bg+:#233935,fg+:#DBD2C7
    --color hl:#88B497,hl+:#88B497,gutter:#172526
    --color pointer:#9EC59B,info:#233935
    --color prompt:#88B497,
    --color border:#233935
    --bind 'tab:accept'
"

# =============================================================================== #
# Zoxide:                                                                         #
# =============================================================================== #
zoxide init nushell | save -f ($env.XDG_CACHE_HOME | path join "zoxide.nu")

# =============================================================================== #
# Carapace:                                                                       #
# =============================================================================== #
carapace _carapace nushell | save -f ($env.XDG_CACHE_HOME | path join "carapace.nu")
