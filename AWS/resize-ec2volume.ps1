Param(
[string][Parameter(Mandatory=$True)] $volumeId,
[int][Parameter(Mandatory=$True)] $newsize
)

# get volume id from ec2 instance id
#$oldvolume = Get-EC2Volume -Filter @{ Name = "attachment.instance-id" ; values = $instance[0].InstanceId }


# manually pass volume id
$oldvolume = Get-EC2Volume -VolumeId $volumeId
$attachment = $oldvolume.Attachments[0]

If ($newsize -lt $oldvolume.Size) {

    Throw "New Volume must be larger than current"

}

If ($attachment.InstanceId -ne $null) {

    If ((Get-EC2InstanceStatus $attachment.InstanceId) -ne $null) {
    
        Write-Host "Instance must be stopped"
        
        #Write-Host "Stopping Instance"

    }
    
}

# Create snapshot from current volume

Write-Host "Creating Snapshot from Volume "$oldvolume.VolumeId""
$snapshot = New-EC2Snapshot -VolumeId $oldvolume.VolumeId

while ($snapshot.Status -ne 'completed') {

    $snapshot = Get-EC2Snapshot -SnapshotId $snapshot.SnapshotId 
    Start-Sleep -Seconds 15

}


# Create new volume from snapshot

If ($oldvolume.VolumeType -eq 'standard') {

    $newvolume = New-EC2Volume -Size $newsize -SnapshotId $snapshot.SnapshotId -AvailabilityZone $oldvolume.AvailabilityZone -VolumeType standard

}


else {

$newvolume = New-EC2Volume -Size $newsize -SnapshotId $snapshot.SnapshotId -AvailabilityZone $oldvolume.AvailabilityZone -VolumeType 'gp2'

}

while ($newvolume.Status -ne 'available') {

    $newvolume = Get-EC2Volume -VolumeId $newvolume.VolumeId
    Start-Sleep -Seconds 15
}

# Remove old volume & add new volume

If ($attachment.InstanceId -ne $null) {

    Dismount-EC2Volume -VolumeId $oldvolume.VolumeId
    Start-Sleep -Seconds 15

    Add-EC2Volume -VolumeId $newvolume.VolumeId -InstanceId $attachment.InstanceId -Device $attachment.Device
    
}


Get-EC2Volume -VolumeId $newvolume.VolumeId | select -ExpandProperty attachments

Remove-EC2Volume -VolumeId $oldvolume.VolumeId -Force

Remove-EC2Snapshot -SnapshotId $snapshot.SnapshotId -Force