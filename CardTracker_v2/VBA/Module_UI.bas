
Attribute VB_Name = "Module_UI"
Option Explicit

Public Sub Last7Days()
    Call Module_eBayAPI.LoadSales(7)
End Sub

Public Sub Last30Days()
    Call Module_eBayAPI.LoadSales(30)
End Sub

Public Sub RefreshNow()
    Call Module_eBayAPI.LoadSales(7)
End Sub

Public Sub AddButtons()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Worksheets("Search")
    Call AddThree(ws, "G2")
    On Error Resume Next
    Set ws = ThisWorkbook.Worksheets("Dashboard")
    Call AddThree(ws, "D2")
End Sub

Private Sub AddThree(ws As Worksheet, anchor As String)
    Dim leftPos As Double: leftPos = ws.Range(anchor).Left
    Dim topPos As Double: topPos = ws.Range(anchor).Top
    
    Dim shp As Shape
    For Each shp In ws.Shapes
        If InStr(1, shp.Name, "btn") > 0 Then shp.Delete
    Next shp
    
    Dim b As Shape
    Set b = ws.Shapes.AddShape(msoShapeRoundedRectangle, leftPos, topPos, 120, 28)
    b.Name = "btnLast7_" & ws.Name
    b.TextFrame2.TextRange.Text = "Last 7 Days"
    b.OnAction = "Module_UI.Last7Days"
    
    Set b = ws.Shapes.AddShape(msoShapeRoundedRectangle, leftPos, topPos + 34, 120, 28)
    b.Name = "btnLast30_" & ws.Name
    b.TextFrame2.TextRange.Text = "Last 30 Days"
    b.OnAction = "Module_UI.Last30Days"
    
    Set b = ws.Shapes.AddShape(msoShapeRoundedRectangle, leftPos, topPos + 68, 120, 28)
    b.Name = "btnRefresh_" & ws.Name
    b.TextFrame2.TextRange.Text = "Refresh Now"
    b.OnAction = "Module_UI.RefreshNow"
End Sub
