; -------------------------------------------------------------------------------- ;
;  Core Keeper Auto Fish AutoHotKey script
;  Version: 0.0.3
;  Last Updated: 2022/04/12
;  Author: Tim Martin
; -------------------------------------------------------------------------------- ;

toggle := 0
baitSkill := -1
isOpen := 0
delay := 12400
time := A_TickCount

MsgBox, 0, % "Core Keeper Auto Fish", % "Welcome to Core Keeper Auto Fish`n`nThis program automatically fishes for you in the game Core Keeper so that you can afk fish while away from your computer.`n`nTo use this program stand with a water block next to you, on your RIGHT.`n`nEnsure you are holding a fishing rod (it is advised to have at least 5 other fishing rods in your inventory).`n`nThen press Ctrl + Shift + f and input your ""Improved Bait"" skill level to automatically fish.`n`nYou can press Ctrl + Shift + f to stop automatically fishing at any time."

OK:
If isOpen
    handleSubmit := 1

Loop {
    stage := 0
    While toggle {
        If (isOpen and handleSubmit) {
            Gui, Submit
            delay := Floor(12400 * (1 - (baitSkill * 0.05)))
            handleSubmit := 0
            isOpen := 0
        }

        If WinExist("Core Keeper") {
            If WinActive("Core Keeper") {
                WinGetPos, WinX, WinY, WinW, WinH
                Rx1 := (WinW / 2) - (0.1883 * WinH)
                Ry1 := 0.7713 * WinH
                Rx2 := (WinW / 2) + (0.186 * WinH)
                Ry2 := 0.803 * WinH
                Mx := WinW * 0.8
                My := WinH / 2

                While (baitSkill < 0 and !isOpen) {
                    Gui, New
                    Gui, Add, Text,, Select your "Improved Bait" skill level.
                    Gui, Add, Edit
                    Gui, Add, UpDown, vbaitSkill Range0-5, 0
                    Gui, Add, Button, Default gOK, OK
                    Gui, Show
                    isOpen := 1
                }

                While isOpen
                    continue

                pixelFound := 0
                PixelSearch, Px1, Py1, Rx1, Ry1, Rx2, Ry2, 0xB94D0D, 3, Fast
                If !ErrorLevel
                    pixelFound := 1
                PixelSearch, Px1, Py1, Rx1, Ry1, Rx2, Ry2, 0xFFA700, 3, Fast
                If !ErrorLevel
                    pixelFound := 1

                If !pixelFound {
                    if (stage == 0) {
                        MouseClick, left, Mx, My,,0,D
                        MouseClick, left, Mx, My,,0,U
                        stage := 1
                        time := A_TickCount
                    }
                    
                    if (stage == 1 and A_TickCount > time + 100) {
                        MouseClick, right, Mx, My,,0,D
                        stage := 2
                        time := A_TickCount
                    }

                    if (stage == 2 and A_TickCount > time + 200) {
                        MouseClick, right, Mx, My,,0,U
                        stage := 3
                        time := A_TickCount
                    }

                    if (stage == 3 and A_TickCount > time + delay) {
                        MouseClick, right, Mx, My,,0,D
                        stage := 4
                        time := A_TickCount
                    }

                    if (stage == 4 and A_TickCount > time + 100) {
                        MouseClick, right, Mx, My,,0,U
                        stage := 5
                        time := A_TickCount
                    }

                    if (stage == 5 and A_TickCount > time + 500) {
                        stage := 0
                    }

                    continue
                }

                pixelFound := 0
                PixelSearch, Px2, Py2, Rx1, Ry1, Rx2, Ry2, 0x161CB4, 3, Fast
                If !ErrorLevel
                    pixelFound := 1
                PixelSearch, Px2, Py2, Rx1, Ry1, Rx2, Ry2, 0x2B2AFF, 3, Fast
                If !ErrorLevel
                    pixelFound := 1

                If !pixelFound {
                    MouseClick, right, Mx, My,,0,D
                    continue
                } else {
                    MouseClick, right, Mx, My,,0,U
                    continue
                }
            } else {
                MsgBox, 4, % "Core Keeper Auto Fish - Core Keeper not active", % "You cannot fish if Core Keeper is not the active window.`n`nWould you like to make Core Keeper the active window?"
                IfMsgBox, Yes
                    WinActivate
                else IfMsgBox, No
                    toggle := 0
                continue
            }
        } else {
            MsgBox, 0, % "Core Keeper Auto Fish - Core Keeper not running", % "Core Keeper is not runing.`n`nPlease run Core Keeper before attempting to fish."
            toggle := 0
            continue
        }
    }
}
return

$^+f::toggle := !toggle