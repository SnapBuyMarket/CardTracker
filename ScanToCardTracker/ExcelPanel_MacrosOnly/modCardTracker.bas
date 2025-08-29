
Attribute VB_Name = "modCardTracker"
Option Explicit

Public Sub ImportOCRAndMap()
    Dim wb As Workbook, ws As Worksheet, p As String
    Set wb = ThisWorkbook
    p = GetProjectDir() & "\Output\ocr_results.csv"
    On Error Resume Next
    Application.ScreenUpdating = False
    If Dir(p) <> "" Then
        If SheetExists("OCR") Then Application.DisplayAlerts = False: wb.Worksheets("OCR").Delete: Application.DisplayAlerts = True
        Set ws = wb.Worksheets.Add
        ws.Name = "OCR"
        With ws.QueryTables.Add(Connection:="TEXT;" & p, Destination:=ws.Range("A1"))
            .TextFileParseType = xlDelimited
            .TextFileCommaDelimiter = True
            .Refresh BackgroundQuery:=False
        End With
        MsgBox "Imported: " & p, vbInformation
    Else
        MsgBox "Not found: " & p, vbExclamation
    End If
    Application.ScreenUpdating = True
End Sub

Public Sub OpenOutputFolder()
    Dim p As String
    p = GetProjectDir() & "\Output"
    Shell "explorer.exe " & Chr(34) & p & Chr(34), vbNormalFocus
End Sub

Public Sub RunDiagnostics()
    Dim msg As String
    msg = "PROJECT_DIR: " & GetProjectDir() & vbCrLf & _
          "Has Scans\Incoming: " & CStr(FolderExists(GetProjectDir() & "\Scans\Incoming")) & vbCrLf & _
          "Has Output: " & CStr(FolderExists(GetProjectDir() & "\Output"))
    MsgBox msg, vbInformation, "CardTracker Diagnostics"
End Sub

Private Function GetProjectDir() As String
    Dim f As Integer, p As String, line As String
    p = ThisWorkbook.Path
    If Dir(p & "\PROJECT_DIR.env") <> "" Then
        f = FreeFile
        Open p & "\PROJECT_DIR.env" For Input As #f
        Line Input #f, line
        Close #f
        If InStr(1, line, "PROJECT_DIR=", vbTextCompare) = 1 Then
            GetProjectDir = Mid$(line, Len("PROJECT_DIR=") + 1)
            Exit Function
        End If
    End If
    GetProjectDir = Environ$("USERPROFILE") & "\Desktop\CardTracker\ScanToCardTracker"
End Function

Private Function FolderExists(path As String) As Boolean
    On Error Resume Next
    FolderExists = (GetAttr(path) And vbDirectory) = vbDirectory
End Function

Private Function SheetExists(name As String) As Boolean
    Dim ws As Worksheet
    On Error Resume Next
    Set ws = ThisWorkbook.Worksheets(name)
    SheetExists = Not ws Is Nothing
End Function
