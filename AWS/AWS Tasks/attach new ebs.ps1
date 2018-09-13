function create-ebsvolume {

    param(
    
        [parameter(mandatory=$true,HelpMessage="Please enter EC2 Instance Name")][string] $InstanceName,
        [parameter(mandatory=$true)][int] $Size,
        [parameter(mandatory=$false)][string] $Device,
        [parameter(mandatory=$true)][string] $VolumeType
               
        )

         $Filter = New-Object Amazon.EC2.Model.Filter
         $Filter.Name = 'tag:Name'
         $Filter.Value = "$InstanceName"
         
         $Reservation = Get-EC2Instance -Filter $Filter | Select-Object -ExpandProperty instances
         
         $InstanceId = $Reservation.InstanceId
         $AZ = $Reservation.Placement.AvailabilityZone
         $Device = Get-Device -InstanceId $InstanceId

         $Volume = New-EC2Volume -Size $Size -VolumeType $VolumeType -AvailabilityZone $AZ -Encrypted $false
        
         Write-Host ""   
         Write-Host "Creating Volume of Size: $Size GB, Volume Type: $VolumeType" -ForegroundColor Green

         while ($Volume.status -ne 'available') {

            $Volume = Get-EC2Volume -VolumeId $Volume.volumeid

            Start-Sleep -Seconds 15
            
            }
         
         # add additional disk 
         Write-Host ""  
         Write-Host "Attaching Volume to $InstanceName..." -ForegroundColor Green
         Add-EC2Volume -VolumeId $Volume.volumeid -InstanceId $InstanceId -Device $Device | Out-Null

         # Tag new volume with instance name
         $Tag = New-Object Amazon.EC2.Model.Tag
         $Tag.key = 'Name'
         $Tag.Value = $InstanceName

         New-EC2Tag -Resource $Volume.VolumeId -Tag $Tag
         While ($Volume.status -ne 'in-use') {

            $Volume = Get-EC2Volume -VolumeId $Volume.volumeid

            Start-Sleep -Seconds 10
            
            }
        (Get-EC2Volume -VolumeId $Volume.VolumeId).Attachments[0]
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

    $Commands = @(
        'Get-Disk | `
        Where partitionstyle -eq "raw" | `
        Initialize-Disk -PartitionStyle MBR -PassThru | `
        New-Partition -AssignDriveLetter -UseMaximumSize | `
        Format-Volume -FileSystem NTFS -Confirm:$false -force'
        )

    $Parameter = @{
          commands = $Commands
    }
    $Document = 'AWS-RunPowerShellScript'

    Write-Host ""
    Write-Host "Initializing disk..." -ForegroundColor Green
    
    Try {
    $Cmd = Send-SSMCommand -DocumentName $Document -Parameter $Parameter -InstanceId $InstanceId
    While ($Cmd.Status -ne 'Success')
    {
        $Cmd = Get-SSMCommand -CommandId $Cmd.CommandId
        Start-Sleep 10
    }
    Write-Host ""
    Write-Host "Disk is initialized & formatted" -ForegroundColor Green
    #Get-SSMCommand -CommandId $Cmd.CommandId | Select-Object DocumentName, Status
    }

    Catch {

        Write-Host ""
        Write-Host "Failed to initialize disk" -ForegroundColor Red
    }
}

create-ebsvolume