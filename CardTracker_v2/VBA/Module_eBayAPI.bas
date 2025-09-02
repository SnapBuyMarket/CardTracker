
Attribute VB_Name = "Module_eBayAPI"
Option Explicit

' === Config helpers ===
Private Function GetCfg(key As String) As String
    Dim ws As Worksheet, rng As Range
    Set ws = ThisWorkbook.Worksheets("Config")
    Set rng = ws.Range("A:A").Find(What:=key, LookIn:=xlValues, LookAt:=xlWhole)
    If Not rng Is Nothing Then
        GetCfg = CStr(ws.Cells(rng.Row, 2).Value)
    Else
        GetCfg = ""
    End If
End Function

Private Function FirstNonEmpty(ParamArray keys() As Variant) As String
    Dim i As Long, v As String
    For i = LBound(keys) To UBound(keys)
        v = GetCfg(CStr(keys(i)))   ' force to string
        If Len(Trim$(v)) > 0 Then
            FirstNonEmpty = v
            Exit Function
        End If
    Next i
    FirstNonEmpty = ""
End Function

Public Function AppID() As String
    AppID = FirstNonEmpty("eBay_AppID", "EBAY_APP_ID", "APP_ID")
End Function

Public Function EbayToken() As String
    EbayToken = FirstNonEmpty("eBay_UserToken", "EBAY_USER_TOKEN", "USER_TOKEN")
End Function

' === Main entry: loops all TRUE rows on Search sheet ===
Public Sub LoadSales(daysBack As Long)
    Dim ws As Worksheet: Set ws = ThisWorkbook.Worksheets("Search")
    Dim lastR As Long, r As Long
    Dim q As String, listingType As String
    Dim minP As Variant, maxP As Variant
    Dim resp As String

    ' clear old results once
    ThisWorkbook.Worksheets("SalesRaw").Rows("2:100000").ClearContents

    lastR = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    For r = 2 To lastR
        If UCase(CStr(ws.Cells(r, "A").Value)) = "TRUE" Then
            q = CStr(ws.Cells(r, "B").Value)           ' Player / query
            minP = ws.Cells(r, "C").Value              ' Min Price (optional)
            maxP = ws.Cells(r, "D").Value              ' Max Price (optional)
            listingType = CStr(ws.Cells(r, "E").Value) ' Auction / BIN / All

            resp = FetchCompletedItemsFlexible(q, daysBack, minP, maxP, listingType)
            If InStr(1, resp, """item"":") > 0 Then
                ParseSalesJSON resp                     ' appends rows
            End If
        End If
    Next r

    MsgBox "Done loading comps for marked rows."
End Sub

' === API call builder: respects Min/Max and ListingType; no 25/50/100 caps ===
Private Function FetchCompletedItemsFlexible(q As String, daysBack As Long, _
    ByVal minP As Variant, ByVal maxP As Variant, ByVal listingType As String) As String

    On Error GoTo EH
    Dim url As String, idx As Long, fromDate As Date
    fromDate = Now() - daysBack

    url = "https://svcs.ebay.com/services/search/FindingService/v1"
    url = url & "?OPERATION-NAME=findCompletedItems"
    url = url & "&SERVICE-VERSION=1.13.0"
    url = url & "&SECURITY-APPNAME=" & AppID
    url = url & "&RESPONSE-DATA-FORMAT=JSON"
    url = url & "&REST-PAYLOAD"
    url = url & "&keywords=" & VBA.Replace(q, " ", "%20")
    url = url & "&categoryId=212"

    idx = 0
    url = url & "&itemFilter(" & idx & ").name=EndTimeFrom&itemFilter(" & idx & ").value=" & _
          Format(fromDate, "yyyy-mm-dd") & "T00:00:00Z"
    idx = idx + 1

    If Len(Trim$(CStr(minP))) > 0 Then
        url = url & "&itemFilter(" & idx & ").name=MinPrice&itemFilter(" & idx & ").value=" & CStr(minP)
        url = url & "&itemFilter(" & idx & ").paramName=Currency&itemFilter(" & idx & ").paramValue=USD"
        idx = idx + 1
    End If
    If Len(Trim$(CStr(maxP))) > 0 Then
        url = url & "&itemFilter(" & idx & ").name=MaxPrice&itemFilter(" & idx & ").value=" & CStr(maxP)
        url = url & "&itemFilter(" & idx & ").paramName=Currency&itemFilter(" & idx & ").paramValue=USD"
        idx = idx + 1
    End If
    If Len(Trim$(listingType)) > 0 And UCase(listingType) <> "ALL" Then
        url = url & "&itemFilter(" & idx & ").name=ListingType&itemFilter(" & idx & ").value=" & listingType
        idx = idx + 1
    End If

    url = url & "&paginationInput.entriesPerPage=100"
    url = url & "&GLOBAL-ID=EBAY-US"

    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    http.Open "GET", url, False
    http.setRequestHeader "X-EBAY-SOA-SECURITY-APPNAME", AppID
    http.send
    FetchCompletedItemsFlexible = http.responseText
    Exit Function
EH:
    FetchCompletedItemsFlexible = "{""error"":""" & Err.Description & """}"
End Function

' === JSON parse & append to SalesRaw (kept simple) ===
Private Sub ParseSalesJSON(json As String)
    On Error GoTo fallback
    Dim sc As Object, o As Object, items, it, ws As Worksheet
    Dim price, ship As Variant
    Set sc = CreateObject("MSScriptControl.ScriptControl")
    sc.Language = "JScript"
    sc.AddCode "function parse(j){return eval('(' + j + ')');}"
    Set o = sc.Run("parse", json)

    Set ws = ThisWorkbook.Worksheets("SalesRaw")
    Dim i As Long: i = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row + 1

    items = o.findCompletedItemsResponse[0].searchResult[0].item
    If IsEmpty(items) Then Exit Sub

    For Each it In items
        On Error Resume Next
        price = it.sellingStatus[0].currentPrice[0]["__value__"]
        ship  = it.shippingInfo[0].shippingServiceCost[0]["__value__"]

        ws.Cells(i, 1).Value = it.itemId[0]
        ws.Cells(i, 2).Value = it.title[0]
        ws.Cells(i, 3).Value = ""               ' player parse TBD
        ws.Cells(i, 4).Value = it.listingInfo[0].endTime[0]
        ws.Cells(i, 5).Value = price
        ws.Cells(i, 6).Value = IIf(IsEmpty(ship), 0, ship)
        ws.Cells(i, 7).Value = price + IIf(IsEmpty(ship), 0, ship)
        ws.Cells(i, 8).Value = it.viewItemURL[0]
        ws.Cells(i, 9).Value = it.galleryURL[0]
        i = i + 1
        On Error GoTo 0
    Next it
    Exit Sub
fallback:
    MsgBox "Parse failed. Consider enabling ScriptControl or installing a JSON parser.", vbExclamation
End Sub
