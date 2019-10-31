[System.Reflection.Assembly]::LoadwithpartialName("Microsoft.AnalysisServices") | Out-Null
$server = 'gauravkam'
$databases = 'CERT' , 'LexBI_Tabular' , 'LexBI_Tabular_DailyRefresh' , 'MERT' , 'MSLCuPID_Cube' , 'SA_Dynamics'
$location = "\\mslt-299\S$\Program Files\Microsoft SQL Server\MSAS12.LEXBI_AS_PE_TAB\OLAP\Backup"

foreach ($db in $databases)

{
    $date = get-date -Format dd-MMMM-yyyy_HH-mm-ss

    $filename = "$db-" + $date + ".abf"
    
    $sqlserver = New-Object Microsoft.AnalysisServices.Server
    $sqlserver.connect("$server")
    $d=$sqlserver.databases.item("$db")
    $d.backup("\\mslt-299\S$\Program Files\Microsoft SQL Server\MSAS12.LEXBI_AS_PE_TAB\OLAP\Backup\$filename",$false,$false,$null,$true,$null)

}