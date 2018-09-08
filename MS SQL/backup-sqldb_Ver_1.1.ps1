# Script to Backup Database


#.Net assemblies for SQL Server SMO, old method
#[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
#Backup assembly, required for backup & restore operations
#[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") 


Import-Module sqlps -DisableNameChecking

$name = "Full Backup On-" + [DateTime]::Now.ToString("dd-MMMM-yyyy")
$path1 = 'S:\BACK-UP\MSLT-301_LEXBI_DW_PE'
$folder = New-Item -Path $path1\$name -itemtype 'directory' -Force
$date = Get-Date -format dd-MMMM-yyyy

$ServerName = "gauravkam"

#SMO Object for server instance
$SQLSvr = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerName)

#SMO object for database
$Db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database
 
foreach ($db in $SQLSvr.Databases | Where-Object {$_.Name -ne "tempdb"}) 
{
    
    $filename = $Db.name + "_" + "$date" + ".bak"
    $fullpath = join-path -path "$folder" -childpath $filename

    Backup-SQLDatabase -ServerInstance $ServerName -Database $Db.name -BackupFile $fullpath -BackupAction Files
}
