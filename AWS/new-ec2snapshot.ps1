# get volume from instanceid 
$volume = (Get-EC2Volume -Filter @{ Name ="attachment.instance-id" ; values = $reservation.instances[0].InstanceId})

# create snapshot from existing volume
$snapshot = New-EC2Snapshot -VolumeId $volume.VolumeId -Description 'Test Snapshot'

# create volume from snapshot
$volume2 = New-EC2Volume -Size 8 -AvailabilityZone us-east-1c -VolumeType gp2 -SnapshotId $snapshot.SnapshotId

# remove volume
$volume2 | Remove-EC2Volume

# remove snapshot
Remove-EC2Snapshot -SnapshotId $snapshot.SnapshotId

