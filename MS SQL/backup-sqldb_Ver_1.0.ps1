[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")

#Backup assembly
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") 


$name = "Full Backup On-" + [DateTime]::Now.ToString("dd-MMMM-yyyy")
$folder = New-Item -Path D:\Backup\$name -itemtype 'directory' -Force


$ServerName = "gauravkam"
$SQLSvr = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerName)
 
$Db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database
 
foreach ($db in $SQLSvr.Databases | Where-Object {$_.Name -ne "tempdb"})


{

    $date = Get-Date -format dd-MMMM-yyyy
    $foldername = $Db.name + "_" + "$date" + ".bak"
    $fullpath = join-path -path "$folder" -childpath $foldername

    Backup-SQLDatabase -InputObject $SQLSvr -Database $Db.name -BackupFile $fullpath -BackupAction Files
}

