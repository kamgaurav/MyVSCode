#Requires -Modules 'AWSPowerShell.NetCore'
$RetentionDays = 14
$Snapshots = Get-EC2Snapshot -Filter @{Name = "tag:BackupType"; Values = "Daily"}
ForEach ($Snapshot in $Snapshots) { 
    $Retention = ([DateTime]::Now).AddDays(-$RetentionDays)
    if ([DateTime]::Compare($Retention, $Snapshot.StartTime) -gt 0) { 
        Remove-EC2Snapshot -SnapshotId $snapshot.SnapshotId -Force 
    } 
}