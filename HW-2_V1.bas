Attribute VB_Name = "Module1"

Sub HW2E()


    
'With ActiveSheet

Dim ws As Worksheet
Dim Year As String
Dim TotalVolume As Double
Dim LastRow As Double
Dim PercentChange As Double
Dim RowPrintCounter As Double
Dim Text As Integer

'For Each ws In Worksheets

'With ws

For Each ws In ThisWorkbook.Sheets
 
       ws.Activate
       

    LastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    MsgBox (LastRow)
    'End With
'LastRow = 272


TSymbol = ""
TSymbolVolume = 0
TotalVolume = 0
RowPrintCounter = 2


'For Each ActiveWorkbook.Worksheets("Sheet1")
'LastRow = ActiveWorkbook.Worksheets("Sheet1").Range("A2", Worksheets("Sheet1").Range("A2").End(xlDown)).Rows.Count
'LastRow = Activeworksheet.Cells(Worksheets.Rows.Count, 1).End(xlUp).Row

For i = 2 To LastRow

    
    If Cells(i + 1, 1).Value = Cells(i, 1).Value Then
    
        TotalVolume = TotalVolume + Cells(i + 1, 7)
        
    Else
        'Text = i + RowPrintCounter
        'MsgBox (Text)
        
        ws.Cells(RowPrintCounter, 10).Value = Cells(i, 1).Value
        ws.Cells(RowPrintCounter, 11).Value = Left(Cells(i, 2).Value, 4)
        ws.Cells(RowPrintCounter, 12).Value = TotalVolume
        'MsgBox (TotalVolume)
        RowPrintCounter = RowPrintCounter + 1
        
    End If
        
    Next i


' --------------------------------------------
' FIXES COMPLETE
' --------------------------------------------
Next ws

MsgBox ("Fixes Complete")

    
End Sub
