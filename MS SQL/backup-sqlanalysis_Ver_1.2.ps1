Import-Module sqlps -DisableNameChecking


$name = "Full Backup On-" + [DateTime]::Now.ToString("dd-MMMM-yyyy")
$path1 = 'G:\BACK-UP\SMSGRBICUBE-TABULAR'
$folder = New-Item -Path $path1\$name -itemtype 'directory' -Force
$date = Get-Date -format dd-MMMM-yyyy

$ServerName = "SMSGRBICUBE\TABULAR"

#SMO Object for server instance
$SQLSvr = New-Object -TypeName  Microsoft.AnalysisServices.Server
$SQLSvr.connect("$ServerName")

$Db = New-Object -TypeName Microsoft.AnalysisServices.Database

foreach ($db in $SQLSvr.Databases | Where-Object {$_.Name -ne "Certifications_v-kinamb_f68bd97c-e230-4f4e-8f83-464de1f0243c"})

{
    $filename = $Db.name + "_" + "$date" + ".abf"
    $fullpath = join-path -path "$folder" -childpath $filename

    #Backup-ASDatabase -backupfile $fullpath -name $Db.name -server $ServerName

    $db.Backup("$fullpath")
}
