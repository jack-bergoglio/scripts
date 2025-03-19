Dim oShell
Set oShell = WScript.CreateObject ("WScript.Shell")
oShell.run "cmd /K CD C:\ & dir Users"
Set oShell = Nothing
