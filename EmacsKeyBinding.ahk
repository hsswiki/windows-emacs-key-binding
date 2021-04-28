/*
Use Emacs and Mac-like Key Bindings on Windows PC

hss.wiki

Since the text edit shortcuts on Emacs (and Mac) are very handy, this script
brings some of them to PC. For example, C-p/n/b/f to move the cursor
up/down/left/right. (C stands for Ctrl on Emacs, but it would be easier to use
if Ctrl is in CapsLock's place. Thus, CapsLock is used as the modifier key in
this script. Afterall, Ctrl and CapsLock can be easily swapped in Mac under
System Preferences, but it is not the case for Windows.)

It is also aimed to bridge the gap between Mac and Windows system shortcuts in
order to unify the user experience. For instance, media control and switching
virtual desktops.

This script is implemented in AutoHotKey for the traditional (QWERTY) keyboard
layout.

An executable (EXE) file, which can run independently (even if AHK is not
installed), can be compiled from this script by using the shortcut Win & 3
(defined below), though the compilation needs AHK to be installed. Or you can
compile it manually, by right-clicking the script and select "Compile Script."
Wait for a second, and an EXE file will appear under the same directory.

Coding notes:

- Multi-line comment's `*/` must start a new line
- Single line comment starts with a semicolon
- Letter case doesn't matter
- Hotkey prefix symbols: ^ for Ctrl, ! for Alt, + for Shift, # for Win
*/

; #############################################################################
;   Init settings
; #############################################################################

#SingleInstance Force
#Warn  ; Enable warnings to assist with detecting common errors.
#NoEnv  ; Recommended for performance and forward compatibility.
SendMode Input  ; Recommended for superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetCapsLockState, AlwaysOff

; =============================================================================
;   Quick AHK controls: Alt + Win + 1~4
; =============================================================================

/* Note that use Alt + Win + 5 to hibernate, 6 to sleep, 7 to shut down. See
"power actions" for detail.
*/

!#1:: Suspend  ; Useful when gaming
/* In AHK, "suspend" means temporarily disable the software (and the
shortcuts), while "pause" means hold some looping action. Select "Pause Script"
from the context menu don't really disable the shortcuts.
*/

!#2:: Reload  ; Useful when the software stuck

; Recompile itself into EXE. Will replace existing file sharing the same name.
!#3:: Run,
(
    "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
    /in "EmacsKeyBinding.ahk" /icon "emacs_icon.ico"
)  ; `()` for line break works only when placed at the beginning of lines.

; Exit AHK
!#4::
    Msgbox, 1, AHK Confirmation, Exit AHK? ???∑(ﾟДﾟノ)ノ
    IfMsgBox Ok
        Exitapp
    Return

; =============================================================================
;   Prepare CapsLock to use as a modifier key
; =============================================================================

; Disables CapsLock to avoid mis-touch
; CapsLock:: Ctrl TODO

CapsLock & Esc::
    If GetKeyState("CapsLock", "T")
        SetCapsLockState, AlwaysOff
    Else
        SetCapsLockState, On
    Return

/*
CapsLock + any modifier key to toggle CapsLock state. Don't know why. Even
`*CapsLock::` won't change its behavior.

`^CapsLock:: CapsLock` won't work here since `CapsLock & <key>` hot keys are
present. That also prevents CapsLock from acting as Ctrl, though we specified
`CapsLock:: Ctrl` above.

Note that the Ctrl key is never remapped. Thus, we can use it as normal for
Control-click, Ctrl-Shift-Esc, etc.

The solution here https://www.autohotkey.com/docs/KeyList.htm#IME doesn't work.
*/

AppsKey:: Ctrl

; #############################################################################
;   Emacs text edit commands
; #############################################################################

; =============================================================================
;   Cursor movement
; =============================================================================

; {Blind} in order to keep Shift pressed for selection if applicable.
CapsLock & f:: sendInput {Blind}{Right}
CapsLock & b:: sendInput {Blind}{Left}
CapsLock & e:: sendInput {Blind}{End}
CapsLock & a:: sendInput {Blind}{Home}
CapsLock & p:: sendInput {Blind}{Up}
CapsLock & n:: sendInput {Blind}{Down}

Alt & f::
    If GetKeyState("Shift")
        SendInput {Shift Down}{Ctrl Down}{Right}{Ctrl Up}{Shift Up}
    Else
        sendInput {Ctrl down}{Right}{Ctrl up}
    Return

Alt & b::
    If GetKeyState("Shift")
        SendInput {Shift Down}{Ctrl Down}{Left}{Ctrl Up}{Shift Up}
    Else
        sendInput {Ctrl down}{Left}{Ctrl up}
    Return

CapsLock & j:: sendInput {Return}

; =============================================================================
;   Deletion
; =============================================================================

CapsLock & h:: sendInput {Backspace}
CapsLock & d:: sendInput {Delete}

CapsLock & w:: sendInput {Ctrl down}{Backspace}{Ctrl up}
Alt & d:: sendInput {Ctrl down}{Delete}{Ctrl up}

CapsLock & k:: sendInput {Shift down}{End}{Shift up}{Delete}
CapsLock & u:: sendInput {Shift down}{Home}{Shift up}{Delete}

; #############################################################################
;   Input method
; #############################################################################

; Cycling Kana in Japanese IME on Windows
LWin & Space:: vk1D  ; Muhennkann key on JP keyboards
    ; Ref: https://answers.microsoft.com/en-us/windows/forum/windows_10-other_settings/keyboard-shortcuts-changed-in-japanese-microsoft/49dbf61d-b367-4685-938b-6081465495ef?page=2

; Cycle through languages like Mac
Alt & Space:: sendInput {Alt down}{Shift down}{Shift up}{Alt up}
    ; Don't know why setting "Ctrl + Shift" in Win and mock it here won't work.

; #############################################################################
;   Replace Ctrl with Alt for common hot keys
; #############################################################################

; Since Ctrl is hard to reach as a modifier key.

Alt & c:: sendInput {Ctrl down}c{Ctrl up}  ; Also to terminate terminal thread
Alt & x:: sendInput {Ctrl down}x{Ctrl up}
Alt & v:: sendInput {Ctrl down}v{Ctrl up}

Alt & a:: sendInput {Ctrl down}a{Ctrl up}
Alt & z:: sendInput {Ctrl down}z{Ctrl up}

Alt & t:: sendInput {Ctrl down}t{Ctrl up}
Alt & s:: sendInput {Ctrl down}s{Ctrl up}
Alt & w:: sendInput {Ctrl down}w{Ctrl up}
Alt & q:: sendInput {Alt down}{F4}{Alt up}

; =============================================================================
;   Use Win instead of Alt if f/b/p/n is involved
; =============================================================================

LWin & f:: sendInput {Ctrl down}f{Ctrl up}  ; Find
LWin & p:: sendInput {Ctrl down}p{Ctrl up}  ; Print
LWin & n:: sendInput {Ctrl down}n{Ctrl up}  ; New

; #############################################################################
;   Reflecting Mac shortcuts
; #############################################################################

; =============================================================================
;   Mac system shortcuts
; =============================================================================

;   Media control: Alt + Functional numeric keys
; -----------------------------------------------------------------------------

^!7:: SendInput {Media_Prev}
^!8:: SendInput {Media_Play_Pause}
^!9:: SendInput {Media_Next}

^!0:: SendInput {Volume_Mute}  ; Mnemonic: 0
^!-:: SendInput {Volume_Down}  ; -
^!=:: SendInput {Volume_Up}    ; +

;   Other Mac system shortcuts
; -----------------------------------------------------------------------------

; Switch virtual desktops
CapsLock & Right:: sendInput {Ctrl down}{LWin down}{Right}{LWin up}{Ctrl up}
CapsLock & Left:: sendInput {Ctrl down}{LWin down}{Left}{LWin up}{Ctrl up}
CapsLock & Up:: sendInput {LWin down}{Tab}{LWin up}

; Open file
LWin & o:: sendInput {Enter}

; Delete file
; Alt & Backspace:: sendInput {Delete}  ; Doesn't work for unknown reason.

; Spotlight search
CapsLock & Space:: sendInput {RWin}

; =============================================================================
;   Mac software shortcuts
; =============================================================================

;   Safari
; -----------------------------------------------------------------------------

; Focus on address bar
LWin & ,:: sendInput {Ctrl down}l{Ctrl up}

; #############################################################################
;   Software-specific shortcuts
; #############################################################################

; =============================================================================
;   Jupyter notebook
; =============================================================================

CapsLock & Enter:: sendInput {Ctrl down}{Enter}{Ctrl up}  ; Run cell
CapsLock & /:: sendInput {Ctrl down}/{Ctrl up}  ; Comment out
CapsLock & _:: sendInput {Ctrl down}_{Ctrl up}

; =============================================================================
;   Shell reverse search
; =============================================================================

CapsLock & r:: sendInput {Ctrl down}{r}{Ctrl up}

; #############################################################################
;   Mini Console
; #############################################################################

Alt & Esc::
    Loop {  ; Back to the console if command not found.

        InputBox, input_str, Mini Console, , , 150, 100

        If ErrorLevel = 1  ; Cancel/Esc was pressed from the input box.
            Break

        arg_arr := StrSplit(input_str, A_Space)  ; Array index starts from 1.
        cmd_str := arg_arr[1]

; =============================================================================
;   Utility
; =============================================================================

        ; Repetition. E.g. `rep = 77` will repeat the = key 77 times.
        If (cmd_str = "rep") {
            ; Must use `If () {}` instead of simple `If` since there are
            ;   multiple statements in the clause. Otherwise error.
            key_str := arg_arr[2]
            n_rep_str := arg_arr[3]
            SendInput % "{" key_str " " n_rep_str "}"
            Break
        }

        ; Maximize window to all extended displays. E.g. `max`
        ; Ref: https://stackoverflow.com/a/9830200
        If (cmd_str = "max") {
            WinGetActiveTitle, Title
            WinRestore, %Title%
            SysGet, X1, 76
            SysGet, Y1, 77
            SysGet, Width, 78
            SysGet, Height, 79
            WinMove, %Title%,, X1, Y1, Width, Height
            Break
        }

; =============================================================================
;   Power action
; =============================================================================

        ; Sleep. E.g. `sle`
        If (cmd_str = "sle") {
            DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
            Break
        }

        ; Hibernate. E.g. `hib`
        If (cmd_str = "hib") {
            DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
            Break
        }

        ; Shut down. E.g. `shu`
        If (cmd_str = "shu") {
            Shutdown, 9
            Break
        }

; =============================================================================
;   If command not found
; =============================================================================

        MsgBox, ``%input_str%``: command not found.
            ; ` is the escape character.
    }
    Return

