
Attribute VB_Name = "Module_Scheduler"
Option Explicit

Public Sub StartHourlyRefresh()
    On Error Resume Next
    Application.OnTime EarliestTime:=Now + TimeSerial(1, 0, 0), _
                      Procedure:="Module_Scheduler.RunRefresh", _
                      Schedule:=True
End Sub

Public Sub RunRefresh()
    On Error Resume Next
    If UCase(ThisWorkbook.Worksheets("Config").Range("B7").Value) = "TRUE" Then
        Call Module_UI.RefreshNow
    End If
    Call StartHourlyRefresh
End Sub

Public Sub StopHourlyRefresh()
    On Error Resume Next
    Application.OnTime EarliestTime:=Now + TimeSerial(1, 0, 0), _
                      Procedure:="Module_Scheduler.RunRefresh", _
                      Schedule:=False
End Sub
