$RetentionDate = ([DateTime]::Now).AddDays(-15)
Get-EC2Snapshot -Filter @{Name = "tag:BackupType"; Values = "Daily"} | Where-Object { [datetime]::Parse($_.StartTime) -GT $RetentionDate} |
    ForEach-Object {
        $SnapshotId = $_.SnapshotId
        Remove-EC2Snapshot -SnapshotId $SnapshotId -Force
    }