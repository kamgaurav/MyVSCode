#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.365.0'}

$Type = 'Daily'

Get-EC2Volume -Filter @{Name = "tag:BackupEnabled"; Values = "True"} |

ForEach-Object {

    If ($_.Attachment) {
        $Device = $_.Attachment[0].Device
        $InstanceId = $_.Attachment[0].InstanceId
        $Reservation = Get-EC2Instance $InstanceId
        $Instance = $Reservation.RunningInstance |
            Where-Object {$_.InstanceId -eq $InstanceId}
        $Name = ($Instance.Tag | Where-Object { $_.Key -eq 'Name' }).Value
        $Description = "Attached to $Name as $Device."
    
    }

    $Volume = $_.VolumeId
    $Snapshot = New-EC2Snapshot $Volume -Description "$Type backup of volume $Volume; $Description"

    $Tag = New-Object amazon.EC2.Model.Tag
    $Tag.Key = 'BackupType'
    $Tag.Value = $Type
    New-EC2Tag -ResourceId $Snapshot.SnapshotID -Tag $Tag
}