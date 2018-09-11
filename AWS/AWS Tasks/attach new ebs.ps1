function create-ebsvolume {

    param(
    
        [parameter(mandatory=$true,HelpMessage="Please enter EC2 Instance Name")][string] $computername,
        [parameter(mandatory=$true)][int] $size,
        [parameter(mandatory=$false)][string] $device,
        [parameter(mandatory=$true)][string] $volumetype
               
        )

         $filter = New-Object Amazon.EC2.Model.Filter
         $filter.Name = 'tag:Name'
         $filter.Value = "$computername"
         
         $reservation = Get-EC2Instance -Filter $filter | Select-Object -ExpandProperty instances
         
         $InstanceId = $reservation.InstanceId
         $az = $reservation.Placement.AvailabilityZone
         $Device = Get-Device -InstanceId $InstanceId

         $volume = New-EC2Volume -Size $size -VolumeType $volumetype -AvailabilityZone $az -Encrypted $false
        
         Write-Host "Creating Volume of Size: $size GB, Type: $volumetype" -ForegroundColor Green

         while ($volume.status -ne 'available') {

            $volume = Get-EC2Volume -VolumeId $volume.volumeid

            Start-Sleep -Seconds 15
            
            }
         
         # add additional disk   
         Write-Host "Attaching Volume to $computername" -ForegroundColor Green
         Add-EC2Volume -VolumeId $volume.volumeid -InstanceId $InstanceId -Device $Device | Out-Null

         # Tag new volume with instance name
         $tag = New-Object Amazon.EC2.Model.Tag
         $tag.key = 'Name'
         $tag.Value = $computername

         New-EC2Tag -Resource $volume.VolumeId -Tag $tag
         While ($volume.status -ne 'in-use') {

            $volume = Get-EC2Volume -VolumeId $volume.volumeid

            Start-Sleep -Seconds 10
            
            }
        (Get-EC2Volume -VolumeId $volume.VolumeId).Attachments[0]
        Initialize-EC2Disk -InstanceId $InstanceId
}

Function Get-Device() {

    param(
              [parameter (mandatory=$true)][string] $InstanceId
          )
    $CurrentDevice = Get-EC2InstanceAttribute $InstanceId -Attribute blockDeviceMapping | Select-Object -ExpandProperty BlockDeviceMappings | Select-Object -last 1

If ($CurrentDevice.DeviceName -eq '/dev/sda1') {
    
    $NewDevice = 'xvdf'
    return $NewDevice
}

Else {

    $a = $CurrentDevice.DeviceName.ToCharArray()

    $inc = +1
    $a[3] = [char]([int]($a[3])+$inc)
    $NewDevice = -join $a
    return $NewDevice

    }
}


Function Initialize-EC2Disk {

    param(
              [parameter (mandatory=$true)][string] $InstanceId
         )

    $commands = @(
        'Get-Disk | `
        Where partitionstyle -eq "raw" | `
        Initialize-Disk -PartitionStyle MBR -PassThru | `
        New-Partition -AssignDriveLetter -UseMaximumSize | `
        Format-Volume -FileSystem NTFS -Confirm:$false -force'
        )

    $parameter = @{
          commands = $commands
    }
    $document = 'AWS-RunPowerShellScript'

    $cmd = Send-SSMCommand -DocumentName $document -Parameter $parameter -InstanceId $InstanceId
    $cmd.Status
    
}

create-ebsvolume