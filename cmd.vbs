Dim oShell
Set oShell = WScript.CreateObject ("WScript.Shell")
oShell.run "cmd /K CD C:\ & dir & hostname & ipconfig"
Set oShell = Nothing
