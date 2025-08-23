
' ImportVBA.vbs - Imports .bas files into CardTracker.xlsx, saves as .xlsm, reopens, runs AddButtons, saves.
Option Explicit
Dim fso, xl, wb, vbproj, folder, f, xlsPath, xlsmPath
Set fso = CreateObject("Scripting.FileSystemObject")
xlsPath = fso.BuildPath(fso.GetParentFolderName(WScript.ScriptFullName), "..\CardTracker.xlsx")
xlsPath = fso.GetAbsolutePathName(xlsPath)
xlsmPath = Replace(xlsPath, ".xlsx", ".xlsm")

If Not fso.FileExists(xlsPath) Then
  WScript.Echo "CardTracker.xlsx not found at: " & xlsPath
  WScript.Quit 1
End If

Set xl = CreateObject("Excel.Application")
xl.Visible = False
Set wb = xl.Workbooks.Open(xlsPath)
Set vbproj = wb.VBProject

folder = fso.BuildPath(fso.GetParentFolderName(WScript.ScriptFullName), "..\VBA")
For Each f In fso.GetFolder(folder).Files
  If LCase(fso.GetExtensionName(f.Path)) = "bas" Then
    vbproj.VBComponents.Import f.Path
  End If
Next

wb.SaveAs xlsmPath, 52
wb.Close True

Set wb = xl.Workbooks.Open(xlsmPath)
xl.Run "Module_UI.AddButtons"
wb.Save
wb.Close True
xl.Quit
WScript.Echo "Imported VBA, added buttons, and saved: " & xlsmPath
