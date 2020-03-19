$FilePath = "C:\Users\gkamble\Documents\sw.xlsx"

$SheetName = "Sheet1"

$ObjExcel = New-Object -ComObject Excel.Application

$ObjExcel.Visible = $false

$WorkBook = $ObjExcel.Workbooks.Open($FilePath)

$WorkSheet = $WorkBook.sheets.item($SheetName)

$RowMax = $WorkSheet.UsedRange.Rows.count
$ColumnMax = $WorkSheet.UsedRange.Columns.count

$Creds = Get-Credential
$Swis = Connect-Swis -Credential $Creds -Hostname localhost

for ($i=2; $i -le $RowMax; $i++) {
    $IPAdd = $WorkSheet.Cells.Item($i,1).Text
    $app = $WorkSheet.Cells.Item($i,2).Text
    $client = $WorkSheet.Cells.Item($i,3).Text
    $env = $WorkSheet.Cells.Item($i,4).Text
    $node_arrangement = $WorkSheet.Cells.Item($i,5).Text
    $node_location = $WorkSheet.Cells.Item($i,6).Text

    $Server = Get-OrionNode -SwisConnection $swis -IPAddress $IPAdd
    $NodeID = $Server.NodeID
    $Uri = "swis://localhost/Orion/Orion.Nodes/NodeID=$NodeID/CustomProperties"
    $Node_Prop = Get-SwisObject $swis -Uri $Uri
    $Node_Prop
}
 
