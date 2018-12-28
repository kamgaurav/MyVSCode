<powershell>

$RawDisk = Get-Disk | Where-Object {$_.Number -ne '0'} | Sort-Object -Property Number

foreach ($Disk in $RawDisk) {

    switch ($Disk.Number) {
        "1" {$NewLabel = 'sysdb'}
        "2" {$NewLabel = 'log'}
        "3" {$NewLabel = 'data1'}
        "4" {$NewLabel = 'data2'}
        "5" {$NewLabel = 'tempdb1'}
        "6" {$NewLabel = 'tempdb2'}
        "7" {$NewLabel = 'backup1'}
        Default {'Unknown'}
    }

    if ($Disk.OperationalStatus -eq 'Online') {
        Clear-Disk -RemoveData -Number $Disk.Number -Confirm:$false
    }
    $MountPath = New-Item -Name $NewLabel -Path "C:\" -ItemType Directory -Force
    Initialize-Disk -Number $Disk.Number -PartitionStyle GPT -Confirm:$false
    $NewPartition = New-Partition -DiskNumber $Disk.Number -UseMaximumSize -AssignDriveLetter
    Start-Sleep 5
    $NewPartition | Format-Volume -FileSystem NTFS -NewFileSystemLabel $NewLabel -Confirm:$false| Out-Null
    Add-PartitionAccessPath -DiskNumber $Disk.Number -PartitionNumber 2 -AccessPath $MountPath
}

</powershell>
<persist>true</persist>