Attribute VB_Name = "Module1"

Sub HWE()


Dim ws As Worksheet
Dim Year As String
Dim TotalVolume As Double
Dim LastRow As Double
Dim PercentChange As Double
Dim RowPrintCounter As Double


'Grabbing each worksheet in the workbook

For Each ws In ThisWorkbook.Sheets

'Activatig the current sheet
 
        ws.Activate
       
'Counting the number of rows

        LastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
        
'Initializing the variables


        TotalVolume = 0
        RowPrintCounter = 2


'Calculating total ticker volumes & retrieving ticker & year of tranction from the sheet


        For i = 2 To LastRow

'Checking if the ticker value is different

            If Cells(i + 1, 1).Value = Cells(i, 1).Value Then
    
                TotalVolume = TotalVolume + Cells(i + 1, 7)
        
            Else
        
'Updating the sheet withticker symbols, years and total volume

                ws.Cells(RowPrintCounter, 10).Value = Cells(i, 1).Value
                ws.Cells(RowPrintCounter, 11).Value = Left(Cells(i, 2).Value, 4)
                ws.Cells(RowPrintCounter, 12).Value = TotalVolume

'Updating the row values for displaying these values in the specified rows/columns in the sheet

                RowPrintCounter = RowPrintCounter + 1
        
            End If
        
 'Looping back to analyze the subsequent row
 
        Next i


'Looping back to next work sheet in the work book


Next ws

MsgBox ("Completed")
 
End Sub
