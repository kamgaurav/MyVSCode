function create-ebsvolume {

    param(
    
        [parameter(mandatory=$true)][string] $computername,
        [parameter(mandatory=$true)][int] $size,
        [parameter(mandatory=$true)][string] $device,
        [parameter(mandatory=$true)][string] $volumetype

        #[parameter(mandatory=$true)][boolean] $encrypted
        #[parameter(mandatory=$false)][string] $snapshotid,
         )

         $filter = New-Object Amazon.EC2.Model.Filter
         $filter.Name = 'tag:Name'
         $filter.Value = $computername
         
         $reservation = Get-EC2Instance -Filter $filter | select -ExpandProperty instances
         
         $instanceId = $reservation.InstanceId
         $az = $reservation.Placement.AvailabilityZone

         $volume = New-EC2Volume -Size $size -VolumeType $volumetype -AvailabilityZone $az -Encrypted $false

         while ($volume.status -ne 'available') {

            $volume = Get-EC2Volume -VolumeId $volume.volumeid

            Start-Sleep -Seconds 15
            
            }
         
         # additional disk xvd[f-z]      
         Add-EC2Volume -VolumeId $volume.volumeid -InstanceId $instanceId -Device $device

         # set delete on termination for added ebs volume
         $spec = New-Object Amazon.EC2.Model.InstanceBlockDeviceMappingSpecification
         $spec.DeviceName = "xvdf"
         $spec.Ebs = New-Object Amazon.EC2.Model.EbsInstanceBlockDeviceSpecification
         $spec.Ebs.DeleteOnTermination = $true

         Edit-EC2InstanceAttribute -InstanceId $instanceId -BlockDeviceMapping $spec

         # Tag new volume with instance name
         $tag = New-Object Amazon.EC2.Model.Tag
         $tag.key = 'Name'
         $tag.Value = $computername

         New-EC2Tag -Resource $volume.VolumeId -Tag $tag

}

create-ebsvolume