; #############################################################################
;   Notes and references
; #############################################################################

/*
; =============================================================================
;   TODO
; =============================================================================

- 2021-04-28: Clean up the script.

The following snippet can use CapsLock as Ctrl. Add conditional clauses in the
loop to implement cursor movement etc. functionalities?

$CapsLock::
    while, GetKeyState("CapsLock","P")
        SendInput {Ctrl down}

            if GetKeyState("b", "P")
                SendInput {Ctrl up}
                MsgBox, 1.
                SendInput {Left}

    SendInput {Ctrl up}
return

SetCapsLockState, AlwaysOff

- Ref
  - https://www.autohotkey.com/boards/viewtopic.php?f=5&t=37002&p=170261#p170261
  - https://superuser.com/questions/515808/caplock-remapping-to-modifier-keys-fails-on-keyboard-repeat

- Goal:
  - CapsLock works as Ctrl. Hold to select multiple / open in new tab.
  - CapsLock - b to use as arrow key, etc.
    - Shift - CapsLock - b to continue selection
    - Combine with number key to repeat cursor movement multiple times.
      E.g. {Left 10}
  - CapsLock won't be turn on with Alt - CapsLock etc.


; =============================================================================
;   Useful documentation
; =============================================================================

- [List of keys](https://www.autohotkey.com/docs/KeyList.htm)

; =============================================================================
;   Special modifiers explained
; =============================================================================

- `{Blind}`: Preserve modifier key status to output
    - Ref: https://www.autohotkey.com/docs/commands/Send.htm#Blind

- Symbols ref: https://www.autohotkey.com/docs/Hotkeys.htm#Symbols
    - `$`: "direct in," to avoid hot key to recursively call itself.
    - `~`: "direct out," to not only trigger hot key but also present raw inputs.
    - `*`: Modifier key wildcard.

; =============================================================================
;   Be careful with remapping
; =============================================================================

A remapping like `Alt & c::...` will also consume other hot keys such as
Shift + Alt + c or Ctrl + Alt + c, since they are forced to fire prematurely.

; =============================================================================
;   Snippets
; =============================================================================

;   Long/short press
; -----------------------------------------------------------------------------

; Long press LCtrl as CapsLock, short press to change to English.
LCtrl::
    KeyWait, %A_ThisHotKey%
    if A_TimeSinceThisHotkey >= 200  ; milliseconds
        SetCapsLockState % !GetKeyState("CapsLock", "T")
        ; Simple `sendInput {CapsLock}` won't turn off.
    else
        sendInput {Ctrl down}{Shift down}{1}{Shift up}{Ctrl up}
    return

*/