[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

#Backup assembly, required for backup & restore operations
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") 

$name = "Full Backup On-" + [DateTime]::Now.ToString("dd-MMMM-yyyy")
$folder = New-Item -Path D:\Backup\$name -itemtype 'directory' -Force
$date = Get-Date -format dd-MMMM-yyyy


$ServerName = "gauravkam"
$SQLSvr = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerName)
 
$Db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database
 
foreach ($db in $SQLSvr.Databases | Where-Object {$_.Name -ne "tempdb"})

{
    $Backup = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Backup
    $Backup.Action = [Microsoft.SQLServer.Management.SMO.BackupActionType]::Database
    $backup.BackupSetDescription = "Full Back of "+$Db.Name
    $Backup.Database = $db.Name
    
    $filename = $Db.name + "_" + "$date" + ".bak"

    $BackupName = join-path -path "$folder" -childpath $filename
    $DeviceType = [Microsoft.SqlServer.Management.Smo.DeviceType]::File
    $BackupDevice = New-Object -TypeName Microsoft.SQLServer.Management.Smo.BackupDeviceItem($BackupName,$DeviceType)
 
    $Backup.Devices.Add($BackupDevice)
    $Backup.SqlBackup($SQLSvr)
    $Backup.Devices.Remove($BackupDevice)
}
