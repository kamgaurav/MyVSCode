[System.Reflection.Assembly]::LoadwithpartialName("Microsoft.AnalysisServices") | Out-Null

$name = "Full Backup On-" + [DateTime]::Now.ToString("dd-MMMM-yyyy")
$path1 = 'G:\BACK-UP\SMSGRBICUBE-SSAS'
$folder = New-Item -Path $path1\$name -itemtype 'directory' -Force
$date = Get-Date -format dd-MMMM-yyyy

$server = 'SMSGRBICUBE'
$databases = 'Budget','FRI','FRIHistorical','Infopedia','LearningPath','ReadinessCubes'


foreach ($db in $databases)

{
    $filename = "$db-" + $date + ".abf"
    
    $sqlserver = New-Object Microsoft.AnalysisServices.Server

    $sqlserver.connect("$server")

    $d=$sqlserver.databases.item("$db")

    $fullpath = join-path -path "$folder" -childpath $filename

    $d.backup("$fullpath",$false,$false,$null,$true,$null)

}