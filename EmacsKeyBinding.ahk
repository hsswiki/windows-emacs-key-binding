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

; =============================================================================
;   Quick AHK controls: Alt + Win + 1~4
; =============================================================================

/* Note that Alt + Win + 5 to hibernate, 6 to sleep, 7 to shut down. See "power
actions" for detail.
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
    else
        return
    return

; =============================================================================
;   Prepare CapsLock to use as a modifier key
; =============================================================================

; Disables CapsLock to avoid mis-touch
CapsLock:: Ctrl

/*
CapsLock + any modifier key (Ctrl/Shift/Alt) to toggle CapsLock state.

`^CapsLock:: CapsLock` won't work here since `CapsLock & <key>` hot keys are
present. That also prevents CapsLock from acting as Ctrl, though we specified
`CapsLock:: Ctrl` above.

Note that the Ctrl key is never remapped. Thus, we can use it as normal for
Control-click, Ctrl-Shift-Esc, etc.

The solution here https://www.autohotkey.com/docs/KeyList.htm#IME doesn't work.
*/

; #############################################################################
;   Emacs text edit commands
; #############################################################################

; =============================================================================
;   Cursor movement
; =============================================================================

CapsLock & f:: sendInput, {Right}
CapsLock & b:: sendInput, {Left}
CapsLock & e:: sendInput, {End}
CapsLock & a:: sendInput, {Home}
CapsLock & p:: sendInput, {Up}
CapsLock & n:: sendInput, {Down}

Alt & f:: sendInput, {Ctrl down}{Right}{Ctrl up}
Alt & b:: sendInput, {Ctrl down}{Left}{Ctrl up}

CapsLock & j:: sendInput, {Return}

; =============================================================================
;   Deletion
; =============================================================================

CapsLock & h:: sendInput, {Backspace}
CapsLock & d:: sendInput, {Delete}

CapsLock & w:: sendInput, {Ctrl down}{Backspace}{Ctrl up}
Alt & d:: sendInput, {Ctrl down}{Delete}{Ctrl up}

CapsLock & k:: sendInput, {Shift down}{End}{Shift up}{Delete}
CapsLock & u:: sendInput, {Shift down}{Home}{Shift up}{Delete}

; #############################################################################
;   Input method
; #############################################################################

; Cycling Kana in Japanese IME on Windows
LWin & Space:: vk1D  ; Muhennkann key on JP keyboards
    ; Ref: https://answers.microsoft.com/en-us/windows/forum/windows_10-other_settings/keyboard-shortcuts-changed-in-japanese-microsoft/49dbf61d-b367-4685-938b-6081465495ef?page=2

; Cycle through languages like Mac
Alt & Space:: sendInput, {Alt down}{Shift down}{Shift up}{Alt up}
    ; Don't know why setting "Ctrl + Shift" in Win and mock it here won't work.

; #############################################################################
;   Replace Ctrl with Alt for common hot keys
; #############################################################################

; Since Ctrl is hard to reach as a modifier key.

Alt & c:: sendInput, {Ctrl down}c{Ctrl up}  ; Also to terminate terminal thread
Alt & x:: sendInput, {Ctrl down}x{Ctrl up}
Alt & v:: sendInput, {Ctrl down}v{Ctrl up}

Alt & a:: sendInput, {Ctrl down}a{Ctrl up}
Alt & z:: sendInput, {Ctrl down}z{Ctrl up}

Alt & t:: sendInput, {Ctrl down}t{Ctrl up}
Alt & s:: sendInput, {Ctrl down}s{Ctrl up}
Alt & w:: sendInput, {Ctrl down}w{Ctrl up}
Alt & q:: sendInput, {Alt down}{F4}{Alt up}

; =============================================================================
;   Use Win instead of Alt if f/b/p/n is involved
; =============================================================================

LWin & f:: sendInput, {Ctrl down}f{Ctrl up}  ; Find
LWin & p:: sendInput, {Ctrl down}p{Ctrl up}  ; Print
LWin & n:: sendInput, {Ctrl down}n{Ctrl up}  ; New

; #############################################################################
;   Reflecting Mac shortcuts
; #############################################################################

; =============================================================================
;   Mac system shortcuts
; =============================================================================

;   Media control: Alt + Functional numeric keys
; -----------------------------------------------------------------------------

Alt & F7:: Send {Media_Prev}
Alt & F8:: Send {Media_Play_Pause}
Alt & F9:: Send {Media_Next}

Alt & F10:: Send {Volume_Mute}  ; Mnemonic: 0
Alt & F11:: Send {Volume_Down}  ; -
Alt & F12:: Send {Volume_Up}  ; +

;   Other Mac system shortcuts
; -----------------------------------------------------------------------------

; Switch virtual desktops
CapsLock & Right:: sendInput, {Ctrl down}{LWin down}{Right}{LWin up}{Ctrl up}
CapsLock & Left:: sendInput, {Ctrl down}{LWin down}{Left}{LWin up}{Ctrl up}
CapsLock & Up:: sendInput, {LWin down}{Tab}{LWin up}

; Switch virtual desktops using only left hand
LWin & s:: sendInput, {Ctrl down}{LWin down}{Right}{LWin up}{Ctrl up}
LWin & a:: sendInput, {Ctrl down}{LWin down}{Left}{LWin up}{Ctrl up}
LWin & w:: sendInput, {LWin down}{Tab}{LWin up}

; Open file
LWin & o:: sendInput, {Enter}

; Delete file
; Alt & Backspace:: sendInput, {Delete}  ; Doesn't work for unknown reason.

; Spotlight search
CapsLock & Space:: sendInput, {RWin}

; =============================================================================
;   Mac software shortcuts
; =============================================================================

;   Safari
; -----------------------------------------------------------------------------

; Focus on address bar
LWin & ,:: sendInput, {Ctrl down}l{Ctrl up}

;   Jupyter notebook
; -----------------------------------------------------------------------------

CapsLock & Enter:: sendInput, {Ctrl down}{Enter}{Ctrl up}
CapsLock & _:: sendInput, {Ctrl down}_{Ctrl up}

; #############################################################################
;   Windows system shortcuts
; #############################################################################

; =============================================================================
;   Power actions
; =============================================================================

; Alt + Win + 5 to hibernate / 6 to sleep / 7 to shutdown

!#5::
    Msgbox, 1, AHK Confirmation, Hibernate? (^.−)☆
    IfMsgBox Ok
        DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
    else
        return
    return

!#6:: DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)

!#7::
    Msgbox, 1, AHK Confirmation, Shut down? _(:3」∠)_
    IfMsgBox Ok
        Shutdown, 9
    else
        return
    return

; =============================================================================
;   Other Windows system shortcuts
; =============================================================================

; Override Windows File Explorer starting directory

LWin & e:: Run, "S:\OneDrive"

; #############################################################################
;   Notes and references
; #############################################################################

/*
; =============================================================================
;   Useful documentation
; =============================================================================

- [List of keys](https://www.autohotkey.com/docs/KeyList.htm)

; =============================================================================
;   Special modifiers explained
; =============================================================================

`{Blind}`: Preserve modifier key status to output
    Ref: https://www.autohotkey.com/docs/commands/Send.htm#Blind

`$`: "direct in," to avoid hot key to recursively call itself.
    Ref: https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

`~`: "direct out," to not only trigger hot key but also present raw inputs.
    Ref: https://www.autohotkey.com/docs/Hotkeys.htm#Symbols

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
        ; Simple `sendInput, {CapsLock}` won't turn off.
    else
        sendInput, {Ctrl down}{Shift down}{1}{Shift up}{Ctrl up}
    return

*/