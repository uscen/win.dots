# =============================================================================== #
# Reset:                                                                          #
# =============================================================================== #
alias cls = clear
alias reset = clear

# =============================================================================== #
# Fetch:                                                                          #
# =============================================================================== #
alias fetch = fastfetch
alias neofetch = fastfetch

# =============================================================================== #
# Zoxide:                                                                         #
# =============================================================================== #
alias cd = z
alias cdf = zi

# =============================================================================== #
# Configs:                                                                        #
# =============================================================================== #
alias dots = cd ($env.USERPROFILE | path join "win.dots")
alias nuc = nvim ($env.APPDATA | path join "nushell" | path join "config.nu")
alias wmc = nvim ($env.USERPROFILE | path join ".glzr" | path join "glazewm" | path join "config.yaml")

# =============================================================================== #
# Eza:                                                                            #
# =============================================================================== #
alias ls = eza --long --group --icons=auto --git --sort=name --group-directories-first
alias ll = eza --long --group --icons=auto --git --sort=name --group-directories-first
alias lt = eza --long --group --icons=auto --git --only-dirs --tree --level=3 --sort=modified

# =============================================================================== #
# Bat:                                                                            #
# =============================================================================== #
alias b = bat
alias bn = bat --number
alias bp = bat --plain
alias bl = bat --line-range
alias bpl = bat --plain --line-range
alias bnl = bat --number --line-range

# =============================================================================== #
# Editor:                                                                         #
# =============================================================================== #
alias v = nvim
alias n = nvim
alias vi = nvim
alias nv = nvim
alias vn = nvim
alias vn = nvim
alias vm = nvim

# =============================================================================== #
# Git:                                                                            #
# =============================================================================== #
alias g = git
alias lg = lazygit
alias gi = g init
alias ge = g clone
alias gd = g diff
alias gf = g fetch
alias gg = g pull
alias gb = g branch
alias gg = g switch
alias ga = g add --all
alias gs = g status -s
alias gc = g commit -m
alias gp = g push -uf origin main
alias gl = g log --oneline --graph --all -10

# =============================================================================== #
# Packages:                                                                       #
# =============================================================================== #
alias pu = scoop update --all
alias pi = scoop install
alias pr = scoop uninstall
alias pq = scoop search
alias pl = scoop list
alias pc = scoop cleanup --cache --all
alias pclean = scoop cleanup --cache --all

# =============================================================================== #
# Others:                                                                         #
# =============================================================================== #
alias yt-concats = yt-dlp --ignore-config --config-locations ($env.APPDATA | path join "yt-dlp" | path join "playlist")
alias yt-music = yt-dlp --ignore-config --config-locations ($env.APPDATA | path join "yt-dlp" | path join "music")
alias dev = browser-sync start --no-notify --server --files '**/*.html, **/*.css, **/*.js'
alias man = tldr
alias cat = bat
