function delete-ebssbapshot{

    param (

            [parameter(mandatory=$true)][string[]] $computername
          )

    foreach ($c in $computername){

    $filter1 = New-Object Amazon.EC2.Model.Filter
    $filter1.Name = 'tag:Name'
    $filter1.Value = $c

    # $reservation.instances property is not expanded
    $reservation = Get-EC2Instance -filter $filter1

    $volumeid = $reservation.instances[0].BlockDeviceMappings.ebs.VolumeId

        foreach ($vol in $volumeid){

        $filter2 = New-Object Amazon.EC2.Model.Filter
        $filter2.Name = 'volume-id'
        $filter2.Value = $vol

        $snapshot = Get-EC2Snapshot -Filter $filter2

        Remove-EC2Snapshot -SnapshotId $snapshot.SnapshotId -Force

        }
    }

}

delete-ebssbapshot