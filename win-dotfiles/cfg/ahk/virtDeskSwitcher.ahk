; # =============================================================================== #
; # Switch VDS:                                                                     #
; # =============================================================================== #
; https://www.computerhope.com/tips/tip224.htm
; https://github.com/pmb6tz/windows-desktop-switcher
; https://github.com/keychain2db/virtual-desktop-switcher/blob/main/VDS.ahk
; # =============================================================================== #
; # =============================================================================== #
; # Global variables:                                                               #
; # =============================================================================== #
global DesktopCount := 1
global CurrentDesktop := 1
global wrapAroundEnabled := true
global pingPongDirection := false ; Right 0, Left 1 (Non-editable)
; # =============================================================================== #
; # Global variables:                                                               #
; # =============================================================================== #
mapDesktopsFromRegistry() {
    global DesktopCount, CurrentDesktop

    desktopListHex := ""
    currentDesktopHex := ""

    try {
        desktopListHex := RegRead(
            "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops",
            "VirtualDesktopIDs",
            "REG_BINARY"
        )

        currentDesktopHex := RegRead(
            "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops",
            "CurrentVirtualDesktop",
            "REG_BINARY"
        )
    } catch {
        DesktopCount := 1
        CurrentDesktop := 1
        return
    }

    desktopListBuf := hexToBuffer(desktopListHex)
    currentDesktopBuf := hexToBuffer(currentDesktopHex)

    DesktopCount := desktopListBuf.Size // 16
    if (DesktopCount < 1)
        DesktopCount := 1

    CurrentDesktop := 1
    loop DesktopCount {
        startPos := (A_Index - 1) * 16
        desktopID := Buffer(16)
        DllCall("RtlMoveMemory",
            "Ptr", desktopID.Ptr,
            "Ptr", desktopListBuf.Ptr + startPos,
            "UInt", 16
        )

        if (bufferCompare(desktopID, currentDesktopBuf)) {
            CurrentDesktop := A_Index
            break
        }
    }
}

hexToBuffer(hex) {
    ; Remove all non-hex characters (0-9, A-F, a-f)
    hex := RegExReplace(hex, "[^0-9A-Fa-f]", "")

    ; Ensure even length (pad with leading 0 if needed)
    if (Mod(StrLen(hex), 2) != 0)
        hex := "0" hex

    bufSize := StrLen(hex) // 2
    buf := Buffer(bufSize)

    loop bufSize {
        hexByte := SubStr(hex, 2*A_Index - 1, 2)
        byte := "0x" hexByte  ; Force hex interpretation
        NumPut("UChar", byte + 0, buf, A_Index - 1)  ; +0 ensures numeric conversion
    }

    return buf
}

bufferCompare(buf1, buf2, size := -1) {
    if (size == -1) {
        if (buf1.Size != buf2.Size)
            return false
        size := buf1.Size
    }

    loop size {
        if (NumGet(buf1, A_Index-1, "UChar") != NumGet(buf2, A_Index-1, "UChar"))
            return false
    }
    return true
}

createNewDesktop() {
    SendInput("^#d")
    Sleep(500)
    mapDesktopsFromRegistry() ;
}

switchDesktopByNumber(targetDesktop) {
    global DesktopCount, CurrentDesktop
    mapDesktopsFromRegistry()
    if (targetDesktop > DesktopCount) {
        while (DesktopCount < targetDesktop) {
            createNewDesktop()
        }
    }
    if (targetDesktop < 1 || targetDesktop > DesktopCount)
        return

    difference := targetDesktop - CurrentDesktop
    if (difference = 0)
        return

    key := difference > 0 ? "{Right}" : "{Left}"
    pressCount := Abs(difference)

    SendInput("{LCtrl down}{LWin down}")
    Loop pressCount {
        SendInput(key)
        Sleep(15)
    }
    SendInput("{LCtrl up}{LWin up}")

    Sleep(15)
    mapDesktopsFromRegistry()
}

#!Tab:: {
    global wrapAroundEnabled, pingPongDirection, DesktopCount, CurrentDesktop
    mapDesktopsFromRegistry()

    if (wrapAroundEnabled) {
        target := CurrentDesktop < DesktopCount ? CurrentDesktop + 1 : 1
        switchDesktopByNumber(target)
    } else {
        oldDesktop := CurrentDesktop

        if (!pingPongDirection) {
            target := CurrentDesktop < DesktopCount ? CurrentDesktop + 1 : CurrentDesktop - 1
        } else {
            target := CurrentDesktop > 1 ? CurrentDesktop - 1 : CurrentDesktop + 1
        }

        switchDesktopByNumber(target)

        Sleep(30)
        mapDesktopsFromRegistry()
        if (CurrentDesktop > oldDesktop) {
            pingPongDirection := false
        } else if (CurrentDesktop < oldDesktop) {
            pingPongDirection := true
        }
    }
}
; # =============================================================================== #
; # Toggle mode with Win+Ctrl+Tab:                                                  #
; # =============================================================================== #
#^Tab:: {
    global wrapAroundEnabled
    wrapAroundEnabled := !wrapAroundEnabled
    Tooltip("Mode: " (wrapAroundEnabled ? "Wrap-around" : "Ping-pong"))
    SetTimer(() => Tooltip(), -1000)
}

loop 9 {
    num := A_Index
    Hotkey("#" num, switchToDesktop.Bind(num))
}

switchToDesktop(num, *) {
    SetKeyDelay(50, 100)
    switchDesktopByNumber(num)
}
; # =============================================================================== #
; # Initialization:                                                                 #
; # =============================================================================== #
mapDesktopsFromRegistry()
