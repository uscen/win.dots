# =============================================================================== #
# General:                                                                        #
# =============================================================================== #
$env.config.show_banner = false
$env.config.bracketed_paste = true

# =============================================================================== #
# Table:                                                                          #
# =============================================================================== #
$env.config.table.mode = 'heavy'
$env.config.table.header_on_separator = true
$env.config.table.missing_value_symbol = '×'
$env.config.table.trim = { methodology: "truncating", truncating_suffix: "…" }

# =============================================================================== #
# Datetime:                                                                       #
# =============================================================================== #
$env.config.datetime_format.table = "%Y-%m-%d %H:%M:%S"
$env.config.datetime_format.normal = "%Y-%m-%d %H:%M:%S"

# =============================================================================== #
# Completions:                                                                    #
# =============================================================================== #
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.case_sensitive = false
$env.config.completions.external.max_results = 20

# =============================================================================== #
# History:                                                                        #
# =============================================================================== #
$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true

# =============================================================================== #
# Vim:                                                                            #
# =============================================================================== #
$env.config.edit_mode = 'vi'
$env.config.cursor_shape.vi_insert = 'block'
$env.config.cursor_shape.vi_normal = 'block'

# =============================================================================== #
# Prompt:                                                                         #
# =============================================================================== #
$env.PROMPT_INDICATOR = " $ "
$env.PROMPT_INDICATOR_VI_INSERT = " $ "
$env.PROMPT_INDICATOR_VI_NORMAL = " $ "
$env.PROMPT_MULTILINE_INDICATOR = " $ "
$env.PROMPT_COMMAND_RIGHT = ""

# =============================================================================== #
# Menu:                                                                           #
# =============================================================================== #
$env.config.menus ++= [{
  name: completion_menu
  only_buffer_difference: false
  marker: "| "
  type: {
    layout: ide
    cursor_offset: -10000
    description_mode: 'right'
    description_offset: 0
    max_completion_height: 20
    border: {
      top_left: '╔',
      top_right: '╗',
      bottom_left: '╚',
      bottom_right: '╝',
      horizontal: '═',
      vertical: '║',
    }
  }
  style: { text: 'green', selected_text: { attr: 'r' }, description_text: 'purple' }
}]

# =============================================================================== #
# Keybindings:                                                                    #
# =============================================================================== #
$env.config.keybindings ++= [
  {
    name: clear_line
    modifier: control
    keycode: char_u
    mode: vi_insert
    event: { edit: CutFromStart }
  },
  {
    name: history_hint_complete
    modifier: control
    keycode: char_f
    mode: vi_insert
    event: { send: HistoryHintComplete }
  },
  {
    name: history_hint_word_complete
    modifier: alt
    keycode: char_f
    mode: vi_insert
    event: { send: HistoryHintWordComplete }
  },
  {
      name: execute_focused_completion
      modifier: none
      keycode: enter
      mode: [emacs, vi_normal, vi_insert]
      event: [
        { send: menuaccept }
        { send: enter }
      ]
  },
  {
      name: accept_completion_item
      modifier: control
      keycode: char_y
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menuaccept }
  },
  {
    name: fuzzy_change_directory
    modifier: alt
    keycode: char_c
    mode: [emacs, vi_normal, vi_insert]
    event: { send: executehostcommand, cmd: 'cd (fd -t d -E .git -E node_modules
        | fzf --preview "eza --color=always --icons --tree {}")' }
  },
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

# =============================================================================== #
# Source:                                                                         #
# =============================================================================== #
source ~/Appdata/Local/Temp/zoxide.nu
source ~/Appdata/Local/Temp/carapace.nu
source alias.nu
