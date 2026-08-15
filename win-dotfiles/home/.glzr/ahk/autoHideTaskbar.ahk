; # =============================================================================== #
; # Toggle Taskbar:                                                                 #
; # =============================================================================== #
^!t:: ToggleTaskbar()
ToggleTaskbar() {
    static ABM_GETSTATE   := 0x00000004
    static ABM_SETSTATE   := 0x0000000A
    static ABS_AUTOHIDE   := 0x00000001
    static ABS_ALWAYSONTOP := 0x00000002

    ; Struct alignment calculations for 32-bit / 64-bit APPBARDATA
    is64         := (A_PtrSize == 8)
    bufSize      := is64 ? 48 : 36
    hWndOffset   := is64 ? 8 : 4
    lParamOffset := is64 ? 40 : 32

    abd := Buffer(bufSize, 0)
    NumPut("UInt", bufSize, abd, 0)

    DetectHiddenWindows(true)
    if (tbHwnd := WinExist("ahk_class Shell_TrayWnd"))
        NumPut("Ptr", tbHwnd, abd, hWndOffset)

    ; Freeze screen updates during DWM recalculation to eliminate redraw lag
    hwndDesktop := DllCall("user32\GetDesktopWindow", "Ptr")
    DllCall("user32\LockWindowUpdate", "Ptr", hwndDesktop)

    ; Query and toggle taskbar auto-hide state
    currentState := DllCall("Shell32\SHAppBarMessage", "UInt", ABM_GETSTATE, "Ptr", abd, "UInt")
    newState     := (currentState & ABS_AUTOHIDE) ? ABS_ALWAYSONTOP : ABS_AUTOHIDE

    NumPut("Ptr", newState, abd, lParamOffset)
    DllCall("Shell32\SHAppBarMessage", "UInt", ABM_SETSTATE, "Ptr", abd)

    ; Allow DWM layout to settle before releasing screen lock
    Sleep(40)
    DllCall("user32\LockWindowUpdate", "Ptr", 0)
}
