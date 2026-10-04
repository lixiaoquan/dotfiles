#Requires AutoHotkey v2.0
#SingleInstance Force
#Include TrayIcon.ahk

RunDisplaySwitch(args)
{
    displaySwitch := A_WinDir "\Sysnative\DisplaySwitch.exe"
    if !FileExist(displaySwitch)
        displaySwitch := A_WinDir "\System32\DisplaySwitch.exe"

    Run('"' displaySwitch '" ' args)
}

^!s:: {
    ; Get tray icon information
    oIcons := TrayIcon_GetInfo("SecureConnect.exe")
    if (oIcons.Length < 1) {
        MsgBox("Tray icon for SecureConnect.exe not found")
        return
    }

    TrayIcon_Button("SecureConnect.exe", "R")
}

^!w:: {
    ; Get tray icon information
    oIcons := TrayIcon_GetInfo("SecureConnect.exe")
    if (oIcons.Length < 1) {
        MsgBox("Tray icon for SecureConnect.exe not found")
        return
    }

    TrayIcon_Button("SecureConnect.exe", "L")
}

^!h:: {
    ; System sleep
    DllCall("PowrProf.dll\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
}

^!m:: {
    ; Open MonoCloud_V1.3.8.exe
    oIcons := TrayIcon_GetInfo("MonoCloud_V1.3.8.exe")
    if (oIcons.Length < 1) {
        MsgBox("Tray icon for MonoCloud_V1.3.8.exe not found")
        return
    }

    TrayIcon_Button("MonoCloud_V1.3.8.exe", "L")
}

^!r:: {
    ; Set right button as primary
    DllCall("SystemParametersInfo", "UInt", 0x21, "UInt", 1, "Ptr", 0, "UInt", 0x03)
}

^!l:: {
    ; Set left button as primary
    DllCall("SystemParametersInfo", "UInt", 0x21, "UInt", 0, "Ptr", 0, "UInt", 0x03)
}

^!e:: {
    ; Extend displays
    RunDisplaySwitch("/extend")
}

^!2:: {
    ; Show only on display 2
    RunDisplaySwitch("/external")
}
