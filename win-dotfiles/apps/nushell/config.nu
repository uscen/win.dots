# =============================================================================== #
# Theme:                                                                          #
# =============================================================================== #
let base00 = "#172526"
let base01 = "#233935"
let base02 = "#2D4F67"
let base03 = "#585858"
let base04 = "#FFD7AA"
let base05 = "#FFD7AA"
let base06 = "#A1A790"
let base07 = "#DBD2C7"
let base08 = "#D2696C"
let base09 = "#F9ADA0"
let base0a = "#88B497"
let base0b = "#E6C384"
let base0c = "#91C4C0"
let base0d = "#938AA9"
let base0e = "#87CBB1"
let base0f = "#DBD2C7"
let base16_theme = {
    separator: $base03
    leading_trailing_space_bg: $base04
    header: $base0b
    date: $base0e
    filesize: $base0d
    row_index: $base0c
    bool: $base08
    int: $base0b
    duration: $base08
    range: $base08
    float: $base08
    string: $base04
    nothing: $base08
    binary: $base08
    cellpath: $base08
    hints: dark_gray

    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b }
    shape_bool: $base0d
    shape_int: { fg: $base0e attr: b }
    shape_float: { fg: $base0e attr: b }
    shape_range: { fg: $base0a attr: b }
    shape_internalcall: { fg: $base0c attr: b }
    shape_external: $base0c
    shape_externalarg: { fg: $base0b attr: b }
    shape_literal: $base0d
    shape_operator: $base0a
    shape_signature: { fg: $base0b attr: b }
    shape_string: $base0b
    shape_filepath: $base0d
    shape_globpattern: { fg: $base0d attr: b }
    shape_variable: $base0e
    shape_flag: { fg: $base0d attr: b }
    shape_custom: { attr: b }
}

# =============================================================================== #
# General:                                                                        #
# =============================================================================== #
$env.config = {
  color_config: $base16_theme
  bracketed_paste: true
  show_banner: false
  float_precision: 2
  use_ansi_coloring: true
  edit_mode: vi
  error_style: "short"
  cursor_shape: {
    vi_normal: block
    vi_insert: block
    emacs: line
  }
  ls: {
      use_ls_colors: true
      clickable_links: false
  }
  rm: {
      always_trash: true
  }
  table: {
    mode: heavy
    index_mode: always
    show_empty: true
    header_on_separator: true
    padding: { left: 1 right: 1 }
    trim: {
        methodology: wrapping
        wrapping_try_keep_words: true
        truncating_suffix: "..."
    }
  }
  explore: {
      status_bar_background: {fg: "#172526", bg: "#DBD2C7"},
      command_bar_text: {fg: "#DBD2C7"},
      highlight: {fg: "black", bg: "yellow"},
      status: {
          error: {fg: "white", bg: "red"},
          warn: {}
          info: {}
      },
      table: {
          split_line: {fg: "#131F20"},
          selected_cell: {bg: light_blue},
          selected_row: {},
          selected_column: {},
      },
  }
  history: {
      max_size: 100_000
      file_format: "sqlite"
      sync_on_enter: true
      isolation: true
  }
  completions: {
      case_sensitive: false
      quick: true
      partial: true
      algorithm: "fuzzy"
      external: {
          enable: true
          max_results: 20
          completer: null
      },
      use_ls_colors: true
  }
  menus: [
   {
    name: completion_menu
    only_buffer_difference: false
    marker: "󱓇  "
    type: {
      layout: columnar
      columns: 4
      col_width: 20
      col_padding: 2
    }
    style: {
      text: { fg: "#DBD2C7" }
      selected_text: { fg: "#172526" bg: "#88B497" attr: b}
      description_text: { fg: "#e6c384" }
      match_text: { attr: b }
      selected_match_text: { attr: br }
    }
  }
  ]
  keybindings: [
  {
      name: execute_focused_completion
      modifier: none
      keycode: enter
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: menuaccept }
        { send: enter }
      ]
  }
  {
      name: accept_completion_item
      modifier: control
      keycode: char_y
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menuaccept }
  }
  {
    name: clear_current_line
    modifier: control
    keycode: char_u
    mode: [emacs, vi_normal, vi_insert]
    event: { edit: clear }
  }
  {
      name: open_command_editor
      modifier: control
      keycode: char_v
      mode: [vi_normal]
      event: { send: openeditor }
  }
  {
    name: fuzzy_change_directory
    modifier: alt
    keycode: char_c
    mode: [emacs, vi_normal, vi_insert]
    event: { send: executehostcommand, cmd: 'cd (fd -t d -E .git -E node_modules
        | fzf --preview "eza --icons --tree {}")' }
  }
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
     {
       send: ExecuteHostCommand
       cmd: "commandline edit --insert (
         history
           | get command
           | reverse
           | uniq
           | str join (char -i 0)
           | fzf
             --scheme history
             --read0
             --query (commandline)
           | decode utf-8
           | str trim
       )"
     }
    ]
  }
 ]
}

# =============================================================================== #
# Prompt:                                                                         #
# =============================================================================== #
$env.PROMPT_INDICATOR = " $ "
$env.PROMPT_INDICATOR_VI_INSERT = " $ "
$env.PROMPT_INDICATOR_VI_NORMAL = " $ "
$env.PROMPT_MULTILINE_INDICATOR = " $ "
$env.PROMPT_COMMAND_RIGHT = ""

# =============================================================================== #
# Source:                                                                         #
# =============================================================================== #
source ~/Appdata/Local/Temp/zoxide.nu
source ~/Appdata/Local/Temp/carapace.nu
source alias.nu
