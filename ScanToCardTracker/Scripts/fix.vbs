Set shell = CreateObject("WScript.Shell")
folderPath = "C:\Users\cwall\Desktop\CardTracker"
subfolderPath = "C:\Users\cwall\Desktop\CardTracker\ScanToCardTracker"
shell.Run "cmd /c icacls """ & folderPath & """ /grant:r cwall:F /t", 1, True
shell.Run "cmd /c icacls """ & subfolderPath & """ /grant:r cwall:F /t", 1, True
shell.Run "cmd /c attrib """ & subfolderPath & "\*"" /s /d", 1, True
shell.Run "cmd /c icacls """ & subfolderPath & "\*"" /t", 1, True
WScript.Echo "Done. Check folder properties."