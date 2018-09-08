function create-ebssnapshot {

    param (

        [parameter (mandatory=$true)][string[]] $computername
        
       )   

       foreach ($c in $computername){

       $filter = New-Object Amazon.EC2.Model.Filter
       $filter.Name = 'tag:Name'
       $filter.Value = $c
       
       $tag = New-Object Amazon.EC2.Model.Tag
       $tag.key = 'Name'
       $tag.Value = $c
       $description = "Attached to instance- $c"

       # $reservation.instances property is expanded
       $reservation = Get-EC2Instance -Filter $filter | select -ExpandProperty instances
       $volumeid = $reservation.BlockDeviceMappings.ebs.VolumeId

       foreach ($vol in $volumeid){

                $snapshot = New-EC2Snapshot -VolumeId $vol -Description $description

                New-EC2Tag -Resource $snapshot.SnapshotId -Tag $tag

               }
       }
}


create-ebssnapshot





