# Backup Database & Transaction logs


[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

#Backup assembly, required for backup & restore operations
#[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") 


$name = "Full Backup On-" + [DateTime]::Now.ToString("dd-MMMM-yyyy")
$path1 = 'D:\Backup'
$folder = New-Item -Path $path1\$name -itemtype 'directory' -Force
$date = Get-Date -format dd-MMMM-yyyy

$ServerName = "gauravkam"

#SMO Object for server instance
$SQLSvr = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerName)

#SMO object for database
$Db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database
 
foreach ($db in $SQLSvr.Databases | Where-Object {$_.Name -ne "tempdb"})

{
    
    $bak_file = $Db.name + "_" + "$date" + ".bak"
    $bak_path = join-path -path "$folder" -childpath $bak_file

    $trn_file = $Db.name + "_" + "$date" + ".trn"
    $trn_path = join-path -path "$folder" -childpath $trn_file

    Backup-SQLDatabase -ServerInstance $ServerName -Database $Db.name -BackupFile $bak_path -BackupAction Files
    Backup-SQLDatabase -ServerInstance $ServerName -Database $Db.name -BackupFile $trn_path -BackupAction Log -LogTruncationType Truncate

}