; Reverse mouse wheel scrolling direction

; hs@hss.wiki

#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#MaxHotkeysPerInterval 1000

!#6:: Suspend

WheelUp::WheelDown
WheelDown::WheelUp
