
Attribute VB_Name = "ThisWorkbook"
Option Explicit

Private Sub Workbook_Open()
    On Error Resume Next
    Call Module_UI.AddButtons
    Call Module_Scheduler.StartHourlyRefresh
End Sub
