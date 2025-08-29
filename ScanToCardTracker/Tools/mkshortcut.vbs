
' mkshortcut.vbs  —  cscript mkshortcut.vbs "C:\path\shortcut.lnk" "C:\path\target.bat" "C:\path\workdir" "Description"
Dim oWS : Set oWS = WScript.CreateObject("WScript.Shell")
Dim args: Set args = WScript.Arguments
If args.Count < 2 Then
  WScript.Echo "Usage: mkshortcut.vbs <lnk> <target> [workdir] [desc]"
  WScript.Quit 1
End If
Dim lnk, tgt, work, desc
lnk = args(0) : tgt = args(1)
If args.Count >= 3 Then work = args(2) Else work = ""
If args.Count >= 4 Then desc = args(3) Else desc = ""
Dim s : Set s = oWS.CreateShortcut(lnk)
s.TargetPath = tgt
If work <> "" Then s.WorkingDirectory = work
If desc <> "" Then s.Description = desc
s.Save
